---
name: tailwind-design-system
description: 在使用 Tailwind CSS 构建 UI 时使用，确保设计系统一致性。Trigger on: "Tailwind", "design system", "design token", "utility classes".
---

# Tailwind 设计系统规范

> 共享技能 — Designer/Frontend 自动加载

## When to Load This Skill

| Role | Task Domain | Load? |
|------|------------|:-----:|
| Frontend | Styling, responsive design, dark mode | ✅ Always — load full |
| Designer | Design tokens, component styling | ✅ Always — load full |
| All other roles | N/A | ❌ Skip |

## 1. 设计 Token 体系

### 颜色系统

使用语义化 token，而非直接使用颜色值：

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    colors: {
      primary: {
        50: 'oklch(97% 0.01 250)',
        100: 'oklch(93% 0.02 250)',
        // ... 50-950
        950: 'oklch(15% 0.05 250)',
      },
      semantic: {
        success: 'oklch(65% 0.2 145)',
        warning: 'oklch(75% 0.15 85)',
        error: 'oklch(55% 0.25 25)',
        info: 'oklch(60% 0.15 250)',
      }
    }
  }
}
```

### 间距系统

基于 4px 网格：

| Token | 值 | 用途 |
|-------|-----|------|
| `space-1` | 4px | 紧凑间距 |
| `space-2` | 8px | 内边距 |
| `space-4` | 16px | 组件间距 |
| `space-6` | 24px | 区块间距 |
| `space-8` | 32px | 大区块间距 |

### 排版系统

9 级字体层级：

| 级别 | 类名 | 字号 | 行高 | 用途 |
|------|------|------|------|------|
| 1 | `text-9xl` | 128px | 1 | 装饰标题 |
| 2 | `text-8xl` | 96px | 1 | 大标题 |
| 3 | `text-7xl` | 72px | 1 | 页面标题 |
| 4 | `text-6xl` | 60px | 1.1 | 区块标题 |
| 5 | `text-5xl` | 48px | 1.2 | 主标题 |
| 6 | `text-4xl` | 36px | 1.3 | 副标题 |
| 7 | `text-3xl` | 30px | 1.4 | 小标题 |
| 8 | `text-2xl` | 24px | 1.5 | 正文大 |
| 9 | `text-xl` | 20px | 1.6 | 正文 |

## 2. 组件样式规范

### Button

4 种变体 × 5 种尺寸：

```html
<!-- 变体 -->
<button class="btn-primary">主要按钮</button>
<button class="btn-secondary">次要按钮</button>
<button class="btn-outline">轮廓按钮</button>
<button class="btn-ghost">幽灵按钮</button>

<!-- 尺寸 -->
<button class="btn-xs">超小</button>
<button class="btn-sm">小</button>
<button class="btn-md">中</button>
<button class="btn-lg">大</button>
<button class="btn-xl">超大</button>
```

### Card

4 种变体：

```html
<div class="card-default">默认卡片</div>
<div class="card-bordered">边框卡片</div>
<div class="card-elevated">阴影卡片</div>
<div class="card-filled">填充卡片</div>
```

## 3. 响应式设计规范

### 断点系统

| 断点 | 前缀 | 最小宽度 | 典型设备 |
|------|------|---------|---------|
| 超小屏 | (默认) | 0px | 手机竖屏 |
| 小屏 | `sm:` | 640px | 手机横屏 |
| 中屏 | `md:` | 768px | 平板 |
| 大屏 | `lg:` | 1024px | 笔记本 |
| 超大屏 | `xl:` | 1280px | 桌面显示器 |
| 巨大屏 | `2xl:` | 1536px | 大显示器 |

### Mobile-First 原则

```html
<!-- ✅ 正确：Mobile-First -->
<div class="w-full md:w-1/2 lg:w-1/3">

<!-- ❌ 错误：Desktop-First -->
<div class="w-1/3 md:w-1/2 w-full">
```

## 4. 暗色模式规范

### 配置

```javascript
// tailwind.config.js
module.exports = {
  darkMode: 'class', // 推荐使用 class 策略
}
```

### Token 映射表

| 浅色模式 | 暗色模式 | 用途 |
|---------|---------|------|
| `bg-white` | `dark:bg-gray-900` | 背景 |
| `text-gray-900` | `dark:text-gray-100` | 文本 |
| `border-gray-200` | `dark:border-gray-700` | 边框 |

## 5. 最佳实践

### 类名组织顺序

```html
<div class="
  <!-- 1. 布局 -->
  flex items-center justify-between
  <!-- 2. 尺寸 -->
  w-full max-w-md
  <!-- 3. 间距 -->
  p-4 gap-2
  <!-- 4. 外观 -->
  bg-white rounded-lg shadow
  <!-- 5. 交互 -->
  hover:shadow-md transition-shadow
">
```

### 反模式清单

- ❌ 使用 `@apply` 组合超过 5 个类
- ❌ 直接使用颜色值而非 token
- ❌ 忽略响应式设计
- ❌ 忽略暗色模式

## 6. 设计系统清单

在交付前检查：

- [ ] 使用语义化颜色 token
- [ ] 遵循 4px 间距网格
- [ ] 使用正确的字体层级
- [ ] 组件有完整的状态样式
- [ ] 支持响应式布局
- [ ] 支持暗色模式
- [ ] 无硬编码的颜色值
- [ ] 无内联样式
