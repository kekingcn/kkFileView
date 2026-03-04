import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  timeout: 30_000,
  expect: { timeout: 10_000 },
  reporter: [['list'], ['html', { outputFolder: 'playwright-report', open: 'never' }]],
  use: {
    baseURL: process.env.KK_BASE_URL || 'http://127.0.0.1:8012',
  },
});
