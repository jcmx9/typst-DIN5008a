#import "@local/din5008a:0.1.1": din5008a, bullet

#show: din5008a.with(
  sender: (
    name: "Dr. Anna Weber",
    street: "Lindenallee 12",
    city: "80331 Muenchen",
    phone: "089 1234567",
    email: "anna.weber@example.de",
    iban: "DE91 7002 0500 0009 8765 43",
    bic: "BFSWDE33MUE",
    bank: "Bank fuer Sozialwirtschaft",
    qr: true,
  ),
  recipient: (
    "Sonnenschein Verlag GmbH",
    "Frau Lisa Bergmann",
    "Lektorat Kinderbuch",
    "Rosenstrasse 5",
    "50667 Koeln",
  ),
  date: "05. April 2026",
  subject: "Manuskript 'Die Abenteuer der kleinen Eule' - Einreichung",
)

Sehr geehrte Frau Bergmann,

mit grosser Freude uebersende ich Ihnen mein Manuskript _Die Abenteuer der kleinen Eule_ zur Begutachtung fuer Ihr Kinderbuchprogramm. Die Geschichte richtet sich an Kinder im Alter von 5 bis 8 Jahren und umfasst 48 illustrierte Seiten.

*Zum Inhalt*

Die kleine Eule Frieda entdeckt eines Nachts, dass der Mond verschwunden ist. Gemeinsam mit ihren Freunden -- dem schlauen Fuchs und der mutigen Maus -- begibt sie sich auf eine Reise durch den Wald, um den Mond wiederzufinden. Dabei lernen die Tiere, dass man gemeinsam auch die groessten Herausforderungen meistern kann.

*Eckdaten zum Manuskript*

#table(
  columns: (1fr, 1fr),
  stroke: none,
  table.header([*Eigenschaft*], [*Details*]),
  table.hline(stroke: 0.5pt),
  [Titel], [Die Abenteuer der kleinen Eule],
  [Zielgruppe], [5 -- 8 Jahre],
  [Umfang], [48 Seiten, ca. 6.200 Woerter],
  [Illustrationen], [12 ganzseitige Aquarelle (beiliegend)],
  [Genre], [Kinderbuch / Vorlesebuch],
)

*Warum Ihr Verlag?*

Ihr Programm ueberzeugt mich seit Jahren durch liebevoll gestaltete Kinderbuecher mit paedagogischem Anspruch. Besonders die Reihe _Kleine Entdecker_ hat mich inspiriert, und ich glaube, dass _Die Abenteuer der kleinen Eule_ thematisch und stilistisch gut in Ihr Sortiment passen wuerde.

Zu meiner Person: Ich bin promovierte Germanistin und arbeite seit zehn Jahren als freie Autorin. Meine bisherigen Veroeffentlichungen umfassen:

- _Wolkenreise_ (Sternberg Verlag, 2022) -- ausgezeichnet mit dem Deutschen Kinderliteraturpreis in der Kategorie Bilderbuch
- _Der Baer, der nicht schlafen wollte_ (Mondlicht Verlag, 2024)
- Diverse Kurzgeschichten in der Zeitschrift _Lesefreude_

Ich wuerde mich sehr freuen, von Ihnen zu hoeren, und stehe fuer Rueckfragen jederzeit gerne zur Verfuegung.

#v(4mm)
Mit herzlichen Gruessen

#v(12mm)
Dr. Anna Weber

#v(4mm)
*Anlagen:*\
#bullet Manuskript (Druckfassung, 48 Seiten)\
#bullet Exposee mit Kapiteluebersicht\
#bullet 3 Illustrationsproben (Aquarell, A4)
