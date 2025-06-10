# API Design Best Practices

## RESTful API Guidelines

### URL Structure
- Use nouns, not verbs in endpoints
- Use plural nouns for consistency
- Use hierarchical structure for relationships
- Examples:
  - `GET /api/v1/users` - List all users
  - `GET /api/v1/users/{id}` - Get specific user
  - `GET /api/v1/users/{id}/orders` - Get user's orders
  - `POST /api/v1/users` - Create new user
  - `PUT /api/v1/users/{id}` - Update user
  - `DELETE /api/v1/users/{id}` - Delete user

### HTTP Methods
- **GET**: Retrieve resources (idempotent)
- **POST**: Create new resources
- **PUT**: Update entire resource
- **PATCH**: Partial update
- **DELETE**: Remove resources

### Status Codes
- **2xx Success**
  - `200 OK` - General success
  - `201 Created` - Resource created
  - `204 No Content` - Success with no response body
- **4xx Client Errors**
  - `400 Bad Request` - Invalid request
  - `401 Unauthorized` - Authentication required
  - `403 Forbidden` - Access denied
  - `404 Not Found` - Resource not found
  - `422 Unprocessable Entity` - Validation errors
- **5xx Server Errors**
  - `500 Internal Server Error` - Server error
  - `503 Service Unavailable` - Service temporarily unavailable

### Request/Response Format
```json
// Success Response
{
  "status": "success",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "meta": {
    "timestamp": "2024-01-01T12:00:00Z"
  }
}

// Error Response
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Pagination
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 100,
    "total_pages": 5,
    "links": {
      "first": "/api/v1/users?page=1",
      "last": "/api/v1/users?page=5",
      "next": "/api/v1/users?page=2",
      "prev": null
    }
  }
}
```

### Filtering and Sorting
- Filtering: `/api/v1/users?status=active&role=admin`
- Sorting: `/api/v1/users?sort=created_at&order=desc`
- Field selection: `/api/v1/users?fields=id,name,email`

### API Versioning
- URL versioning: `/api/v1/users`
- Header versioning: `Accept: application/vnd.api+json;version=1`
- Choose one approach and be consistent

### Authentication
- Use standard authentication methods:
  - Bearer tokens (JWT)
  - OAuth 2.0
  - API keys for server-to-server
- Always use HTTPS
- Include authentication in headers: `Authorization: Bearer {token}`

### Rate Limiting
- Implement rate limiting headers:
  - `X-RateLimit-Limit`: Maximum requests per window
  - `X-RateLimit-Remaining`: Requests remaining
  - `X-RateLimit-Reset`: Time when limit resets

### CORS Configuration
- Configure appropriate CORS headers
- Be specific about allowed origins in production
- Include necessary headers:
  - `Access-Control-Allow-Origin`
  - `Access-Control-Allow-Methods`
  - `Access-Control-Allow-Headers`

## OpenAPI/Swagger Specification

### Basic Structure
```yaml
openapi: 3.0.0
info:
  title: Sample API
  description: API description
  version: 1.0.0
  contact:
    email: api@example.com
servers:
  - url: https://api.example.com/v1
    description: Production server
paths:
  /users:
    get:
      summary: List all users
      operationId: listUsers
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
components:
  schemas:
    User:
      type: object
      required:
        - id
        - email
      properties:
        id:
          type: integer
        email:
          type: string
          format: email
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
```

### Documentation Best Practices
- Document all endpoints
- Include request/response examples
- Describe error scenarios
- Specify required vs optional parameters
- Use consistent naming conventions
- Include authentication requirements

### API Testing
- Write comprehensive API tests
- Test all status codes
- Validate response schemas
- Test error scenarios
- Performance testing for endpoints
- Security testing (injection, authentication)

### GraphQL Considerations
- Define clear schema
- Implement proper resolvers
- Handle N+1 query problems
- Implement query depth limiting
- Use DataLoader for batching
- Proper error handling

### WebSocket Best Practices
- Define clear message protocols
- Implement heartbeat/ping-pong
- Handle reconnection logic
- Proper error handling
- Authentication for connections
- Rate limiting for messages