```julia
AnnotatedString{S <: AbstractString} <: AbstractString
```

メタデータを持つ文字列で、注釈付きの領域の形をしています。

より具体的には、ラベル付きの値で注釈を付けることができるラップされた文字列の周りのシンプルなラッパーです。

```text
                           C
                    ┌──────┸─────────┐
  "this is an example annotated string"
  └──┰────────┼─────┘         │
     A        └─────┰─────────┘
                    B
```

上の図は、3つの範囲に注釈が付けられた`AnnotatedString`を表しています（ラベルは`A`、`B`、`C`）。各注釈はラベル（`Symbol`）と値（`Any`）を保持します。これら3つの情報は、`@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}`として保持されます。

ラベルは一意である必要はなく、同じ領域に同じラベルを持つ複数の注釈を持つことができます。

一般的に`AnnotatedString`のために書かれたコードは、以下の特性を保持する必要があります：

  * 注釈が適用される文字
  * 各文字に対して注釈が適用される順序

特定の`AnnotatedString`の使用によって追加の意味が導入される場合があります。

これらのルールの帰結は、隣接して連続して配置された、同一のラベルと値を持つ注釈は、結合された範囲を跨ぐ単一の注釈に相当するということです。

[`AnnotatedChar`](@ref)、[`annotatedstring`](@ref)、[`annotations`](@ref)、および[`annotate!`](@ref)も参照してください。

# コンストラクタ

```julia
AnnotatedString(s::S<:AbstractString) -> AnnotatedString{S}
AnnotatedString(s::S<:AbstractString, annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}})
```

`AnnotatedString`は、引数に存在する注釈を保持しながら[`string`](@ref)のように動作する[`annotatedstring`](@ref)を使っても作成できます。

# 例

```jldoctest; setup=:(using Base: AnnotatedString)
julia> AnnotatedString("this is an example annotated string",
                    [(1:18, :A, 1), (12:28, :B, 2), (18:35, :C, 3)])
"this is an example annotated string"
```
