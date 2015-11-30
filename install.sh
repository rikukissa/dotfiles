#!/bin/bash

bin="$HOME/.bin"
dotfiles="$(pwd)"
sublime="$HOME/Library/Application Support/Sublime Text 3"
sublime_bin=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl

if [[ -d "$dotfiles" ]]; then
  echo "Symlinking dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

link() {
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  rm -rf "$to"
  ln -s "$from" "$to"
}

# Symlink config files from here to ~/
for location in $(find home -name '.*'); do
  file="${location##*/}"
  file="${file%.sh}"
  link "$dotfiles/$location" "$HOME/$file"
done

# Create .bin directory
if [ ! -d "$bin" ]; then
  echo "Creating directory $bin"
  mkdir -p "$bin"
fi
grep -q -F 'export PATH="$PATH:'"$bin"'"' ~/.zshrc || echo 'export PATH="$PATH:'"$bin"'"' >> ~/.zshrc

# Symlink subl binary under .bin directory

if [ -d "$sublime" ]; then

  if [ ! -f "$bin/subl" ]; then
    link "$dotfiles/sublime-text/User" "$sublime/Packages/User"
    ln -s "$sublime_bin" "$bin/subl"
  fi

else
  echo "Sublime Text 3 is not installed"
fi
