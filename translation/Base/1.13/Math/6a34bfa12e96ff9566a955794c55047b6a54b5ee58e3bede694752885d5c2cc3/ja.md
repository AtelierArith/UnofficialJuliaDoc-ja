```julia
@evalpoly(z, c...)
```

係数 `c[1]`、`c[2]`、... に対して、多項式 ``\sum_k z^{k-1} c[k]`` を評価します。つまり、係数は `z` のべきの昇順で与えられます。このマクロは、ホーナー法、または複素数の `z` の場合は、より効率的な Goertzel に似たアルゴリズムを使うインラインコードに展開されます。

関連項目: [`evalpoly`](@ref)。

# Examples

```jldoctest
julia> @evalpoly(3, 1, 0, 1)
10

julia> @evalpoly(2, 1, 0, 1)
5

julia> @evalpoly(2, 1, 1, 1)
7
```
