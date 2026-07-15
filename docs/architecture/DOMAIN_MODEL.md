# DOMAIN MODEL

## Overview

The Map Project is not a mapping application.

It is a **Road Intelligence Platform**.

The map is only a visualization layer.

The real system revolves around events occurring on road infrastructure.

---

# Core Business Objects

The platform consists of the following core domains.

---

## User

Represents a citizen using the application.

Responsibilities

- Authentication
- Navigation
- Reporting hazards
- Receiving notifications
- Saving favourite places

---

## Authority

Represents a verified organization capable of publishing official road updates.

Examples

- Traffic Police
- Municipal Corporation
- Public Works Department
- Road Contractors

Responsibilities

- Publish road events
- Update road status
- Schedule future closures

---

## Organization

Represents an institution.

Examples

- Nashik Municipal Corporation
- Traffic Police
- PWD

An organization can contain multiple authority users.

---

## Road Network

Represents the complete road infrastructure imported from OpenStreetMap.

The application never owns the road network.

It only augments it.

---

## Road Segment

Represents the smallest navigable section of a road.

Road events affect road segments instead of entire roads.

---

## Road Event

Represents any temporary change affecting road travel.

Examples

- Road Closed
- Construction
- Accident
- Flood
- VIP Movement
- Police Barricade
- Festival Diversion

Road events have a start time and an end time.

---

## Hazard

Represents a user-reported issue.

Examples

- Pothole
- Waterlogging
- Fallen Tree
- Damaged Road

Hazards may become verified road events.

---

## Notification

Represents a message delivered to users.

Examples

- Road Closed Ahead
- Flood Alert
- Diversion Available

---

## Route

Represents a calculated navigation path.

Routes are generated dynamically.

Routes are not permanently stored.

---

## Device

Represents a physical mobile device.

Used for

- Push notifications
- Device management
- Session tracking

---

# Business Rules

Road Segments never disappear.

Road Events are temporary.

Hazards are community-generated.

Authorities create official Road Events.

Users cannot officially close roads.

Verified authority updates always have higher priority than public reports.

Road weights are determined by active Road Events.

The routing engine reads Road Segment data together with active Road Events.

---

# Event Flow

Authority

↓

Road Event Created

↓

Road Segment Updated

↓

Routing Engine

↓

Notification Engine

↓

Users Receive Updated Route

---

# Current Domain Status

Approved

Version

0.1.0