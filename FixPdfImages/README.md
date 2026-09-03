# FixPdfImages

## Purpose

This folder holds the figures used in the thesis in PDF form, plus a small
utility script (`FixImages.sh`) that repairs a font-embedding problem that
PDF figures can develop depending on how they were originally generated.

## Why PDF for figures instead of PNG/JPG

PDF is used for the thesis figures (rather than raster formats like PNG or
JPG) because it is a vector/print-oriented format: text, lines, and curves
stay sharp at any zoom level or print size, instead of pixelating. This
matters for a document that may be printed, zoomed into during defense, or
archived long-term by the graduate college. LaTeX also handles PDF figures
natively via `\includegraphics`, so there's no quality loss from an extra
raster conversion step.

## The catch: font embedding

The trade-off is that a PDF is only as portable as its embedded fonts. Many
tools that export plots as PDF (ROOT, matplotlib, certain plotting
libraries, etc.) do not embed all fonts by default — instead they reference
fonts by name and assume the viewing/rendering system has them installed.
Depending on how a given PDF was generated, this can cause:

- Text in the figure (axis labels, legends) rendering incorrectly or
  substituting a different font on another machine.
- LaTeX/PDF compilers or university ETD submission systems flagging the
  document because not all fonts are fully embedded (a common requirement
  for institutional repository submission).

Because this depends entirely on how each individual PDF was produced, not
every figure needs fixing — but any that don't embed fonts do need a fix
before they go into the final thesis PDF.

## Folder layout

```
FixPdfImages/
├── input/          <- original PDF figures go here (the script's input)
├── fixed_images/    <- repaired PDFs are written here (the script's output)
└── FixImages.sh
```

Keeping originals and fixed output in separate folders means the script is
never overwriting a source file in place, and it's always obvious at a
glance which PDFs still need to be reviewed/swapped in.

## What `FixImages.sh` does

The script scans the `input/` folder for `.pdf` files and, for each one:

1. Runs `pdffonts` on it and checks whether any listed font shows `no` in
   the "embedded" column.
2. If a font is not embedded, it reprocesses the PDF with Ghostscript
   (`gs`) using prepress settings that force all fonts to be embedded and
   subsetted (`-dEmbedAllFonts=true -dSubsetFonts=true`), writing the
   repaired file to `fixed_images/` under the same name.
3. If all fonts are already embedded, the file is left alone (reported as
   "OK, skipped") and nothing is written for it.

Before running, the script also checks that `pdffonts` and `gs` are
actually installed and available on your `PATH`, and fails early with a
clear message if either is missing (rather than failing partway through
with a cryptic error).

At the end it prints a summary of how many files were fixed vs. already
fine, and reminds you to spot-check the fixed PDFs visually before
replacing the originals (or before pointing `\includegraphics` at the
`fixed_images/` versions).

### Usage

```bash
# uses ./input as the input folder and ./fixed_images as the output folder
./FixImages.sh

# custom input folder, default output folder (./fixed_images)
./FixImages.sh /path/to/some/input

# custom input and output folders
./FixImages.sh /path/to/input /path/to/output
```

The script resolves its default `input`/`fixed_images` folders relative to
its own location, so it behaves the same regardless of which directory you
run it from.

### Dependencies

The script needs the following installed and available on `PATH`:

- **Bash** (it's a bash script; run on macOS/Linux, or WSL/Git Bash on
  Windows).
- **`pdffonts`** — part of the `poppler-utils` package. Used to check
  whether a PDF's fonts are embedded.
- **Ghostscript (`gs`)** — used to reprocess and re-embed fonts into a new
  PDF.

On macOS (Homebrew):

```bash
brew install poppler ghostscript
```

On Debian/Ubuntu:

```bash
sudo apt-get install poppler-utils ghostscript
```

The script checks for both `pdffonts` and `gs` at startup and will exit
immediately with a clear error message if either is missing, rather than
failing partway through a run.

## Folder contents

- `FixImages.sh` — the font-embedding fix script described above.
- `input/` — original figure PDFs (`alpha_coupling.pdf`,
  `eta_spectrum_fit_sPHENIX.pdf`, `pi0_spectrum_fit_sPHENIX.pdf`), some of
  which have font-embedding issues.
- `fixed_images/` — output of the script; contains the repaired versions
  of the figures that needed a fix.
