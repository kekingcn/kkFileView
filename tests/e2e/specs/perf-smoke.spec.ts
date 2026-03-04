import { test, expect, request as playwrightRequest } from '@playwright/test';

const fixtureBase = process.env.FIXTURE_BASE_URL || 'http://127.0.0.1:18080';
const envMaxMs = Number(process.env.E2E_MAX_PREVIEW_MS);
const maxMs = Number.isFinite(envMaxMs) ? envMaxMs : 15000;

function b64(v: string): string {
  return Buffer.from(v).toString('base64');
}

async function timedPreview(request: any, fileUrl: string) {
  const started = Date.now();
  const resp = await request.get(`/onlinePreview?url=${b64(fileUrl)}`);
  const elapsed = Date.now() - started;
  return { resp, elapsed };
}

test.beforeAll(async () => {
  const api = await playwrightRequest.newContext();
  const required = ['sample.txt', 'sample.docx', 'sample.xlsx'];
  try {
    for (const name of required) {
      const resp = await api.get(`${fixtureBase}/${name}`);
      expect(resp.ok(), `fixture missing or unavailable: ${name}`).toBeTruthy();
    }
  } finally {
    await api.dispose();
  }
});

test('perf: txt preview response under threshold', async ({ request }) => {
  const { resp, elapsed } = await timedPreview(request, `${fixtureBase}/sample.txt`);
  expect(resp.status()).toBe(200);
  expect(elapsed).toBeLessThan(maxMs);
});

test('perf: docx preview response under threshold', async ({ request }) => {
  const { resp, elapsed } = await timedPreview(request, `${fixtureBase}/sample.docx`);
  expect(resp.status()).toBe(200);
  expect(elapsed).toBeLessThan(maxMs);
});

test('perf: xlsx preview response under threshold', async ({ request }) => {
  const { resp, elapsed } = await timedPreview(request, `${fixtureBase}/sample.xlsx`);
  expect(resp.status()).toBe(200);
  expect(elapsed).toBeLessThan(maxMs);
});
