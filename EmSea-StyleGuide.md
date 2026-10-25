Em-Sea Style Guide
Last Updated: 2026-10-25

## 1. Principles

- **DRY:** Pull duplicate logic (loops, regex, complicated bits) into reusable functions.
- **Single Responsibility:** Keep functions focused on a single task.
- **Handle Errors:** Catch or bubble up internal errors while allowing users to make ridiculous configurations.
- **Tidy:** Comment out unused variables during testing and delete later.

## 2. Naming and Formatting

- **Variables, Arrays, and Hashes:** `snake_case`
- **Constants:** `UPPER_SNAKE_CASE`
- **Functions, Modules, and Classes:** `CamelCase`
- **Indentation:** 4 spaces (no tabs)
- **Punctuation:** Oxford commas
- **Spacing:** Minimal newlines between functions and logic shifts

## 3. Documentation

- **File Header:** *(Remember to update after major changes)*
  - Script Name:
  - Description:
- **As Needed File Headers:** *(When non-obvious)*
  - Language:
  - Output:
  - Glossary:
  - License:
  - Sources:
- **User Documentation:** Use precise user-facing instructions, options, and constraints.
- **Code Documentation:** Limit comments to explaining tricky logic, grouping major functionality, and tracking in-progress modifications.

## 4. 3D Printing and CAD

- **Tolerances:** Use dedicated clearance variables for sliding and attaching parts.
- **Manifold Geometry:** Use `EPSILON = 0.02`.
- **Safe Rounding:** Bind radii to prevent broken geometry (e.g., `max(0.01, ...)`).
