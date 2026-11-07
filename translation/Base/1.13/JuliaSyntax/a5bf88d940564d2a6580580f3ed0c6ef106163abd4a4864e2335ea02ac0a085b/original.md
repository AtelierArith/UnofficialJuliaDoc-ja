```julia
K"name"
Kind(namestr)
```

`Kind` is a type tag for specifying the type of tokens and interior nodes of a syntax tree. Abstractly, this tag is used to define our own *sum types* for syntax tree nodes. We do this explicitly outside the Julia type system because (a) Julia doesn't have sum types and (b) we want concrete data structures which are unityped from the Julia compiler's point of view, for efficiency.

Naming rules:

  * Kinds which correspond to exactly one textural form are represented with that text. This includes keywords like K"for" and operators like K"*".
  * Kinds which represent many textural forms have UpperCamelCase names. This includes kinds like K"Identifier" and K"Comment".
  * Kinds which exist merely as delimiters are all uppercase
