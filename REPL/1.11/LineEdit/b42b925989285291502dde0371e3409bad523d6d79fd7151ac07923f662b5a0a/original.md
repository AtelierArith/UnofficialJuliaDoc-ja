```julia
receive_da1!(props::TerminalProperties, io::IO)
```

Read and parse a DA1 (Device Attributes) response from `io` (after `\e[?` has been consumed by the keymap). Reads until `c` (DA1 terminator) or `^C` (bail-out), parses the semicolon-separated parameters as integers, and stores them in `props.da1`.
