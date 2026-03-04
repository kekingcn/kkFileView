import { test, expect } from '@playwright/test';

const fixtureBase = process.env.FIXTURE_BASE_URL || 'http://127.0.0.1:18080';
const maxMs = Number(process.env.E2E_MAX_PREVIEW_MS || 15000);

function b64(v: string): string {
  return Buffer.from(v).toString('base64');
}

async function timedPreview(request: any, fileUrl: string) {
  const started = Date.now();
  const resp = await request.get(`/onlinePreview?url=${b64(fileUrl)}`);
  const elapsed = Date.now() - started;
  return { resp, elapsed };
}

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
