# V1: pdfLaTeX with Manual Alt Text

This is the original version of the template. It compiles with
**pdfLaTeX** (TeX Live 2023 or newer; in Overleaf's Menu, set Compiler to
pdfLaTeX and TeX Live version to 2023 or newer). Figure alt text is added in Adobe Acrobat Pro after compiling,
and PDF figures whose fonts are not embedded are fixed beforehand with
`FixPdfImages/FixImages.sh`. See the [repository README](../README.md) for
how it compares with [V2](../V2_LuaLaTeX_TaggedPDF/), which does both
automatically.

**Build locally:** run `make` in `OU_TAD_Reference/` (pdfLaTeX, BibTeX,
then pdfLaTeX twice). The PDF is `OU_TAD_Reference/main.pdf`.

## Project Overview

> **Disclaimer:** This document (and the TAD/Headers/Title Case notes
> throughout it) was put together based on one student's personal,
> lived experience going through OU's TAD review process. It is **not**
> an official OU or TAD publication, and it is **not guaranteed to
> reflect the most current OU thesis formatting requirements** — those
> can and do change. Treat this as a good starting point and a shortcut
> past common, previously-seen mistakes, not as the final word. Always
> confirm the current requirements directly with TAD Services before you
> submit.

## What this is

This is an Ohio University (OU) thesis and dissertation (ETD) LaTeX
template. The goal is to give a starting point whose formatting (title
page, front matter, margins, chapter/section structure, bibliography
style, etc.) is built to closely match Ohio University's accepted ETD
(Electronic Thesis and Dissertation) format, so a student can focus on
writing rather than fighting the formatting requirements.

## Folder structure

- **`OU_TAD_Reference/`** — the actual LaTeX template/example. It's a
  working, compilable thesis built around `main.tex`, the `ohio-etd.cls`
  class file (which encodes the OU formatting rules), a `Makefile`, a
  bibliography (`references.bib`, `alphaurl_etd.bst`), front matter
  (abstract, acknowledgments, acronyms, dedication, symbols), appendices,
  and a seven-chapter thesis body with figures under `Images/`.
- **`FixPdfImages/`** — a small utility folder with a script for fixing a
  font-embedding issue that some PDF figures can have. See
  [`FixPdfImages/README.md`](FixPdfImages/README.md) for details.

## Important: the content is a placeholder, not real research

The LaTeX **formatting** in `OU_TAD_Reference/` is meant to be as close as
possible to the OU-accepted format. However, the **content** — the
chapter text, figures, data, and results (currently themed around
particle physics / sPHENIX-style calibration and analysis) — is only an
illustrative example used to demonstrate how the template's structure and
formatting work in practice. It is **not** real research, and none of the
numbers, claims, or figures should be taken as fact.

The content is also **severely incomplete**: each chapter folder
currently holds only a single placeholder section file (e.g.
`1_1_PhysicsVariable.tex`, `2_1_QCD_Overview.tex`, etc.), not a full
chapter. Treat the example content purely as a scaffold to show where and
how real chapter content, figures, and citations would go — it will need
to be replaced entirely with an actual thesis's content.

The reason it's written to *look* like real, realistic thesis writing
(rather than lorem-ipsum placeholder text) is so you can actually compile
it, read it, and check how the formatting behaves against real-example
content — headings, citations, figures, tables — before you commit to
using the template for your own thesis. It's a test/check aid, not a
source of information.

## A note on figures: PNG vs. PDF

**In short: PNG is fine, PDF is better where possible, and PDF figures
sometimes need a fix before they're submission-ready.**

The example figures under `OU_TAD_Reference/Images/` are currently PNG
files, and PNG works fine for `\includegraphics` in LaTeX — nothing here
is broken by using PNG. That said, **PDF is the better choice for figures
where possible** — being a vector/print format, PDF figures stay sharp at
any zoom level or print size instead of pixelating, which matters for a
document that may be printed, zoomed into during a defense, or archived
long-term.

If/when figures are swapped to PDF, be aware that some PDF-exporting tools
don't embed all fonts by default, which can cause rendering issues or
trip up ETD submission checks. The `FixPdfImages/` folder exists exactly
for that situation — see [`FixPdfImages/README.md`](FixPdfImages/README.md) for how to detect and
fix non-embedded fonts in a PDF figure.

## After Your Thesis Compiles: Manual Fixes Still Needed in Adobe Acrobat Pro

Compiling `main.tex` gets you most of the way to a submittable PDF, but
**not all the way**. This template already handles some accessibility
requirements automatically — `main.tex` sets `pdflang={en-US}` and
`pdfdisplaydoctitle=true` via `\hypersetup{}`, and `\pdfgentounicode=1` is
enabled so text is extracted correctly. That covers the "text language is
specified" and "document title is showing in title bar" checks on its
own.

What it does **not** handle automatically: **alt text on images, guaranteed
font embedding, and the accessibility pass as a whole**. Those three need
a manual round in Adobe Acrobat Pro after every compile, before the PDF
goes to TAD. (TAD's own "Creating an Accessible ETD (LaTeX)" guide covers
this too — the steps below just spell out exactly where to click.)

### 1. Add alt text to every figure

This template's `\includegraphics` calls don't carry built-in alt-text
support, so the easiest place to add accessible image descriptions is
directly in the compiled PDF:

- In Acrobat Pro, open the **All Tools → Prepare for accessibility**
  panel.
- Click **Add alternate text**. Acrobat will step through each image in
  the document and let you type a short description for it.
- Do this for every figure — don't skip any.

**If Acrobat does not currently recognize some / any content as a `<Figure>`:**

- Open **All Tools → Prepare for accessibility**.
- Select **Fix reading order**.
- In the Reading Order window, enable **Show tables and figures**.
- Drag a rectangle around the image, then click **Figure** (or
  **Figure/Caption**, to include the caption) in the Reading Order window.
- Move to the next figure and repeat until all figures are selected.
- Then follow the previous instructions to add alternate text to each
  figure.

### 2. Confirm every font is embedded

Even though `pdflatex`/`lualatex` embed most fonts by default, it's worth
verifying directly, especially for any figure PDFs pulled in from other
tools:

- Open **File → Document Properties → Fonts** tab (or **Document
  Properties** from the file menu).
- Check every font listed under "Fonts Used in this Document." Each one
  should say **"(Embedded)"** or **"(Embedded Subset)"** next to its
  name.
- If any font is listed *without* "Embedded," it needs to be fixed before
  submission. For figure PDFs specifically, that's exactly what
  `FixPdfImages/FixImages.sh` automates — see [`FixPdfImages/README.md`](FixPdfImages/README.md).

### 3. Run the Accessibility Check — and only require what TAD requires

- Open **All Tools → Prepare for accessibility → Check for
  accessibility**.
- In the **Accessibility Checker Options** dialog:
  - Under **Report Options**, check both **"Create accessibility
    report"** and **"Attach report to document."**
  - Under **Page Range**, select **"All pages in document."**
  - Under **Checking Options → Document**, TAD only requires these four
    boxes checked (leave the rest — tagged PDF, reading order, bookmarks,
    color contrast — unchecked; they're not part of TAD's requirement):
    - Accessibility permission flag is set
    - Document is not image-only PDF
    - Text language is specified
    - Document title is showing in title bar
  - Click **Start Checking.**
- Any failing items show up in a panel to the left of the PDF — fix all
  of them before moving on.
- Return the final PDF **and** the attached accessibility report to
  `tad@ohio.edu` together.

## What TAD (Thesis & Dissertation Services) actually checks for

This template aims to satisfy OU's formatting rules up front, but real TAD
review correspondence shows a few things worth double-checking by hand
before submission, since they're easy to slip on even with a correct
template:

- **Title Case consistency** — title page, approval page, and abstract
  must all use *identical* Title Case for the title. See the dedicated
  "Title Case" section below for the exact rule.
- **Header formatting is level-specific** — this is the single most
  common thing reviewers flag. See the dedicated "Headers" section below
  for the full breakdown.
- **Abstract's first paragraph is not indented** — every other paragraph
  is.
- **TOC / List of Tables / List of Figures page numbers must match the
  actual document** — re-check after any late edits shift pagination.
- **Reference list consistency**: use "&" or "and" between authors
  consistently (including comma placement before it), end each reference
  with a period (except ones ending in a DOI/URL), and keep spacing/
  indentation uniform with no stray blank lines.
- **Hyperlink every DOI/URL in the references** — blue, underlined, and
  clickable.
- **Embed all fonts and add alt text to every image in the final PDF**,
  and run the Adobe Acrobat Pro accessibility check — see the dedicated
  "After Your Thesis Compiles" section above for exact steps.
- **Visually proof the final PDF** — confirm every table and figure
  renders correctly and all pages are aligned before sending it in.

This is not an exhaustive TAD checklist, just a short list of items that
have tripped up real submissions — always check the current requirements
on the TAD Services site before your final submission.

## Title Case: the exact rule (and where it applies)

Title Case mismatches are the other issue that shows up constantly in TAD
feedback — usually because "Title Case" gets applied loosely instead of
by the actual rule. The rule:

- **Capitalize the first letter of every word that is four or more
  letters long**, no matter what part of speech it is (e.g. "With",
  "From", "Into", "Under" are all capitalized because they're 4+
  letters).
- **Also always capitalize "major" words regardless of length** — nouns,
  verbs, adjectives, adverbs, and pronouns (e.g. "Is", "Has", "Are").
- **Lowercase minor words of three letters or fewer** — articles (a, an,
  the), short prepositions (in, on, at, of, by, to), and coordinating
  conjunctions (and, but, or, nor) — *unless* that word is the first or
  last word of the title/heading, or immediately follows a colon or dash.
- **Always capitalize the first word**, and the first word after a colon,
  regardless of its length.

Example from real TAD feedback (word-by-word): *Measurement of Meson
Production in Collisions With sPHENIX* — "of" and "in" stay lowercase
(3 letters, minor words), while "with" is capitalized despite being a
preposition, because it's 4 letters.

**This one rule applies identically everywhere Title Case is required**:
the title page, the approval page, the abstract's title, and the text of
every heading level (1–5) throughout the thesis. TAD checks that the
title reads *exactly* the same way, word-for-word and case-for-case,
every time it appears — a common correction is simply a mismatch between
how the title was capitalized on the title page vs. the approval page vs.
the abstract.

## Headers: APA style levels (the most common thesis formatting issue)

Header/heading formatting is consistently the most common correction TAD
sends back, so it gets its own section. OU's thesis format follows base
APA style heading levels (APA 7th edition), with numerical designators
(e.g. `5.8.2.1`) layered on top. Per APA's own guidance
([apastyle.apa.org/style-grammar-guidelines/paper-format/headings](https://apastyle.apa.org/style-grammar-guidelines/paper-format/headings)),
there are five heading levels:

| Level | Alignment    | Style        | Case       | Punctuation      | Body text                  |
|-------|--------------|--------------|------------|------------------|-----------------------------|
| 1     | Centered     | Bold         | Title Case | none             | Starts as a new paragraph  |
| 2     | Flush left   | Bold         | Title Case | none             | Starts as a new paragraph  |
| 3     | Flush left   | Bold Italic  | Title Case | none             | Starts as a new paragraph  |
| 4     | Indented     | Bold         | Title Case | Ends with a period | Runs in on the same line |
| 5     | Indented     | Bold Italic  | Title Case | Ends with a period | Runs in on the same line |

A few points worth internalizing, since they're exactly where past
submissions have gone wrong:

- **Never skip a level.** Always start at Level 1 and move down
  sequentially — a Level 3 heading can't appear without a Level 2 above
  it in that chapter.
- **Only Levels 1–3 show up in the Table of Contents.** Levels 4 and 5
  are still required to follow the formatting above, but they're left out
  of the TOC.
- **"Title Case" is the same rule used everywhere else in the document**
  (title page, approval page, abstract, and every heading level) — see
  the "Title Case" section above for the exact rule.
- **Level 4 vs. Level 5 is identified by the numerical designator**, not
  just visual judgment — a four-part number (e.g. `5.8.2.1`) is Level 4;
  a five-part number (e.g. `5.8.2.1.1`) is Level 5.

The `ohio-etd.cls` class file in `OU_TAD_Reference/` already implements
this heading hierarchy, but any manual header formatting (or headers
added outside the class's section/subsection commands) should be checked
against the table above.

## Suggested next steps

- Review `OU_TAD_Reference/main.tex` and `ohio-etd.cls` to understand how
  the OU-required formatting is implemented.
- Replace the placeholder chapter content with real thesis content,
  chapter by chapter.
- Where possible, prefer PDF versions of figures over PNG, running them
  through `FixPdfImages/FixImages.sh` first if font embedding is an
  issue.
- Once a draft looks TAD-ready, follow up directly with TAD Services to
  confirm it actually meets current requirements — as the disclaimer at
  the top notes, this document is a starting point, not a substitute for
  their review.
