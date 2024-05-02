pipe() {
  [ "$1" = -fail ] || set -- '' "$@"
  eval "$(
    pipeline="$2 | " cmd='' i=0 xs='' sp=$(printf '\t\n ')
    shift 2 && [ "${-#*e}" = "$-" ] && flag="+e" || flag="-e"
    while [ "$pipeline" ] && i=$((i + 1)); do
      cmd2="set +e; (set $flag; ${pipeline%%[$sp]\|[$sp]*})"
      cmd="${cmd}${cmd:+|}{ $cmd2 3>&- 4>&-; echo xs$i=\$? >&3; }"
      pipeline=${pipeline#*[$sp]\|[$sp]} xs="${xs}${xs:+ }\$xs$i"
    done
    eval "$(eval "$cmd" 3>&1 >&4); echo \"PIPESTS='$xs'\""
  )"
  set -- "$PIPESTS" "$1"
  [ "$2" ] && until [ "${1% 0}" = "$1" ]; do set -- "${1% 0}"; done
  return "${1##* }"
} 4>&1
