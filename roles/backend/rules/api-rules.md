## API Rules

1. REST: nouns for resources, HTTP verbs for actions (GET /users, POST /users, PUT /users/:id)
2. Consistent error format: `{ "code": "ERROR_CODE", "message": "Human readable", "details": {} }`
3. Pagination: cursor-based for large datasets, offset-based for small
4. Versioning: `/api/v1/` prefix
5. Rate limiting on all public endpoints
6. Idempotency keys for write operations (POST/PUT)
7. All responses must include `X-Request-Id` header
8. HTTP status codes: 200 success, 201 created, 400 bad request, 401 unauthorized, 403 forbidden, 404 not found, 409 conflict, 422 validation error, 429 rate limited, 500 server error
9. Request validation at controller level (before service)
10. Response serialization: never return raw database entities
11. CORS: whitelist specific origins only
12. Content-Type: application/json for all API responses
