# ProofPack

ProofPack is a production-style Flutter application for creating **digital handover records** with photos, offline persistence, synchronization, and data integrity verification.

The project is being built incrementally with a focus on **real-world Flutter engineering practices**, rather than just UI development.

## Problem

Handover information is often scattered across:

* WhatsApp messages
* Photos
* Paper documents
* Notes
* Screenshots

This can make it difficult to determine what the actual condition was at the time of handover.

ProofPack provides a structured digital record containing the handover details, photos, timestamps, and synchronization status.

## Core Idea

```text
Create Handover
       ↓
Save Locally
       ↓
Work Offline
       ↓
Sync When Internet Is Available
       ↓
Track Sync Status
       ↓
Generate Integrity Proof
```

## Current Scope

The initial MVP focuses on:

* Creating digital handover records
* Adding photos
* Offline-first local persistence
* Hive-based local storage
* Firebase synchronization
* Connectivity monitoring
* Sequential synchronization
* Retry with backoff
* Individual photo synchronization tracking
* Proof ID and SHA-256 integrity verification
* Basic automated testing

## Architecture

The project follows a **feature-first Clean Architecture** approach.

```text
Presentation
     ↓
  Domain
     ↓
   Data
  ↙     ↘
Local   Remote
 ↓         ↓
Hive    Firebase
```

Current feature structure:

```text
lib/
├── core/
│
└── handover/
    ├── data/
    │   ├── adapter/
    │   ├── datasource/
    │   ├── model/
    │   └── repository/
    │
    ├── domain/
    │   ├── entity/
    │   ├── repository/
    │   └── usecase/
    │
    └── presentation/
        ├── bloc/
        ├── screens/
        └── widgets/
```

## Technology Stack

* Flutter
* Dart
* BLoC
* GetIt
* Hive
* Firebase
* Clean Architecture
* Feature-first architecture
* Offline-first data synchronization
* SHA-256 integrity hashing
* Unit, Widget and Integration Testing

## Engineering Focus

The primary goal of this project is to explore and demonstrate practical engineering concepts such as:

* Offline-first architecture
* Local persistence
* Repository pattern
* Data-source abstraction
* Connectivity-driven synchronization
* Retry and exponential backoff
* Sequential synchronization
* Partial/individual photo synchronization
* Data integrity verification
* Dependency injection
* Testable architecture

## Project Status

🚧 **Work in Progress**

The project is being developed incrementally. Features and architecture may evolve as implementation requirements become clearer.

## Future Possibilities

Potential future enhancements include:

* QR-based proof verification
* Authentication
* Additional handover types
* Web/Desktop verification client
* More advanced synchronization strategies

These are intentionally outside the initial MVP scope.

## Learning Approach

This project is being developed as a practical engineering exercise.

The implementation follows:

```text
Requirement
    ↓
Design
    ↓
Implementation
    ↓
Testing
    ↓
Review
    ↓
Improvement
```

The focus is on understanding **why** an architectural decision is made, not simply implementing a predefined solution.
