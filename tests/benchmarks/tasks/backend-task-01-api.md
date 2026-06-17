# Backend Task 01: API Implementation — 购物车接口

## 角色
Backend (后端工程师)

## 前置条件
需要先运行 PM Task 01 产出的 PRD

## 输入 Prompt

```
你是一个后端工程师。基于 `docs/current/requirements/PRD.md` 中的购物车 PRD，
实现以下 RESTful API：

## 接口列表
1. POST /api/cart/items — 添加商品到购物车
2. GET /api/cart — 获取当前用户购物车
3. PATCH /api/cart/items/:id — 修改商品数量
4. DELETE /api/cart/items/:id — 删除购物车商品
5. DELETE /api/cart — 清空购物车

## 要求
- 使用适当的框架和语言（自选）
- 需包含：路由定义、请求/响应结构、数据验证、错误处理
- 购物车数据需要持久化（数据库设计）
- 支持用户认证（购物车与用户绑定）
- 编写对应接口的测试
- 输出到 src/backend/cart/

## 边界条件
- 商品不存在时的处理
- 库存不足时的处理
- 未登录用户访问购物车
- 购物车为空时的行为
```

## 评估重点
- API 设计规范性（RESTful 约定、状态码使用）
- 错误处理完整性（所有边界条件覆盖）
- 数据库 Schema 合理性
- 测试覆盖率
