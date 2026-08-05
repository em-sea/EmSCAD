Em-Sea Style Guide
Last Updated: 2026-08-05

## 1. Principles
* **DRY:** Pull duplicate logic (loops, regex, complicated bits) into reusable functions.
* **Tight scope:** Keep variables as local as possible but don't nest functions.
* **Handle errors:** Catch or bubble up errors.
* **Single responsibility:** Keep functions small and focused on one job.
* **Tidy:** Comment out unused variables for later cleanup.
* **Don't reinvent the wheel:** Use standard libraries (BOSL2, gridfinity_extended_openscad) when reasonable.

---

## 2. Naming/Style
* **Variables/Arrays/Hashes:** snake_case
* **Constants:** UPPER_SNAKE_CASE
* **Functions/Modules/Classes:** CamelCase
* **Indentation:** Use 4 spaces, not tabs.
* **Oxford Commas:** Use them.

---

## 3. Documentation
* **Metadata:** Check that the file's top metadata stays accurate and includes:
	Script Name: 
	Description: 
	Language:
	Output:
	Glossary:
* **User Documentation:** Keep detailed, user-facing customization comments up to date.
* **Code Documentation:** Only add inline comments for logic that's actually tricky, unfinished, or annoying.

---

## 4. 3D Printing/CAD
* **Tolerances:** Use clearance variables for parts that slide/connect.
* **Manifold Geometry:** Fix non-manifold edges and use the `EPSILON = 0.02` when cutting/connecting to avoid Z-fighting and zero-thickness walls.
* **Safe Rounding:** Bound radii and hull coordinates [e.g min()/max(0.01, ...)] so that extreme dimensions don't break things.