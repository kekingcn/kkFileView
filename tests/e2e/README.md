# kkFileView E2E MVP

This folder contains a first MVP of end-to-end automated tests.

## What is covered

- Basic preview smoke checks for common file types (txt/md/json/xml/csv/html/png)
- Basic endpoint reachability
- Security regression checks for blocked internal-network hosts (`10.*`) on:
  - `/onlinePreview`
  - `/getCorsFile`

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
```

3. Generate fixtures and start fixture server:

```bash
cd /path/to/kkFileView
node tests/e2e/scripts/generate-fixtures.mjs
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
