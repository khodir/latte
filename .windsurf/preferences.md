# Windsurf AI Preferences for Latte Project

## Code Generation Preferences

### Ruby/Rails Code Style
- Prefer explicit method names over abbreviated ones
- Use Rails conventions and idioms consistently
- Implement proper error handling with meaningful messages
- Use strong parameters for all controller actions
- Prefer `find_by!` over `find_by` for better error handling

### Frontend Code Style
- Use Vue 3 Composition API with `<script setup>` syntax
- Implement comprehensive TypeScript types
- Use Quasar components over custom HTML when available
- Apply Tailwind utility classes for styling
- Keep components focused and single-responsibility

### Database Interactions
- Always use scopes for tenant isolation (`by_perusahaan`)
- Implement eager loading with `includes()` to prevent N+1 queries
- Use transactions for multi-step operations
- Include proper validations and constraints

## AI Assistant Behavior

### Code Suggestions
- **Always suggest complete, working solutions** rather than partial code snippets
- **Include all necessary imports and dependencies**
- **Provide context-aware suggestions** based on existing codebase patterns
- **Follow established naming conventions** in the project

### Problem Solving Approach
- **Analyze the full context** before suggesting solutions
- **Consider multi-tenancy implications** for all data operations
- **Think about both frontend and backend** when implementing features
- **Suggest proper testing approaches** for new code

### Error Handling
- **Implement comprehensive error handling** in all suggestions
- **Use Rails flash messages** for user feedback
- **Handle both validation errors and system errors**
- **Provide meaningful error messages** to users

## Feature Implementation Guidelines

### New Model Creation
1. Include proper associations and validations
2. Implement tenant scoping with `by_perusahaan`
3. Add custom serialization methods if needed
4. Include audit fields (`created_by`, `updated_by`)

### New Controller Actions
1. Use Inertia.js for rendering Vue components
2. Implement proper authorization checks
3. Use transactions for data modifications
4. Include pagination for list views
5. Provide proper flash messages

### New Frontend Components
1. Use TypeScript with proper type definitions
2. Implement proper prop validation
3. Use Quasar components for consistency
4. Handle loading and error states
5. Follow responsive design principles

## Testing Preferences

### Backend Testing
- Write RSpec tests for all new models and controllers
- Include both positive and negative test cases
- Test authorization and tenant isolation
- Use descriptive test names that explain behavior

### Frontend Testing
- Test component behavior and user interactions
- Mock external dependencies appropriately
- Test TypeScript type safety
- Include accessibility testing considerations

## Documentation Standards

### Code Comments
- Document complex business logic
- Explain non-obvious design decisions
- Include examples for complex methods
- Document API contracts and expected data formats

### Commit Messages
- Use descriptive commit messages
- Reference issue numbers when applicable
- Explain the "why" not just the "what"
- Keep commits focused and atomic

## Performance Considerations

### Database Optimization
- Always consider query performance implications
- Suggest appropriate database indexes
- Use pagination for large datasets
- Monitor for N+1 query patterns

### Frontend Optimization
- Consider bundle size impact of new dependencies
- Suggest lazy loading for large components
- Optimize image and asset loading
- Consider caching strategies

## Security Mindset

### Data Protection
- Always validate and sanitize user inputs
- Implement proper authorization checks
- Consider GDPR and data privacy implications
- Use secure file upload practices

### Authentication & Authorization
- Leverage Devise authentication patterns
- Implement proper role-based access control
- Validate tenant data isolation
- Use secure session management

## Communication Style

### Code Explanations
- Provide clear, concise explanations
- Focus on the business value of changes
- Explain architectural decisions
- Include migration and deployment considerations

### Problem Diagnosis
- Ask clarifying questions when requirements are unclear
- Suggest alternative approaches when appropriate
- Consider backward compatibility implications
- Think about scalability and maintainability

## Integration Patterns

### Inertia.js Usage
- Pass minimal, focused data as props
- Handle form submissions with Inertia helpers
- Implement proper loading states
- Use Inertia's built-in error handling

### API Design
- Follow RESTful conventions
- Use consistent response formats
- Include proper HTTP status codes
- Implement versioning when needed

## Deployment Considerations

### Docker & Kamal
- Consider containerization implications
- Think about environment-specific configurations
- Include health check considerations
- Plan for zero-downtime deployments

### Monitoring & Observability
- Include logging for important operations
- Consider metrics and monitoring needs
- Plan for error tracking and alerting
- Think about performance monitoring
