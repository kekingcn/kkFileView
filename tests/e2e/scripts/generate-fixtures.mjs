import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const fixturesDir = path.resolve(__dirname, '..', 'fixtures');
fs.mkdirSync(fixturesDir, { recursive: true });

const write = (name, content) => fs.writeFileSync(path.join(fixturesDir, name), content);

write('sample.txt', 'kkFileView e2e sample text');
write('sample.md', '# kkFileView\n\nThis is a markdown fixture.');
write('sample.json', JSON.stringify({ app: 'kkFileView', e2e: true }, null, 2));
write('sample.xml', '<root><name>kkFileView</name><e2e>true</e2e></root>');
write('sample.csv', 'name,value\nkkFileView,1\ne2e,1\n');
write('sample.html', '<!doctype html><html><body><h1>kkFileView fixture</h1></body></html>');

// zip (contains txt) - only generate if missing to avoid noisy local diffs
const zipPath = path.join(fixturesDir, 'sample.zip');
if (!fs.existsSync(zipPath)) {
  const zipWork = path.join(fixturesDir, 'zip-tmp');
  fs.mkdirSync(zipWork, { recursive: true });
  fs.writeFileSync(path.join(zipWork, 'inner.txt'), 'kkFileView zip inner file');
  try {
    execFileSync('zip', ['-X', '-q', '-r', zipPath, 'inner.txt'], { cwd: zipWork });
  } catch (err) {
    console.error('Failed to create sample.zip fixture. Ensure "zip" is installed and available in PATH.');
    throw err instanceof Error ? err : new Error(String(err));
  } finally {
    fs.rmSync(zipWork, { recursive: true, force: true });
  }
}

// 1x1 png
write(
  'sample.png',
  Buffer.from(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO7Zx1sAAAAASUVORK5CYII=',
    'base64'
  )
);

// tiny valid pdf
write(
  'sample.pdf',
  `%PDF-1.1\n1 0 obj<< /Type /Catalog /Pages 2 0 R >>endobj\n2 0 obj<< /Type /Pages /Kids [3 0 R] /Count 1 >>endobj\n3 0 obj<< /Type /Page /Parent 2 0 R /MediaBox [0 0 200 200] /Contents 4 0 R >>endobj\n4 0 obj<< /Length 44 >>stream\nBT /F1 12 Tf 72 120 Td (kkFileView e2e pdf) Tj ET\nendstream\nendobj\nxref\n0 5\n0000000000 65535 f \n0000000010 00000 n \n0000000060 00000 n \n0000000117 00000 n \n0000000212 00000 n \ntrailer<< /Root 1 0 R /Size 5 >>\nstartxref\n306\n%%EOF\n`
);

console.log('fixtures generated in', fixturesDir);
