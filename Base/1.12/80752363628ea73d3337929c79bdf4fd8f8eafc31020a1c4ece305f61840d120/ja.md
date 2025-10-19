```julia
stack(f, args...; [dims])
```

コレクションの各要素に関数を適用し、その結果を `stack` します。または、いくつかのコレクションを [`zip`](@ref) して一緒に処理します。

関数はすべて同じサイズの配列（またはタプル、または他のイテレータ）を返す必要があります。これらは結果のスライスとなり、`dims`（指定されている場合）に沿って、またはデフォルトで最後の次元に沿って区切られます。

他にも [`mapslices`](@ref)、[`eachcol`](@ref) を参照してください。

# 例

```jldoctest
julia> stack(c -> (c, c-32), "julia")
2×5 Matrix{Char}:
 'j'  'u'  'l'  'i'  'a'
 'J'  'U'  'L'  'I'  'A'

julia> stack(eachrow([1 2 3; 4 5 6]), (10, 100); dims=1) do row, n
         vcat(row, row .* n, row ./ n)
       end
2×9 Matrix{Float64}:
 1.0  2.0  3.0   10.0   20.0   30.0  0.1   0.2   0.3
 4.0  5.0  6.0  400.0  500.0  600.0  0.04  0.05  0.06
```
