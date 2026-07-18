#!/usr/bin/env bash
# hinagata — standalone Clojure test suite.
set -euo pipefail
cd "$(dirname "$0")"
if [[ -e hinagata || -L hinagata ]]; then
  echo "refusing to replace existing ./hinagata" >&2
  exit 2
fi
ln -s "$PWD" hinagata
trap 'unlink hinagata' EXIT
clojure -Sdeps "{:paths [\"$PWD\" \"$PWD/src\" \"$PWD/test\"]}" -M -e '
(require (quote clojure.test)
         (quote hinagata.murakumo-test)
         (quote hinagata.methods.test-datom-emit)
         (quote hinagata.methods.test-statute-reach)
         (quote hinagata.tests.test-analyze)
         (quote hinagata.tests.test-cid)
         (quote hinagata.tests.test-coverage)
         (quote hinagata.tests.test-esign)
         (quote hinagata.tests.test-kotoba)
         (quote hinagata.tests.test-maturity)
         (quote hinagata.tests.test-query)
         (quote hinagata.tests.test-validate)
         (quote hinagata.tests.test-wasm))
(let [namespaces (quote [hinagata.murakumo-test
                         hinagata.methods.test-datom-emit
                         hinagata.methods.test-statute-reach
                         hinagata.tests.test-analyze
                         hinagata.tests.test-cid
                         hinagata.tests.test-coverage
                         hinagata.tests.test-esign
                         hinagata.tests.test-kotoba
                         hinagata.tests.test-maturity
                         hinagata.tests.test-query
                         hinagata.tests.test-validate
                         hinagata.tests.test-wasm])
      result (apply clojure.test/run-tests namespaces)]
  (System/exit (if (zero? (+ (:fail result) (:error result))) 0 1)))'
