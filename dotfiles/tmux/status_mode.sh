#!/usr/bin/env bash
mode=$(tmux show-environment STATUS_MODE 2>/dev/null | cut -d= -f2)
case "$mode" in
  todo) bash /home/dontwait/Documents/git/nix-conf/dotfiles/tmux/random_note.sh ;;
  pomo) bash /home/dontwait/Documents/git/nix-conf/dotfiles/tmux/pomodoro.sh 2>/dev/null ;;
  *)    echo "$USER👀" ;;
esac
