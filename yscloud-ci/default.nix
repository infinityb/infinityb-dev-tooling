{ pulls }:

let
  pkgs = import <nixpkgs>{};
in with import ../lib.nix;
with pkgs.lib;
let
  defaults = {
    enabled = 1;
    hidden = false;
    keepnr = 10;
    schedulingshares = 100;
    checkinterval = 600;
    enableemail = false;
    emailoverride = "";
    nixexprinput = "yscloud";
    nixexprpath = "ci.nix";
  };
  primary_jobsets = {
    yscloud-unstable = defaults // {
      description = "yscloud";
      inputs = {
        yscloud = mkFetchGithub "https://github.com/infinityb/yscloud master";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable-small";
      };
    };
  };
  pr_data = builtins.fromJSON (builtins.readFile pulls);
  makePr = num: info: {
    name = "yscloud-${num}";
    value = defaults // {
      description = "PR ${num}: ${info.title}";
      inputs = {
        yscloud = mkFetchGithub "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git ${info.head.ref}";
        nixpkgs = mkFetchGithub "https://github.com/nixos/nixpkgs-channels.git nixos-unstable";
      };
    };
  };
  pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
  jobsetsAttrs = pull_requests // primary_jobsets;
in {
  jobsets = makeSpec jobsetsAttrs;
}
