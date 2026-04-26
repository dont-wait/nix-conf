{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    postgresql # Cho Postgres (lệnh psql)
    mariadb # Cho MySQL (lệnh mysql)
    sqlcmd # Cho SQL Server (lệnh sqlcmd của Microsoft)

    # Cần thiết để icon không bị lỗi ô vuông
    # nerdfonts
  ];
}
