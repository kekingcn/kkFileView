import { test, expect } from '@playwright/test';

const fixtureBase = process.env.FIXTURE_BASE_URL || 'http://127.0.0.1:18080';

for (const proxy of [false, true]) {
  test(`image title retains the source filename with kkagent=${proxy}`, async ({ page }) => {
    const source = `${fixtureBase}/sample.png`;
    const encoded = encodeURIComponent(Buffer.from(source).toString('base64'));
    const response = await page.goto(`/onlinePreview?url=${encoded}&kkagent=${proxy}`);

    expect(response?.status()).toBe(200);
    await expect(page.locator('.viewer-title')).toHaveText('sample.png');
  });
}
