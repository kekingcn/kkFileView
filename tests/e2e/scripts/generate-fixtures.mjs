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

// archive fixtures (contains inner.txt) - generate if missing
const archiveWork = path.join(fixturesDir, 'archive-tmp');
fs.mkdirSync(archiveWork, { recursive: true });
const innerFile = path.join(archiveWork, 'inner.txt');
fs.writeFileSync(innerFile, 'kkFileView archive inner file');

const ensureArchive = (name, generator) => {
  const out = path.join(fixturesDir, name);
  if (fs.existsSync(out)) return;
  try {
    generator(out);
  } catch (err) {
    try {
      fs.rmSync(out, { force: true });
    } catch {
      // ignore cleanup errors; original error will be rethrown
    }
    throw err;
  }
};

const buildDeterministicTar = (out, gzip = false) => {
  const py = String.raw`import io, tarfile, gzip
from pathlib import Path

out = Path(r'''${out}''')
inner_path = Path(r'''${innerFile}''')
data = inner_path.read_bytes()
use_gzip = ${gzip ? 'True' : 'False'}

if use_gzip:
    with out.open('wb') as f:
        with gzip.GzipFile(filename='', mode='wb', fileobj=f, mtime=0) as gz:
            with tarfile.open(fileobj=gz, mode='w', format=tarfile.USTAR_FORMAT) as tf:
                info = tarfile.TarInfo('inner.txt')
                info.size = len(data)
                info.mtime = 946684800  # 2000-01-01 00:00:00 UTC
                info.uid = 0
                info.gid = 0
                info.uname = 'root'
                info.gname = 'root'
                tf.addfile(info, io.BytesIO(data))
else:
    with tarfile.open(out, mode='w', format=tarfile.USTAR_FORMAT) as tf:
        info = tarfile.TarInfo('inner.txt')
        info.size = len(data)
        info.mtime = 946684800  # 2000-01-01 00:00:00 UTC
        info.uid = 0
        info.gid = 0
        info.uname = 'root'
        info.gname = 'root'
        tf.addfile(info, io.BytesIO(data))
`;
  execFileSync('python3', ['-c', py]);
};

try {
  ensureArchive('sample.zip', out => {
    execFileSync('zip', ['-X', '-q', '-r', out, 'inner.txt'], { cwd: archiveWork });
  });

  ensureArchive('sample.tar', out => {
    buildDeterministicTar(out, false);
  });

  ensureArchive('sample.tgz', out => {
    buildDeterministicTar(out, true);
  });

  ensureArchive('sample.7z', out => {
    try {
      execFileSync('7z', ['a', '-bd', '-y', '-mtc=off', '-mta=off', '-mtm=off', out, 'inner.txt'], {
        cwd: archiveWork,
      });
    } catch (err) {
      if (err && typeof err === 'object' && 'code' in err && err.code === 'ENOENT') {
        execFileSync('bsdtar', ['-a', '-cf', out, 'inner.txt'], { cwd: archiveWork });
      } else {
        throw err;
      }
    }
  });
} catch (err) {
  console.error('Failed to create archive fixtures. Ensure python3, zip, 7z (or bsdtar) are available in PATH.');
  throw err instanceof Error ? err : new Error(String(err));
} finally {
  fs.rmSync(archiveWork, { recursive: true, force: true });
}

const rarFixture = path.join(fixturesDir, 'sample.rar');
if (!fs.existsSync(rarFixture)) {
  throw new Error(
    'Missing required fixture tests/e2e/fixtures/sample.rar. Restore it from git (e.g. `git checkout -- tests/e2e/fixtures/sample.rar`) before running e2e.'
  );
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
