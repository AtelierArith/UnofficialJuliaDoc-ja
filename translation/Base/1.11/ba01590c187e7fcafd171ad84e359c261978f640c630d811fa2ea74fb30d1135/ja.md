```
fld1(x, y)
```

フロア除算で、`mod1(x,y)` と一貫した値を返します。

関連情報として [`mod1`](@ref)、[`fldmod1`](@ref) を参照してください。

# 例

```jldoctest
julia> x = 15; y = 4;

julia> fld1(x, y)
4

julia> x == fld(x, y) * y + mod(x, y)
true

julia> x == (fld1(x, y) - 1) * y + mod1(x, y)
true
```
