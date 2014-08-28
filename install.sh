#!/bin/bash

bin="$HOME/bin"
dotfiles="$HOME/dotfiles"
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

for location in $(find home -name '.*'); do
  file="${location##*/}"
  file="${file%.sh}"
  link "$dotfiles/$location" "$HOME/$file"
done

if [ ! -d "$bin" ]; then
  echo "Creating directory $bin"
  mkdir -p "$bin"
fi

if [ -d "$sublime" ]; then
  link "$dotfiles/sublime-text/User" "$sublime/Packages/User"
  ln -s "$sublime_bin" "$HOME/bin/subl"
else
  echo "Sublime Text 3 is not installed"
fi
