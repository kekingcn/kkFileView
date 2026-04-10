<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>暂不支持预览</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .error-card {
            max-width: 600px;
            width: 100%;
            background: #ffffff;
            border-radius: 32px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            text-align: center;
            padding: 40px 32px 48px;
            transition: transform 0.2s ease;
        }

        .error-card:hover {
            transform: translateY(-4px);
        }

        .icon-container {
            margin-bottom: 24px;
        }

        .icon-container img {
            width: 120px;
            height: 120px;
            display: inline-block;
        }

        h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 12px;
        }

        .file-type-badge {
            background: #f1f5f9;
            color: #0f172a;
            font-weight: 600;
            display: inline-block;
            padding: 6px 16px;
            border-radius: 40px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .reason-box {
            background: #fef2f2;
            border-left: 4px solid #dc2626;
            padding: 16px 20px;
            border-radius: 16px;
            margin: 20px 0;
            text-align: left;
        }

        .reason-label {
            font-weight: 600;
            color: #991b1b;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .reason-message {
            color: #1e293b;
            font-size: 15px;
            line-height: 1.5;
            word-break: break-word;
        }

        .community-link {
            background: #f8fafc;
            border-radius: 24px;
            padding: 16px 20px;
            margin-top: 28px;
            border: 1px solid #e2e8f0;
        }

        .community-link p {
            font-size: 15px;
            color: #334155;
            margin-bottom: 10px;
        }

        .community-link a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #3b82f6;
            color: white;
            text-decoration: none;
            padding: 10px 24px;
            border-radius: 40px;
            font-weight: 500;
            transition: background 0.2s;
        }

        .community-link a:hover {
            background: #2563eb;
        }

        .footer-note {
            margin-top: 24px;
            font-size: 13px;
            color: #94a3b8;
        }
    </style>
</head>
<body>
<div class="error-card">
    <div class="icon-container">
        <!-- Base64 内嵌 SVG：文档 + 问号，表示不支持 -->
        <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0iI2Y1OTAwYiIgd2lkdGg9IjEyMCIgaGVpZ2h0PSIxMjAiPgogIDxwYXRoIGQ9Ik0yMCA2aC04bC0yLTJINGMyLTEuMSAwLTEgMCAwdjE0YzAgMS4xLjkgMiAyIDJoMTZjMS4xIDAgMi0uOSAyLTJWN2MwLTEuMS0uOS0yLTItMnptLTIgMTJINlY4aDQuMjFsMiAySDE4djh6bS01LTRoLTR2LTJoNHYyem0wLTNoLTRWOWg0djJ6Ii8+Cjwvc3ZnPg==" alt="不支持预览">
    </div>
    <h1>暂不支持在线预览</h1>
    <div class="file-type-badge">
        📄 文件类型：${fileType}
    </div>
    <div class="reason-box">
        <div class="reason-label">
            ⚠️ 具体原因
        </div>
        <div class="reason-message">
            ${msg}
        </div>
    </div>
    <div class="community-link">
        <p>有任何疑问，欢迎加入 kk 开源社区知识星球咨询</p>
        <a href="https://t.zsxq.com/09ZHSXbsQ" target="_blank" rel="noopener noreferrer">
            🔗 加入知识星球
        </a>
    </div>
    <div class="footer-note">
        系统暂不支持此格式在线查看，建议下载后使用本地软件打开
    </div>
</div>
</body>
</html>