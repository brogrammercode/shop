# Feature Development Standard Workflow

This document outlines the sequential steps for creating, updating, or fixing any module or feature within the project.

## 1. Core Principles
- **Zero-Comment Policy**: All code must be 100% comment-free and self-documenting.
- **Strict Layering**: Follow the defined architecture for each app type.
- **Type Safety**: Maintain strict TypeScript/Dart typing throughout.
- **Centralized Constants**: Never use hardcoded strings; use feature-specific constant files.

---

## 2. API (Backend)
Follow these steps in order when implementing a new feature:

1.  **Define Types**: Create `[feature].type.ts` for data structures and interfaces.
2.  **Database Schema**: Update `schema.prisma` with relevant models and run `npx prisma generate`.
3.  **Repository**: Implement `[feature].repo.ts` using Prisma for all database operations.
4.  **Service (Business Logic)**: Implement `[feature].service.ts` to handle logic and interact with Repositories.
5.  **Security/Utilities**: Implement `src/infra/security/` utilities if specific hashing or token logic is needed.
6.  **Constants**: Populate `[feature].constant.ts` with all messages, error strings, and configuration values.
7.  **Controller**: Implement `[feature].controller.ts` using the `asyncHandler` utility.
8.  **Middleware**: Implement `[feature].middleware.ts` for authentication or validation if required.
9.  **Route**: Create `[feature].route.ts` to map endpoints to controller methods.
10. **Register Route**: Attach the new route to the global router in `src/routes/index.ts`.

---

## 3. MOBILE (Flutter)
Follow these steps in order when implementing a new feature:

1.  **Define Model**: Create the data models and serialization logic.
2.  **Data Provider/Repo**: Implement the repository to handle networking or local storage.
3.  **State Management**: Create the Cubit or Bloc to manage feature state and business logic.
4.  **UI Components**: Build reusable widgets specific to the feature.
5.  **Pages/Screens**: Implement the final UI layout using theme-based tokens and responsive scaling.
6.  **Routing**: Register the new screens in the application's router.

---

## 4. General Maintenance (Fix/Update)
1.  **Analyze**: Identify the specific layer (Repo, Service, Controller) where the change is needed.
2.  **Verify Standards**: Ensure the change doesn't introduce comments or break type safety.
3.  **Update Constants**: Add any new strings to the relevant `constant.ts` file.
4.  **Test**: Verify the fix across the entire feature stack (from Repo up to Route/UI).