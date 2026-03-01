import { app, HttpRequest, HttpResponseInit } from '@azure/functions';

const GITHUB_TOKEN = process.env.GITHUB_TOKEN!;
const GITHUB_REPO = process.env.GITHUB_REPO!; // "owner/repo"
const TRIGGER_WORD = process.env.TRIGGER_WORD || '@po-agent';

interface AzDoPayload {
  eventType: string;
  resource: {
    text?: string;
    id?: number;
    workItemId?: number;
    revisedBy?: { displayName?: string };
  };
  resourceContainers?: {
    project?: { id: string };
  };
}

app.http('azdo-webhook', {
  methods: ['POST'],
  handler: async (req: HttpRequest): Promise<HttpResponseInit> => {
    const body = await req.text();
    const payload: AzDoPayload = JSON.parse(body);

    // Only handle work item comment events
    if (payload.eventType !== 'workitem.commented') {
      return { status: 200, body: 'Ignored event type' };
    }

    const commentText = payload.resource?.text || '';
    const commentId = payload.resource?.id;
    const workItemId = payload.resource?.workItemId;

    // Only trigger if comment mentions the trigger word
    if (!commentText.toLowerCase().includes(TRIGGER_WORD.toLowerCase())) {
      return { status: 200, body: 'No trigger word found' };
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
          event_type: 'azure-devops-comment',
          client_payload: {
            comment_text: commentText,
            comment_id: commentId,
            work_item_id: workItemId,
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
