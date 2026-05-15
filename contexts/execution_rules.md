# AI Execution Rules - Unified

All AI agents and coding assistants MUST follow these rules strictly before and during any task execution in this repository.

## 1. Global Zero-Comment Policy
- **100% Comment-Free**: All code must be completely free of comments. No exceptions.
- **Self-Documenting Code**: Use descriptive naming for variables, functions, and classes to explain logic and intent.
- **Clean Diffs**: When modifying files, remove any existing comments within the scope of your changes.

## 2. Feature-Based Architecture
- **Structure by Feature**: Organize code within `features/[feature_name]/` directories across all applications (API, Mobile, Web).
- **Domain Isolation**: Each feature folder should contain its own:
    - **UI/Pages**: Screen definitions and complex layouts.
    - **Components**: Feature-specific UI elements.
    - **Logic/State**: Cubits, Blocs, Hooks, or Services.
    - **Data/Repo**: Repositories and data sources.
    - **Models/Types**: Data structures and interfaces.
- **Shared Resources**:
    - `core/`: Themes, networking, dependency injection, and shared utilities.
    - `constants/`: Centralized configuration, assets, and strings.
    - `components/ui/`: Global, reusable UI primitives.

## 3. Frontend Standards (Mobile & Web)
- **No Hardcoded Styles**: Use theme-based tokens for colors, spacing, and typography.
- **Design System Consistency**: Strictly adhere to relevant `context/*_ui_standard.md` documents.
- **Responsive Design**: Use appropriate scaling tools (e.g., `ScreenUtil` for Mobile, relative units for Web).
- **Separation of Concerns**: Keep business logic out of UI files. Use State Management or Repositories for all logic.

## 4. Backend Standards (API)
- **Strict Type Safety**: Use TypeScript interfaces/types for all data models and API responses.
- **Repository Pattern**: Centralize all database and external API interactions in Repositories.
- **Middleware**: Use middleware for cross-cutting concerns like Authentication, Validation, and Logging.
- **Layered Architecture**: Controllers handle I/O, Services handle business logic, and Repositories handle data persistence.

## 5. Pre-Execution Analysis
- **Deep Analysis**: Before any UI change, analyze the relevant UI standard files.
- **Pattern Matching**: Review existing files in the target directory to understand local coding patterns and architecture.

## 6. Execution Workflow
1.  **Analyze**: Understand requirements and relevant context files.
2.  **Plan**: Draft an implementation plan following these rules.
3.  **Execute**: Write modular, typed, and comment-free code.
4.  **Verify**: Ensure the code builds and aligns with established standards.
