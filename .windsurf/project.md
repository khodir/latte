# Project Configuration for Windsurf AI

## Project Metadata
- **Name**: Latte
- **Type**: Full-stack web application
- **Primary Language**: Ruby (Rails 8.0)
- **Frontend**: Vue.js 3 + TypeScript
- **Database**: MariaDB
- **Architecture**: Multi-tenant SaaS application

## Technology Stack

### Backend
- **Framework**: Ruby on Rails 8.0.2
- **Database**: MariaDB with Trilogy adapter
- **Authentication**: Devise
- **Authorization**: Custom tenant-based authorization
- **Type Safety**: Sorbet
- **Testing**: RSpec, Capybara
- **Deployment**: Kamal + Docker
- **Monitoring**: OpenTelemetry, Prometheus

### Frontend
- **Framework**: Vue.js 3 with Composition API
- **Language**: TypeScript
- **UI Library**: Quasar Framework
- **Styling**: Tailwind CSS
- **Build Tool**: Vite
- **SPA Integration**: Inertia.js

### Development Tools
- **Code Quality**: RuboCop (Rails Omakase), Brakeman
- **Package Management**: Bundler (Ruby), npm (Node.js)
- **Version Control**: Git
- **IDE**: Supports Rails and Vue.js development

## Key Features
- Multi-tenant point of sales system
- Product management with categories and images
- Sales transaction processing
- User authentication and authorization
- File upload with Active Storage
- Responsive web interface
- RESTful API design

## Development Environment
- **Ruby Version**: As specified in `.ruby-version`
- **Node.js**: Required for frontend build tools
- **Database**: MariaDB/MySQL compatible
- **Docker**: For containerized deployment

## Important Directories
- `app/models/` - ActiveRecord models
- `app/controllers/` - Rails controllers
- `app/frontend/` - Vue.js frontend code
- `config/` - Rails configuration
- `db/` - Database migrations and schema
- `spec/` - RSpec tests

## Business Domain
The application provides point of sales functionality for multiple companies (perusahaan) with:
- Items with codes, names, descriptions, and images
- Categorization system for items
- Multi-tenant data isolation
- User management and authentication

## Deployment Strategy
- Docker containerization
- Kamal for deployment orchestration
- Environment-specific configurations
- Health checks and monitoring
