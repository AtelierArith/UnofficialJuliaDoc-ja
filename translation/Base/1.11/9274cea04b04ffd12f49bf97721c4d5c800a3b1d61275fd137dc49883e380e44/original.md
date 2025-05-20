```
AnnotatedString{S <: AbstractString} <: AbstractString
```

A string with metadata, in the form of annotated regions.

More specifically, this is a simple wrapper around any other [`AbstractString`](@ref) that allows for regions of the wrapped string to be annotated with labeled values.

```text
                           C
                    ┌──────┸─────────┐
  "this is an example annotated string"
  └──┰────────┼─────┘         │
     A        └─────┰─────────┘
                    B
```

The above diagram represents a `AnnotatedString` where three ranges have been annotated (labeled `A`, `B`, and `C`). Each annotation holds a label (`Symbol`) and a value (`Any`). These three pieces of information are held as a `@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}`.

Labels do not need to be unique, the same region can hold multiple annotations with the same label.

Code written for `AnnotatedString`s in general should conserve the following properties:

  * Which characters an annotation is applied to
  * The order in which annotations are applied to each character

Additional semantics may be introduced by specific uses of `AnnotatedString`s.

A corollary of these rules is that adjacent, consecutively placed, annotations with identical labels and values are equivalent to a single annotation spanning the combined range.

See also [`AnnotatedChar`](@ref), [`annotatedstring`](@ref), [`annotations`](@ref), and [`annotate!`](@ref).

# Constructors

```julia
AnnotatedString(s::S<:AbstractString) -> AnnotatedString{S}
AnnotatedString(s::S<:AbstractString, annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}})
```

A AnnotatedString can also be created with [`annotatedstring`](@ref), which acts much like [`string`](@ref) but preserves any annotations present in the arguments.

# Examples

```julia-repl
julia> AnnotatedString("this is an example annotated string",
                    [(1:18, :A => 1), (12:28, :B => 2), (18:35, :C => 3)])
"this is an example annotated string"
```
