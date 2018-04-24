{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, attoparsec, base, base16-bytestring
      , bytestring, bytestring-builder, case-insensitive, containers
      , cryptohash, filepath, hashable, HUnit, Only, postgresql-libpq
      , scientific, semigroups, stdenv, tasty, tasty-golden, tasty-hunit
      , template-haskell, text, time, transformers, uuid-types, vector
      }:
      mkDerivation {
        pname = "postgresql-simple";
        version = "0.5.3.0";
        src = ./.;
        libraryHaskellDepends = [
          aeson attoparsec base bytestring bytestring-builder
          case-insensitive containers hashable Only postgresql-libpq
          scientific semigroups template-haskell text time transformers
          uuid-types vector
        ];
        testHaskellDepends = [
          aeson base base16-bytestring bytestring containers cryptohash
          filepath HUnit tasty tasty-golden tasty-hunit text time vector
        ];
        description = "Mid-Level PostgreSQL client library";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
