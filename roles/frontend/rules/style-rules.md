## Style Rules

1. Tailwind CSS is the only styling approach — no CSS-in-JS, no CSS modules, no styled-components
2. Use the project's Tailwind design tokens — no custom hex colors
3. Mobile-first responsive: `base → sm → md → lg → xl`
4. Use Tailwind's spacing scale (multiples of 4px)
5. Dark mode: use `dark:` variants, never hardcode light/dark colors
6. Animations: use Tailwind transitions, respect `prefers-reduced-motion`
7. Z-index: use the project's z-index scale, never use arbitrary values
8. Font sizes: use Tailwind's type scale only
9. Shadows: use Tailwind's shadow scale, consistent with design system
10. Group related styles with `@apply` in component-level CSS only when Tailwind classes exceed 8+
