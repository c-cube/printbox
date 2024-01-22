(lang dune 3.0)
(name printbox)
(using mdx 0.2)
(generate_opam_files true)
(version 0.8)
(license "BSD-2-Clause")

(authors "Simon Cruanes" "Guillaume Bury")
(maintainers c-cube)
(source (github c-cube/printbox))

(package
  (name printbox)
  (synopsis "Allows to print nested boxes, lists, arrays, tables in several formats")
  (depends (ocaml (>= 4.08)) (odoc :with-doc))
  (tags ("print" "box" "table" "tree")))

(package
  (name printbox-text)
  (synopsis "Text renderer for printbox, using unicode edges")
  (depends (printbox (= :version))
           (uutf (>= 1.0))
           (uucp (>= 2.0))
           (odoc :with-test)
           (mdx (and (>= 1.4) :with-test))))

(package
  (name printbox-html)
(synopsis "Printbox unicode handling")
(description "
Adds html output handling to the printbox package.
Printbox allows to print nested boxes, lists, arrays, tables in several formats")
  (depends (printbox (= :version))
           (printbox-text (and (= :version) :with-test))
           (odoc :with-test)
           (tyxml (>= 4.3))
           (mdx (and (>= 1.4) :with-test))))

(package
  (name printbox-md)
(synopsis "Printbox Markdown rendering")
(description "
Adds Markdown output handling to the printbox package, with fallback to text and simplified HTML.
Printbox allows to print nested boxes, lists, arrays, tables in several formats")
  (depends (printbox (= :version))
           (printbox-text (and (= :version) :with-test))
           (printbox-html (and (= :version) :with-test))
           (odoc :with-test)
           (mdx (and (>= 1.4) :with-test))))
