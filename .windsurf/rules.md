# Windsurf AI Coding Rules and Guidelines

## Project Overview
This is a Rails 8.0 application with Vue.js 3 + TypeScript frontend using Inertia.js, Quasar UI framework, and Tailwind CSS. The project follows a modern full-stack architecture with proper separation of concerns.

## Core Technologies
- **Backend**: Ruby on Rails 8.0, Puma, MariaDB (Trilogy), Devise authentication
- **Frontend**: Vue.js 3, TypeScript, Inertia.js, Quasar, Tailwind CSS, Vite
- **Testing**: RSpec, Capybara, Selenium WebDriver
- **Deployment**: Kamal, Docker
- **Type Safety**: TypeScript (Frontend)
- **Observability**: OpenTelemetry, Prometheus

## Ruby/Rails Guidelines

### Code Style & Structure
- Follow Rails conventions and the principle of "Convention over Configuration"
- Prefer explicit over implicit - use clear method names and variable names
- Use strong parameters for all controller actions
- Implement proper error handling with transactions for data consistency

### Model Guidelines
- Use descriptive model names that reflect business domain
- Implement proper validations with clear error messages
- Use scopes for reusable query logic (e.g., `scope :by_perusahaan`)
- Override `as_json` when custom serialization is needed
- Use `belongs_to`, `has_many`, `has_one` associations appropriately
- Implement custom table names when needed (`self.table_name = "item"`)

### Controller Guidelines
- Keep controllers thin - business logic belongs in models or services
- Use before_actions for common functionality
- Implement proper authorization checks
- Use Inertia.js for rendering frontend components
- Follow RESTful conventions (show, new, edit, create, update, destroy)
- Use transactions for multi-step operations
- Implement proper flash messages for user feedback

### Database Guidelines
- Use descriptive migration names with timestamps
- Include proper indexes for performance
- Use foreign key constraints where appropriate
- Follow Rails naming conventions for tables and columns

## Frontend Guidelines

### Vue.js + TypeScript
- Use Composition API with `<script setup>` syntax
- Implement proper TypeScript types for all props, emits, and data
- Use Pinia for state management when needed
- Follow Vue.js style guide conventions
- Use single-file components (.vue files)

### Inertia.js Integration
- Use Inertia for seamless SPA-like navigation
- Pass data from Rails controllers as props to Vue components
- Handle form submissions with Inertia's form helpers
- Implement proper loading states and error handling

### Styling Guidelines
- Use Tailwind CSS utility classes for styling
- Leverage Quasar components for consistent UI
- Follow mobile-first responsive design principles
- Use semantic HTML elements
- Maintain consistent spacing and typography
- Use Font Awesome for Icons

### File Organization
- Place Vue components in `app/frontend/components/`
- Organize pages in `app/frontend/pages/` matching Rails routes
- Use `app/frontend/layouts/` for layout components
- Keep assets in `app/frontend/assets/`

## Testing Guidelines

### RSpec (Backend)
- Write descriptive test names that explain the behavior
- Use proper test structure: Arrange, Act, Assert
- Test both happy path and edge cases
- Use factories for test data (Faker gem available)
- Test model validations, associations, and custom methods
- Test controller actions with proper authentication context

### Frontend Testing
- Write unit tests for complex Vue components
- Test user interactions and form submissions
- Mock external dependencies and API calls
- Test TypeScript type safety

## Security Guidelines

### Authentication & Authorization
- Use Devise for authentication
- Implement proper authorization checks in controllers
- Validate user permissions before data access
- Use strong parameters to prevent mass assignment
- Implement CSRF protection (Rails default)

### Data Protection
- Sanitize user inputs
- Use parameterized queries (Rails default with ActiveRecord)
- Implement proper file upload validation
- Use secure headers and CSP policies

## Performance Guidelines

### Backend Optimization
- Use database indexes for frequently queried columns
- Implement eager loading with `includes()` to avoid N+1 queries
- Use pagination for large datasets
- Implement caching where appropriate (Solid Cache available)
- Monitor database query performance

### Frontend Optimization
- Implement code splitting with Vite
- Optimize images and assets
- Use lazy loading for components when appropriate
- Minimize bundle size and dependencies

## Development Workflow

### Code Quality
- Run RuboCop for Ruby code style enforcement
- Use Brakeman for security vulnerability scanning
- Run TypeScript compiler checks
- Write comprehensive tests before deploying

### Git Practices
- Use descriptive commit messages
- Create feature branches for new development
- Use pull requests for code review
- Keep commits atomic and focused

### Environment Management
- Use environment-specific configuration files
- Keep sensitive data in environment variables
- Use Rails credentials for secrets management
- Test in development environment before staging

## Error Handling

### Backend Error Handling
- Use Rails rescue_from for global error handling
- Implement proper logging with structured data
- Use transactions for data consistency
- Provide meaningful error messages to users

### Frontend Error Handling
- Implement global error boundaries
- Handle API errors gracefully
- Provide user-friendly error messages
- Log errors for debugging

## API Design

### RESTful Principles
- Use standard HTTP methods (GET, POST, PUT, DELETE)
- Implement consistent URL patterns
- Return appropriate HTTP status codes
- Use JSON for API responses

### Data Serialization
- Use `as_json` with proper options for model serialization
- Include related data when needed (`include: [:category]`)
- Implement pagination metadata in responses

## Deployment & DevOps

### Docker & Kamal
- Use multi-stage Docker builds for optimization
- Implement proper health checks
- Use environment-specific configurations
- Monitor application performance and logs

### Observability
- Implement OpenTelemetry tracing
- Use Prometheus metrics for monitoring
- Set up proper logging with structured data
- Monitor application performance and errors

## File Naming Conventions

### Ruby Files
- Use snake_case for file names
- Match class names to file names
- Use descriptive names that reflect functionality

### Frontend Files
- Use PascalCase for Vue component files
- Use kebab-case for utility files
- Organize files by feature/domain

## Documentation

### Code Documentation
- Write clear comments for complex business logic
- Document API endpoints and parameters
- Maintain up-to-date README files
- Document deployment and setup procedures

### Type Annotations
- Implement comprehensive TypeScript types
- Document complex type definitions
- Use JSDoc comments for JavaScript/TypeScript functions

## Specific Project Patterns

### Multi-tenancy (Perusahaan)
- Always scope queries by `perusahaan_id`
- Use `by_perusahaan` scopes consistently
- Implement proper authorization for tenant data
- Include `perusahaan_id` in all relevant models

### File Uploads
- Use Active Storage for file management
- Implement proper file validation
- Provide image URLs through model methods
- Handle file deletion properly

### Category Management
- Use many-to-many relationships through join tables
- Implement proper category assignment and updates
- Handle category deletion gracefully
- Maintain data consistency in transactions

## Common Pitfalls to Avoid

1. **N+1 Queries**: Always use `includes()` for associations
2. **Missing Validations**: Implement proper model validations
3. **Unsafe Parameters**: Always use strong parameters
4. **Missing Transactions**: Use transactions for multi-step operations
5. **Inconsistent Naming**: Follow Rails and Vue.js conventions
6. **Missing Type Annotations**: Use TypeScript consistently
7. **Poor Error Handling**: Implement comprehensive error handling
8. **Security Vulnerabilities**: Follow security best practices
9. **Performance Issues**: Monitor and optimize database queries
10. **Missing Tests**: Write comprehensive test coverage

## Code Review Checklist

- [ ] Proper type annotations (TypeScript)
- [ ] Strong parameters used in controllers
- [ ] Proper validations in models
- [ ] Transactions used for multi-step operations
- [ ] Eager loading implemented to avoid N+1 queries
- [ ] Proper error handling and user feedback
- [ ] Security considerations addressed
- [ ] Tests written and passing
- [ ] Code follows project conventions
- [ ] Documentation updated if needed
