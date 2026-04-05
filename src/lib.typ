// din5008a — DIN 5008 Form A letter template for Typst
// Copyright (c) 2026 jcmx9 — MIT License

#import "@preview/cades:0.3.1": qr-code

// Bullet character in Source Sans 3 (consistent with header/footer)
#let bullet = text(font: "Source Sans 3", "▪")

#let din5008a(
  sender: (:),
  recipient: (),
  date: none,
  subject: none,
  closing: none,
  signature: none,
  attachments: (),
  fold-marks: true,
  body,
) = {
  // -- Fonts --
  let font-body = "Source Serif 4"
  let font-ui = "Source Sans 3"
  let font-mono = "Source Code Pro"
  let gray = rgb(128, 128, 128)

  // -- DIN 5008 Form A measurements (mm from page top) --
  let margin-left = 25mm              // left margin
  let margin-right = 20mm             // right margin (binding edge)
  let margin-top = 20mm               // top margin
  let margin-bottom = 30mm            // bottom margin (space for footer)
  let return-addr-y = 40.7mm          // return address (bottom of Zusatz-/Vermerkzone)
  let addr-field-y = 44.7mm           // address zone top (27mm + 17.7mm)
  let info-block-y = 27.0mm           // information block top (aligned with address field)
  let info-block-x = 125.0mm          // information block left edge
  let info-block-w = 75.0mm           // information block width
  let text-body-y = 80.5mm            // subject (2 blank lines after address field end at 72mm, DIN 5008:2020)
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
    // page 1: no header — page 2+: follow-up header
    header: context {
      let pg = counter(page).get().first()
      if pg > 1 {
        set text(font: font-ui, size: 9pt, fill: gray)
        align(right, {
          recipient-name
          sep
          if subject != none { subject }
          sep
          [Seite #pg]
        })
      }
    },
    // footer: centered separator line + 3 lines
    footer: {
      set text(font: font-ui, size: 9pt, fill: gray)
      v(2mm)
      line(length: 100%, stroke: 0.5pt + gray)
      v(1.5mm)
      align(center, {
        {
          let parts = ()
          if sender.at("name", default: none) != none { parts.push(sender.name) }
          if sender.at("street", default: none) != none and sender.at("city", default: none) != none {
            parts.push(sender.street + ", " + sender.city)
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
        context {
          let pg = counter(page).get().first()
          let total = counter(page).final().first()
          [Seite #pg von #total]
        }
      })
    },
    footer-descent: 8mm,
    // fold marks and punch hole (page 1 only)
    background: context {
      let pg = counter(page).get().first()
      if fold-marks and pg == 1 {
        place(top + left, dx: 0mm, dy: fold-1,
          line(length: 9mm, stroke: 0.75pt + gray))
        place(top + left, dx: 0mm, dy: punch,
          line(length: 11mm, stroke: 0.75pt + gray))
        place(top + left, dx: 0mm, dy: fold-2,
          line(length: 9mm, stroke: 0.75pt + gray))
      }
    },
  )

  // -- Default text settings --
  set text(font: font-body, size: 11pt, lang: "de", region: "DE")
  set par(justify: true, leading: 5.5pt, spacing: 16.5pt)  // 150% line height (5.5pt between lines, 16.5pt = one blank line between paragraphs)
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
  show table.cell.where(y: 0): set text(weight: "bold")
  // code blocks: monospace with light background, min 3 lines together
  show raw.where(block: true): it => {
    set text(font: font-mono, size: 10pt)
    block(width: 100%, fill: rgb(245, 245, 245), inset: 8pt, radius: 2pt, breakable: false, it)
  }
  show raw.where(block: false): set text(font: font-mono, size: 10pt)

  // ============================================================
  // Information block — 32mm top, 125mm left, 75mm wide
  // ============================================================
  place(top + left,
    dx: info-block-x - margin-left,
    dy: info-block-y - margin-top,
    box(width: info-block-w, {
      set text(font: font-ui, size: 11pt, fill: black)
      align(right, {
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
      })
      // date — last field in information block
      if date != none {
        align(right, text(font: font-body, size: 11pt, date))
      }
      v(-1mm)
      line(length: 100%, stroke: 0.5pt + gray)
      v(-1mm)
      // QR code — generated from sender data at compile time
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
        v(0.5mm)
        align(right, qr-code(vcard, width: 15mm, color: gray))
      }
    }),
  )

  // ============================================================
  // Return address — bottom of Zusatz-/Vermerkzone (filled upward)
  // ============================================================
  place(top + left,
    dx: 0mm,
    dy: return-addr-y - margin-top,
    {
      set text(font: font-ui, size: 9pt, fill: gray)
      underline(offset: 1.5pt, stroke: 0.3pt + gray, {
        if sender.at("name", default: none) != none { sender.name }
        sep
        if sender.at("street", default: none) != none { sender.street }
        sep
        if sender.at("city", default: none) != none { sender.city }
      })
    },
  )

  // ============================================================
  // Address zone — 44.7mm from top
  // ============================================================
  place(top + left,
    dx: 0mm,
    dy: addr-field-y - margin-top,
    box(width: 85mm, {
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
    text(font: font-body, size: 11pt, weight: "bold", subject)
    v(6mm)
  }

  // body
  body

  // closing, signature, sender name — 3 blank lines between closing and name (DIN 5008)
  // signature: SVG recommended — use #103c78 (Rohrer & Klingner Salix) as stroke color
  if closing != none {
    // 3 blank lines between closing and name (DIN 5008)
    // single paragraph with linebreak() — uses same leading as body text
    let name = sender.at("name", default: "")
    {
      closing
      linebreak()
      hide[.]
      linebreak()
      hide[.]
      linebreak()
      hide[.]
      linebreak()
      name
    }
    // signature on own layer over the blank lines
    if signature != none {
      context {
        let h = measure({
          closing; linebreak(); hide[.]; linebreak(); hide[.]; linebreak(); hide[.]; linebreak(); name
        }).height
        place(dy: -h, box(height: h, signature))
      }
    }
    if attachments.len() > 0 {
      v(16.5pt)
      text(weight: "bold", "Anlagen:")
      linebreak()
      for att in attachments {
        text(font: font-ui, "▪")
        [ #att]
        linebreak()
      }
    }
  }
}
