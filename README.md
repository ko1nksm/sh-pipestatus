# sh-pipestatus: Portable pipestatus and pipefail

To our delight, `pipefail` has been standardized in POSIX and implemented in all POSIX shells. However, `PIPESTATUS` (`pipestatus` for zsh) is only available in bash and zsh. This project will make `PIPESTATUS` available to all POSIX shells.

- Supports `pipefail` behavior
- Support for `errexit` shell option
- No global variables except `PIPESTS`
- All POSIX shells supported
  - sh, bash, ksh, zsh, etc.
- Shortest code possible
- Extra: Function to ignore `SIGPIPE` (`igpipe`)

Note: The Bourne shell is not supported because it is legacy, not POSIX compliant, and no longer used.

This replaces the old FAQ (How do I get the exit code of cmd1 in cmd1|cmd2) on comp.unix.shell.

- https://cfajohnson.com/shell/cus-faq-2.html
- https://www.unix.com/302268337-post4.html

## Usage

Use it as:

```sh
# From
cmd1 | cmd2 | cmd3

# To
pipe 'cmd1 | cmd2 | cmd3' "$@"

# or
pipe -fail 'cmd1 | cmd2 | cmd3' "$@"

# exit codes are in
echo "$? and $PIPESTS" # => 0 and 0 0 0
```

Note: sh-pipestatus separates each command in the pipeline with `<whitespace>|<whitespace>` (whitespace: space, tab, newline). Therefore, if part of a command contains this delimiter, it will be misinterpreted. To avoid this, use the following instead or shell functions.

```sh
# From
pipe 'echo "foo | bar" | tr a-z A-Z'

# To
pipe 'echo "foo ""| bar" | tr a-z A-Z'
```

```sh
# From
pipe 'echo "foo" | case $1 in x | y) cat ;; esac | tr a-z A-Z' x

# To
pipe 'echo "foo" | case $1 in x|y) cat ;; esac | tr a-z A-Z' x
```

```sh
# From
pipe 'echo $((1 | 2)) | tr 3 C'

# To
pipe 'echo $((1|2)) | tr 3 C'
```

## Function to ignore SIGPIPE

When you enable `pipefail`, you will probably be plagued by `SIGPIPE`. The `igpipe` function is for ignoring `SIGPIPE`.

```sh
set -o pipefail
seq 100000 | cat | head >/dev/null
echo $? # => 141

igpipe seq 100000 | igpipe cat | head >/dev/null
echo $? # => 0
```
