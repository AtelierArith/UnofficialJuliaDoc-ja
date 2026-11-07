```julia
eigmax(A; permute::Bool=true, scale::Bool=true)
```

`A`の最大固有値を返します。オプション`permute=true`を指定すると、行列を並べ替えて上三角行列に近づけます。また、`scale=true`を指定すると、行列を対角要素でスケーリングし、各行と各列のノルムをより均等にします。`A`の固有値が複素数の場合、複素数はソートできないため、この方法は失敗することに注意してください。

# Examples

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
`A` cannot have complex eigenvalues.
Stacktrace:
[...]
```
