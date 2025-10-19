```julia
@NamedTuple{key1::Type1, key2::Type2, ...}
@NamedTuple begin key1::Type1; key2::Type2; ...; end
```

このマクロは、`NamedTuple` 型を宣言するためのより便利な構文を提供します。与えられたキーと型を持つ `NamedTuple` 型を返し、これは `NamedTuple{(:key1, :key2, ...), Tuple{Type1,Type2,...}}` と同等です。`::Type` 宣言が省略された場合、それは `Any` と見なされます。`begin ... end` 形式は、宣言を複数行に分けることを可能にします（`struct` 宣言に似ています）が、それ以外は同等です。`NamedTuple` マクロは、`NamedTuple` 型を印刷する際に使用されます。たとえば、タプル `(a=3.1, b="hello")` は型 `NamedTuple{(:a, :b), Tuple{Float64, String}}` を持ち、これは次のように `@NamedTuple` を使用して宣言することもできます。

```jldoctest
julia> @NamedTuple{a::Float64, b::String}
@NamedTuple{a::Float64, b::String}

julia> @NamedTuple begin
           a::Float64
           b::String
       end
@NamedTuple{a::Float64, b::String}
```

!!! compat "Julia 1.5"
    このマクロは Julia 1.5 以降で利用可能です。

