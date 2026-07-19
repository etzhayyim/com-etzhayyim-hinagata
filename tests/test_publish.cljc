(ns hinagata.tests.test-publish
  (:require [clojure.test :refer [deftest is]]
            [hinagata.methods.publish :as publish]
            #?(:clj [cheshire.core :as json])))

(deftest manifest-is-portable-pure-data
  (is (= 1 (get (publish/manifest [{"id" "tmpl.one"}]) "templateCount"))))

#?(:clj
   (deftest publisher-uses-static-json-and-loader-dependencies
     (let [dir (.toFile (java.nio.file.Files/createTempDirectory
                         "hinagata-publish"
                         (make-array java.nio.file.attribute.FileAttribute 0)))
           result (publish/publish {} [] dir)
           manifest-file (clojure.java.io/file dir "publish-manifest.json")]
       (is (= 0 (get result "templateCount")))
       (is (= 0 (get (json/parse-string (slurp manifest-file)) "templateCount")))
       (is (.exists (clojure.java.io/file dir "PUBLISH.md"))))))
