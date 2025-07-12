# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Get5 API is a Phoenix/Elixir web application for managing Counter-Strike competitive matches. It provides a web interface and API for tournament management, integrating with game servers via RCON protocol.

## Development Commands

### Setup
```bash
# Using Docker (recommended)
docker-compose up
docker-compose run web mix ecto.setup  # First time only

# Native Elixir
mix deps.get
mix ecto.setup
mix phx.server
```

### Common Development Tasks
```bash
# Run the development server
mix phx.server

# Run tests
mix test
mix test path/to/test_file.exs  # Run specific test file

# Database operations
mix ecto.create
mix ecto.migrate
mix ecto.reset  # Drop, create, migrate and seed

# Code formatting
mix format
mix format path/to/file.ex  # Format specific file

# Compile with warnings as errors
mix compile --warnings-as-errors

# Deploy assets (for production)
mix assets.deploy
```

## Architecture Overview

The application follows Phoenix's context pattern, separating business logic from the web layer:

### Core Contexts (`lib/get5_api/`)
- **Accounts**: User authentication and management
- **Matches**: Match lifecycle management (creation, status updates, completion)
- **Teams**: Team and player roster management
- **GameServers**: RCON communication and server configuration
- **Stats**: Match statistics aggregation
- **MapSelections**: Map veto/selection logic for matches

### Web Layer (`lib/get5_api_web/`)
- **LiveViews** (`/live/`): Real-time UI components using Phoenix LiveView
- **Controllers**: Traditional request/response endpoints
- **Resolvers**: GraphQL API resolvers for Absinthe
- **Components**: Reusable UI components using Phoenix Components

### Key Architectural Patterns
1. **LiveView for Real-time Updates**: Most UI uses LiveView for WebSocket-based updates without custom JavaScript
2. **GraphQL API**: Flexible querying via Absinthe at `/api/graphql/v1`
3. **REST Endpoints**: Game server integration endpoints for match events
4. **RCON Protocol**: Direct game server communication using the `rcon` library

## Testing Approach

Tests include fixtures and mocks for external services:
- Mock RCON server for game server communication testing
- Database sandboxing for isolation
- LiveView testing helpers for UI components

Run tests in watch mode during development:
```bash
mix test.watch  # If configured
```

## Important Files and Patterns

### Database Migrations
Located in `priv/repo/migrations/`. Always review existing schema before adding new fields.

### LiveView Modules
Follow the pattern in existing LiveViews:
- Mount/handle_event/handle_info lifecycle
- Use `assign_defaults/2` for common assigns
- Implement proper error handling with flash messages

### GraphQL Schema
- Schema definitions in `lib/get5_api_web/schema/`
- Resolvers in `lib/get5_api_web/resolvers/`
- Always handle authorization in resolvers

### RCON Communication
- Use `Get5Api.GameServers.Rcon` module for server communication
- Handle connection failures gracefully
- Test with mock RCON server in `test/support/`

## Development Tips

1. **Database URLs**: Use `DATABASE_URL` environment variable or config files
2. **LiveView Updates**: Prefer server-side state management over JavaScript
3. **Error Handling**: Use `{:ok, result}` / `{:error, reason}` tuples consistently
4. **Testing**: Write tests for new features, especially for contexts and LiveViews
5. **Formatting**: Run `mix format` before committing code