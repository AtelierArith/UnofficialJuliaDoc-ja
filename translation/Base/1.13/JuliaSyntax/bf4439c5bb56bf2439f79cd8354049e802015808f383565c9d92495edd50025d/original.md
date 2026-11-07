Return the string representation of a token kind, or `nothing` if the kind represents a class of tokens like K"Identifier".

When `unique=true` only return a string when the kind uniquely defines the corresponding input token, otherwise return `nothing`.  When `unique=false`, return the name of the kind.

TODO: Replace `untokenize()` with `Base.string()`?
