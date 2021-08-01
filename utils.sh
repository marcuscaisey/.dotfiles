# Return if we're running on osx
osx() {
  [ $(uname) = "Darwin" ]
}

# Return if we're running on osx
linux() {
  [ $(uname) = "Linux" ]
}

# echo wrapper which cycles between output colours on subsequent calls
cecho() {
  echo "$(tput setaf ${ci:-1})$1$(tput sgr0)" && ci=$(( (${ci:-1} % 6) + 1 ))
}
