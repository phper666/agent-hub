## State Management Rules

1. Server state → React Query (fetch, cache, sync)
2. Client state (global) → Zustand (simple store)
3. Client state (local) → useState / useReducer
4. Form state → React Hook Form + Zod validation
5. URL state → useSearchParams (Next.js)
6. Never store server state in Zustand — use React Query
7. Never use Context for high-frequency updates (input, scroll)
8. Query keys must be structured: `['users', userId, 'posts']`
9. Mutations must invalidate related queries
10. Optimistic updates for instant feedback on user actions
