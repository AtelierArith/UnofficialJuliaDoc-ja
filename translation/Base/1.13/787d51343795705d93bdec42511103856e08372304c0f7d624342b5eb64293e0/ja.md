```julia
stack(f, args...; [dims])
```

コレクションの各要素に関数を適用し、`stack`結果を返します。複数のコレクションを対象にする場合は、[`zip`](@ref)して適用します。

関数は、すべて同じサイズの配列（またはタプル、その他のイテレーター）を返す必要があります。これらは結果のスライスとなり、それぞれ`dims`（指定されている場合）に沿って、指定がなければ最後の次元に沿って分割されます。

[`mapslices`](@ref)、[`eachcol`](@ref)も参照してください。

# Examples

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
