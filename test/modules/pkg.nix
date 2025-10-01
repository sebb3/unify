{inputs,...}: {
    imports = [inputs.flake-parts.flakeModules.easyOverlay];
    perSystem = {pkgs, ...}:
    let myPkg = pkgs.runCommand "nada" '' echo "hej" '';
    in
    {
        overlayAttrs = { inherit myPkg; };
    };
}
