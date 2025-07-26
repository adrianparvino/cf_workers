(lang dune 3.13)

(using melange 0.1)

(name cf_workers)

(generate_opam_files true)

(source
 (github adrianparvino/cf_workers))

(authors "Adrian Parvin Ouano")

(maintainers "Adrian Parvin Ouano")

(license "LGPL-3.0-only")

(documentation https://url/to/documentation)

(package
 (allow_empty)
 (name cf_workers)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  ocaml
  (melange
   (>= 3.0.0))
  (dune
   (>= 3.13))
  odoc
  melange-webapi)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
