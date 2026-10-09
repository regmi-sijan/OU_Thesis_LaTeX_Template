# V2: LuaLaTeX with a Tagged, Accessible PDF

This version builds the accessibility features TAD asks for into the
compile: figure alt text is written in the LaTeX source, the PDF is tagged
(headings, lists, tables, links, formulas), and the fonts inside PDF/EPS
figures are embedded automatically. It compiles with **LuaLaTeX**
(`-shell-escape`, TeX Live 2025 or newer, plus Ghostscript). See the
[repository README](../README.md) for how it compares with
[V1](../V1_pdfLaTeX_ManualAltText/), the simpler pdfLaTeX version.

**Build locally:** run `make` in `OU_TAD_Reference/` (LuaLaTeX with
`-shell-escape`, BibTeX, then LuaLaTeX twice). The PDF is
`OU_TAD_Reference/main.pdf`.

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
  and a seven-chapter thesis body with figures under `Images/`. It also
  contains `embedfigurefonts.sty`, which embeds the fonts of every PDF/EPS
  figure automatically at compile time (see "A note on figures" below).
- **[`tagged_sample.pdf`](tagged_sample.pdf)** — this template compiled with `\TaggedPDFtrue`,
  so you can see the result (tags, alt text, bookmarks) in Acrobat before
  building your own.

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

**In short: PNG is fine, PDF is better where possible, and the font fix
that PDF figures sometimes need now happens automatically when you
compile.**

Most example figures under `OU_TAD_Reference/Images/` are PNG files, and
PNG works fine for `\includegraphics` in LaTeX — nothing here is broken by
using PNG. Three figures (in Chapter 4 and Appendix B) are PDFs made with
ROOT, whose fonts are not embedded, to show the automatic font fix below at
work. (`Images/` also keeps PNG copies of those three, and PDF copies of
two matplotlib figures, for comparison.) That said, **PDF is the better choice for figures
where possible** — being a vector/print format, PDF figures stay sharp at
any zoom level or print size instead of pixelating, which matters for a
document that may be printed, zoomed into during a defense, or archived
long-term.

Some PDF-exporting tools, ROOT in particular, don't embed their fonts by
default (they only *reference* Helvetica, Times, Symbol, ...). That can
cause rendering issues and trips TAD's "all fonts embedded" check.
**The template handles this automatically:**
`OU_TAD_Reference/embedfigurefonts.sty`, loaded in `main.tex`, passes every
`.pdf`/`.eps` figure through Ghostscript at compile time, embeds all of its
fonts, and includes the repaired copy. You can put ROOT, matplotlib,
gnuplot, MATLAB, ... PDFs straight into `Images/` and `\includegraphics`
them as usual, with no manual conversion step.

- **Overleaf:** works out of the box (Overleaf enables shell escape and has
  Ghostscript installed).
- **Local build:** compile with `lualatex -shell-escape main.tex` (or run
  `make`), with Ghostscript installed (`gs`; on Windows add the package
  option `gs=gswin64c`).
- Repaired copies are cached in a `fontfixed-figures/` folder created next
  to `main.tex` during the compile. They are keyed by each figure's
  checksum, so a figure is processed again only when it changes. Your
  original figure files are never modified.
- The compile log reports how many figures were repaired. If one cannot
  be repaired, you get a warning naming the file. For the final TAD build,
  `\usepackage[strict]{embedfigurefonts}` turns that into an error.
- To leave one figure untouched, use
  `\includegraphics[embedfonts=false]{...}`. All options are documented at
  the top of `embedfigurefonts.sty`.
- PNG/JPG figures contain no fonts and are passed through unchanged.

## Alt Text and the Accessible (Tagged) PDF

TAD's accessibility review asks for alternative text on every figure. The
template puts the alt text **in the LaTeX source**, so it is written into the
compiled PDF and you don't have to type it into Acrobat after every compile.

### Writing alt text

Give every `\includegraphics` an `alt` key:

```latex
\includegraphics[width=0.9\textwidth,
  alt={Plot of the neutral-pion mass versus transverse momentum from 2.75 to
       7.75 GeV for two triggers. The mass stays near 0.139 GeV up to about
       5.5 GeV and then rises to about 0.145 GeV.}]{Images/6_Plots/pi0_peak_vs_pT.png}
```

- Describe what the figure **shows** (type of plot, axes, ranges, main
  trend) in one to three sentences. Don't repeat the caption word for word,
  and don't start with "Image of".
- Use plain words for symbols ("eta", "neutral pion", "percent") and avoid
  the LaTeX special characters `% # & _ ^ $ { }` inside `alt={...}`.
- A figure made of two images (two `minipage`s, or two stacked
  `\includegraphics`) needs an `alt` on **each** image.
- A purely decorative image (logo, divider) gets `artifact` instead:
  `\includegraphics[artifact]{...}`.
- If you forget one, the tagged build warns *"Alternative text for graphic is
  missing"* and names the file.

Every figure in the template already has alt text, as examples.

### Engine and the switch at the top of `main.tex`

The template is set up for **LuaLaTeX**, the engine LaTeX's PDF tagging is
designed for (Overleaf: Menu > Settings > Compiler > **LuaLaTeX**, TeX Live
version **2025** or newer). It still compiles with pdfLaTeX.

```latex
\newif\ifTaggedPDF
\TaggedPDFtrue    % <-- true: accessible build with alt text (default); false: fast drafts
```

| | `\TaggedPDFtrue` (default, submit this) | `\TaggedPDFfalse` (drafts) |
|---|---|---|
| Figure alt text in the PDF | **yes** | no (kept in the source) |
| Headings, lists, tables, links, formulas tagged | **yes** | no |
| Acrobat "Figures alternate text" | **Passed** | **Failed** (untagged) |
| LuaLaTeX time per pass (this 32-page template, Overleaf) | about 8-10 s | about 5 s |

**Overleaf's free plan stops every compile after 10 seconds**, and a normal
Overleaf compile runs LuaLaTeX at least twice, so on the free plan builds
usually time out (when they do, Overleaf also discards the saved reference
data, so the build never settles). Make the version you submit:

- **Locally** (free, no time limit): install TeX Live **2025 or newer**
  (MacTeX on macOS) plus Ghostscript, clone this repository (or download
  your Overleaf project with Menu > Download > Source), and run `make` in
  `OU_TAD_Reference/` (it runs `lualatex -shell-escape` and `bibtex`).
- **On Overleaf** with a longer compile timeout (a paid plan or Overleaf's
  free trial; it's also worth asking OU IT whether OU offers Overleaf
  Professional).

While writing on the free plan, you can switch to `\TaggedPDFfalse` and/or
set Overleaf's compiler to pdfLaTeX (drafts compile in 2-4 s); the alt text
stays in the source. For a short document on the free plan, a file named
`latexmkrc` at the top level of the Overleaf project containing `$max_repeat = 1;` makes each
Recompile do a single pass; click Recompile until the "Rerun" warnings are
gone (remove that file again afterwards).

### What the tagged build covers in Acrobat's accessibility check

- **Figures alternate text:** each figure is a `<Figure>` tag carrying the text
  from `alt={...}`.
- **Tagged PDF / Tagged content:** the whole document is tagged.
- **Headings:** chapter and front-matter titles are H1, sections H2,
  subsections H3.
- **Tables:** the first row is the header row (the List of Symbols uses its
  first column instead). For a table with two header rows, add
  `\tagpdfsetup{table/header-rows={1,2}}` inside that `table` environment;
  for header cells in the first column,
  `\tagpdfsetup{table/header-rows={},table/header-columns={1}}`.
- **Formulas:** each formula carries its LaTeX source as alternate text.
- **Links and tab order:** they're tagged, with tab order following the
  structure.
- **Language and title:** the language (en-US) is set, and the title shows in
  the title bar (the plain-text `pdftitle` in `main.tex`).
- **Lists: Lbl and LBody:** only list items use the `Lbl` (label) tag.
  Acrobat applies the PDF 1.7 rules, where a `Lbl` may only sit inside a list
  item, so the class tags the other labels LaTeX produces (the entry numbers
  in the Table of Contents and the List of Figures/Tables, "Figure 1.1:" and
  "Table 1.1:" in captions, equation numbers and footnote marks) as plain
  `Span` text.
- **Character encoding:** every character in the PDF maps to Unicode, so
  screen readers and copy-paste get the right text. `glyphtounicode` (loaded
  in `main.tex`) covers the Type 1 math fonts (the OpenType text fonts carry their own
  Unicode data), and the class adds the
  `wasysym` symbols (`\smiley`, `\Box`, `\permil`, ...). If you add another
  symbol package and this check fails, use the symbol as a Unicode character
  from the main font instead (LuaLaTeX accepts them directly), or open an
  issue on this repository's GitHub page so its glyph names can be added to
  the list in `ohio-etd.cls`.

### Checking the alt text in Acrobat

Check a PDF made with `\TaggedPDFtrue`. Acrobat's "Figures alternate text"
rule requires every image on a page to have alternate text or be marked as
an artifact. An untagged PDF (a `\TaggedPDFfalse` build) has no tags to hold
alt text, so that rule fails there until the alt text is added by hand in
Acrobat (step 1 under "After Your Thesis Compiles").

- **Acrobat Pro:**
  - **All tools > Prepare for accessibility > Check for accessibility:**
    under *Alternate Text*, "Figures alternate text" should be *Passed*.
  - In the **Accessibility Tags** panel, each `<Figure>` shows its text
    under *Properties > Alternate text*.
- **Acrobat Reader (free):**
  - **File > Properties > Description:** "Tagged PDF" should say *Yes*.
  - **View > Read Out Loud > Activate Read Out Loud**, then click a figure:
    Reader speaks its alt text.

If the checker still flags something, note the rule name and page shown in
the left panel (right-click > *Show in Tags panel* shows the element).

### Reading the whole Acrobat report

Acrobat's checker gives each rule one of these results:

| Result | Meaning | What to do |
|---|---|---|
| **Passed** | The rule is met. | Nothing. |
| **Failed** | The rule is broken. | Fix it before you submit. |
| **Skipped** | The rule was turned off in the *Accessibility Checker Options* dialog before the check ran. | Nothing. See the note below. |
| **Needs manual check** | Acrobat can't decide this rule by itself. | Look at it yourself. |

TAD's procedure (step 3 under *After Your Thesis Compiles*) turns off
**Tagged PDF, Logical Reading Order, Bookmarks** and **Color contrast**, so
those show as *Skipped*. If you turn them on anyway:

- Tagged PDF and Bookmarks pass: the PDF is tagged and has bookmarks for
  every chapter and section.
- Logical Reading Order and Color contrast always come back *Needs manual
  check*. The reading order follows your LaTeX source, and the text is black
  on white.

**Tables: Summary** asks for a *Summary* entry on every table. LaTeX can't
write table summaries yet, and TAD doesn't require them. Your table caption
already describes the table. This rule is often turned off by default, so it
shows as *Skipped*.

### Notes for whoever maintains the template

To make tagging work, `ohio-etd.cls` changes a few internals. None of them
changes the printed layout.

- **Chapters:** `\chapter` no longer uses `\secdef`. LaTeX would otherwise
  replace it with its own (non-OU) layout. Chapter and front-matter titles
  are tagged as H1.
- **Captions:** a caption is measured with tagging paused, then typeset once.
- **Abstract title:** the underline uses a small built-in macro
  (`\OU@underline`) instead of `soul`/`ulem`, which break tagging.
- **Contents and list pages:** acronyms inside entries are plain text, so a
  link is never nested in another link.
- **Front matter:** a `\par` follows each front-matter block.
- **Spaces (pdfLaTeX only):** `interwordspace=false`, because pdfTeX's real-space feature
  collapses the spaces of the bold small-caps chapter titles with txfonts.
- **LuaLaTeX:** text fonts are OpenType clones of Times/Helvetica/Courier
  (TeX Gyre Termes/Heros/Cursor via `fontspec`; math keeps txfonts); the
  `pdftex` class option is no longer used (PDF output is detected, and the
  option would make hyperref load the wrong driver); `\draftmode` is only
  defined under pdfLaTeX (it is a LuaTeX primitive); `glyphtounicode` is
  loaded for either engine.
- **PDF title and author:** `\title`/`\author` set them only as fallbacks;
  `\hypersetup` in `main.tex` wins.
- **Labels:** the kernel's symbolic structure names `toc/item/label`,
  `float/figure/label`, `float/table/label`, `math/label`,
  `block/theorem-like/label` and `block/verbatim/linenumber`, and the tags
  `footnotemark`/`footnotelabel`, are mapped to `Span` (PDF versions below
  2.0 only; see `\OU@nolbl`).
- **Unicode for wasysym:** glyph-name-to-Unicode entries for the wasysym
  symbols are set at `\begin{document}` (`\OU@gtu`). Without them,
  `\smiley` made Acrobat's "Character encoding" check fail.

## After Your Thesis Compiles: Manual Fixes Still Needed in Adobe Acrobat Pro

Compiling `main.tex` gets you most of the way to a submittable PDF, but
**not all the way**. This template already handles some accessibility
requirements automatically — `main.tex` sets `pdflang={en-US}` and
`pdfdisplaydoctitle=true` via `\hypersetup{}`, and glyph-to-Unicode mapping
(`glyphtounicode`) is enabled so text is extracted correctly. That covers the "text language is
specified" and "document title is showing in title bar" checks on its
own.

Font embedding is handled at compile time too: the thesis fonts are always
embedded, and `embedfigurefonts.sty` embeds the fonts inside PDF/EPS
figures. Alt text comes from the LaTeX source when you build with `\TaggedPDFtrue`
(see "Alt Text and the Accessible (Tagged) PDF" above). What is **not**
automatic is **the accessibility check itself**: it is a manual round in
Adobe Acrobat Pro before the PDF goes to TAD (and the font check below is
still worth doing as a final confirmation). (TAD's own "Creating an Accessible ETD (LaTeX)" guide covers
this too — the steps below just spell out exactly where to click.)

### 1. Add alt text to every figure

**Only needed for an untagged build (`\TaggedPDFfalse`).** A build with
`\TaggedPDFtrue` already carries the alt text from
`\includegraphics[alt={...}]` on every figure, so skip to step 2. Rebuilding
with `\TaggedPDFtrue` is easier; for an untagged PDF, add the descriptions in
Acrobat:

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
  submission. Fonts inside PDF/EPS figures are embedded automatically by
  `embedfigurefonts.sty`, so this should not happen. If it does, look in
  the compile log for an `embedfigurefonts` warning naming the figure
  (usually shell escape or Ghostscript was unavailable in a local build).

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
  and run the Adobe Acrobat Pro accessibility check. Fonts are embedded
  automatically, and alt text is written with `alt={...}` and appears in
  the `\TaggedPDFtrue` build. See "Alt Text and the Accessible (Tagged)
  PDF" and "After Your Thesis Compiles" above.
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
- Where possible, prefer PDF versions of figures over PNG. Their fonts are
  embedded automatically at compile time (see "A note on figures" above).
- Make the version you submit with `\TaggedPDFtrue`, so figure alt text
  and tags are in the PDF, and check it in Acrobat.
- Once a draft looks TAD-ready, follow up directly with TAD Services to
  confirm it actually meets current requirements — as the disclaimer at
  the top notes, this document is a starting point, not a substitute for
  their review.
