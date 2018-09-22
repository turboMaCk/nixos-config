# In ideal world every project would have it's own nix defintion
# this is hard to enforce so let's provide sane globals
# So work can be done

{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs.elmPackages; [
        elm
        elm-format
    ];
}
