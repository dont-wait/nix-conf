{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    postgresql 
    mariadb 
    sqlcmd 
    mongodb-compass

  ];
}
