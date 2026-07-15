# Contributing to The Map Project

Welcome to **The Map Project**!

This document outlines the development standards, architecture, and workflow used throughout the project.

---

# Development Workflow

Every new feature should be developed in its own branch.

Example:

```
feature/report-incident
feature/navigation
feature/auth
feature/profile
```

Bug fixes:

```
fix/login
fix/map-crash
```

Documentation:

```
docs/readme
docs/api
```

---

# Commit Convention

Use Conventional Commits.

Examples:

```
feat: add Google authentication

fix: resolve GPS permission issue

refactor: improve map architecture

docs: update README

chore: remove unused files
```

---

# Flutter Architecture

The project follows a feature-first architecture.

```
apps/
└── mobile/
    └── lib/
        ├── core/
        ├── features/
        ├── models/
        └── routes/
```

Each feature should contain:

```
models/
pages/
providers/
repositories/
services/
widgets/
```

---

# State Management

State management is handled using **Riverpod**.

All business logic should live inside repositories or services.

Widgets should remain lightweight.

---

# Backend

Backend services are powered by **Supabase**.

Do not access Supabase directly from UI widgets.

Use the Repository Pattern.

---

# Code Quality

Before every commit, run:

```bash
flutter analyze
```

No analyzer issues should remain.

---

# Pull Requests

Every pull request should:

- Compile successfully
- Pass flutter analyze
- Follow project architecture
- Include a meaningful description

---

Happy Coding!