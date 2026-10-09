# Ohio University Thesis and Dissertation LaTeX Template

A LaTeX template for Ohio University (OU) theses and dissertations (ETDs).
Its formatting (title page, approval page, abstract, front matter, margins,
heading levels, bibliography) is built to match what OU's Thesis and
Dissertation Services (TAD) accepts, so you can focus on writing.

> **Disclaimer:** This template and its notes come from one student's
> experience with OU's TAD review. It is not an official OU or TAD
> publication, and the requirements can change. Confirm the current
> requirements with TAD before you submit.

## Two versions

Both versions use the same OU page layout and the same example thesis.
They differ in how the PDF is made accessible for TAD's review: figure alt
text and the fonts inside PDF figures.

| | [V1: pdfLaTeX, manual alt text](V1_pdfLaTeX_ManualAltText/) | [V2: LuaLaTeX, tagged PDF](V2_LuaLaTeX_TaggedPDF/) |
|---|---|---|
| Compiler | pdfLaTeX | LuaLaTeX with `-shell-escape` |
| TeX Live | 2023 or newer | 2025 or newer |
| Compile time | Fast; fine on Overleaf's free plan | Slower; usually too slow for Overleaf's free plan (10-second limit) |
| Fonts inside PDF figures (ROOT, matplotlib, ...) | Fix each figure yourself with `FixPdfImages/FixImages.sh` | Embedded automatically at every compile (needs Ghostscript) |
| Figure alt text | Typed into Acrobat Pro after **every** compile | Written once in the source: `\includegraphics[alt={...}]{...}` |
| Tagged PDF (headings, lists, tables, links, formulas) | No | Yes |
| Acrobat Pro work before you submit | Add alt text, check fonts, run the accessibility check | Run the accessibility check |
| Example output | None | [`tagged_sample.pdf`](V2_LuaLaTeX_TaggedPDF/tagged_sample.pdf) |

### Which one should I use?

- **V1** if you want the simplest setup. It compiles quickly, including on
  Overleaf's free plan, and you add the alt text in Acrobat Pro
  each time you make the final PDF. Use PNG/JPG figures, or run your PDF
  figures through `FixPdfImages` first.
- **V2** if you recompile often or have many figures. Alt text and font
  embedding live in the source, so every compile carries them. Make the
  final build locally (TeX Live 2025 or newer) or on an Overleaf plan with
  a longer compile time.

With either version, run Acrobat's accessibility check on the final PDF and
send its report to TAD together with the PDF. Each version's README walks
through the steps.

## Quick start

First get the files: clone this repository, or use **Code > Download ZIP**
on GitHub and unzip it.

### V1 (pdfLaTeX)

1. Build it:
   - **Overleaf:** zip the `V1_pdfLaTeX_ManualAltText` folder on its own and
     upload it (New Project > Upload Project). In Overleaf's Menu, set
     Compiler to **pdfLaTeX**, TeX Live version to **2023** or newer, and
     Main document to `OU_TAD_Reference/main.tex`.
   - **Locally:** run `make` in `V1_pdfLaTeX_ManualAltText/OU_TAD_Reference`
     (pdfLaTeX, BibTeX, then pdfLaTeX twice).
2. Replace the example content with your own.
3. Before submitting: add alt text, check the fonts and run the
   accessibility check in Acrobat Pro, as described in
   [V1's README](V1_pdfLaTeX_ManualAltText/README.md).

### V2 (LuaLaTeX, tagged PDF)

1. Build it:
   - **Overleaf:** zip the `V2_LuaLaTeX_TaggedPDF` folder on its own and
     upload it. In Overleaf's Menu, set Compiler to **LuaLaTeX**, TeX Live
     version to **2025** or newer, and Main document to
     `OU_TAD_Reference/main.tex`. On the free plan, write with
     `\TaggedPDFfalse` (top of `main.tex`) and make the final build locally
     or on a plan with a longer compile time.
   - **Locally:** install Ghostscript too, then run `make` in
     `V2_LuaLaTeX_TaggedPDF/OU_TAD_Reference` (LuaLaTeX with
     `-shell-escape`, BibTeX, then LuaLaTeX twice). On Windows, load the
     package as `\usepackage[gs=gswin64c]{embedfigurefonts}`.
2. Replace the example content with your own, and give every figure an
   `alt={...}` description.
3. Before submitting: run the accessibility check in Acrobat Pro, as
   described in [V2's README](V2_LuaLaTeX_TaggedPDF/README.md).

### Local builds

- Install TeX Live from [tug.org/texlive](https://tug.org/texlive/) (MacTeX
  on macOS). Linux distribution packages are often older than the versions
  above; check with `pdflatex --version`.
- No `make` (for example on Windows)? Run the four commands listed in the
  version's `Makefile` one after another.

## Repository layout

```
.
├── README.md                        this file
├── V1_pdfLaTeX_ManualAltText/       original template
│   ├── README.md                    V1 guide, TAD notes, Acrobat steps
│   ├── FixPdfImages/                script that embeds fonts in PDF figures
│   └── OU_TAD_Reference/            the thesis (main.tex, ohio-etd.cls, ...)
└── V2_LuaLaTeX_TaggedPDF/           accessible version
    ├── README.md                    V2 guide, alt text, TAD notes
    ├── tagged_sample.pdf            compiled example of V2
    └── OU_TAD_Reference/            the thesis, plus embedfigurefonts.sty
```

Inside each `OU_TAD_Reference/`: `main.tex` (start here), `ohio-etd.cls`
(the OU formatting rules), `frontmatter/`, `Thesis/` (one folder per
chapter), `appendices/`, `Images/`, `references.bib` and the bibliography
style `alphaurl_etd.bst`.

## Good to know

- The example content (an sPHENIX-style particle physics analysis) is a
  **placeholder**, not real research. It is there so you can see headings,
  citations, figures and tables formatted before you write your own.
- Each version's README also covers what TAD reviewers flag most often:
  Title Case, the APA heading levels and reference-list consistency.
- `ohio-etd.cls` builds on Ohio University's ETD class (version 1.3,
  updated by Samuel Jero).
