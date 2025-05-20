```
@show exs...
```

1つ以上の式とその結果を`stdout`に出力し、最後の結果を返します。

関連情報: [`show`](@ref), [`@info`](@ref man-logging), [`println`](@ref).

# 例

```jldoctest
julia> x = @show 1+2
1 + 2 = 3
3

julia> @show x^2 x/2;
x ^ 2 = 9
x / 2 = 1.5
```
