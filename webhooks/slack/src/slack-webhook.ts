import { app, HttpRequest, HttpResponseInit } from '@azure/functions';
import * as crypto from 'crypto';

interface SlackEvent {
  type: string;
  challenge?: string;
  event?: {
    type: string;
    text: string;
    channel: string;
    thread_ts?: string;
    ts: string;
    bot_id?: string;
    user?: string;
  };
}

const GITHUB_TOKEN = process.env.GITHUB_TOKEN!;
const GITHUB_REPO = process.env.GITHUB_REPO!; // "owner/repo"
const SLACK_SIGNING_SECRET = process.env.SLACK_SIGNING_SECRET!;

function verifySlackRequest(req: HttpRequest, body: string): boolean {
  const timestamp = req.headers.get('x-slack-request-timestamp');
  const signature = req.headers.get('x-slack-signature');
  if (!timestamp || !signature) return false;

  const sigBasestring = `v0:${timestamp}:${body}`;
  const mySignature = 'v0=' + crypto
    .createHmac('sha256', SLACK_SIGNING_SECRET)
    .update(sigBasestring)
    .digest('hex');

  return crypto.timingSafeEqual(Buffer.from(mySignature), Buffer.from(signature));
}

app.http('slack-webhook', {
  methods: ['POST'],
  handler: async (req: HttpRequest): Promise<HttpResponseInit> => {
    const body = await req.text();

    if (SLACK_SIGNING_SECRET && !verifySlackRequest(req, body)) {
      return { status: 401, body: 'Invalid signature' };
    }

    const payload: SlackEvent = JSON.parse(body);

    // Handle Slack URL verification challenge
    if (payload.type === 'url_verification') {
      return { status: 200, body: payload.challenge };
    }

    const event = payload.event;
    if (!event || event.type !== 'app_mention') {
      return { status: 200, body: 'Ignored' };
    }

    // Skip bot messages (prevent loops)
    if (event.bot_id) {
      return { status: 200, body: 'Skipped bot message' };
    }

    // Dispatch to GitHub
    const response = await fetch(
      `https://api.github.com/repos/${GITHUB_REPO}/dispatches`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${GITHUB_TOKEN}`,
          'Accept': 'application/vnd.github.v3+json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          event_type: 'slack-message',
          client_payload: {
            text: event.text,
            channel_id: event.channel,
            thread_ts: event.thread_ts || event.ts,
            message_ts: event.ts,
            user: event.user,
          },
        }),
      }
    );

    if (response.ok || response.status === 204) {
      return { status: 200, body: 'Dispatched' };
    } else {
      const err = await response.text();
      return { status: 500, body: `GitHub dispatch failed: ${err}` };
    }
  },
});
