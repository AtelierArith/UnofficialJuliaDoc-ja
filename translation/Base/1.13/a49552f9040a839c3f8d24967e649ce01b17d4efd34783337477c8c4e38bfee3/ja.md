```julia
AnnotatedString{S <: AbstractString} <: AbstractString
```

注釈付き領域を含む、メタデータ付きの文字列です。

より具体的には、これは任意の[`AbstractString`](@ref)を包むシンプルなラッパーで、ラップされた文字列の領域にラベル付きの値を注釈として付与できます。

```text
                           C
                    ┌──────┸─────────┐
  "this is an example annotated string"
  └──┰────────┼─────┘         │
     A        └─────┰─────────┘
                    B
```

上の図は、3つの範囲に注釈（`A`、`B`、`C`）が付与された`AnnotatedString`を示しています。各注釈は、ラベル（`Symbol`）と値（`Any`）を持ちます。この3つの情報は、`@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}`として保持されます。

ラベルは一意である必要はなく、同じ領域に同じラベルの注釈を複数付与できます。

`AnnotatedString`全般を対象とするコードでは、次の性質を維持する必要があります。

  * 注釈が適用される文字
  * 各文字に注釈が適用される順序

`AnnotatedString`の用途によっては、これらに加えて別の意味が導入されることがあります。

この規則から、同じラベルと値を持つ注釈が隣接して連続している場合、それらは範囲を結合した単一の注釈と等価になります。

[`AnnotatedChar`](@ref)、[`annotatedstring`](@ref)、[`annotations`](@ref)、[`annotate!`](@ref)も参照してください。

# Constructors

```julia
AnnotatedString(s::S<:AbstractString) -> AnnotatedString{S}
AnnotatedString(s::S<:AbstractString, annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}})
```

AnnotatedStringは[`annotatedstring`](@ref)を使って作成することもできます。これは[`string`](@ref)とよく似ていますが、引数に含まれる注釈を保持します。

# Examples

```jldoctest; setup=:(using Base: AnnotatedString)
julia> AnnotatedString("this is an example annotated string",
                    [(1:18, :A, 1), (12:28, :B, 2), (18:35, :C, 3)])
"this is an example annotated string"
```
