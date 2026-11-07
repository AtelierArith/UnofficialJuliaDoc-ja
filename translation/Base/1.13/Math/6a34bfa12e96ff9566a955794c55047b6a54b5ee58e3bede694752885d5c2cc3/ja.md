```julia
@evalpoly(z, c...)
```

係数 `c[1]`、`c[2]`、… に対して、多項式 ``\sum_k z^{k-1} c[k]`` の値を計算します。つまり、係数は `z` のべき乗の昇順で与えられます。このマクロは、ホーナー法、または複素数の `z` に対しては、より効率的な Goertzel 法に似たアルゴリズムを使う、効率的なインラインコードに展開されます。

[`evalpoly`](@ref) も参照してください。

# Examples

```jldoctest
julia> @evalpoly(3, 1, 0, 1)
10

julia> @evalpoly(2, 1, 0, 1)
5

julia> @evalpoly(2, 1, 1, 1)
7
```
