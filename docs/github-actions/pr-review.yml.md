# PR Review — GitHub Actions 配置

> PR review 能力（pr-agent + collaborative-review）**不**在日常开发角色中加载。
> 改为 GitHub Actions 在 PR 打开时自动触发。零 token 开销，按需运行。

---

## 快速配置

在仓库根目录创建 `.github/workflows/pr-review.yml`：

```yaml
name: PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened]
  issue_comment:
    types: [created, edited]

permissions:
  pull-requests: write
  issues: write
  contents: read

jobs:
  pr-agent:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: PR Agent — Describe + Review
        uses: The-PR-Agent/pr-agent@main
        env:
          OPENAI_KEY: ${{ secrets.OPENAI_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITHUB_ACTION.AUTO_DESCRIBE: true
          GITHUB_ACTION.AUTO_REVIEW: true
          PR_REVIEWER.EXTRA_INSTRUCTIONS: |
            Follow the code review rules from Agent Hub:
            - Security: SQL injection, XSS, auth bypass, secrets in code
            - Quality: naming, DRY, function ≤50 lines, file ≤300 lines
            - Performance: N+1 queries, memory leaks, missing indexes
            - Tests: coverage ≥80%, edge cases, test independence
```

---

## 替代方案：GitLab CI

```yaml
pr_agent:
  stage: review
  image: python:3.10
  script:
    - pip install pr-agent
    - pr-agent --pr_url $CI_MERGE_REQUEST_PROJECT_URL/-/merge_requests/$CI_MERGE_REQUEST_IID review
  only:
    - merge_requests
```

---

## 本地手动触发（备用）

如果不想配 CI，对 QA 角色说：

```
"读取 git diff，加载 .shared/skills/pr-review/ 和 .shared/skills/collaborative-review/，
 按 code-review-rules 逐项审查"
```

> 注意：这会消耗 token，只适合偶尔使用。日常 PR 审查推荐 Action 方案。
