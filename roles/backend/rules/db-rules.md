## Database Rules

1. Migrations only — never modify schema directly in production
2. Every table must have: `id`, `created_at`, `updated_at`
3. Use soft deletes (`deleted_at`) for user-facing data
4. Index columns used in WHERE / JOIN / ORDER BY
5. No N+1 queries — use eager loading or batch queries
6. Transactions for multi-table writes
7. Foreign keys with ON DELETE behavior specified
8. No SELECT * — always specify columns
9. Use UUID or ULID for public-facing IDs (never expose auto-increment)
10. Migration must be reversible (up + down)
11. Seed data only for development, never for production
12. Connection pooling: use configured pool, never create raw connections
