# SYSTEM ACTORS

## Overview

The Map Project consists of multiple actors interacting with the Road Intelligence Platform.

Each actor has different permissions and responsibilities.

---

# Actor 1 — Guest

Description

A user who has not signed in.

Permissions

- View map
- Search locations
- View public road events

Restrictions

- Cannot report hazards
- Cannot receive personalized notifications
- Cannot save favourites

---

# Actor 2 — Citizen

Description

A registered user.

Permissions

- Login
- Navigate
- Report hazards
- Save favourite places
- Receive notifications
- View nearby alerts

Restrictions

- Cannot publish official road closures

---

# Actor 3 — Verified Reporter

Description

A trusted citizen with higher reporting credibility.

Additional Permissions

- Faster report approval
- Higher confidence score

---

# Actor 4 — Authority Officer

Description

A verified authority account.

Examples

- Traffic Police
- Municipal Corporation
- PWD
- Road Contractor

Permissions

- Publish road closures
- Publish construction updates
- Publish diversions
- Schedule road events
- Edit active road events

Restrictions

Cannot modify system settings.

---

# Actor 5 — Organization Administrator

Description

Administrator of an organization.

Permissions

- Manage authority officers
- Approve organization members
- View organization analytics

---

# Actor 6 — System Administrator

Description

Platform administrator.

Permissions

- Manage all users
- Manage organizations
- Verify reports
- Suspend accounts
- Configure system settings
- View analytics

---

# Actor Relationships

Guest

↓

Citizen

↓

Verified Reporter

↓

Authority Officer

↓

Organization Administrator

↓

System Administrator

Higher roles inherit lower permissions where applicable.

---

# Authentication

Authentication is handled using Supabase Authentication.

Supported providers

- Google
- Email

---

# Authorization

Role Based Access Control (RBAC)

Permissions are enforced at

- API Level
- Database Level (RLS)
- Frontend