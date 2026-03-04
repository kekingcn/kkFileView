import fs from 'node:fs';
import path from 'node:path';

const fixturesDir = path.resolve(process.cwd(), 'tests/e2e/fixtures');
fs.mkdirSync(fixturesDir, { recursive: true });

const write = (name, content) => fs.writeFileSync(path.join(fixturesDir, name), content);

write('sample.txt', 'kkFileView e2e sample text');
write('sample.md', '# kkFileView\n\nThis is a markdown fixture.');
write('sample.json', JSON.stringify({ app: 'kkFileView', e2e: true }, null, 2));
write('sample.xml', '<root><name>kkFileView</name><e2e>true</e2e></root>');
write('sample.csv', 'name,value\nkkFileView,1\ne2e,1\n');
write('sample.html', '<!doctype html><html><body><h1>kkFileView fixture</h1></body></html>');

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
