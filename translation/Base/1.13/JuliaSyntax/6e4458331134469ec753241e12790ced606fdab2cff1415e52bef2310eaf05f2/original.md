```julia
tokenize(text; operators_as_identifiers=true)
```

Returns the tokenized UTF-8 encoded `text` as a vector of `Token`s. The text for the token can be retrieved by using `untokenize()`. The full text can be reconstructed with, for example, `join(untokenize.(tokenize(text), text))`.

This interface works on UTF-8 encoded string or buffer data only.

The keyword `operators_as_identifiers` specifies whether operators in identifier-position should have `K"Identifier"` as their kind, or be emitted as more specific operator kinds. For example, whether the `+` in `a + b` should be emitted as `K"Identifier"` (the default) or as `K"+"`.
