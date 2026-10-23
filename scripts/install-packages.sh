#!/bin/bash

set -e

PACKAGES=(
    # CLI Applications
    git           # Git version control
    xdg-user-dirs # for user
    vim           # Text editor
    btop          # System monitor
    cava          # visualizer
    fastfetch     # System information
    eza           # Better ls + tree
    kitty         # Terminal
    fish          # Shell
    awww          # wallpaper
    quickshell    # QT Quick shell 
    starship      # Shell decoration
    matugen       # color theme

    # GUI Applications
    nautilus           # File Manager
    eog		       # Image viewer 
    gnome-text-editor  # normal text editor
    decibels           # audio player

    # Settings
    qt5ct # qt5 settings
    qt6ct # qt6 settings

# --- No Need --- 
#    plasma-nm    # network settings
#    bluedevil	  # bluetooth settings
#    kvantum-qt5 # for qt5
#    kvantum    # for QT apps 


)

sudo pacman -S --needed "${PACKAGES[@]}"

echo "All packages installed successfully."
