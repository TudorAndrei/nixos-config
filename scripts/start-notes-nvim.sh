#!/usr/bin/env bash

alacritty --title notes-nvim -e sh -c 'cd /home/tudor/cave/littlebrain && nvim' &
sleep 0.5
hyprctl dispatch movetoworkspacesilent special:notes

