\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{ohio-etd}[2013/07/31 version 1.3 Ohio University Electronic
Thesis and Dissertation Class]

% 1.1 - change \listof to \addlistof to avoid conflict with float.sty
%     - load amsthm.sty since this must also precede txfonts.sty
%     - Thanks to Aleksey Imaev for pointing out these conflicts

% 1.2 - correct the copyright line to include the year before the name
%     - add "Page" to the table of contents and list of figures/tables

% 1.3 - Remove signature lines from "signature page" per ETD requirements
%     - Remove broken spacing code adding a newline at point of figure insertion
%     - Update graduation months for Semesters
%     - Add new "htc" option for HTC students. Adds \htcmajor, \htcdegree,
%       \htcdos, and \htcdean to front matter.
%	Updated by Samuel Jero <sj323707@ohio.edu>

% define some macros that allow the class to pass options to the underlying
% article.cls without causing erroneous error messages about unused options
\newcommand* \@leqno{\@gobble} 
\newcommand* \@fleqn{\@gobble} 
\newcommand* \@draft{\@gobble} 
\newcommand* \@fontsize{12pt}

\newif \if@pdftex   
\newif \if@htc  
\newif \if@numbered 
\newif \if@draft             
\newif \if@sstables 
\newif \if@coadvise
\newif \if@cmfont

\DeclareOption  {draft}    {\renewcommand*\@draft{draft}\@drafttrue}
\DeclareOption  {leqno}    {\renewcommand*\@fleqn{fleqn}}
\DeclareOption  {fleqn}    {\renewcommand*\@leqno{leqno}}
\DeclareOption  {11pt}     {\renewcommand*\@fontsize{11pt}}
\DeclareOption  {12pt}     {\renewcommand*\@fontsize{12pt}}
\DeclareOption  {cmfont}   {\@cmfonttrue}
\DeclareOption  {pdftex}   {\@pdftextrue}
\DeclareOption  {numbered} {\@numberedtrue}
\DeclareOption  {sstables} {\@sstablestrue}
\DeclareOption	{htc}      {\@htctrue}

\ExecuteOptions {12pt}
\ProcessOptions
% PDF features (bookmarks, PDF title, transparency group) are switched on
% automatically whenever the output is PDF (pdfLaTeX or LuaLaTeX), so the
% "pdftex" option is no longer needed. Don't pass it with LuaLaTeX: as a
% global option it would make hyperref and graphicx load their pdfTeX drivers.
\RequirePackage{iftex}
\ifpdf \@pdftextrue \fi

\LoadClass[\@draft,\@fleqn,\@leqno,\@fontsize]{article}

\RequirePackage {lastpage} % count the number of pages
\RequirePackage {soul}     % kept for documents that use \ul, \hl, \st, ...
\RequirePackage {url}      % intelligent line breaks for URLs and DOIs
\urlstyle{same}

\AtEndOfClass{
  \RequirePackage[
    bookmarks,
    breaklinks,
    colorlinks=false,
    pdfborder={0 0 0}
  ]{hyperref}
}

\RequirePackage{amsmath,amsthm} % AMS math must be defined prior to txfonts
\if@cmfont\else\RequirePackage{txfonts}\fi % Times fonts versus Computer Modern
% LuaLaTeX (or XeLaTeX): the text uses OpenType clones of Times, Helvetica and
% Courier (TeX Gyre Termes, Heros, Cursor). Unicode fonts give a tagged PDF
% correct, searchable text with real spaces; math keeps the txfonts symbols.
\RequirePackage{iftex}
\iftutex
  \if@cmfont\else
    \RequirePackage{fontspec}
    \setmainfont{texgyretermes}[Extension=.otf, UprightFont=*-regular,
      BoldFont=*-bold, ItalicFont=*-italic, BoldItalicFont=*-bolditalic]
    \setsansfont{texgyreheros}[Extension=.otf, UprightFont=*-regular,
      BoldFont=*-bold, ItalicFont=*-italic, BoldItalicFont=*-bolditalic]
    \setmonofont{texgyrecursor}[Extension=.otf, UprightFont=*-regular,
      BoldFont=*-bold, ItalicFont=*-italic, BoldItalicFont=*-bolditalic]
  \fi
\fi

% provide the means to switch back and forth between single and double spacing, 
% adapted from the previous OU LaTeX class.
% ---------------------------------------------------------------------------
% Tagged-PDF (accessibility) support. These helpers do nothing unless the
% document starts with \DocumentMetadata{... tagging=on ...}.
%   \OU@tagheading{H1}  tag the next paragraph as a heading of that level
% \SuspendTagging is provided by LaTeX 2024-06 and later; define a no-op for
% older installations.
% ---------------------------------------------------------------------------
\providecommand\SuspendTagging[1]{}
\providecommand\ResumeTagging[1]{}
% Tables: the first row of a tabular is its header row (Acrobat's "Tables:
% headers" check). Change it for one table inside that table environment,
% e.g. \tagpdfsetup{table/header-rows={1,2}}, or for a table that is only
% used for layout: \tagpdfsetup{table/tagging=presentation}.
% Formulas get their LaTeX source as alternate text.
% interwordspace=false (pdfLaTeX only): pdfTeX must not insert "real" space
% characters. With
% the OT1-encoded small caps of txfonts it uses font slot 32, which is not a
% space, and the spaces in chapter headings collapse ("ANDPHYSICS").
% Viewers and screen readers find the word gaps without them.
% Labels outside lists: Acrobat's checker uses the PDF 1.7 rules, where a Lbl
% (label) may only sit inside a list item (LI). LaTeX also tags the entry
% numbers in the table of contents and the lists of figures/tables, the
% "Figure 1.1:"/"Table 1.1:" caption labels, equation numbers and footnote
% marks as Lbl, which fails Acrobat's "Lists: Lbl and LBody" check. Tag them as
% Span (plain inline text) instead; screen readers still read them.
\ExplSyntaxOn
\cs_new_protected:Npn \OU@nolbl
  {
    \pdf_version_compare:NnT < { 2.0 }
      {
        \clist_map_inline:nn
          {
            toc/item/label, float/figure/label, float/table/label,
            math/label, block/theorem-like/label, block/verbatim/linenumber
          }
          {
            \tl_if_exist:cT { l__tag_name_##1_tl }
              { \AssignStructureRole {##1} { Span } }
          }
        \tagpdfsetup
          { role/new-tag = footnotemark/Span, role/new-tag = footnotelabel/Span }
      }
  }
\ExplSyntaxOff
\ifdefined\tagpdfsetup
  \tagpdfsetup{table/header-rows={1}}
  \tagpdfsetup{math/alt/use}
  \ifpdftex \AtBeginDocument{\tagpdfsetup{interwordspace=false}}\fi
  \AddToHook{begindocument/end}{\OU@nolbl}
\fi
% Unicode for the wasysym symbols (\smiley, \Box, \permil, ...). The
% glyphtounicode file loaded in main.tex has no entries for them, and
% Acrobat's "Character encoding" check fails on any glyph it can't map to
% Unicode. (pdfLaTeX and LuaLaTeX; the fonts are written at the end of the
% run, so setting this at \begin{document} is in time.)
\ifdefined\pdfglyphtounicode \let\OU@glyphtounicode\pdfglyphtounicode
\else\ifdefined\pdfextension
  \protected\def\OU@glyphtounicode{\pdfextension glyphtounicode }\fi\fi
\def\OU@gtu#1/#2,{%
  \ifx\relax#1\else\OU@glyphtounicode{#1}{#2}\expandafter\OU@gtu\fi}
\AtBeginDocument{\ifdefined\OU@glyphtounicode \OU@gtu %
  smiley/263A,blacksmiley/263B,frownie/2639,permil/2030,Box/25A1,XBox/2612,%
  Diamond/25C7,checked/2713,phone/260E,recorder/2315,lightning/21AF,%
  sqsubset/228F,sqsupset/2290,lhd/22B2,rhd/22B3,unlhd/22B4,unrhd/22B5,%
  LHD/25C0,RHD/25B6,leadsto/219D,apprle/2272,apprge/2273,varint/222B,%
  iint/222C,iiint/222D,varoint/222E,oiint/222F,dispvarint/222B,%
  dispiint/222C,dispiiint/222D,dispvaroint/222E,dispoiint/222F,%
  diameter/2300,Circle/25CB,CIRCLE/25CF,Bowtie/22C8,AC/223F,invneg/2310,%
  varangle/2222,leftturn/21BA,rightturn/21BB,applecmd/2318,eigthnote/266A,%
  twonotes/266B,Paragraph/00B6,brokenvert/00A6,agemO/2127,dh/00F0,%
  openo/0254,zh/0292,mercury/263F,jupiter/2643,saturn/2644,uranus/2645,%
  neptun/2646,pluto/2647,aries/2648,taurus/2649,gemini/264A,cancer/264B,%
  virgo/264D,libra/264E,scorpio/264F,sagittarius/2650,capricorn/2651,%
  aquarius/2652,pisces/2653,ascnode/260A,descnode/260B,conjunction/260C,%
  opposition/260D,\relax/,%
\fi}

% \tagpdfsetup is a no-op when the PDF is not tagged
\providecommand\tagpdfsetup[1]{}
\newcommand*\OU@tagheading[1]{%
  \ifdefined\tagpdfsetup \tagpdfsetup{para/tag=#1}\fi}

% \OU@underline{text}: underline that breaks across lines (used for the title
% in the abstract). Words are underlined one by one (math such as
% $\sqrt{s} = 200$ is kept together) and the spaces between them are
% underlined, stretchable and breakable. Unlike soul and ulem, each word is
% typeset exactly once, which keeps a tagged PDF consistent.
\newcommand*\OU@ul@pos{0.2em}   % depth of the underline below the baseline
\newcommand*\OU@ul@th{0.4pt}    % thickness of the underline
\newcommand\OU@ulword[1]{%
  \setbox\z@\hbox{#1}%
  \rlap{\vrule\@height-\OU@ul@pos\@depth\dimexpr\OU@ul@pos+\OU@ul@th\relax
         \@width\wd\z@}%
  \box\z@}
\newcommand\OU@ulspace{%
  \leaders\hrule\@height-\OU@ul@pos\@depth\dimexpr\OU@ul@pos+\OU@ul@th\relax
  \hskip\fontdimen2\font\@plus\fontdimen3\font\@minus\fontdimen4\font\relax}
\ExplSyntaxOn
\seq_new:N \l__ou_ul_seq
\tl_new:N \l__ou_ul_word_tl
\int_new:N \l__ou_ul_dollar_int
\bool_new:N \l__ou_ul_started_bool
\cs_new_protected:Npn \OU@underline #1
  {
    \leavevmode
    \seq_set_split:Nnn \l__ou_ul_seq { ~ } {#1}
    \tl_clear:N \l__ou_ul_word_tl
    \bool_set_false:N \l__ou_ul_started_bool
    \seq_map_inline:Nn \l__ou_ul_seq
      {
        \tl_put_right:Nn \l__ou_ul_word_tl {##1}
        \int_zero:N \l__ou_ul_dollar_int
        \tl_map_inline:Nn \l__ou_ul_word_tl
          { \tl_if_eq:nnT {####1} {$} { \int_incr:N \l__ou_ul_dollar_int } }
        \int_if_odd:nTF \l__ou_ul_dollar_int
          { \tl_put_right:Nn \l__ou_ul_word_tl { ~ } } % inside math: keep going
          {
            \bool_if:NT \l__ou_ul_started_bool { \OU@ulspace }
            \exp_args:NV \OU@ulword \l__ou_ul_word_tl
            \bool_set_true:N \l__ou_ul_started_bool
            \tl_clear:N \l__ou_ul_word_tl
          }
      }
  }
\ExplSyntaxOff

\newcommand* \singlespace{\renewcommand*\baselinestretch{1.0}\large\normalsize}
\newcommand* \@dsp{\renewcommand*\baselinestretch{1.655}\large\normalsize}

\newlength \@lineskip
\newlength \@fracskip
\newlength \@doubleskip
\setlength \@lineskip   {1.000\baselineskip}
\setlength \@fracskip   {0.655\baselineskip}
\setlength \@doubleskip {1.655\baselineskip}

% (LuaTeX has a primitive called \draftmode; it is left alone there)
\ifdefined\draftmode\else \newcommand* \draftmode{\@drafttrue}\fi
\AtBeginDocument{
  \if@draft  
    \singlespace
  \else
    \@dsp
  \fi
}

\newcounter{@appcount}
\AtEndDocument{
  \if@appendix
    \ifnum \c@chapter=\c@@appcount \else 
    \ClassWarningNoLine{ohio-etd}{appendix count has changed. 
                            Rerun to get labels right}
    \fi
    \immediate\write\@auxout{\string\setcounter{@appcount}{\number\c@chapter}}
  \else
    \immediate\write\@auxout{\string\setcounter{@appcount}{0}}
  \fi    
}

\setlength\paperheight    {11.0in}
\setlength\paperwidth     { 8.5in}
                          
\setlength\hoffset        {0in}
\setlength\voffset        {0in}
\setlength\marginparwidth {0in}     % no marginal notes
\setlength\marginparsep   {0in}
\setlength\marginparpush  {0in}    
\setlength\oddsidemargin  {0.5in}   % (in addition to the 1in default)
\setlength\evensidemargin {0.5in}   % (in addition to the 1in default)
\setlength\topmargin      {0in}     % (in addition to the 1in default)
\setlength\headheight     {\@lineskip} 
\setlength\headsep        {\@lineskip} 
\setlength\footskip       {0in}
                          
\setlength\textwidth      {\paperwidth}
\setlength\textheight     {\paperheight}

\addtolength \textwidth {-2in}      % 1in defaults for left and right margins
\addtolength \textwidth {-\oddsidemargin}
\addtolength \textheight{-2in}      % 1in defaults for top and bottom margins
\addtolength \textheight{-\headheight}
\addtolength \textheight{-\headsep}
\addtolength \textheight{-\footskip}

\renewcommand \topfraction      {1}
\renewcommand \textfraction     {0}
\renewcommand \floatpagefraction{.5}

\def\ps@headings{%
  \def\@oddhead {\hfil\thepage} % page number in top right corner
  \def\@evenhead{}
  \def\@oddfoot {}
  \def\@evenfoot{}
  \let\@mkboth\markboth
}

% MACROS FOR THE FRONTMATTER

\newcommand\degree[1]{
  \begingroup
    \def\deg{#1}
    \def\degMA{MA}
    \def\degMS{MS}
    \def\degMCTP{MCTP}
    \def\degPhD{PhD}
    \ifx\deg\degMA\endgroup
      \newcommand*\@degree{Master of Arts}
      \newcommand*\@degreeabbr{M.A.}     
      \newcommand*\@doctype{thesis}
      \newcommand*\@Doctype{Thesis}
    \else\ifx\deg\degMS\endgroup
      \newcommand*\@degree{Master of Science}
      \newcommand*\@degreeabbr{M.S.}     
      \newcommand*\@doctype{thesis}
      \newcommand*\@Doctype{Thesis}
    \else\ifx\deg\degMCTP\endgroup
      \newcommand*\@degree{Master of Communication Technology and Policy}
      \newcommand*\@degreeabbr{MCTP}                       
      \newcommand*\@doctype{thesis}
      \newcommand*\@Doctype{Thesis}
    \else\ifx\deg\degPhD\endgroup
      \newcommand*\@degree{Doctor of Philosophy}
      \newcommand*\@degreeabbr{Ph.D.} 
      \newcommand*\@doctype{dissertation}
      \newcommand*\@Doctype{Dissertation}
    \else\endgroup
      \ClassWarning{ohio-etd}{degree not recognized (expecting MA, MS, MCTP,
        or PhD)}
    \fi\fi\fi\fi
}

\newcommand*\graduation[2]{
  \begingroup
    \def\month{#1}
    \def\monthMar{May}
    \def\monthMay{August}
    \def\monthAug{December}
    \ifx\month\monthMar\endgroup\newcommand*\@gradmonth{#1}
    \else\ifx\month\monthMay\endgroup\newcommand*\@gradmonth{#1}
    \else\ifx\month\monthAug\endgroup\newcommand*\@gradmonth{#1}
    \else\ifx\month\monthNov\endgroup\newcommand*\@gradmonth{#1}
    \else
      \ClassWarning{ohio-etd}{graduation month not recognized (expecting May, August, or December)}
    \fi\fi\fi\fi
  \newcommand*\@gradyear{#2}   
}

\newcommand*\program[1]     {\newcommand*\@program{#1}}
\newcommand*\department[1]  {\newcommand*\@department{#1}}
\newcommand*\college[1]     {\newcommand*\@college{#1}}

\newcommand*\advisor[2]     {\newcommand*\@advisor{#1}
                             \newcommand*\@advisortitle{#2}}
\newcommand*\coadvisor[2]   {\newcommand*\@coadvisor{#1}
                             \newcommand*\@coadvisortitle{#2}\@coadvisetrue}
\newcommand*\dean[2]        {\newcommand*\@dean{#1}
                             \newcommand*\@deantitle{#2}}
\renewcommand*\author[2]    {\renewcommand*\@author{#1 #2}
                             \newcommand*\@authorreversed{#2, #1}%
                             \OU@pdfinfo{pdfauthor={#1 #2}}}
\renewcommand\title[1]      {\renewcommand\@title{#1}\OU@pdfinfo{pdftitle={#1}}}
% PDF metadata fallbacks; a later \hypersetup{pdftitle=...,pdfauthor=...} in
% main.tex overrides them (give a plain-text title there: it is what the PDF
% title bar and the accessibility checker show)
\newcommand\OU@pdfinfo[1]{\ifdefined\hypersetup\hypersetup{#1}\fi}
\newcommand*\authorreversed[1]{\renewcommand*\@authorreversed{#1}}



\newcommand{\@centeredpage}[1]{  
  \newpage
  \vbox to \textheight{
    \vfil
    \begin{center}
      \@dsp 
      #1\par
      \vspace{\@doubleskip}
    \end{center}
    \vfil
  }
}
%HTC additions
\newcommand*\htcmajor[1]     {\newcommand*\@htcmajor{#1}}
\newcommand\htcdegree[1]{
  \begingroup
    \def\deg{#1}
    \def\degBA{BA}
    \def\degBS{BS}
    \ifx\deg\degBA\endgroup
      \newcommand*\@htcdegree{Bachelor of Arts}
      \newcommand*\@htcdegreeabbr{B.A.}     
      \newcommand*\@htcdoctype{thesis}
      \newcommand*\@htcDoctype{Thesis}
    \else\ifx\deg\degBS\endgroup
      \newcommand*\@htcdegree{Bachelor of Science}
      \newcommand*\@htcdegreeabbr{B.S.}     
      \newcommand*\@htcdoctype{thesis}
      \newcommand*\@htcDoctype{Thesis}
    \else\endgroup
      \ClassWarning{ohio-etd}{degree not recognized (expecting BA or BS)}
    \fi\fi
}
\newcommand*\htcdos[1]        {\newcommand*\@htcdos{#1}}
\newcommand*\htcdean[2]        {\newcommand*\@htcdean{#1}
                             \newcommand*\@htcdeantitle{#2}}
% FRONT MATTER

\newcommand\makefrontmatter{
  
  % error checking
  \begingroup
    \newif\if@ferr
    \@ferrfalse
    \@ifundefined{@degree}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing degree}}{}
    \@ifundefined{@gradmonth}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing graduation month}}{}
    \@ifundefined{@program}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing program name}}{}
    \@ifundefined{@department}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing department name}}{}
    \@ifundefined{@college}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing college name}}{}
    \@ifundefined{@author}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing author's name}}{}
    \@ifundefined{@title}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing document's title}}{}
    \@ifundefined{@advisor}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing advisor's information}}{}
    \@ifundefined{@dean}{
      \@ferrtrue\ClassWarningNoLine{ohio-etd}{missing dean's information}}{}
   	\if@htc
   		\@ifundefined{@htcmajor}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC major}}{}
   		\@ifundefined{@htcdegree}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC degree}}{}
   		\@ifundefined{@htcdos}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC DOS information}}{}
   		\@ifundefined{@htcdean}{
   			\@ferrtrue\ClassWarningNoLine{ohio-etd}{missing HTC dean information}}{}
   	\fi
    \if@ferr 
      \ClassError{ohio-etd}{missing required frontmatter definitions}
                 {All frontmatter macros must be defined in the preamble}
    \fi
  \endgroup

  % print the frontmatter
  \@titlepage      
  \@govtdisclaimer 
  \@approvalpage   
  \@abstract       
  \@dedication     
  \@acknowledgments
  \tableofcontents 
  \@listoftables   
  \@listoffigures  
  \@makelist
  
%   \@otherlists
%   \@listofsymbols  
%   \@listofacronyms 

  % free up some memory
  \global\let\@pdftex          \@empty
  \global\let\@centeredpage    \@empty
  \global\let\@titlepage       \@empty
  \global\let\@govtdisclaimer  \@empty
  \global\let\@approved        \@empty
  \global\let\@approvalpage    \@empty
  \global\let\@abstract        \@empty
  \global\let\@dedication      \@empty
  \global\let\@acknowledgments \@empty
  \global\let\@listoftables    \@empty
  \global\let\@listoffigures   \@empty
  \global\let\@listofsymbols   \@empty
  \global\let\@listofacronyms  \@empty
  \global\let\govtdisclaimer   \relax
  \global\let\abstract         \relax
  \global\let\dedication       \relax
  \global\let\acknowledgments  \relax
  \global\let\acknowledgements \relax
  \global\let\listofsymbols    \relax
  \global\let\listofacronyms   \relax
  \global\let\tableofcontents  \relax
  \global\let\graduation       \relax
  \global\let\program          \relax
  \global\let\department       \relax
  \global\let\college          \relax
  \global\let\author           \relax
  \global\let\title            \relax
  \global\let\advisor          \relax
  \global\let\coadvisor        \relax
  \global\let\dean             \relax    
  \global\let\@degreeabbr      \@empty
  \global\let\@gradyear        \@empty
  \global\let\@gradmonth       \@empty
  \global\let\@program         \@empty
  \global\let\@department      \@empty
  \global\let\@college         \@empty
  \global\let\@author          \@empty
  \global\let\@title           \@empty
  \global\let\@advisor         \@empty
  \global\let\@coadvisor       \@empty
  \global\let\@deantitle       \@empty    
  \global\let\@advisortitle    \@empty
  \global\let\@coadvisortitle  \@empty
  \global\let\@dean            \@empty    
  \global\let\@signwidth       \@empty
}
  
\newcommand\@titlepage{
  \newpage
  \if@pdftex 
    % PDF title/author: \title and \author set them as fallbacks; the
    % plain-text \hypersetup{pdftitle=...} in main.tex overrides them.
 
    % The following line accomodates transparency in PDF files
    \@ifundefined{IfPDFManagementActiveTF}{\@secondoftwo}{\IfPDFManagementActiveTF}
      {\PDFManagementAdd{Page}{Group}{<</S /Transparency /I true /CS /DeviceRGB>>}}% \DocumentMetadata
      {\ifdefined\pdfpageattr\pdfpageattr {/Group << /S /Transparency /I true /CS /DeviceRGB>>}\fi}%
  \fi
  \thispagestyle{empty}
  \setcounter{page}{1}
  \if@htc
	  \begin{center}
	    \@dsp
	    \@title\\[5\@doubleskip]
	    A \@doctype\ presented to\\
	    The Honors Tutorial College\\
	    Ohio University\\[\@doubleskip]
	    In partial fulfillment\\
	    of the Requirements for Graduation\\
	    from the Honors Tutorial College\\
	    with the degree of\\
	    \@htcdegree\ in \@htcmajor\\[5\@doubleskip]
	    \@author\\
	    \@gradmonth\ \@gradyear\\
	    \@ifundefined{govtdisclaimer}{}{
	      \copyright\ \@gradyear\ \@author. All Rights Reserved.
	    }
	  \end{center}\par % \par closes the block for tagged PDFs; no visual effect
  \else
	  \begin{center}
	    \@dsp
	    \@title\\[5\@doubleskip]
	    A \@doctype\ presented to\\
	    the faculty of\\
	    the \@college\ of Ohio University\\[\@doubleskip]
	    In partial fulfillment\\
	    of the requirements for the degree\\
	    \@degree\\[5\@doubleskip]
	    \@author\\
	    \@gradmonth\ \@gradyear\\
	    \@ifundefined{govtdisclaimer}{}{
	      \copyright\ \@gradyear\ \@author. All Rights Reserved.
	    }
	  \end{center}\par % \par closes the block for tagged PDFs; no visual effect
  \fi
  \setcounter{footnote}{0}
}

\let\@govtdisclaimer\relax % default to \relax so that the command can be
                           % issued in the frontmatter whether or not the
                           % \govtdisclaimer command is set in the preamble.
                           % Note that \let is required over \newcommand to
                           % later test with \@ifundefined
\newcommand\govtdisclaimer[1][
  The views expressed in this dissertation are those of the 
  author and do not reflect the official policy or position of
  the United States Air Force, the Department of Defense, \\ 
  or the United States Government.
]
{
  \@ifundefined{@govtdisclaimer}
    {\newcommand\@govtdisclaimer{\@centeredpage{#1}}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\govtdisclaimer}}
}

\newcommand*\@approved{Approved:\quad}
\settowidth \@tempdima{\@approved}
\newlength  \@signwidth
\setlength  \@signwidth\textwidth
\addtolength\@signwidth{-2\@tempdima}

\newcommand{\@approvalpage}{
  \newpage
  \if@htc
  	\begin{center}
	    \@dsp
	    This \@doctype\ has been approved by\\
	    The Honors Tutorial College and\\
	    The \@department\\[2\@doubleskip minus
	    1\@doubleskip] \underline{\hspace\@signwidth}\\
	    \@advisor\\
	    \@advisortitle\\
	    Thesis Advisor\\[2\@doubleskip minus 1\@doubleskip]
	    \if@coadvise
	      \underline{\hspace\@signwidth}\\
	      \@coadvisor\\
	      \@coadvisortitle\\
	      Thesis Advisor\\[2\@doubleskip minus 1\@doubleskip]
	    \fi
	    \underline{\hspace\@signwidth}\\
	    \@htcdos\\
	   	Honors Tutorial College, Director of Studies\\
	   	\@htcmajor\\[2\@doubleskip minus 1\@doubleskip]
	   	\underline{\hspace\@signwidth}\\
	   	\@htcdean\\
	   	\@htcdeantitle\\[2\@doubleskip minus 1\@doubleskip]
	   	\underline{\hspace\@signwidth}\\
	    \@dean\\
	    \@deantitle\\
	  \end{center}\par % \par closes the block for tagged PDFs; no visual effect
  \else
	  \begin{center}
	    \@dsp
	    This \@doctype\ titled\\
	    \@title\\[2\@lineskip minus 3\@doubleskip]
	    by\\
	    \MakeUppercase{\@author}\\[1\@doubleskip]
	    has been approved for \\
	    the \@department\ \\
	    and the \@college\ by\\[3\@doubleskip minus 1\@doubleskip]
	    \@advisor\\
	    \@advisortitle\\[2\@doubleskip minus 1\@doubleskip]
	    \if@coadvise
	      \@coadvisor\\
	      \@coadvisortitle\\[2\@doubleskip minus 1\@doubleskip]
	    \fi
	    \@dean\\
	    \@deantitle\\
	  \end{center}\par % \par closes the block for tagged PDFs; no visual effect
  \fi
}

\newcommand*\@last{\relax}
\newcommand*\@end{\null}
% Although forced line breaks may have been inserted into the title for the
% title page, these must be removed before printing the title on the approval
% page.
\def\@stripbreaks#1\\#2\@end{#1\if#2\@last\else\space\@stripbreaks#2\@end\fi}
\def\@tooneline{\expandafter\@stripbreaks\@title\\\@last\@end}
\let\@titleoneline=\@tooneline
\renewcommand\abstract[1]{
  \newcommand\@abstract{
    \@schaptertoc{Abstract}
    \begingroup
      \@dsp
      \begingroup
        \raggedright
        \MakeUppercase\@authorreversed,
        \@degreeabbr, \@gradmonth\ \@gradyear, \@program\\
        \protected@edef\OU@abstracttitle{\@titleoneline}%
        \expandafter\OU@underline\expandafter{\OU@abstracttitle}\ (\pageref{LastPage} pp.)\\
        \if@coadvise
          Directors of \@Doctype: \@advisor\ and \@coadvisor\\
        \else
          Director of \@Doctype: \@advisor\\
        \fi
      \endgroup
      \noindent #1 \\
      \noindent\centering
      %\@approved\hfil\\
    \endgroup
  }
}


\let\@dedication\relax
\newcommand\dedication[1]{
  \clearpage
  \@ifundefined{@dedication}
    {\newcommand\@dedication{\@schaptertoc{Dedication}#1}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\dedication}}
}


% \let\@dedication\relax
% \newcommand\dedication[1]{
%   \@ifundefined{@dedication}
%     { \newcommand\@dedication{\@schaptertoc{Dedication}#1
%         \clearpage
%         \refstepcounter{schapter}
%         \addcontentsline{toc}{chapter}{Dedication}
%         \@centeredpage{\emph{#1}}
%       }
%     
%     {\ClassWarning{ohio-etd}{ignoring subsequent \protect\dedication}}
% }
% }

\let\@acknowledgments\relax
\newcommand\acknowledgments[1]{
  \@ifundefined{@acknowledgments}
    {\newcommand\@acknowledgments{\@schaptertoc{Acknowledgments}#1}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\acknowledgments}}
}
\newcommand\acknowledgements[1]{
  \@ifundefined{@acknowledgments}
    {\newcommand\@acknowledgments{\@schaptertoc{Acknowledgements}#1}}
    {\ClassWarning{ohio-etd}{ignoring subsequent \protect\acknowledgements}}
}

\renewcommand\tableofcontents{
  \clearpage
  \if@pdftex \pdfbookmark[0]{Table of Contents}{TOC} \fi
  \chapter*{Table of Contents}
  \begingroup 
    \singlespace
    \hfill Page\par
    \@starttoc{toc}
  \endgroup
}

% Entries in the Table of Contents and the lists of figures/tables are links
% already. An acronym (\ac{...}) in a heading or caption must not add a second
% link nested inside that entry (invalid in a tagged PDF), so acronyms are
% printed as plain text there.
\let\OU@starttoc\@starttoc
\def\@starttoc#1{%
  \begingroup
    \@ifundefined{AC@hyperlink}{}{\def\AC@hyperlink##1##2{##2}}%
    \OU@starttoc{#1}%
  \endgroup}

\newcounter{listctr}
\newcounter{listcnt}
\renewcommand\thelistcnt {\@Alph\c@listcnt}
\renewcommand\thelistctr {\@Alph\c@listctr}

\newcommand\@makelist{
  \ifnum \c@listcnt>\c@listctr
    \refstepcounter{listctr}
    \csname @listof\thelistctr \endcsname
    \@makelist
  \fi
}
  
\newcommand\addlistof[2]{
  \refstepcounter{listcnt}
  \expandafter\gdef\csname @listof\thelistcnt\endcsname{\@addlistof{#1}{#2}}
}

\newcommand\@addlistof[2]{
  \@schaptertoc{List of #1}
  \if@numbered\addvspace{\@lineskip}\fi
  \begingroup
    \singlespace
    #2
  \endgroup
  \par % closes the last paragraph or list for tagged PDFs; no visual effect
}

\newcommand\@listoffigures{
  \setcounter{tocdepth}{1}
  \begingroup
    \let\numberline=\@numberlinefigure
    \@addlistof{Figures}{
      % add \@fracskip and \@lineskip to get correct spacing within the 
      % singlespace structure of the \@addlistof macro
      \if@numbered \addvspace{\@doubleskip} \noindent Figure 
      \else \addvspace{\@fracskip} \fi \hfill Page\par
      \addvspace{\@lineskip}
      \@starttoc{lof}
    }
  \endgroup
}

\newcommand\@listoftables{
  \setcounter{tocdepth}{1}
  \begingroup
    \let\numberline=\@numberlinetable
    \@addlistof{Tables}{
      % add \@fracskip and \@lineskip to get correct spacing within the 
      % singlespace structure of the \@addlistof macro
      \if@numbered \addvspace{\@doubleskip} \noindent Table 
      \else \addvspace{\@fracskip} \fi \hfill Page\par
      \addvspace{\@lineskip}
      \@starttoc{lot}
    }
  \endgroup
}

\newcommand\notables {\renewcommand\@listoftables{}}
\newcommand\nofigures{\renewcommand\@listoffigures{}}

\newcommand\references[1]{
  \clearpage
  \refstepcounter{schapter}
  \addcontentsline{toc}{chapter}{\bibname}
  \if@numbered\addvspace{\@doubleskip}\else\addvspace{\@fracskip}\fi
  \begingroup
    \singlespace 
    #1
  \endgroup
}

\newcommand*{\bibname}{References}
\renewenvironment{thebibliography}[1]{ 
  \@schaptertoc{\bibname}%
  \if@numbered\addvspace{\@doubleskip}\else\addvspace{\@fracskip}\fi
  \list{ \@biblabel{\@arabic\c@enumiv}}%
       { \settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}
       }%
   \sloppy
   \clubpenalty4000
   \@clubpenalty \clubpenalty
   \widowpenalty4000
   \sfcode`\.\@m
   \singlespace
}
{\def\@noitemerr
  {\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
}

\newif\if@appendix 
\renewcommand\appendix{
  \@appendixtrue
  \setcounter{chapter}{0}
  \renewcommand\thechapter {\@Alph\c@chapter}
  \ifnum \c@@appcount>1
    \newcommand*\@appname{Appendix\space\thechapter}
  \else
    \newcommand*\@appname{Appendix}
  \fi
  \if@numbered
    \addtocontents{lof} {\protect\addvspace{\@lineskip}}
    \addtocontents{lot} {\protect\addvspace{\@lineskip}}
  \fi
  \immediate\write\@auxout{\string\@writefile{toc}{%
      \string\setcounter{tocdepth}{0}}} % limit toc to Appendix title only
}

\newcounter{chapter}
\newcounter{schapter}
\renewcommand\thesection  {\thechapter.\@arabic\c@section}

\newcommand\chapter{
  \clearpage
   \global\@topnum\z@
   \@afterindenttrue
   % identical to \secdef\@chapter\@schapter; written out so that LaTeX's
   % tagging code keeps this OU chapter layout instead of replacing \chapter
   \@ifstar{\@schapter}{\@dblarg\@chapter}%
}

\def\@schapter#1{ % used by some bibliography packages
  \@makechapterhead{#1}
  \vspace{\@fracskip}
}

\newcommand\@schaptertoc[2][schapter]{
  \clearpage
  \global\@topnum\z@
  \@afterindenttrue
  \refstepcounter{#1}
  \addcontentsline{toc}{chapter}{#2}
  \@makechapterhead{#2}
}

\if@numbered

  \def\@chapter[#1]#2{
    \refstepcounter{chapter}
    \if@appendix
      \typeout{Appendix \thechapter.}
      \addcontentsline{toc}{chapter}{\@appname:\space#1}
      \@makechapterhead{\@appname:\space#2}
    \else
      \typeout{Chapter \thechapter.}
      \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}
      \@makechapterhead{\thechapter\quad#2}
    \fi
    \addtocontents{lof}{\protect\addvspace{\@lineskip}}
    \addtocontents{lot}{\protect\addvspace{\@lineskip}}
  }

  \def\@makechapterhead#1{
    \begingroup
      \OU@tagheading{H1}%
      \centering \sc \Large \bfseries #1 \par \nobreak
      \vspace{-\@fracskip}
      \addvspace{\@lineskip}
    \endgroup
    \@afterheading
  }


% ============================================================
% APA-style headings below chapter level
%
% \chapter            -> unchanged
% \section            -> APA Level 2
% \subsection         -> APA Level 3
% \subsubsection      -> APA Level 4
% \subsubsubsection   -> APA Level 5
% deeper levels       -> APA Level 5 appearance
% ============================================================

% APA Level 2: Flush Left, Bold, Title Case
\renewcommand\section{%
  \@startsection{section}{1}{\z@}%
    {1.5ex \@plus -1ex \@minus -.2ex}%
    {1.5ex \@plus .2ex}%
    {\normalfont\normalsize\bfseries}%
}

% APA Level 3: Flush Left, Bold Italic, Title Case
\renewcommand\subsection{%
  \@startsection{subsection}{2}{\z@}%
    {1.5ex \@plus -1ex \@minus -.2ex}%
    {1.5ex \@plus .2ex}%
    {\normalfont\normalsize\bfseries\itshape}%
}

% APA Level 4: Indented, Bold, Run-in, automatic period
\renewcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\parindent}%
    {1.5ex \@plus -1ex \@minus -.2ex}%
    {-1em}%
    {\normalfont\normalsize\bfseries}%
}

\let\oldsubsubsection\subsubsection
\renewcommand{\subsubsection}[1]{%
  \oldsubsubsection{#1.}%
}

% APA Level 5: Indented, Bold Italic, Run-in, automatic period
\newcounter{subsubsubsection}[subsubsection]

\renewcommand\thesubsubsubsection{%
  \thesubsubsection.\arabic{subsubsubsection}%
}

\newcommand\subsubsubsection{%
  \@startsection{subsubsubsection}{4}{\parindent}%
    {1.5ex \@plus -1ex \@minus -.2ex}%
    {-1em}%
    {\normalfont\normalsize\bfseries\itshape}%
}

\let\oldsubsubsubsection\subsubsubsection
\renewcommand{\subsubsubsection}[1]{%
  \oldsubsubsubsection{#1.}%
}

% Anything deeper follows APA Level 5 appearance
% Indented, Bold Italic, Run-in, automatic period

\renewcommand\paragraph{%
  \@startsection{paragraph}{5}{\parindent}%
    {1.5ex \@plus -1ex \@minus -.2ex}%
    {-1em}%
    {\normalfont\normalsize\bfseries\itshape}%
}

\let\oldparagraph\paragraph
\renewcommand{\paragraph}[1]{%
  \oldparagraph{#1.}%
}

\renewcommand\subparagraph{%
  \@startsection{subparagraph}{6}{\parindent}%
    {1.5ex \@plus -1ex \@minus -.2ex}%
    {-1em}%
    {\normalfont\normalsize\bfseries\itshape}%
}

\let\oldsubparagraph\subparagraph
\renewcommand{\subparagraph}[1]{%
  \oldsubparagraph{#1.}%
}

% Number headings through subsubsubsection
\setcounter{secnumdepth}{4}

  \@addtoreset {equation} {chapter}
  \@addtoreset {figure}   {chapter}
  \@addtoreset {table}    {chapter}
  \@addtoreset {section}  {chapter}

  \renewcommand \theequation {\thechapter.\@arabic\c@equation}
  \renewcommand \thefigure   {\thechapter.\@arabic\c@figure}
  \renewcommand \thetable    {\thechapter.\@arabic\c@table}

  \let\@numberlinefigure=\numberline
  \let\@numberlinetable= \numberline

  \renewcommand* \l@figure        {\@dottedtocline{1} {0em}   {2.3em}}
  \renewcommand* \l@table         {\@dottedtocline{1} {0em}   {2.3em}}
  \renewcommand* \l@section       {\@dottedtocline{1} {1.5em} {2.3em}}
  \renewcommand* \l@subsection    {\@dottedtocline{2} {3.8em} {3.2em}}
  \renewcommand* \l@subsubsection {\@dottedtocline{3} {7.0em} {4.1em}}
  \renewcommand* \l@paragraph     {\@dottedtocline{4} {10em}  {5em}}
  \renewcommand* \l@subparagraph  {\@dottedtocline{5} {12em}  {6em}}

\else

  \setcounter{secnumdepth}{0}
  \def\@chapter[#1]#2{
    \refstepcounter{chapter}
    \if@appendix
      \typeout{Appendix \thechapter.}
      \addcontentsline{toc}{chapter}{\@appname:\space#1}
      \@makechapterhead{\@appname:\space#2}
    \else
      \typeout{Chapter\space\thechapter.}
      \addcontentsline{toc}{chapter}{Chapter\space\thechapter: #1}
      \@makechapterhead{Chapter\space\thechapter: #2}
   \fi
  }
  \def\@makechapterhead#1{
    \begingroup
      \OU@tagheading{H1}%
      \centering \uppercase\expandafter{#1} \par \nobreak
    \endgroup
    \@afterheading
 }
  \renewcommand\section{\@startsection {section}{1}{\z@}%
    {1sp}{1sp}{\normalfont\normalsize\centering}}
  \renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
     {1sp}{1sp}{\normalfont\normalsize\itshape\centering}}
  \renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
     {1sp}{1sp}{\normalfont\normalsize\itshape}}
  \renewcommand\paragraph{\@startsection{paragraph}{4}{\parindent}%
     {1sp}{1sp}{\normalfont\normalsize\itshape}}
  \renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
     {1sp}{-1em}{\normalfont\normalsize\itshape}}

  \newlength    \@figurelabel
  \settowidth   \@figurelabel{Figure:\nobreakspace}
  \addtolength  \@figurelabel{1.5em}
  \renewcommand*\l@figure{\@dottedtocline{1}{0em}{\@figurelabel}}

  \newlength    \@tablelabel
  \settowidth   \@tablelabel{Table:\nobreakspace}
  \addtolength  \@tablelabel{1.5em}
  \renewcommand*\l@table{\@dottedtocline{1}{0em}{\@tablelabel}}

  \renewcommand \theequation {\@arabic\c@equation}
  \renewcommand \thefigure   {\@arabic\c@figure}
  \renewcommand \thetable    {\@arabic\c@table}

  \newcommand\@numberlinefigure[1]{\hb@xt@\@tempdima{Figure #1\hfil}}
  \newcommand\@numberlinetable [1]{\hb@xt@\@tempdima{Table #1\hfil}}

  \renewcommand* \l@section       {\@dottedtocline{1} {1.5em} {0em}}
  \renewcommand* \l@subsection    {\@dottedtocline{2} {3em}   {0em}}
  \renewcommand* \l@subsubsection {\@dottedtocline{3} {4.5em} {0em}}
  \renewcommand* \l@paragraph     {\@dottedtocline{4} {6em}   {0em}}
  \renewcommand* \l@subparagraph  {\@dottedtocline{5} {7.5em} {0em}}

\fi

\setcounter{tocdepth}{3}

\def\fps@figure{tbh}
\def\fnum@figure{Figure\nobreakspace\thefigure}
\renewenvironment{figure}
               {\@float{figure}}
               {\end@float}

\def\fps@table{tbh}
\def\fnum@table{Table\nobreakspace\thetable}
\renewenvironment{table}
               { \if@sstables \singlespace \fi
                 \@float{table}
               }
               { \vspace{-\@lineskip}
                 \end@float
               }
\renewenvironment{table*}
               {\if@sstables \singlespace \fi
                \@dblfloat{table}}
               {\end@dblfloat}

\setlength\floatsep      {2\@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\textfloatsep  {1\@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\intextsep     {1\@doubleskip \@plus 1\p@ \@minus 1\p@}
\setlength\@fptop        {0\p@} % align float pages with the top of the page
\addtolength\textfloatsep\@lineskip

\setlength\abovecaptionskip{1ex}
\setlength\belowcaptionskip{1ex}
\long\def\@makecaption#1#2{%
  \expandafter\ifx#1\fnum@table 
  \else 
    \vskip \abovecaptionskip 
  \fi
  % measure only (tagging suspended, so the text is tagged exactly once)
  \sbox\@tempboxa{\SuspendTagging{caption}#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    \begingroup
      \singlespace #1: #2\par
    \endgroup
  \else
    \global \@minipagefalse
    \begingroup
      \singlespace \hb@xt@\hsize{\hfil #1: #2\hfil}%
    \endgroup
  \fi
  \expandafter\ifx#1\fnum@table 
    \vskip \belowcaptionskip
  \fi
}

\newcommand\l@chapter[2]{%
  \addpenalty{-\@highpenalty}%
  \setlength\@tempdima{1.5em}
  \begingroup
    \leavevmode
    \@dottedtocline{0}{0em}{1.5em}{#1}{#2}\par
    \nobreak
  \endgroup
}

\renewcommand\@makefntext[1]{%
  \noindent
  \hb@xt@2em{\hss\@makefnmark}
  \singlespace\footnotesize #1
}

\pagestyle{headings}
\raggedright
\setlength\parindent{2em} % must follow the \raggedright or will be reset to 0
\pretolerance=2000  
\clubpenalty =10000  
\widowpenalty=10000 
