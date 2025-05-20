```
eigmax(A; permute::Bool=true, scale::Bool=true)
```

行列 `A` の最大固有値を返します。オプション `permute=true` は行列を上三角行列に近づけるために行列を置換し、`scale=true` は行列の対角要素でスケーリングして行と列のノルムをより等しくします。注意すべきは、`A` の固有値が複素数の場合、この方法は失敗します。なぜなら、複素数はソートできないからです。

# 例

```jldoctest
julia> A = [0 im; -im 0]
2×2 Matrix{Complex{Int64}}:
 0+0im  0+1im
 0-1im  0+0im

julia> eigmax(A)
1.0

julia> A = [0 im; -1 0]
2×2 Matrix{Complex{Int64}}:
  0+0im  0+1im
 -1+0im  0+0im

julia> eigmax(A)
ERROR: DomainError with Complex{Int64}[0+0im 0+1im; -1+0im 0+0im]:
`A` は複素固有値を持つことができません。
Stacktrace:
[...]
```
