(lang dune 3.13)

(using melange 0.1)

(name cf_workers)

(generate_opam_files true)

(source
 (github adrianparvino/cf_workers))

(authors "Adrian Parvin Ouano")

(maintainers "Adrian Parvin Ouano")

(license "LGPL-3.0-only")

(documentation https://github.com/adrianparvino/cf_workers)

(package
 (name cf_workers)
 (synopsis "Melange bindings for Cloudflare Workers")
 (description "Melange bindings for Cloudflare Workers")
 (depends
  ocaml
  (melange
   (>= 5.0.1))
  odoc))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
