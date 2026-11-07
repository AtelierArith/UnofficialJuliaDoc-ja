```julia
@ncallkw N f kw sym...
```

キーワード引数を含む関数呼び出し式を生成します `kw...`。[`@ncall`](@ref)の場合と同様に、`sym`は任意の数の関数引数を表し、最後の引数は無名関数式でもかまいません。これは`N`引数に展開されます。

# Examples

```jldoctest
julia> using Base.Cartesian

julia> f(x...; a, b = 1, c = 2, d = 3) = +(x..., a, b, c, d);

julia> x_1, x_2 = (-1, -2); b = 0; kw = (c = 0, d = 0);

julia> @ncallkw 2 f (; a = 0, b, kw...) x
-3

```
