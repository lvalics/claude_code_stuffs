# Task Specification Template

## Task Overview
**Task ID:** {{JIRA_TASK_ID}}  
**Title:** {{TASK_TITLE}}  
**Priority:** High / Medium / Low  
**Estimated Effort:** {{STORY_POINTS}} points / {{HOURS}} hours  
**Sprint:** {{SPRINT_NUMBER}}  

## Background
Provide context about why this task is needed and what problem it solves.

## Objectives
- Primary objective
- Secondary objectives (if any)

## Requirements

### Functional Requirements
1. **FR1:** Description of functional requirement 1
2. **FR2:** Description of functional requirement 2
3. **FR3:** Description of functional requirement 3

### Non-Functional Requirements
1. **Performance:** Response time < 200ms for API calls
2. **Security:** All endpoints must be authenticated
3. **Scalability:** Support for 1000 concurrent users
4. **Compatibility:** Support latest 2 versions of major browsers

## Technical Specifications

### Architecture Overview
Describe how this fits into the overall system architecture.

### Database Changes
```sql
-- Example schema changes
ALTER TABLE users ADD COLUMN last_login TIMESTAMP;
CREATE INDEX idx_users_last_login ON users(last_login);
```

### API Endpoints (if applicable)
```
POST /api/v1/resource
GET /api/v1/resource/{id}
PUT /api/v1/resource/{id}
DELETE /api/v1/resource/{id}
```

### Data Models
```typescript
interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  createdAt: Date;
  updatedAt: Date;
}
```

## User Interface

### UI/UX Requirements
- Mockup links or descriptions
- User flow diagrams
- Responsive design requirements

### Accessibility Requirements
- WCAG 2.1 Level AA compliance
- Keyboard navigation support
- Screen reader compatibility

## Acceptance Criteria
- [ ] AC1: User can successfully create a new resource
- [ ] AC2: Validation errors are displayed clearly
- [ ] AC3: Success message appears after creation
- [ ] AC4: List updates automatically after creation
- [ ] AC5: All tests pass with >80% coverage

## Testing Strategy

### Unit Tests
- Test all service methods
- Test validation logic
- Test error handling

### Integration Tests
- Test API endpoints
- Test database operations
- Test third-party integrations

### E2E Tests
- Test complete user workflows
- Test across different browsers

## Dependencies
- **Blocker:** [JIRA-123] Must be completed first
- **Related:** [JIRA-456] Related feature

## Risks and Mitigation
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| API rate limits | Medium | High | Implement caching |
| Data migration issues | Low | High | Create rollback plan |

## Definition of Done
- [ ] Code complete and follows coding standards
- [ ] Unit tests written and passing
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Deployed to staging environment
- [ ] QA testing passed
- [ ] Product owner approval received

## Notes
Additional information, assumptions, or constraints.

## Resources
- [Design Mockup](link-to-mockup)
- [API Documentation](link-to-api-docs)
- [Related RFC](link-to-rfc)

---
**Created by:** {{AUTHOR}}  
**Date:** {{DATE}}  
**Last Updated:** {{LAST_UPDATED}}