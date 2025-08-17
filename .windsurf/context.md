# Project Context for Windsurf AI

## Project: Latte
A modern multi-tenant point of sales system built with Rails 8.0 and Vue.js 3.

## Architecture Overview

### Backend (Rails 8.0)
- **Framework**: Ruby on Rails 8.0.2
- **Database**: MariaDB with Trilogy adapter
- **Authentication**: Devise
- **Deployment**: Kamal with Docker
- **Observability**: OpenTelemetry + Prometheus
- **Caching**: Solid Cache, Solid Queue, Solid Cable

### Frontend (Vue.js 3 + TypeScript)
- **Framework**: Vue.js 3 with Composition API
- **Language**: TypeScript
- **UI Framework**: Quasar
- **Styling**: Tailwind CSS
- **Build Tool**: Vite
- **SPA Integration**: Inertia.js

### Key Business Models
1. **Perusahaan** (Company) - Multi-tenant architecture
2. **Item** - Inventory items with categories and images
3. **Category** - Item categorization system
4. **User** - Authentication with Devise
5. **ItemCategory** - Many-to-many join table

### File Structure Patterns
- **Models**: `app/models/` - Business logic and data validation
- **Controllers**: `app/controllers/` - Request handling with Inertia rendering
- **Frontend**: `app/frontend/` - Vue.js components and TypeScript
- **Tests**: `spec/` - RSpec tests with fixtures

### Data Flow
1. Rails controllers handle HTTP requests
2. Controllers use Inertia.js to render Vue components
3. Vue components receive data as props from Rails
4. Form submissions go through Inertia back to Rails
5. Database operations use ActiveRecord with proper scoping

### Multi-tenancy Pattern
- All data is scoped by `perusahaan_id`
- Controllers use `@current_perusahaan` for data isolation
- Models implement `by_perusahaan` scopes
- Authorization checks ensure tenant data separation

### Image Handling
- Active Storage for file uploads
- S3 integration available (aws-sdk-s3)
- Image URLs generated through model methods
- Proper file validation and cleanup

### Testing Strategy
- RSpec for backend testing
- Model, controller, and request specs
- Fixtures for test data
- SimpleCov for coverage reporting

### Development Tools
- Brakeman for security scanning
- RuboCop for code style (Rails Omakase)
- Hirb for console formatting
- Debug gem for debugging

## Common Patterns in Codebase

### Controller Pattern
```ruby
class ItemController < ApplicationController
  def show
    @data = Item.by_perusahaan(@current_perusahaan.id)
    # Apply filters and pagination
    render inertia: "master/item/show", props: { data: @data }
  end
end
```

### Model Pattern
```ruby
class Item < ApplicationRecord
  belongs_to :perusahaan
  has_many :item_category
  has_many :category, through: :item_category
  
  scope :by_perusahaan, ->(id) { where(perusahaan_id: id) }
  
  def as_json(options = {})
    super(options).merge({ image_url: self.image_url })
  end
end
```

### Frontend Component Pattern
- Vue 3 Composition API with `<script setup>`
- TypeScript for type safety
- Quasar components for UI
- Inertia props for data from Rails

## Development Workflow
1. Backend-first development with Rails
2. Frontend components built with Vue.js
3. Inertia.js bridges the gap seamlessly
4. Tests written for both layers
5. Docker deployment with Kamal

## Performance Considerations
- Eager loading with `includes()` to avoid N+1 queries
- Pagination for large datasets
- Database indexing for performance
- Vite for optimized frontend builds
- CDN integration for assets

## Security Measures
- Devise for authentication
- Strong parameters in controllers
- CSRF protection enabled
- Tenant data isolation
- File upload validation
- Brakeman security scanning
