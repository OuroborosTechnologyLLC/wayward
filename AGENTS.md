# Wayward Project Instructions

## Project Purpose

Wayward is a rules-light sword-and-sorcery tabletop RPG. Preserve its concise, practical tone and internal mechanical consistency.

## Canonical Files

- `Core-Rules.html` is the canonical core-rule document.
- `Draft.md` contains provisional material. Do not treat drafts as final or integrate them unless explicitly requested.
- `styles.css` defines the shared document presentation.

## Editorial Conventions

- Address the game moderator as the “Referee.”
- Use established terms consistently: Stamina, Armor, Defense, Lore, Physical, Combat, Craft, Social, and Stealth.
- Format tests as “throw Lore 8+,” “throw Physical 12+,” and similar.
- Format modifiers as “modifier +2” or “modifier −2.”
- Use `2d6`, `d66`, `1d6 rounds`, and metric distances such as `10m`.
- Prefer concise rules language. State the effect, duration, resistance throw, and important exceptions.
- Do not silently change game balance, numerical values, or mechanical meaning while copyediting.
- Flag apparent contradictions rather than choosing one interpretation without notice.
- Place every rule, clarification, or adjudication instruction intended for the Referee rather than the player in a referee-guidance box. Players should be able to skip these boxes without missing player-facing rules.

## HTML Conventions

- Preserve the existing HTML indentation and table structure.
- Wrap tables in `.table-scroll` containers with an appropriate `aria-label` and `tabindex="0"`.
- Reuse existing table classes and column classes.
- Give every heading a unique, descriptive `id`.
- Include every `h1`, `h2`, `h3`, `h4`, and `h5` heading in the table of contents, nested to reflect the document hierarchy.
- Update the table of contents whenever sections or headings are added, removed, renamed, or moved.
- Ensure every table-of-contents link has a matching heading ID.
- Format Referee-only material as `<aside class="referee-guidance" aria-label="Referee guidance">`, include the `referee-guidance__label`.
- Do not perform document-wide reformatting for a localized change.

## Draft Integration

- Keep alternate or playtest material visibly separate from the primary rules.
- Preserve the source wording unless editing is requested.
- Use distinct IDs for repeated titles such as “Alternate List.”
- Do not delete material from `Draft.md` after integrating it unless explicitly requested.

## Licensing

- Do not change copyright, attribution, or license text without explicit instruction.
- Preserve distinctions between original, adapted, and third-party material.

## Verification

After changing the HTML:

- Parse it with Pandoc to catch structural problems.
- Check for duplicate IDs.
- Check that all table-of-contents links resolve.
- Check that every `h1` through `h5` heading appears in the table of contents.
- Confirm copied tables have the expected number and order of rows.
