# DOMAIN DICTIONARY

This document defines the meaning of every core business term used throughout the project.

These definitions are considered the single source of truth.

---

# User

A person using the mobile application.

A user may navigate, receive notifications, report incidents and manage personal preferences.

---

# Authority

A verified government department or authorized contractor capable of publishing official road events.

Authorities always have higher trust than public reports.

---

# Organization

An institution responsible for one or more authority users.

Examples

- Nashik Municipal Corporation
- Traffic Police
- Public Works Department

---

# Road Network

The complete map imported from OpenStreetMap.

The project never modifies the original map.

---

# Road Segment

The smallest navigable section of a road.

Every road event references one or more road segments.

---

# Incident Report

A report submitted by a citizen describing a temporary issue.

Examples

- Pothole
- Flood
- Accident
- Fallen Tree
- Damaged Road
- Waterlogging

Incident reports require verification.

---

# Road Event

An official event affecting road navigation.

Examples

- Road Closed
- Diversion
- Construction
- VIP Movement
- Festival Restriction

Road events directly affect routing.

---

# Verification

The process of confirming an Incident Report.

Verification may be performed by

- Authority
- Administrator
- Confidence Algorithm

---

# Confidence Score

A numerical value representing how trustworthy an Incident Report is.

Confidence increases when

- More users report the same issue.
- A verified reporter submits it.
- An authority confirms it.

---

# Route

A dynamically calculated navigation path.

Routes are never permanently stored.

---

# Notification

A message delivered to a user.

Examples

- Road Closed Ahead
- Flood Warning
- Diversion Available

---

# Device

A physical smartphone registered for push notifications.

---

# Road Intelligence Layer

The logical layer combining

Road Events

+

Incident Reports

+

Confidence Scores

+

Authority Updates

This layer provides live data to the Routing Engine.

---

# Routing Engine

The software responsible for calculating the best path.

GraphHopper is the selected routing engine.

---

# Map Layer

Visual representation of OpenStreetMap.

The map itself contains no business logic.

---

# Event Lifecycle

Incident Report

↓

Verification

↓

Road Event

↓

Route Recalculation

↓

Notification

↓

Archive

---

Version

0.1.0