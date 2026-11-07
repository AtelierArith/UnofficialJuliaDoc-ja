```julia
State
```

A struct representing of the parser state (if you squint, a state monad even).

To create the initial state, use the constructor:     State(content::AbstractString, mod::Union{Module, Nothing}=nothing) -> State

Its fields are as follows:

  * `content::String`, the (unescaped) input string
  * `bytes::Vector{UInt8}`, the codeunits of `content`. This is a `Vector{UInt8}` instead of a `CodeUnits{UInt8}` because we need to be able to modify the array, for instance when erasing escape characters.
  * `s::Iterators.Stateful`, an `(index, char)` iterator of `content`
  * `mod::Union{Module, Nothing}`, the (optional) context with which to evaluate inline expressions in. This should be provided iff the styled markup comes from a macro invocation.
  * `parts::Vector{Any}`, the result of the parsing, a list of elements that when passed to `annotatedstring` produce the styled markup string. The types of its values are highly diverse, hence the `Any` element type.
  * `active_styles::Vector{Vector{Tuple{Int, Int, Union{Symbol, Expr, Tuple{Symbol, Any}}}}}}`, A list of batches of styles that have yet to be applied to any content. Entries of a batch consist of `(source_position, start_position, style)` tuples, where `style` may be just a symbol (referring to a face), a `Tuple{Symbol, Any}` annotation, or an `Expr` that evaluates to a valid annotation (when `mod` is set).
  * `pending_styles::Vector{Tuple{UnitRange{Int}, Union{Symbol, Expr, Tuple{Symbol, Any}}}}`, A list of styles that have been terminated, and so are known to occur over a certain range, but have yet to be applied.
  * `offset::Int`, a record of the between the `content` index and the index in the resulting styled string, as markup structures are absorbed.
  * `point::Int`, the current index in `content`.
  * `escape::Bool`, whether the last character seen was an escape character.
  * `interpolations::Int`, how many interpolated values have been seen. Knowing whether or not anything needs to be evaluated allows the resulting string to be computed at macroexpansion time, when possible, and knowing how many allows for some micro-optimisations.
  * `errors::Vector`, any errors raised during parsing. We collect them instead of immediately throwing so that we can list as many issues as possible at once, instead of forcing the author of the invalid styled markup to resolve each issue one at a time. This is expected to be populated by invocations of `styerr!`.
