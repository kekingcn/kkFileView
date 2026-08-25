import { test, expect, request as playwrightRequest } from '@playwright/test';

const fixtureBase = process.env.FIXTURE_BASE_URL || 'http://127.0.0.1:18080';

function b64(v: string): string {
  return Buffer.from(v).toString('base64');
}

async function openPreview(request: any, fileUrl: string) {
  const encoded = encodeURIComponent(b64(fileUrl));
  return request.get(`/onlinePreview?url=${encoded}`);
}

async function openPreviewBody(request: any, fileUrl: string, waitForFinal = false) {
  const encoded = encodeURIComponent(b64(fileUrl));
  const url = `/onlinePreview?url=${encoded}`;
  let body = '';
  for (let i = 0; i < (waitForFinal ? 10 : 1); i++) {
    const resp = await request.get(url);
    expect(resp.status()).toBe(200);
    body = await resp.text();
    if (!waitForFinal || !body.includes('文件转换中')) {
      break;
    }
    await new Promise(resolve => setTimeout(resolve, 1500));
  }
  return body;
}

function expectAnyContains(body: string, candidates: string[], label: string) {
  const hit = candidates.some(candidate => body.includes(candidate));
  expect(hit, `${label} should contain one of: ${candidates.join(', ')}`).toBeTruthy();
}

test.beforeAll(async () => {
  const api = await playwrightRequest.newContext();
  const required = [
    'sample.txt',
    'sample.md',
    'sample.json',
    'sample.xml',
    'sample.csv',
    'sample.html',
    'sample.png',
    'sample.pdf',
    'sample.docx',
    'sample.xlsx',
    'sample.pptx',
    'sample.zip',
    'sample.tar',
    'sample.tgz',
    'sample.7z',
    'sample.rar',
    'sample.mp4',
    'text.dxf',
  ];

  try {
    for (const name of required) {
      const resp = await api.get(`${fixtureBase}/${name}`);
      expect(resp.ok(), `fixture missing or unavailable: ${name}`).toBeTruthy();
    }
  } finally {
    await api.dispose();
  }
});

test('01 home/index reachable', async ({ request }) => {
  const resp = await request.get('/');
  expect(resp.status()).toBeLessThan(500);
});

test('02 txt preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.txt`);
  expectAnyContains(body, ['普通文本预览', 'sample.txt'], 'txt preview');
});

test('03 markdown preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.md`);
  expectAnyContains(body, ['Markdown', 'sample.md', 'markdown'], 'markdown preview');
});

test('04 json preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.json`);
  expectAnyContains(body, ['JSON', 'sample.json', 'json'], 'json preview');
});

test('05 xml preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.xml`);
  expectAnyContains(body, ['XML', 'sample.xml', 'xml'], 'xml preview');
});

test('06 csv preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.csv`);
  expectAnyContains(body, ['CSV', 'sample.csv', 'csv'], 'csv preview');
});

test('07 html preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.html`);
  expectAnyContains(body, ['HTML', 'sample.html', 'html'], 'html preview');
});

test('08 png preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.png`);
  expectAnyContains(body, ['图片预览', 'sample.png', '<img'], 'png preview');
});

test('09 pdf preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.pdf`, true);
  expectAnyContains(body, ['图片预览', 'sample.pdf', 'pdf'], 'pdf preview');
});

test('10 docx preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.docx`, true);
  expectAnyContains(body, ['图片预览', 'sample.docx', 'office'], 'docx preview');
});

test('11 xlsx preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.xlsx`, true);
  expectAnyContains(body, ['sample.xlsx预览', 'xlsx', 'office'], 'xlsx preview');
});

test('12 pptx preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.pptx`, true);
  expectAnyContains(body, ['ppt', 'sample.pptx', 'office'], 'pptx preview');
});

test('13 zip preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.zip`);
  expectAnyContains(body, ['压缩包预览', 'sample.zip', 'inner.txt'], 'zip preview');
});

test('14 tar preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.tar`);
  expectAnyContains(body, ['压缩包预览', 'sample.tar', 'inner.txt'], 'tar preview');
});

test('15 tgz preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.tgz`);
  expectAnyContains(body, ['压缩包预览', 'sample.tgz', 'inner.txt', '系统暂不支持在线预览'], 'tgz preview');
});

test('16 7z preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.7z`);
  expectAnyContains(body, ['压缩包预览', 'sample.7z', 'inner.txt'], '7z preview');
});

test('17 rar preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.rar`);
  expectAnyContains(body, ['压缩包预览', 'sample.rar', 'inner.txt'], 'rar preview');
});

test('18 mp4 preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/sample.mp4`);
  expectAnyContains(body, ['播放器', '<video', 'sample.mp4'], 'mp4 preview');
});

test('19 cad dxf preview', async ({ request }) => {
  const body = await openPreviewBody(request, `${fixtureBase}/text.dxf`, true);
  expectAnyContains(body, ['text.dxf', '<svg', 'svg'], 'cad preview');
});

test('20 security: block 10.x host in onlinePreview', async ({ request }) => {
  const resp = await openPreview(request, `http://10.1.2.3/a.pdf`);
  const body = await resp.text();
  expect(body).toContain('不受信任');
});

test('21 security: block 10.x host in getCorsFile', async ({ request }) => {
  const encoded = b64('http://10.1.2.3/a.pdf');
  const resp = await request.get(`/getCorsFile?urlPath=${encoded}`);
  const body = await resp.text();
  expect(body).toContain('不受信任');
});

test('22 pdf preview applies custom watermark settings', async ({ page }) => {
  const query = new URLSearchParams({
    url: b64(`${fixtureBase}/sample.pdf`),
    watermarkTxt: 'Custom watermark',
    watermarkXSpace: '37',
    watermarkYSpace: '43',
    watermarkFont: 'Courier New',
    watermarkFontsize: '31px',
    watermarkColor: 'rgb(1, 2, 3)',
    watermarkAlpha: '0.65',
    watermarkWidth: '100',
    watermarkHeight: '77',
    watermarkAngle: '17',
  });

  await page.goto(`/onlinePreview?${query.toString()}`);
  const watermark = page.frameLocator('#pdfFrame').locator('.mask_div').first();
  await expect(watermark).toHaveText('Custom watermark');

  const style = await watermark.evaluate(element => ({
    fontFamily: element.style.fontFamily,
    fontSize: element.style.fontSize,
    color: element.style.color,
    opacity: element.style.opacity,
    width: element.style.width,
    height: element.style.height,
    transform: element.style.transform,
  }));
  expect(style).toEqual({
    fontFamily: '"Courier New"',
    fontSize: '31px',
    color: 'rgb(1, 2, 3)',
    opacity: '0.65',
    width: '100px',
    height: '77px',
    transform: 'rotate(-17deg)',
  });

  const positions = await page.frameLocator('#pdfFrame').locator('.mask_div').evaluateAll(elements =>
    elements.map(element => ({
      left: Number.parseFloat(element.style.left),
      top: Number.parseFloat(element.style.top),
    })),
  );
  const nextColumn = positions.find(position => position.left !== positions[0].left);
  expect(positions[1].top - positions[0].top).toBe(120);
  expect(nextColumn).toBeDefined();
  expect(nextColumn!.left - positions[0].left).toBe(137);
});
