// din5008a — DIN 5008 Form A letter template for Typst
// Copyright (c) 2026 jcmx9 — MIT License

#import "@preview/cades:0.3.1": qr-code
#import "/version.typ": version

// Bullet character in Source Sans 3 (consistent with header/footer)
#let bullet = text(font: "Source Sans 3", "▪")

#let din5008a(
  sender: (:),
  recipient: (),
  date: none,
  subject: none,
  closing: none,
  signature: none,
  signature-width: 40mm,
  accent: rgb("#B03060"),
  debug: false,
  attachments: (),
  fold-marks: true,
  body,
) = {
  // -- Fonts --
  let font-body = "Source Serif 4"
  let font-ui = "Source Sans 3"
  let font-mono = "Source Code Pro"
  let gray = rgb(128, 128, 128)
  let dbg = if debug { 1pt + red } else { none }
  let dbg-fill = if debug { rgb(255, 0, 0, 15%) } else { none }

  // -- DIN 5008 Form A measurements (mm from page top) --
  let margin-left = 25mm              // left margin
  let margin-right = 20mm             // right margin (binding edge)
  let margin-top = 20mm               // top margin
  let margin-bottom = 28mm              // 4mm + line + 4mm + 12.7mm (3×9pt + 2×4.5pt) + 7mm page edge
  let footer-bottom = 297mm - 7mm       // footer box bottom: 7mm from page edge
  let footer-line-y = footer-bottom - 12.7mm - 4mm  // separator line above footer text
  // = 273.71mm from top
  let return-addr-y = 40.7mm          // return address (bottom of Zusatz-/Vermerkzone)
  let addr-field-y = 44.7mm           // address zone top (27mm + 17.7mm)
  let info-block-y = 32.0mm           // information block top (DIN diagram: 32mm)
  let info-block-x = 125.0mm          // information block left edge
  let info-block-w = 75.0mm           // information block width
  let text-body-y = 103.46mm          // subject position (DIN diagram: 103,46mm)
  let fold-1 = 87mm                   // fold mark 1
  let fold-2 = 192mm                  // fold mark 2
  let punch = 148.5mm                 // punch hole mark

  // follow-up header data
  let recipient-name = if recipient.len() > 0 { recipient.at(0) } else { "" }
  let sep = [ ▪ ]

  // -- Page setup --
  set page(
    paper: "a4",
    margin: (
      top: margin-top,
      bottom: margin-bottom,
      left: margin-left,
      right: margin-right,
    ),
    header: none,
    footer: none,
    // background: all DIN elements absolutely positioned
    background: context {
      let pg = counter(page).get().first()
      // debug: vertical scale every 5mm on right edge
      if debug {
        for i in range(0, 60) {
          let y = i * 5mm
          let len = if calc.rem(i, 2) == 0 { 3mm } else { 1.5mm }
          place(top + right, dx: 0mm, dy: y,
            line(length: len, stroke: 0.5pt + red))
          if calc.rem(i, 2) == 0 {
            place(top + right, dx: len + 1mm, dy: y - 1.5mm,
              text(font: font-ui, size: 5pt, fill: red, str(i * 5)))
          }
        }
      }
      // follow-up header (page 2+)
      if pg > 1 {
        place(top + left, dx: margin-left, dy: 10mm,
          box(width: 165mm, stroke: dbg, fill: dbg-fill, {
            set text(font: font-ui, size: 9pt, fill: gray)
            align(right, {
              recipient-name
              sep
              if subject != none { subject }
              sep
              [Seite #pg]
            })
          }))
      }
      // fold marks (page 1 only)
      if fold-marks and pg == 1 {
        place(top + left, dx: 0mm, dy: fold-1,
          line(length: 9mm, stroke: 0.75pt + accent))
        place(top + left, dx: 0mm, dy: punch,
          line(length: 11mm, stroke: 0.75pt + accent))
        place(top + left, dx: 0mm, dy: fold-2,
          line(length: 9mm, stroke: 0.75pt + accent))
      }
      // footer: absolute position on every page
      // footer: line at footer-line-y, text bottom-aligned 7mm from page edge
      place(top + left, dx: margin-left, dy: footer-line-y,
        line(length: 165mm, stroke: 0.75pt + accent))
      {
        // build footer content to measure its height
        let footer-content = {
          set text(font: font-ui, size: 9pt, fill: gray)
          align(center, {
            {
              let parts = ()
              if sender.at("name", default: none) != none { parts.push(sender.name) }
              if sender.at("street", default: none) != none and sender.at("city", default: none) != none {
                parts.push(sender.street)
                parts.push(sender.city)
              }
              if sender.at("phone", default: none) != none { parts.push("Telefon " + sender.phone) }
              if sender.at("email", default: none) != none { parts.push("E-Mail " + sender.email) }
              parts.join([ ▪ ])
            }
            linebreak()
            {
              let bank-parts = ()
              if sender.at("iban", default: none) != none { bank-parts.push("IBAN " + sender.iban) }
              if sender.at("bic", default: none) != none { bank-parts.push("BIC " + sender.bic) }
              if sender.at("bank", default: none) != none { bank-parts.push(sender.bank) }
              if bank-parts.len() > 0 {
                bank-parts.join([ ▪ ])
                linebreak()
              }
            }
            {
              let pg = counter(page).get().first()
              let total = counter(page).final().first()
              [Seite #pg von #total]
            }
          })
        }
        let footer-height = measure(box(width: 165mm, footer-content)).height
        place(top + left, dx: margin-left, dy: 297mm - 7mm - footer-height,
          box(width: 165mm, stroke: dbg, fill: dbg-fill, footer-content))
      }
    },
  )

  // PDF metadata
  set document(
    title: if subject != none { subject } else { "" },
    author: sender.at("name", default: ""),
    keywords: ("din5008a", "v" + version, "https://github.com/jcmx9/typst-DIN5008a"),
  )

  // -- Default text settings --
  set text(font: font-body, size: 11pt, lang: "de", region: "DE")
  // all bold → semibold (headings, *strong*, etc.)
  show strong: it => text(weight: "semibold", it.body)
  show heading: it => text(weight: "semibold", size: 11pt, it.body)
  set par(justify: false, leading: 5.5pt, spacing: 16.5pt)  // 150% line height (5.5pt between lines, 16.5pt = one blank line between paragraphs)
  set list(marker: text(font: font-ui, "▪"))
  // prevent orphaned list items (min 2 together)
  show list: set block(breakable: false)
  show enum: set block(breakable: false)
  // tables: monospace 10pt, compact, header darker, zebra stripes
  show table: set text(font: font-mono, size: 10pt)
  set table(
    inset: (x: 6pt, y: 3pt),
    fill: (_, y) => {
      if y == 0 { rgb(210, 210, 210) }
      else if calc.odd(y) { white }
      else { rgb(240, 240, 240) }
    },
    stroke: 0.75pt + gray,
  )
  show table.cell.where(y: 0): set text(weight: "semibold")
  // code blocks: monospace with light background, min 3 lines together
  show raw.where(block: true): it => {
    set text(font: font-mono, size: 10pt)
    block(width: 100%, fill: rgb(245, 245, 245), inset: 8pt, radius: 2pt, breakable: false, it)
  }
  show raw.where(block: false): set text(font: font-mono, size: 10pt)

  // ============================================================
  // Information block — 32mm top, 125mm left, 75mm × 63mm
  // ============================================================
  place(top + left,
    dx: info-block-x - margin-left,
    dy: info-block-y - margin-top,
    box(width: info-block-w, height: 63mm, stroke: dbg, fill: dbg-fill,
      align(bottom + right, {
        set text(font: font-ui, size: 11pt, fill: accent)
        set par(spacing: 0pt, leading: 5.5pt)
        // sender details — built bottom-up, displayed top-down
        if sender.at("name", default: none) != none {
          text(sender.name)
          linebreak()
        }
        if sender.at("street", default: none) != none {
          text(sender.street)
          linebreak()
        }
        if sender.at("city", default: none) != none {
          text(sender.city)
          linebreak()
        }
        if sender.at("phone", default: none) != none {
          [Telefon #sender.phone]
          linebreak()
        }
        if sender.at("email", default: none) != none {
          [E-Mail #sender.email]
        }
        // QR code (optional)
        if sender.at("qr", default: false) == true {
          let vcard-parts = ("BEGIN:VCARD", "VERSION:3.0")
          if sender.at("name", default: none) != none {
            vcard-parts.push("FN:" + sender.name)
          }
          if sender.at("street", default: none) != none and sender.at("city", default: none) != none {
            vcard-parts.push("ADR:;;" + sender.street + ";" + sender.city + ";;;Germany")
          }
          if sender.at("phone", default: none) != none {
            vcard-parts.push("TEL:" + sender.phone)
          }
          if sender.at("email", default: none) != none {
            vcard-parts.push("EMAIL:" + sender.email)
          }
          vcard-parts.push("END:VCARD")
          let vcard = vcard-parts.join("\n")
          v(4mm)
          qr-code(vcard, width: 16mm, color: accent)
        }
        // separator line
        v(4mm)
        line(length: info-block-w, stroke: 0.75pt + accent)
        v(7mm)
        // date
        if date != none {
          text(font: font-body, size: 11pt, fill: black, date)
          v(1mm)
        }
      })),
  )

  // ============================================================
  // Return address — bottom of Zusatz-/Vermerkzone (filled upward)
  // ============================================================
  place(top + left,
    dx: 0mm,
    dy: return-addr-y - margin-top,
    box(width: 85mm, stroke: dbg, fill: dbg-fill, {
      set text(font: font-ui, size: 9pt, fill: accent)
      underline(offset: 1.5pt, stroke: 0.75pt + accent, {
        if sender.at("name", default: none) != none { sender.name }
        sep
        if sender.at("street", default: none) != none { sender.street }
        sep
        if sender.at("city", default: none) != none { sender.city }
      })
    }),
  )

  // ============================================================
  // Address zone — 44.7mm from top
  // ============================================================
  place(top + left,
    dx: 0mm,
    dy: addr-field-y - margin-top,
    box(width: 85mm, height: 27.3mm, stroke: dbg, fill: dbg-fill, {
      set text(font: font-body, size: 11pt, fill: black)
      for (i, addr-line) in recipient.enumerate() {
        text(addr-line)
        if i < recipient.len() - 1 {
          linebreak()
        }
      }
    }),
  )

  // ============================================================
  // Subject — 103.46mm from top (DIN 5008 Form A)
  // ============================================================
  v(text-body-y - margin-top)

  if subject != none {
    text(font: font-body, size: 11pt, weight: "semibold", subject)
    v(6mm)
  }

  // body
  body

  // closing, signature, sender name — 3 blank lines between closing and name (DIN 5008)
  // signature: SVG string (from read()) — currentColor is replaced with Salix (#103c78)
  let salix = "#103c78"
  // resolve signature: string (SVG data) → image with Salix color
  let sig-img = if type(signature) == str {
    image(bytes(signature.replace("currentColor", salix)), width: signature-width)
  } else {
    signature
  }
  if closing != none {
    let name = sender.at("name", default: "")
    // parbreak() forces new paragraph = blank line before closing
    parbreak()
    // single paragraph: closing + 3 blank lines + name (all with same leading)
    closing

    // 3 blank lines between closing and name (DIN 5008)
    linebreak()
    hide[.]
    linebreak()
    hide[.]
    linebreak()
    hide[.]

    // name in own block — signature overlays blank lines above
    parbreak()
    block({
      if sig-img != none {
        context {
          let sig-h = measure(sig-img).height
          place(dx: -2mm, dy: -(sig-h + 2mm),
            box(stroke: dbg, fill: dbg-fill, sig-img))
        }
      }
      name
    })

    // attachments after name
    if attachments.len() > 0 {
      parbreak()
      text(weight: "semibold", "Anlagen:")
      linebreak()
      for att in attachments {
        text(font: font-ui, "▪")
        [ #att]
        linebreak()
      }
    }
  }
}
