# din5008a

A [Typst](https://typst.app) template for German business letters following **DIN 5008 Form A**.

![Preview](docs/preview.png)

## Features

- Full DIN 5008 Form A layout with exact measurements per standard
- All elements absolutely positioned via `place()` (address field, info block, fold marks, footer)
- Informationsblock: bottom-right aligned, 75 mm × 63 mm at 125 mm left / 32 mm top
- Dynamic vCard QR code via `@preview/cades` (optional, 16 mm)
- SVG signature with configurable accent color
- Debug mode: red outlines + fill on all positioned boxes, vertical scale
- **Source Serif 4** body text (11 pt, Semibold for emphasis)
- **Source Sans 3** UI elements (9 pt, footer, header, return address)
- **Source Code Pro** tables and code blocks (10 pt)
- 150% line spacing (leading: 5.5 pt, spacing: 16.5 pt)
- Zebra-striped tables with 0.75 pt borders
- Code blocks with light gray background
- Unordered list bullets as small black squares (▪)

## Requirements

### Typst

[Typst](https://typst.app) >= 0.12

### Fonts (static versions required)

Typst does not support variable fonts correctly. Install **static** `.ttf` files:

**Source Serif 4** (body text):
```bash
# Download from https://github.com/adobe-fonts/source-serif/releases
# Install these files:
cp SourceSerif4-Regular.ttf SourceSerif4-Semibold.ttf SourceSerif4-Bold.ttf \
   SourceSerif4-It.ttf SourceSerif4-SemiboldIt.ttf SourceSerif4-BoldIt.ttf \
   ~/Library/Fonts/    # macOS
# Linux: ~/.local/share/fonts/
```

**Source Sans 3** (UI elements):
```bash
# Download from https://github.com/adobe-fonts/source-sans/releases
cp SourceSans3-Regular.ttf SourceSans3-Bold.ttf \
   SourceSans3-It.ttf SourceSans3-BoldIt.ttf \
   ~/Library/Fonts/
```

**Source Code Pro** (tables, code):
```bash
# Download from https://github.com/adobe-fonts/source-code-pro/releases
cp SourceCodePro-Regular.ttf SourceCodePro-Bold.ttf \
   SourceCodePro-It.ttf SourceCodePro-BoldIt.ttf \
   ~/Library/Fonts/
```

Remove any variable font files (`*[wght].ttf`) for these families.

## Quick Start

```typst
#import "@local/din5008a:26.4.11": din5008a, bullet

#show: din5008a.with(
  sender: (
    name: "Dr. Anna Weber",
    street: "Lindenallee 12",
    city: "80331 München",
    phone: "089 1234567",
    email: "anna.weber@example.de",
    iban: "DE91 7002 0500 0009 8765 43",
    bic: "BFSWDE33MUE",
    bank: "Bank für Sozialwirtschaft",
    qr: true,
  ),
  recipient: (
    "Sonnenschein Verlag GmbH",
    "Frau Lisa Bergmann",
    "Rosenstraße 5",
    "50667 Köln",
  ),
  date: "5. April 2026",
  subject: "Betreff des Schreibens",
  closing: "Mit herzlichen Grüßen",
  signature: image("unterschrift.svg"),
  attachments: (
    "Dokument 1",
    "Dokument 2",
  ),
)

Sehr geehrte Frau Bergmann,

hier steht der Brieftext.
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sender` | dictionary | `(:)` | Sender: `name`, `street`, `city`, `phone`, `email`, `iban`, `bic`, `bank`, `qr` (bool) |
| `recipient` | array | `()` | Recipient address lines (max 6) |
| `date` | string | `none` | Date (shown in Informationsblock) |
| `subject` | string | `none` | Subject line (semibold) |
| `closing` | string | `none` | Closing phrase (e.g. "Mit freundlichen Grüßen") |
| `signature` | content | `none` | Signature image: `image("unterschrift.svg")` |
| `attachments` | array | `()` | Attachment descriptions (rendered after sender name) |
| `accent` | color | `#B03060` | Accent color for fold marks, sender text, QR, lines |
| `debug` | bool | `false` | Show red outlines on all positioned boxes |
| `fold-marks` | bool | `true` | Show fold and punch hole marks |

### Signature

SVG recommended (vector, lossless scaling). Use `#265282` as stroke color for Rohrer & Klingner *Salix* iron gall ink look. Set `stroke="currentColor"` in the SVG to inherit the accent color from the template.

### Formatting

All standard Typst formatting works in the letter body:

| Element | Syntax |
|---------|--------|
| Semibold | `*text*` |
| Italic | `_text_` |
| Headings | `= / == / ===` (all 11 pt semibold) |
| Unordered list | `- item` (▪ bullets) |
| Numbered list | `+ item` |
| Table | `#table(columns: (auto, auto), ...)` |
| Code block | ` ``` code ``` ` |
| Inline code | `` `code` `` |
| Footnote | `#footnote[text]` |
| Link | `https://...` |
| Underline | `#underline[text]` |
| Strikethrough | `#strike[text]` |
| Superscript | `#super[text]` |
| Subscript | `#sub[text]` |
| Block quote | `#quote(block: true)[text]` |
| Separator | `#line(length: 100%, stroke: 0.75pt + luma(80%))` |

## DIN 5008 Form A Layout

```
 ┌──────────────────────────────────────────────┐
 │  Briefkopffeld (frei gestaltbar)             │ 27mm
 ├────────────────────┬─────────────────────────┤
 │  Rücksendeangabe   │                         │
 │  Zusatz/Vermerke   │  Informationsblock      │ 32mm
 │  ─ ─ ─ ─ ─ ─ ─ ─  │  (bottom-right aligned) │
 │  Anschriftzone     │  Name, Adresse, Tel,    │
 │  (6 Zeilen)        │  E-Mail, QR, Linie,     │
 │  85mm              │  Datum                  │ 95mm
 ├────────────────────┤  75mm × 63mm            │
 │                    ├─────────────────────────┤
 │                                              │
 │  Betreff (semibold)                          │ 103.46mm
 │  Anrede + Textkörper                         │
 │  (Source Serif 4, 11pt, 150% Zeilenabstand)  │
 │                                              │
─┤ Faltmarke 1                                  │ 87mm
 │                                              │
─┤ Lochmarke                                    │ 148.5mm
 │                                              │
─┤ Faltmarke 2                                  │ 192mm
 │                                              │
 │──────────────────────────────────────────────│ 275.3mm
 │  Footer (Source Sans 3, 9pt, zentriert)      │
 │  Kontakt ▪ Bank ▪ Seite x von y             │ 290mm
 └──────────────────────────────────────────────┘
  │← 25mm →│                          │← 20mm →│
```

## Versioning

Auto-versioned as `YY.M.x` (SemVer compatible). Version is stored in `version.typ` and `typst.toml`, updated automatically on each commit via pre-commit hook.

## License

[MIT](LICENSE)
