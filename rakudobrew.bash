_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local commands='
    current
    list-available
    build
    build-panda
    triple
    rehash
    switch
    nuke
    self-upgrade
    test
    exec
    init
    shell
    local
    global
    version
    versions
    which
    whence
  '
  local backends='
    jvm
    glr
    moar
  '

  case "$COMP_CWORD" in
    1)
      COMPREPLY=( $( compgen -W "$commands" -- "$cur") )
      ;;
    *)
      case "${COMP_WORDS[1]}" in
        build)
          case "$cur" in
            -*)
              COMPREPLY=('--configure-opts=')
              compopt -o nospace
              ;;
            *)
              COMPREPLY=( $( compgen -W "$backends all" -- "$cur") )
              ;;
          esac
          ;;
        switch)
          COMPREPLY=( $( compgen -W "$backends" -- "$cur") )
          ;;
        nuke)
          COMPREPLY=( $( compgen -W "$backends" -- "$cur") )
          ;;
        test)
          COMPREPLY=( $( compgen -W "$backends all" -- "$cur") )
          ;;
      esac
      ;;
  esac
}
complete -F _rakudobrew rakudobrew
