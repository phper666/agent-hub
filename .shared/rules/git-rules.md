## Git Rules（所有角色必须遵守）

### Commit 规范

1. **Commit message 格式**: `type(scope): description`
   - type: `feat` / `fix` / `refactor` / `test` / `docs` / `chore` / `perf` / `style` / `ci` / `build`
   - scope: 可选，表示影响范围（如模块名、组件名）
   - description: 简要描述，使用祈使语气，首字母小写，不加句号
   - 示例: `feat(auth): add OAuth2 login flow`
2. 一个 commit 只包含一个逻辑变更（原子提交）
3. Commit body 可选，用于解释 **why** 而非 **what**
4. 遇到 breaking change 时，footer 必须注明: `BREAKING CHANGE: <描述>`

### 分支管理

5. 分支命名: `feat/v{N}-{功能名}` / `fix/v{N}-{bug描述}` / `chore/{描述}` / `hotfix/{紧急修复}`
6. 分支名使用小写英文 + 短横线，不使用中文或大写
7. Feature 分支从 `main` 创建，生命周期不超过一个迭代
8. 合并前必须 rebase 到最新 `main`，保持线性历史（优先 rebase over merge）
9. 合并前必须通过所有 CI 检查
10. 合并必须人工操作，不自动合并
11. 合并后删除远程分支

### 提交前检查

12. 提交前运行 `ocr review --from HEAD~1 --to HEAD`
13. 不要提交临时文件、debug 代码、注释掉的代码
14. 不要提交 IDE 配置文件（.idea/, .vscode/）、OS 文件（.DS_Store）
15. 敏感信息（密钥、Token、密码）绝不进入 git 历史
16. 提交前确认 `.gitignore` 覆盖所有应忽略的文件

### Pull Request 规范

17. PR 标题遵循 commit message 格式
18. PR 描述必须包含：
    - 变更原因（Why）
    - 变更内容摘要（What）
    - 测试方式（How to verify）
    - 关联的 issue/story 编号
19. PR 单次变更不超过 400 行，超过则拆分
20. 每个 PR 至少需要 1 人 review 通过
21. Review 评论必须有建设性，指出问题时附带建议

### Tag 与版本

22. Release tag 格式: `v{major}.{minor}.{patch}`（语义化版本）
23. 每次发布必须附带 CHANGELOG 更新
