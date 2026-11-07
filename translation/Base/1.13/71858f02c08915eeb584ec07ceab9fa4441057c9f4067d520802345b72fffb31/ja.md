```julia
@NamedTuple{key1::Type1, key2::Type2, ...}
@NamedTuple begin key1::Type1; key2::Type2; ...; end
```

このマクロを使うと、`NamedTuple` 型をより簡潔な構文で宣言できます。指定したキーと型を持つ `NamedTuple` 型を返し、これは `NamedTuple{(:key1, :key2, ...), Tuple{Type1,Type2,...}}` と同等です。`::Type` 宣言を省略した場合は、`Any` とみなされます。`begin ... end` 形式では、宣言を複数行に分けて記述できます（`struct` 宣言と同様）が、それ以外は同等です。`NamedTuple` マクロは、REPL などで `NamedTuple` 型を表示するときに使われます。

たとえば、タプル `(a=3.1, b="hello")` の型は `NamedTuple{(:a, :b), Tuple{Float64, String}}` です。これは、次のように `@NamedTuple` を使って宣言することもできます。

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
    このマクロは Julia 1.5 以降で利用できます。

