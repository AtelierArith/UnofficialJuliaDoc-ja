```julia
AnnotatedChar{S <: AbstractChar} <: AbstractChar
```

注釈付きの Char です。

より具体的には、任意のラベル付き注釈（`@NamedTuple{label::Symbol, value}`）のリストを、ラップされた文字とともに保持する、他の任意の [`AbstractChar`](@ref) を包むシンプルなラッパーです。

関連項目：[`AnnotatedString`](@ref)、[`annotatedstring`](@ref)、`annotations`、`annotate!`。

# Constructors

```julia
AnnotatedChar(s::S) -> AnnotatedChar{S}
AnnotatedChar(s::S, annotations::Vector{@NamedTuple{label::Symbol, value}})
```

# Examples

```jldoctest; setup=:(using Base: AnnotatedChar)
julia> AnnotatedChar('j', [(:label, 1)])
'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)
```
