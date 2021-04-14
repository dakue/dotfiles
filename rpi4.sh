#!/bin/bash

# get vc4 working
sudo pacman -U xf86-video-fbturbo-git xf86-video-fbturbo

# add vulkan driver
sudo pacman -Sy vulkan-broadcom vulkan-mesa-layers vulkan-tools

# add others
sudo pacman -Sy lxterminal
