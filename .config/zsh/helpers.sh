# implement the bash fg #
fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

osc() {
  code=$1
  text=$2
  echo -n "\x1b]$code;$text\x1b\\"
}
