# dotfiles

## Packages needed for dotfiles

### Manjaro

```
pacman -Sy tmux neovim
```

### Set chromium as default browser

```
sed -i 's|userapp-Pale Moon.desktop|chromium.desktop|g' ~/.config/mimeapps.list
```

### Set alacritty as terminal in i3 config

```
sed -i 's|bindsym $mod+Return exec terminal|bindsym $mod+Return exec alacritty|g' ~/.i3/config
```
