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
   (and
    (>= v0.17)
    (< v0.18)))
  (base_quickcheck
   (and
    (>= v0.17)
    (< v0.18)))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-to-cmdliner
   (>= 0.0.9))
  (cmdliner
   (>= 1.3.0))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
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
   (and
    (>= v0.17)
    (< v0.18)))
  (pbrt
   (>= 3.1))
  (pbrt_services
   (>= 3.1))
  (pbrt_yojson
   (>= 3.1))
  (pplumbing
   (>= 0.0.9))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_yojson_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (sexplib0
   (and
    (>= v0.17)
    (< v0.18)))
  (shexp
   (and
    (>= v0.17)
    (< v0.18)))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))
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
   (and
    (>= v0.17)
    (< v0.18)))
  (base_quickcheck
   (and
    (>= v0.17)
    (< v0.18)))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-to-cmdliner
   (>= 0.0.9))
  (cmdliner
   (>= 1.3.0))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
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
   (and
    (>= v0.17)
    (< v0.18)))
  (pbrt
   (>= 3.1))
  (pbrt_services
   (>= 3.1))
  (pbrt_yojson
   (>= 3.1))
  (pplumbing
   (>= 0.0.9))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_yojson_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (sexplib0
   (and
    (>= v0.17)
    (< v0.18)))
  (shexp
   (and
    (>= v0.17)
    (< v0.18)))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))
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
   (and
    (>= v0.17)
    (< v0.18)))
  (cmdlang
   (>= 0.0.9))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
  (ocaml-protoc
   (>= 3.1))
  (pplumbing
   (>= 0.0.9))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))
  (twirpc
   (= :version))
  (twirpc-tests
   (= :version))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
