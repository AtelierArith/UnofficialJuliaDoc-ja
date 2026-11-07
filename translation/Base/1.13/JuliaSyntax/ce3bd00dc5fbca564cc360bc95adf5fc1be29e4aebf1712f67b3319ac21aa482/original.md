```julia
parse!(TreeType, io::IO; rule=:all, version=VERSION)
```

Parse Julia source code from a seekable `IO` object. The output is a tuple `(tree, diagnostics)`. When `parse!` returns, the stream `io` is positioned directly after the last byte which was consumed during parsing.
