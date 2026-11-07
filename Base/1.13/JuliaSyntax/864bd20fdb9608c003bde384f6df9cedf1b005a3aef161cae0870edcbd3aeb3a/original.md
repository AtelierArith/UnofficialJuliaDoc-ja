```julia
bump_split(stream, token_spec1, [token_spec2 ...])
```

Bump the next token, splitting it into several pieces

Tokens are defined by a number of `token_spec` of shape `(nbyte, kind, flags)`. If all `nbyte` are positive, the sum must equal the token length. If one `nbyte` is negative, that token is given `tok_len + nbyte` bytes and the sum of all `nbyte` must equal zero.

This is a hack which helps resolves the occasional lexing ambiguity. For example

  * Whether .+ should be a single token or the composite (. +) which is used for standalone operators.
  * Whether ... is splatting (most of the time) or three . tokens in import paths

TODO: Are these the only cases?  Can we replace this general utility with a simpler one which only splits preceding dots?
