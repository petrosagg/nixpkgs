# materialized doesn't use npm to pull in its few node dependencies but instead
# manually pulls the tar archives for each package and pulls out a couple of
# files.
#
# The list of modules can be found in this file
# https://github.com/MaterializeInc/materialize/blob/master/src/materialized/build/npm.rs
[
  {
    name = "@hpcc-js/wasm";
    version = "0.3.14";
    sha256 = "0gj5l35cn2xli5r7r4rbznn0fl59czadnikar6ymkdka9wbfxihj";
    js_prod_file = "dist/index.min.js";
    js_dev_file = "dist/index.js";
    extra_file = {
      src = "dist/graphvizlib.wasm";
      dst = "js/vendor/@hpcc-js/graphvizlib.wasm";
    };
  }
  {
    name = "babel-standalone";
    version = "6.26.0";
    sha256 = "0ghg6spvk7j03fggdw50r87r3gwc6hzx2zbqmspka4wfhs7r7myd";
    js_prod_file = "babel.min.js";
    js_dev_file = "babel.js";
  }
  {
    name = "d3";
    version = "5.16.0";
    sha256 = "1bncr7k89p5xy2qb8zf6wc0zyyrz5mbv44771gyrymvifa312139";
    js_prod_file = "dist/d3.min.js";
    js_dev_file = "dist/d3.js";
  }
  {
    name = "d3-flame-graph";
    version = "3.1.1";
    sha256 = "12fsb6hx553j07jnvmcxxvxh3cky7dfah8vzzb0fzszb0alcrk9f";
    css_file = "dist/d3-flamegraph.css";
    js_prod_file = "dist/d3-flamegraph.min.js";
    js_dev_file = "dist/d3-flamegraph.js";
  }
  {
    name = "pako";
    version = "1.0.11";
    sha256 = "1c2wa72s6iqnjjw94yf0w5yfwr620x0kw9m3y8jr950qjwmfgpja";
    js_prod_file = "dist/pako.min.js";
    js_dev_file = "dist/pako.js";
  }
  {
    name = "react";
    version = "16.14.0";
    sha256 = "0kr5xvzhb18lzr9hdl1z28w6c2i5j7qgrmk684mc42zghmrh3zsz";
    js_prod_file = "umd/react.production.min.js";
    js_dev_file = "umd/react.development.js";
  }
  {
    name = "react-dom";
    version = "16.14.0";
    sha256 = "0p8vw539qpaqvz615qgw6m7lw542zarfb0d0nfqba5h1vksjcrns";
    js_prod_file = "umd/react-dom.production.min.js";
    js_dev_file = "umd/react-dom.development.js";
  }
]
