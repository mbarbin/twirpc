(lang dune 3.17)

(name twirpc)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/twirpc))

(documentation "https://mbarbin.github.io/twirpc/")

(implicit_transitive_deps false)

(package
 (name twirpc)
 (synopsis
  "Opinionated wrappers to build RPC clients and servers with ocaml-twirp")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (base_quickcheck
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-to-cmdliner
   (>= 0.0.9))
  (cmdliner
   (>= 1.3.0))
  (expect_test_helpers_core
   (>= v0.17))
  (ezcurl
   (>= 0.2.4))
  (fmt
   (>= 0.9.0))
  (fpath
   (>= 0.7.3))
  (fpath-sexp0
   (>= 0.2.2))
  (letfun
   (>= 0.0.1))
  (ocaml-protoc
   (>= 3.1))
  (parsexp
   (>= v0.17))
  (pbrt
   (>= 3.1))
  (pbrt_services
   (>= 3.1))
  (pbrt_yojson
   (>= 3.1))
  (pplumbing
   (>= 0.0.12))
  (ppx_compare
   (>= v0.17))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_enumerate
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppx_yojson_conv
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (sexplib0
   (>= v0.17))
  (shexp
   (>= v0.17))
  (stdio
   (>= v0.17))
  (tiny_httpd
   (>= 0.17))
  (twirp_core
   (>= 0.1))
  (twirp_ezcurl
   (>= 0.1))
  (twirp_tiny_httpd
   (>= 0.1))
  (yojson
   (>= 2.1.1))))

(package
 (name twirpc-tests)
 (synopsis "Tests for twirpc")
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (base_quickcheck
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-to-cmdliner
   (>= 0.0.9))
  (cmdliner
   (>= 1.3.0))
  (expect_test_helpers_core
   (>= v0.17))
  (ezcurl
   (>= 0.2.4))
  (fmt
   (>= 0.9.0))
  (fpath
   (>= 0.7.3))
  (fpath-sexp0
   (>= 0.2.2))
  (letfun
   (>= 0.0.1))
  (ocaml-protoc
   (>= 3.1))
  (parsexp
   (>= v0.17))
  (pbrt
   (>= 3.1))
  (pbrt_services
   (>= 3.1))
  (pbrt_yojson
   (>= 3.1))
  (pplumbing
   (>= 0.0.12))
  (ppx_compare
   (>= v0.17))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppx_yojson_conv
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (sexplib0
   (>= v0.17))
  (shexp
   (>= v0.17))
  (stdio
   (>= v0.17))
  (tiny_httpd
   (>= 0.17))
  (twirp_core
   (>= 0.1))
  (twirp_ezcurl
   (>= 0.1))
  (twirp_tiny_httpd
   (>= 0.1))
  (twirpc
   (= :version))
  (yojson
   (>= 2.1.1))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))

(package
 (name twirpc-dev)
 (synopsis
  "Package to regroup dev targets for the project, documentation, and more")
 (allow_empty) ; In case the package is wip or attached to stanzas that dune doesn't see.
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (cmdlang
   (>= 0.0.9))
  (expect_test_helpers_core
   (>= v0.17))
  (ocaml-protoc
   (>= 3.1))
  (pplumbing
   (>= 0.0.12))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (stdio
   (>= v0.17))
  (twirpc
   (= :version))
  (twirpc-tests
   (= :version))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
