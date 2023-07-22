# Return if we're running on osx
osx() {
  [ "$(uname)" = "Darwin" ]
}

# Return if we're running on osx
linux() {
  [ "$(uname)" = "Linux" ]
}
