;; TeX-related configuration

; hook me up with auctex
;(require 'tex-site)
;(load "auctex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;(setq-default TeX-master nil)
;(add-hook 'LaTeX-mode-hook #'LaTeX-install-toolbar)

; Add custom beamer stuph
;(eval-after-load "tex"
; '(TeX-add-style-hook "beamer" 'my-beamer-mode))

;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;; 	    (let ((LaTeX-mode-map (make-sparse-keymap)))
;; 	      (define-key LaTeX-mode-map "\C-\M-x" 'tex-frame))))

;; (defun tex-frame ()
;;   "Run pdflatex on current frame.  
;; Frame must be declared as an environment."
;;   (interactive)
;;   (let ((beg)
;; 	(begin)
;; 	(end))
;;     (save-excursion
;;       (search-backward "\\begin{frame}")
;;       (setq begin (point))
;;       (forward-char 1)
;;       (LaTeX-find-matching-end)
;;       (setq end (point))
;;       (TeX-pin-region begin end)

;;       (TeX-region-create (TeX-region-file TeX-default-extension)
;; 			 (buffer-substring begin end)
;; 			 (file-name-nondirectory (TeX-region-file))
;; 			 (TeX-current-offset begin))
;;       (TeX-command "LaTeX" 'TeX-region-file))))

;; Would like to make it so that this is only defined when auctex is
;; loaded
(global-set-key (kbd "C-c C-$") 'TeX-dollar-sign-skeleton)

;; ;; Create a DVI file
;;(setq TeX-DVI-via-PDFTeX t)
;; Use PDF mode by default
(add-hook 'LaTeX-mode-hook (lambda () (setq TeX-PDF-mode t)))
;; Make emacs aware of multi-file projects
(add-hook 'LaTeX-mode-hook (lambda () (setq-default TeX-master nil)))

;; (defun guess-TeX-master (filename)
;;   "Guess the master file for FILENAME from currently open .tex files."
;;   (let ((candidate nil)
;; 	(filename (file-name-nondirectory filename)))
;;     (save-excursion
;;       (dolist (buffer (buffer-list))
;; 	(with-current-buffer buffer
;; 	  (let ((name (buffer-name))
;; 		(file buffer-file-name))
;; 	    (if (and file (string-match "\\.tex$" file))
;; 		(progn
;; 		  (goto-char (point-min))
;; 		  (if (re-search-forward (concat "\\\\input{" filename "}") nil t)
;; 		      (setq candidate file))
;; 		  (if (re-search-forward (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
;; 		      (setq candidate file))))))))
;;     (if candidate
;; 	(message "TeX master document: %s" (file-name-nondirectory candidate)))
;;     candidate))

;; (setq TeX-master (guess-TeX-master (buffer-file-name)))

;; ;; Jump to relevant page in PDF document (requires AUCTeX)
;; (require 'tex-site)
;; (add-hook 'TeX-mode-hook
;;     (lambda ()
;;         (add-to-list 'TeX-output-view-style
;;             '("^pdf$" "."
;;               "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
;; )

;; ;; Auto-raise Emacs on activation
;; (defun raise-emacs-on-aqua() 
;;     (shell-command "osascript -e 'tell application \"Aquamacs\" to activate' &"))
;; (add-hook 'server-switch-hook 'raise-emacs-on-aqua)

;; -----------------------------------------------------------------------------
;; LaTeX Skeletons
;;
;; These can be added to the menu bar as above file using
;; easy-menu-add-item.
;;
;; -----------------------------------------------------------------------------

(defun latex-letter-skeleton (receivers-address)
  "Inserts a LaTeX letter skeleton into current buffer.  This
  only makes sense for empty buffers."
  (interactive "MReceiver's Address? ")
  (skeleton-insert 
   '(nil                ;no prompt                   
     "\\documentclass[12pt]{letter}\n"
     "\\synctex=1\n"
     "\\usepackage[margin=1in]{geometry}\n"
     "% Some of the article customisations are relevant for this class\n"
     "\n"
     "\\name{Name} % return address on the envelope\n"
     "\\signature{Name} % Goes after the closing\n"
     "\\address{Address}\n"
     "\n"
     "%\\makelabels % this command prints envelope labels on the final\n"
     "            % page of the document\n"
     "\n"
     "\\begin{document}\n"
     "\\begin{letter}{"receivers-address"}\n"
     "\n"
     "\\opening{" _ "} % eg Hello.\n"
     "\n"
     "\n"
     "\n"
     "\\closing{} % eg Regards,\n"
     "\n"
     "%\\cc{} % people this letter is cc-ed to\n"
     "%\\encl{} % list of anything enclosed\n"
     "%\\ps{} % any post scriptums.\n"
     "\n"
     "\\end{letter}\n"
     "\\end{document}\n")))

(define-skeleton latex-brief-article-skeleton
  "Inserts a LaTeX skeleton for a brief article."
  "Title: "
  "%\\documentclass[12pt,doc]{apa}\n"
  "\\documentclass[12pt]{article}\n"
  "%\\usepackage{apacite} % \\cite<prefix>[suffix]{key1,key2}, \\citeA, \\citeNP,\n"
  "                     % \\fullcite, \\shortcite, \\citeyear, \\citeauthor, \\nocite\n"
  "\\synctex=1\n"
  "%\\usepackage[margin=1.0in]{geometry}\n"
  "%\\usepackage[left=1in,top=1in,right=1in,bottom=1in,nohead]{geometry}\n"
  "%\\geometry{letterpaper} \n"
  "%\\geometry{landscape} % Rotated page geometry\n"
;;  "%\\usepackage[parfill]{parskip} % Begin pars w/ empty line instead of indent\n"
  "%\\usepackage{color}\n"
  "\\usepackage{soul} % \\hl \\ul \\st \\caps \\so\n"
  "\\usepackage{graphicx}\n"
  "\\usepackage{amsmath}\n"
  "%\\usepackage{amssymb}\n"
  "%\\usepackage{epstopdf}\n"
  "\n"
  "\pdfinfo{\n"
  "   /Author (Name)\n"
  "   /Title ()\n"
  "   /Subject ()\n"
  "   /Keywords ()\n"
  "}\n"
  "\n"
;;  "%\\DeclareGraphicsRule{.tif}{png}{.png}{`convert #1 `dirname #1`/`basename #1 .tif`.png} % Convert tif to png (requires ImageMagick)\n"
;;  "\n"
  "\\title{"str | "Brief Article""}\n"
  "\\author{Name}\n"
  "\\date{}%\\today\n"
  "\n"
  "\\begin{document}\n"
  "\\maketitle\n"
  "%\\section{}\n"
  "%\\subsection{}\n"
  "\n"
  > _ "\n"
  "\n"
  "%\\bibliography{mvm}\n"
  "%\\bibliographystyle{apacite}\n"
  "\n"
  "\\end{document}\n")

(define-skeleton latex-apa-article-skeleton
  "Inserts a LaTeX skeleton for a brief article."
  "Title: "
  "%\\documentclass[jou]{apa}\n"
  "%\\documentclass[12pt,man]{apa}\n"
  "\\documentclass[12pt,doc]{apa}\n"
  "\\synctex=1\n"
  "%\\usepackage{apacite} % \\cite<prefix>[suffix]{key1,key2}, \\citeA, \\citeNP,\n"
  "                     % \\fullcite, \\shortcite, \\citeyear, \\citeauthor, \\nocite\n"
  "\\usepackage{graphicx}\n"
  "\\usepackage{amsmath}\n"
  "%\\usepackage{amssymb}\n"
  "\\usepackage{color}\n"
  "\\usepackage{soul} % \\hl \\ul \\st \\caps \\so\n"
  "%\\usepackage{url}\n"
  "%\\usepackage{epstopdf}\n"
  "\\usepackage[margin=1.0in]{geometry}\n"
  "%\\usepackage[left=1in,top=1in,right=1in,bottom=1in,nohead]{geometry}\n"
  "%\\usepackage{changebar} % \\cbstart \\cbend\n"
  "\n"
  "\pdfinfo{\n"
  "   /Author (Name)\n"
  "   /Title ()\n"
  "   /Subject ()\n"
  "   /Keywords ()\n"
  "}\n"
  "\n"
;;  "%\\usepackage[parfill]{parskip} % Begin pars w/ empty line instead of indent\n"
  "\n"
;;  "%\\DeclareGraphicsRule{.tif}{png}{.png}{`convert #1 `dirname #1`/`basename #1 .tif`.png} % Convert tif to png (requires ImageMagick)\n"
;;  "\n"
  "\\title{"str | "Article Title""}\n"
  "\n"
  "\\shorttitle{Short Title}\n"
  "\n"
  "\\rightheader{Short Title}\n"
  "\n"
  "\\leftheader{Last name}\n"
  "\n"
  "\\author{Name}\n"
  "\n"
  "\\affiliation{University}\n"
  "\n"
  "%\\affiliations{University}{University}\n"
  "\n"
  "\\abstract{%\n"
  "  % \\input{abstract}\n"
  "  Insert abstract here.\n"
  "\n"
  "  % \\vspace{0.1in}\n\n"
  "  \\textbf{Keywords:}\n"
  "\n"
  "}\n"
  "\n"
  "\\acknowledgements{The authors acknowledge support from National\n"
  "  Institutes of Health grant~MH. We are grateful to X and Y for\n"
  "  assistance with data collection. Address correspondence concerning\n"
  "  this article to Name, University\n"
  "\n"
  "\\ifapamodeman{%\n"
  "  \\note{\n"
  "    \\begin{flushleft}\n"
  "      Version of \\today.\\\\\n"
  "      Address correspondence to:\\\\\n"
  "      Name\\\\\n"
  "      University\\\\\n"
  "      email:\\\\\n"
  "      tel:\\\\\n"
  "    \\end{flushleft}\n"
  "  }}\n"
  "{ %else, i.e., in jou and doc mode\n"
  "  % \\note{Submitted: \\today}\n"
  "}\n"
  "\n"
  "\\journal{Manuscript in preparation.}\n"
  "\n"
  "\\volume{Please do not quote or cite without permission.}\n"
  "\n"
  "\\ccoppy{Version of \\today.}\n"
  "\n"
  "\\copnum{Comments welcome.}\n"
  "\n"
  "\\begin{document}\n"
  "\\maketitle\n\n"
  "\n"
  "% experiment numbers\n"
  "\\newcommand{\\expAbbrev}{1}\n"
  "\n"
  "% % Introduction\n"
  "% \\input{intro}\n"
  "\n"
  "% % Experiment 1\n"
  "% \\input{expAbbrev}\n"
  "\n"
  "% % General discussion\n"
  "% \\input{gen_discuss}\n"
  "\n"
  "\\section{Introduction}\n"
  "\n"
  > _ "\n"
  "\n"
  "%\\subsection{}\n"
  "\n\n\n"
  "\\section{Experiment}\n"
  "\\label{sec:}\n"
  "%Section~\\ref{sec:}\n"
  "\n\n\n"
  "\\subsection{Method}\n"
  "\n\n\n"
  "\\subsubsection{Participants}\n"
  "\n\n\n"
  "\\subsubsection{Materials}\n"
  "\n\n\n"
  "\\subsubsection{Design}\n"
  "\n\n\n"
  "\\subsubsection{Procedure}\n"
  "\n\n\n"
  "\\subsubsection{Electrophysiological recordings}\n"
  "\n\n\n"
  "\\subsubsection{Electrophysiological data processing}\n"
  "\n\n\n"
  "\\subsection{Results}\n"
  "\n\n\n"
  "\\subsubsection{Behavioral results}\n"
  "\n\n\n"
  "\\subsubsection{Electrophysiological results}\n"
  "\n\n\n"
  "\\subsection{Discussion}\n"
  "\n\n\n"
  "\\section{General Discussion}\n"
  "\n\n\n"
  "\\bibliography{mvm}\n"
  "%\\bibliographystyle{apacite}\n"
  "\n"
  "\\end{document}\n")

(define-skeleton latex-simple-text-skeleton
  "Inserts a simple LaTeX skeleton for a blank page."
  "Title: "
  "\\documentclass[12pt]{article}\n"
  "%\\synctex=1\n"
  "\\usepackage[margin=1.25in]{geometry}\n"
  "%\\usepackage[left=1in,top=1in,right=1in,bottom=1in,nohead]{geometry}\n"
  "\\usepackage{graphicx}\n"
  "\\usepackage{amsmath}\n"
  "\\usepackage{soul}\n"
  "\\usepackage{color}\n"
  "%\\setlength{\\parskip}{2.3ex} % vertical space between paragraphs\n"
  "%\\setlength{\\parindent}{0in} % amount of indentation of paragraph\n"
  "%\\usepackage{setspace} % spacing\n"
  "%\\doublespacing\n"
  "%\\usepackage[colorlinks=true,linkcolor=blue,pdfstartview=FitV,citecolor=gray40,urlcolor=blue]{hyperref} % hyperlinks\n"
  "\n"
  "\\begin{document}\n"
  "%\\thispagestyle{empty}\n"
  "\n"
  "\\begin{flushleft}\n"
  "  %\\begin{singlespace}\n"
  "  Name\\\\\n"
  "  Class\\\\\n"
  "  Date\n"
  "  %\\end{singlespace}\n"
  "\\end{flushleft}\n"
  "\n"
  "\\begin{center}\n"
  "  {\\large "str | "Title""}\n"
  "\\end{center}\n"
  "\n"
  > _
  "\n\n"
  "%\\href{http://www.google.com}{hyperlink}\n"
  "\n"
  "\\end{document}\n")

(define-skeleton latex-beamer-skeleton
  "Inserts a LaTeX beamer presentation skeleton."
  "Title: "
  "\\documentclass{beamer}\n"
  "\\synctex=1\n"
  "\\usepackage{graphicx}\n"
  "\\usepackage{amsmath}\n"
  "\\usepackage{pgf,pgfarrows,pgfnodes,pgfautomata,pgfheaps,pgfshade}\n"
  "\\usepackage{tikz}\n"
  "\n"
  "\\usetheme{default}\n"
  "%\\usetheme{Madrid}\n"
  "%\\usetheme[secheader]{Madrid}\n"
  "\\usecolortheme{seahorse}\n"
  "\\usecolortheme{rose}\n"
  "\n"
  "\\useinnertheme{default}\n"
  "%\\useinnertheme{rectangles}\n"
  "%\\useoutertheme{default}\n"
  "\n"
  "% Suppress navigation symbols\n"
  "%\\setbeamertemplate{navigation symbols}{}\n"
  "\n"
  "% % TOC at beginning of each section\n"
  "% \\AtBeginSection[]\n"
  "% {\n"
  "%   \\begin{frame}<beamer>\n"
  "%     \\tableofcontents[currentsection]\n"
  "%   \\end{frame}\n"
  "% }\n"
  "\n"
  "% If you wish to uncover everything in a step-wise fashion, uncomment\n"
  "% the following command: \n"
  "%\\beamerdefaultoverlayspecification{<+->}\n"
  "\n"
  "%\\pgfdeclareimage[height=0.5cm]{cu-logo}{figs/CU_logo}\n"
  "%\\logo{\\pgfuseimage{cu-logo}}\n"
  "\n"
  "\\title{"str | "Title""}\n"
  "\\author{Name}\n"
  "\\institute[University]{Event}\n"
  "\\date{\\today}\n"
  "\n"
  "\\begin{document}\n"
  "\n"
  "\\begin{frame}\n"
  "  \\titlepage\n"
  "\\end{frame}\n"
  "\n"
  "\\begin{frame}\n"
  "  \\frametitle{Table of contents}\n"
  "  \\tableofcontents\n"
  "\\end{frame}\n"
  "\n"
  "\\section{"_"}\n"
  "\n"
  "\\begin{frame}\n"
  "  \\frametitle{Title}\n"
  "  Text\n"
  "\\end{frame}\n"
  "\n"
  "\\subsection{Subsection}\n"
  "\\begin{frame}\n"
  "  \\frametitle{title}\n"
  "  Text\n"
  "\\end{frame}\n"
  "\n"
  "\\section{Section 2}\n"
  "\\subsection{Lists}\n"
  "\n"
  "\\begin{frame}\n"
  "  \\frametitle{lists with pause}\n"
  "\n"
  "  \\begin{itemize}\n"
  "  \\item Thing 1 \\pause\n"
  "  \\item Thing 2\n"
  "  \\end{itemize}\n"
  "\\end{frame}\n"
  "\n"
  "\\section{Section 3}\n"
  "\\subsection{blocs}\n"
  "\n"
  "\\begin{frame}\n"
  "  \\frametitle{blocs}\n"
  "\n"
  "  \\begin{block}{title of the bloc}\n"
  "    bloc text\n"
  "  \\end{block}\n"
  "  \n"
  "  \\begin{exampleblock}{title of the bloc}\n"
  "    bloc text\n"
  "  \\end{exampleblock}\n"
  "  \n"
  "  \\begin{alertblock}{title of the bloc}\n"
  "    bloc text\n"
  "  \\end{alertblock}\n"
  "\\end{frame}\n"
  "\n"
  "\\section{Section 4}\n"
  "\\subsection{split screen}\n"
  "\n"
  "\\begin{frame}\n"
  "  \\frametitle{splitting screen}\n"
  "  \\begin{columns}\n"
  "    \\begin{column}{5cm}\n"
  "      \\begin{enumerate}\n"
  "      \\item Thing 1\n"
  "      \\item Thing 2\n"
  "      \\end{enumerate}\n"
  "    \\end{column}\n"
  "    \\begin{column}{5cm}\n"
  "      \\begin{tabular}{|c|c|}\n"
  "        \\hline\n"
  "        \\textbf{Column} & \\textbf{Column} \\\\\n"
  "        \\hline\n"
  "        Table & Blah \\\\\n"
  "        \\hline\n"
  "        Table & Blah \\\\\n"
  "        \\hline\n"
  "      \\end{tabular}\n"
  "    \\end{column}\n"
  "  \\end{columns}\n"
  "\\end{frame}\n"
  "\n"
  "\\end{document}\n")

(define-skeleton latex-figure-skeleton
  "Inserts a LaTeX figure skeleton."
  "File path/name: "
  "\\begin{figure}\n"
  "  \\centering\n"
  "  \\includegraphics[width=\\textwidth]{"str"}\n"
  "  \\caption{"_"}\n"
  "  \\label{fig:}\n"
  "  %\\ref{fig:}\n"
  "  %\\pageref{fig:}\n"
  "\\end{figure}\n")

(define-skeleton TeX-dollar-sign-skeleton
  "Make a pair of dollar signs and leave point inside"
  nil
  "$"_"$")

(define-skeleton latex-anova-summary-table-skeleton
  "Inserts a LaTeX ANOVA summary table skeleton."
  ""
  "\\begin{tabular}{lllllll}\n"
  "  ANOVA source table\\\\\n"
  "  \\hline\n"
  "  $Source$ & $SS$ & $df$ & $MS$ & $F^{*}$ & $PRE$ & $p$ \\\\\n"
  "  \\hline\n"
  "  Model (reduce) & SSR"_" & PA-PC & MSR = SSR/df & MSR/MSE & SSR/SSE(C) & $< $ \\\\\n"
  "  var &  &  &  &  &  & $< $ \\\\\n"
  "  Error & SSE(A) & n-PA & MSE = SSE(A)/df & - & - & - \\\\\n"
  "  Corrected Total & SSE(C) & n-PC & - & - & - & - \\\\\n"
  "\\end{tabular}\n")

(define-skeleton latex-stats-models-skeleton
  "Inserts a LaTeX Grad Stats HW model setup skeleton."
  ""
  "\\begin{itemize}\n"
  "\\item Theoretical\n"
  "  \\begin{itemize}\n"
  "  \\item Model A: $var_{i} = \\beta_{0} + \\beta_{1}(var) +\n"
  "    \\epsilon_{i}$\n"
  "  \\item Model C: $var_{i} = \\beta_{0} + \\epsilon_{i}$\n"
  "  \\end{itemize}\n"
  "  \n"
  "\\item Predictive\n"
  "  \\begin{itemize}\n"
  "  \\item Model A: $\\hat{var} =  + (Var)$\n"
  "  \\item Model C: $\\hat{var} = $\n"
  "  \\end{itemize}\n"
  "  \n"
  "\\item $H_{0}:$ $\\beta_{1} = 0$\n"
  "\\item $PA-PC = $\n"
  "\\item $n-PA = $\n"
  "\\item $PRE = $\n"
  "\\item $F^{*}_{,} = $\n"
  "\\item Slope: \n"
  "\\item Intercept: \n"
  "\\item Conclusion: [$F^{*}_{,} = $, $p < $ , $PRE = $].\n"
  "\\end{itemize}\n")

;; Set up skeletons (see below) in a menu in AUCTeX mode
(defvar LaTeX-mode-menu)
(add-hook 'LaTeX-mode-hook 
          (lambda () 
            (easy-menu-add-item LaTeX-mode-menu
                                nil ["Skeletons" nil t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["Letter" latex-letter-skeleton
                                t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["Brief Article"
                                latex-brief-article-skeleton t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["APA Article"
                                latex-apa-article-skeleton t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["Simple Text"
                                latex-simple-text-skeleton t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["Beamer Presentation"
                                latex-beamer-skeleton t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["Figure"
                                latex-figure-skeleton t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["ANOVA Summary Table"
                                latex-anova-summary-table-skeleton
                                t])
            (easy-menu-add-item LaTeX-mode-menu '("Skeletons")
                                ["Stats Models"
                                latex-stats-models-skeleton t])))
