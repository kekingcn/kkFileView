# kkFileView E2E MVP

This folder contains a first MVP of end-to-end automated tests.

## What is covered

- Basic preview smoke checks for common file types (txt/md/json/xml/csv/html/png)
- Office Phase-2 smoke checks (docx/xlsx/pptx)
- Archive smoke check (zip)
- Basic endpoint reachability
- Security regression checks for blocked internal-network hosts (`10.*`) on:
  - `/onlinePreview`
  - `/getCorsFile`
- Basic performance smoke checks (configurable threshold): txt/docx/xlsx preview response time

## Local run

1. Build server jar:

```bash
mvn -q -pl server -DskipTests package
```

2. Install deps + browser:

```bash
cd tests/e2e
npm install
npx playwright install --with-deps chromium
pip3 install -r requirements.txt
```

> Prerequisite: ensure `zip` command is available in PATH (used for `sample.zip` fixture generation).

3. Generate fixtures and start fixture server:

```bash
cd /path/to/kkFileView
npm run gen:all
cd tests/e2e/fixtures && python3 -m http.server 18080
```

4. Start kkFileView in another terminal:

```bash
JAR_PATH=$(ls server/target/kkFileView-*.jar | head -n 1)
KK_TRUST_HOST='*' KK_NOT_TRUST_HOST='10.*,172.16.*,192.168.*' java -jar "$JAR_PATH"
```

5. Run tests:

```bash
cd tests/e2e
KK_BASE_URL=http://127.0.0.1:8012 FIXTURE_BASE_URL=http://127.0.0.1:18080 npm test
```

Optional:

```bash
# smoke only (self-contained: will auto-generate fixtures)
npm run test:smoke

# perf smoke (self-contained; default threshold 15000ms)
E2E_MAX_PREVIEW_MS=15000 npm run test:perf
```
