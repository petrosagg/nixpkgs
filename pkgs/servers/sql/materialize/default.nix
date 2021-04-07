{ stdenv
, lib
, fetchFromGitHub
, fetchzip
, rustPlatform
, buildPackages
, darwin
, cmake
, libiconv
, openssl
, perl
, pkg-config}:

let
  fetchNpmPackage = {name, version, sha256, js_prod_file, js_dev_file, ...} @ args:
  let
    package = fetchzip {
      url = "https://registry.npmjs.org/${name}/-/${baseNameOf name}-${version}.tgz";
      inherit sha256;
    };

    static = "./src/materialized/src/http/static";
    cssVendor = "./src/materialized/src/http/static/css/vendor";
    jsProdVendor = "./src/materialized/src/http/static/js/vendor";
    jsDevVendor = "./src/materialized/src/http/static-dev/js/vendor";

    files = with args; [
      { src = js_prod_file; dst = "${jsProdVendor}/${name}.js"; }
      { src = js_dev_file;  dst = "${jsDevVendor}/${name}.js"; }
    ] ++ lib.optional (args ? css_file) { src = css_file; dst = "${cssVendor}/${name}.css"; }
      ++ lib.optional (args ? extra_file) { src = extra_file.src; dst = "${static}/${extra_file.dst}"; };
  in
    lib.concatStringsSep "\n" (lib.forEach files ({src, dst}: ''
      mkdir -p "${dirOf dst}"
      cp "${package}/${src}" "${dst}"
    ''));

  npmPackages = import ./npm_deps.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "materialize";
  version = "0.7.1";
  rev = "f4bd159fa73d37d44f8ed3f1db13c0c2ff85566f";

  src = fetchFromGitHub {
    owner = "MaterializeInc";
    repo = pname;
    inherit rev;
    sha256 = "01fhqjzzz9p0gpdbvkfz0p6422akyx5qfqgj3a78mgwiy83jfypj";
  };

  cargoSha256 = "0gfpv3rqmr18lbja1hl1iipn20fnnxslcwr3l2yb2k06sp19pcz9";

  nativeBuildInputs = [ cmake perl pkg-config ]
    # Provides the mig command used by the krb5-src build script
    ++ lib.optional stdenv.isDarwin buildPackages.darwin.bootstrap_cmds;

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.DiskArbitration
    ];

  # Skip tests that use the network
  checkFlagsArray = [
    "--exact"
    "--skip test_client"
    "--skip test_client_errors"
    "--skip test_no_block"
  ];

  postPatch = ''
    ${lib.concatStringsSep "\n" (map fetchNpmPackage npmPackages)}
    substituteInPlace ./misc/dist/materialized.service --replace /usr/bin $out/bin
    substituteInPlace ./misc/dist/materialized.service --replace _Materialize root
  '';

  MZ_DEV_BUILD_SHA = rev;
  cargoBuildFlags = [ "--package materialized" ];

  postInstall = ''
    install --mode=444 -D ./misc/dist/materialized.service $out/etc/systemd/system/materialized.service
  '';

  meta = with lib; {
    homepage    = "https://materialize.com";
    description = "A streaming SQL materialized view engine for real-time applications";
    license     = licenses.bsl11;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.petrosagg ];
  };
}
