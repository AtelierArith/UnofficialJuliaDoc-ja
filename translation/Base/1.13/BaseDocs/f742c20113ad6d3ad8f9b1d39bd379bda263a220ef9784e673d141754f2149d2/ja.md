```julia
nfields(x)::Int
```

指定されたオブジェクトのフィールド数を取得します。

# Examples

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

これらの例では、`a` はフィールドを2つ持つ [`Rational`](@ref) です。`b` は `Int` であり、フィールドをまったく持たないプリミティブなビット型です。`ex` はフィールドを1つ持つ [`ErrorException`](@ref) です。
