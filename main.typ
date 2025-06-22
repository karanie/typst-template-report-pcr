#import "config.typ": *

#set document(
  title: [#report_type #author_name],
  author: author_name,
)
#set page(page_layout)
#set text(font: root_font, size: root_font_size, lang: lang, hyphenate: hyphenate)

// === Cover
#if report_type == "Laporan Proyek Akhir" {
  include "sections/cover/cover_report-1.typ"
} else {
  include "sections/cover/cover_proposal.typ"
}

// === Preface

#set page(
  margin: page_margin,
)
#set par(
  justify: true,
  first-line-indent: (
    amount: par_first_line_indent,
    all: par_first_line_indent_all
  )
)
#set figure.caption(separator: " ")
#set figure(numbering: it => {
  [#counter(heading).get().at(0).#it]
})
#set table.header(repeat: true)
#show heading.where(
  level: 1
): it => [
  #pagebreak()
  #set align(center)
  #set text(12pt, weight: "bold")
  #pad(bottom: 18pt)[
    #upper([
      #it.body
    ])
  ]
]
#show figure: set block(breakable: true)
#show figure.where(
  kind: "tabel"
): set figure.caption(position: top)
#let appendix-counter = counter("appendix")
#show outline.entry.where(level: 1): it => {
  if it.body() == [Lampiran] {
    appendix-counter.step()
    link(
      it.element.location(),
      it.indented(
        none,
        grid(
          columns: (auto, auto, auto),
          pad(right: 0.25em)[Lampiran #context appendix-counter.display("A")],
          [#repeat([.], gap: 0.15em)],
          pad(left: 0.25em)[#context appendix-counter.display("A")-#it.page()]
        )
      )
    )
  } else if it.body() == [Daftar Pustaka] {
    it
  } else {
    it
  }
}

#set page(numbering: "i")
#if report_type == "Laporan Proyek Akhir" {
  include "sections/preface/statements.typ"
}

#set page(numbering: "i")
#set page(
  footer: context [
    #grid(
      columns: (1fr, 1fr, 1fr),
      [],
      [
        #align(center + bottom)[
          #counter(page).display()
        ]
      ],
      [
        #align(right + bottom)[
          #image("media/logo_pcr.png", width: 3cm)
        ]
      ]
    )
  ]
)
#set math.equation(numbering: "(1)", supplement: "Persamaan")

#include "sections/preface/main.typ"

// === Main Content
#set page(numbering: "1")
#set heading(numbering: "1.")
#show heading.where(
  level: 1
): it => [
  #if report_type == "Laporan Proyek Akhir" {
    pagebreak()
    counter(figure.where(kind: "tabel")).update(0)
    counter(figure.where(kind: "gambar")).update(0)
    set align(center)
    set text(heading_1_font_size, weight: heading_1_font_weight)
    let selector = selector(heading).before(here())
    let level = counter(selector)
    pad(bottom: heading_1_bottom_padding)[
      #upper([
        BAB #level.display("I") \ #it.body
      ])
    ]
  } else {
    pagebreak()
    counter(figure.where(kind: "tabel")).update(0)
    counter(figure.where(kind: "gambar")).update(0)
    set text(heading_1_font_size, weight: heading_1_font_weight)
    let selector = selector(heading).before(here())
    let level = counter(selector)
    pad(bottom: heading_1_bottom_padding)[
      #upper([
        #grid(
          columns: (par_first_line_indent, auto),
          [ #level.display("I"). ],
          [ #it.body ]
        )
      ])
    ]
  }
]
#show: rest => {
  for i in (2, 3, 4) {
    rest = {
      show heading.where(level: i): it => [
        #set text(heading_n_font_size, weight: heading_n_font_weight)
        #let selector = selector(heading).before(here())
        #let level = counter(selector)
        #pad(bottom: heading_n_bottom_padding)[
          #grid(
            columns: (par_first_line_indent, auto),
            [ #level.display() ],
            [ #it.body ]
          )
        ]
      ]
      rest
    }
  }
  rest
}

#include "sections/main/chap1.typ"
#include "sections/main/chap2.typ"
#include "sections/main/chap3.typ"
#if report_type == "Laporan Proyek Akhir" {
  include "sections/main/chap4-testing-analysis.typ"
} else {
  include "sections/main/chap4-cost-time-mgnt.typ"
}

#set heading(numbering: none)
#show heading.where(
  level: 1
): it => [
  #pagebreak()
  #set align(center)
  #set text(heading_1_font_size, weight: heading_1_font_weight)
  #pad(bottom: heading_1_bottom_padding)[
    #upper([
      #it.body
    ])
  ]
]
= Daftar Pustaka

#bibliography(
  "citations/bibtex.bib",
  title: none,
  full: false,
  style: "citations/apa.csl",
)

#set page(
  footer: context [
    #grid(
      columns: (1fr, 1fr, 1fr),
      [],
      [
        #align(center)[
          #counter(heading).display("A")-#counter(page).display("1")
        ]
      ],
      [
        #align(right)[
          #image("media/logo_pcr.png", width: 2.5cm)
        ]
      ]
    )
  ]
)
#set par(
  justify: true,
  first-line-indent: 0pt
)
#set text(size: 8pt)
#counter(page).update(1)
#set heading(numbering: "A")
#counter(heading).update(0)
#show heading.where(
  level: 1
): it => [
  #pagebreak()
  // this doesn't work when rendered as outline entry for some reasons, so please reset the counter everytime before you add new header
  //#counter(page).update(0)
  #set align(center)
  #set text(12pt, weight: "bold")
  #pad(bottom: 18pt)[
    #upper([
      Lampiran #counter(heading).display("A")
    ])
  ]
]

#include "sections/appendix/appendix.typ"
