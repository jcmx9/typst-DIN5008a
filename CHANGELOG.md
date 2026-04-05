# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [0.1.1] - 2026-04-05

### Changed

- Switched from DIN 5008 Form B to Form A
- All positions per DIN 5008 Form A standard
- Renamed package, function, and repo from din5008b to din5008a
- Date moved into Informationsblock (DIN-correct)
- Return address at bottom of Zusatz-/Vermerkzone (aufwaerts befuellt)
- Line spacing 150%, paragraph spacing one blank line
- Footer and return address font size 9pt
- QR code 20mm, gray
- List bullets use Source Sans 3 small square (▪)
- Static font files required (no variable font support in Typst)

## [0.1.0] - 2026-04-04

### Added

- Initial letter template (originally Form B)
- Source Serif 4 (body) and Source Sans 3 (UI) font configuration
- Address field with return address line, annotation zone, and recipient zone
- Informationsblock with sender details and date
- Centered footer with contact, bank, and page counter
- Fold marks and punch hole mark
- vCard QR code support
- Example letter template
