```julia
eigmin(A; permute::Bool=true, scale::Bool=true)
```

`A` の最小固有値を返します。オプション `permute=true` は、行列がより上三角行列に近づくように並べ替えます。また、`scale=true` は、行列を対角要素でスケーリングし、行と列のノルムをより均等にします。`A` の固有値が複素数の場合、複素数はソートできないため、この方法は失敗することに注意してください。

# Examples

```jldoctest
julia> A = [0 im; -im 0]
2×2 Matrix{Complex{Int64}}:
 0+0im  0+1im
 0-1im  0+0im

julia> eigmin(A)
-1.0

julia> A = [0 im; -1 0]
2×2 Matrix{Complex{Int64}}:
  0+0im  0+1im
 -1+0im  0+0im

julia> eigmin(A)
ERROR: DomainError with Complex{Int64}[0+0im 0+1im; -1+0im 0+0im]:
`A` cannot have complex eigenvalues.
Stacktrace:
[...]
```
