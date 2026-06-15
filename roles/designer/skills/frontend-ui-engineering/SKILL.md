---
name: frontend-ui-engineering
description: 在构建前端组件时使用，确保组件质量和一致性
---

# 前端组件工程规范

> 适用于 Designer、Frontend 角色

## 1. 组件设计原则

### 5 大原则

1. **单一职责** - 一个组件只做一件事
2. **可复用性** - 通过 props 定制，而非修改内部
3. **可组合性** - 可以与其他组件组合使用
4. **可测试性** - 易于编写单元测试
5. **可访问性** - 符合 WCAG 2.1 AA 标准

### 分层架构

```
pages/          # 页面组件（路由级）
├── features/   # 功能模块（业务逻辑）
├── components/ # UI 组件（纯展示）
└── shared/     # 共享组件（通用）
```

### 命名规范

| 类型 | 命名规则 | 示例 |
|------|---------|------|
| 组件 | PascalCase | `UserProfile.tsx` |
| Hook | use 前缀 | `useAuth.ts` |
| 工具函数 | camelCase | `formatDate.ts` |
| 常量 | UPPER_SNAKE_CASE | `API_ENDPOINTS.ts` |
| 类型 | PascalCase + Props/Suffix | `ButtonProps.ts` |

### Props 设计

```typescript
// ✅ 好的 Props 设计
interface ButtonProps {
  // 必需的
  children: React.ReactNode;
  onClick: () => void;
  
  // 可选的，有默认值
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  
  // 扩展
  className?: string;
  ariaLabel?: string;
}

// ❌ 差的 Props 设计
interface ButtonProps {
  type: string;  // 应该用联合类型
  style: any;    // 不要用 any
  onClick: Function;  // 要具体化函数签名
}
```

## 2. 状态管理规范

### 状态分类

| 类型 | 用途 | 工具 |
|------|------|------|
| 服务端状态 | API 数据 | React Query |
| 客户端状态 | 全局 UI 状态 | Zustand |
| 表单状态 | 表单数据 | React Hook Form |
| URL 状态 | 路由参数 | React Router |
| 本地状态 | 组件内部 | useState |
| 持久化状态 | localStorage | zustand/middleware |

### React Query 示例

```typescript
// 使用乐观更新
const useUpdateTodo = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: updateTodo,
    onMutate: async (newTodo) => {
      await queryClient.cancelQueries({ queryKey: ['todos'] });
      const previousTodos = queryClient.getQueryData(['todos']);
      queryClient.setQueryData(['todos'], (old) => [...old, newTodo]);
      return { previousTodos };
    },
    onError: (err, newTodo, context) => {
      queryClient.setQueryData(['todos'], context.previousTodos);
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] });
    },
  });
};
```

### Zustand Store 模板

```typescript
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface AppState {
  count: number;
  increment: () => void;
  decrement: () => void;
}

export const useAppStore = create<AppState>()(
  devtools(
    persist(
      (set) => ({
        count: 0,
        increment: () => set((state) => ({ count: state.count + 1 })),
        decrement: () => set((state) => ({ count: state.count - 1 })),
      }),
      { name: 'app-store' }
    )
  )
);
```

## 3. 性能优化规范

### Bundle 懒加载

```typescript
const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyComponent />
    </Suspense>
  );
}
```

### Memo 规则

| 场景 | 使用 | 不使用 |
|------|------|--------|
| 纯展示组件 | `React.memo` | - |
| 昂贵计算 | `useMemo` | - |
| 回调函数 | `useCallback` | - |
| 简单组件 | - | 过度优化 |

### Core Web Vitals 目标

| 指标 | 目标 | 说明 |
|------|------|------|
| LCP | < 2.5s | 最大内容绘制 |
| FID | < 100ms | 首次输入延迟 |
| CLS | < 0.1 | 累积布局偏移 |

## 4. 可访问性规范

### WCAG 2.1 AA 要求

- [ ] 所有交互元素可键盘访问
- [ ] 足够的颜色对比度（4.5:1）
- [ ] 图片有 alt 文本
- [ ] 表单有 label
- [ ] ARIA 属性正确使用

### 语义化 HTML

```html
<!-- ✅ 正确 -->
<nav aria-label="主导航">
  <ul>
    <li><a href="/">首页</a></li>
  </ul>
</nav>

<!-- ❌ 错误 -->
<div class="nav">
  <div class="link" onclick="goHome()">首页</div>
</div>
```

## 5. 测试规范

### 测试金字塔

```
E2E 测试（少量）
    ↑
集成测试（适量）
    ↑
单元测试（大量）
```

### 组件测试模板

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click</Button>);
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

## 6. 组件文档规范

### Storybook 格式

```typescript
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'UI/Button',
  component: Button,
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['primary', 'secondary', 'outline'],
    },
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    children: 'Button',
    variant: 'primary',
  },
};
```

## 附录：技术栈参考

| 类别 | 推荐 |
|------|------|
| 框架 | React / Next.js |
| 语言 | TypeScript (strict mode) |
| 样式 | Tailwind CSS |
| 状态管理 | React Query + Zustand |
| 表单 | React Hook Form + Zod |
| 测试 | Vitest + Testing Library |
| 文档 | Storybook |
| Lint | ESLint + Prettier |
