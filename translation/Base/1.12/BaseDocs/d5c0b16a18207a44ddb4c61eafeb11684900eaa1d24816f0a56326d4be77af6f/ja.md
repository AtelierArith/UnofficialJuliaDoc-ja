```julia
nfields(x) -> Int
```

与えられたオブジェクトのフィールドの数を取得します。

# 例

```jldoctest
julia> a = 1//2;

julia> nfields(a)
2

julia> b = 1
1

julia> nfields(b)
0

julia> ex = ErrorException("I've done a bad thing");

julia> nfields(ex)
1
```

これらの例では、`a` は [`Rational`](@ref) で、2つのフィールドを持っています。`b` は `Int` で、フィールドを全く持たないプリミティブビットタイプです。`ex` は [`ErrorException`](@ref) で、1つのフィールドを持っています。
