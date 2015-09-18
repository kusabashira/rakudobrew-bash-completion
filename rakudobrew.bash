_rakudobrew_which() {
  local version="$(rakudobrew version)"
  local prefix="$(type -P rakudobrew)"
  prefix="${prefix%%/bin/*}"

  local paths=(
    "$prefix/$version/install/bin"
    "$prefix/$version/install/share/perl6/site/bin"
  )
  local bins=""
  for path in "${paths[@]}"; do
    if [ -d "$path" ]; then
      bins="$bins $(ls "$path")"
    fi
  done
  COMPREPLY=( $(compgen -W "$bins" -- "$cur") )
}

_rakudobrew_commands() {
  local commands="$(
    rakudobrew help |\
    awk '{
      for (i = 1; i <= NF; ++i)
        if ($i == "rakudobrew")
          print $(i+1);
    }'
  )"
  COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
}

_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local backends='
    jvm
    moar
    pre-glr
  '

  case "$COMP_CWORD" in
    1)
      _rakudobrew_commands
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
              COMPREPLY=( $(compgen -W "$backends all" -- "$cur") )
              ;;
          esac
          ;;
        switch)
          COMPREPLY=( $(compgen -W "$backends" -- "$cur") )
          ;;
        nuke)
          COMPREPLY=( $(compgen -W "$backends" -- "$cur") )
          ;;
        test)
          COMPREPLY=( $(compgen -W "$backends all" -- "$cur") )
          ;;
        local|global)
          versions="$(rakudobrew versions | cut -c3-)"
          COMPREPLY=( $(compgen -W "$versions" -- "$cur") )
          ;;
        which)
          _rakudobrew_which
          ;;
      esac
      ;;
  esac
}
complete -F _rakudobrew rakudobrew
