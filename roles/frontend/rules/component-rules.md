## Component Rules

1. Every component must have TypeScript props interface
2. Every component file must be < 200 lines — split if larger
3. No inline styles — use Tailwind classes only
4. Props drilling > 3 levels → use context or state management
5. All async operations must have loading + error + empty states
6. All images must have alt text
7. All interactive elements must be keyboard accessible
8. Use semantic HTML (button, nav, main, section, article)
9. Destructure props in function signature
10. Export component as default + named export
11. Co-locate tests with components: `Component.test.tsx`
12. No magic numbers — extract to constants or Tailwind config
