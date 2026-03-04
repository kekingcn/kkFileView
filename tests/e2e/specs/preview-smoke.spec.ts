import { test, expect } from '@playwright/test';

const fixtureBase = process.env.FIXTURE_BASE_URL || 'http://127.0.0.1:18080';

function b64(v: string): string {
  return Buffer.from(v).toString('base64');
}

async function openPreview(request: any, fileUrl: string) {
  const encoded = b64(fileUrl);
  return request.get(`/onlinePreview?url=${encoded}`);
}

test('01 home/index reachable', async ({ request }) => {
  const resp = await request.get('/');
  expect(resp.status()).toBeLessThan(500);
});

test('02 txt preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.txt`);
  expect(resp.status()).toBe(200);
});

test('03 markdown preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.md`);
  expect(resp.status()).toBe(200);
});

test('04 json preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.json`);
  expect(resp.status()).toBe(200);
});

test('05 xml preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.xml`);
  expect(resp.status()).toBe(200);
});

test('06 csv preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.csv`);
  expect(resp.status()).toBe(200);
});

test('07 html preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.html`);
  expect(resp.status()).toBe(200);
});

test('08 png preview', async ({ request }) => {
  const resp = await openPreview(request, `${fixtureBase}/sample.png`);
  expect(resp.status()).toBe(200);
});

test('09 security: block 10.x host in onlinePreview', async ({ request }) => {
  const resp = await openPreview(request, `http://10.1.2.3/a.pdf`);
  const body = await resp.text();
  expect(body).toContain('不受信任');
});

test('10 security: block 10.x host in getCorsFile', async ({ request }) => {
  const encoded = b64('http://10.1.2.3/a.pdf');
  const resp = await request.get(`/getCorsFile?urlPath=${encoded}`);
  const body = await resp.text();
  expect(body).toContain('不受信任');
});
