# Warisan Kating — Sprint Checklist

## ~~Sprint 1: Project Setup & Core Architecture~~ ✅
- [x] Initialize Flutter project
- [x] Create scalable folder structure (`lib/features`, `lib/core`, `lib/shared`, `lib/services`)
- [x] Add essential dependencies (Firebase, Provider, image_picker, uuid, google_fonts)
- [x] Setup basic routing & BottomNavigationBar shell (Home, Add, Chat, Profile)
- [x] Create data models — `Item`, `User`, `ChatMessage`, `ChatRoom`, `Barter`
- [x] Create abstract service layer + mock implementations for offline UI testing
- [x] Firebase.initializeApp() enabled in main.dart
- [x] Global AppTheme design system (Indigo/Teal + Amber palette, Poppins/Inter typography, 12px shapes)

## ~~Sprint 2: Authentication & User Profile~~ 🔲 (deferred)
- [ ] Firebase Auth — email/password sign-up & login
- [ ] Auth state management with Provider
- [ ] User profile CRUD (Firestore `users` collection)
- [ ] Profile avatar upload (Firebase Storage + image_picker)
- [ ] Auth guard / redirect for protected routes

> **Note:** Sprint 2 (Auth) is scaffolded with placeholder profile screen and `current-user` stubs throughout the codebase. Replace stubs with real auth in a future iteration.

## ~~Sprint 3: Product Listings & Barter Flow~~ ✅
- [x] Product model & Firestore `products` collection
- [x] Home feed — real-time StreamBuilder from Firestore `items` collection
- [x] Wire services via Provider into app
- [x] Add-product form (title, desc, price, condition dropdown)
- [x] Image picker integration (camera + gallery via bottom sheet)
- [x] Image compression — iterative JPEG quality reduction to ≤ 300 KB
- [x] FirestoreItemService — upload image to Storage, save item with downloadURL
- [x] Error handling (try-catch on all Firestore/Storage operations)
- [x] Product detail screen (hero image, info, description)
- [x] Barter request flow (create via dialog, accept, reject)
- [x] Barter model + FirestoreBarterService (Firestore `barters` collection)

## ~~Sprint 4: Chat, Notifications & Polish~~ ✅
- [x] Real-time chat per barter (Firestore sub-collection)
- [x] Chat list screen (all conversations for current user)
- [x] Chat room screen (message bubbles, auto-scroll, send bar)
- [x] "Hubungi" on item detail → getOrCreateRoom → chat room
- [x] Reusable EmptyStateWidget and ErrorStateWidget
- [x] Loading indicators on image loads, chat room creation, data streams
- [x] Empty states on Home, Chat list, Chat room, Profile
- [x] Error states with descriptive messages on Home and Chat
- [x] Profile placeholder with login CTA
- [x] Comprehensive README.md (description, features, setup, architecture)
- [x] Final todo.md cleanup

---
> **Current status:** 🎉 Release Candidate — Sprints 1, 3, 4 complete. Sprint 2 (Auth) deferred.
