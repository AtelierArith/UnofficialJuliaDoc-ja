```julia
lu!(A, pivot = RowMaximum(); check = true, allowsingular = false) -> LU
```

`lu!` は [`lu`](@ref) と同じですが、コピーを作成せず、入力の `A` を上書きすることでメモリを節約します。因数分解の結果が `A` の要素型で表現できない数になる場合（整数型など）、[`InexactError`](@ref) 例外がスローされます。

!!! compat "Julia 1.11"
    `allowsingular` キーワード引数は Julia 1.11 で追加されました。


# Examples

```jldoctest
julia> A = [4. 3.; 6. 3.]
2×2 Matrix{Float64}:
 4.0  3.0
 6.0  3.0

julia> F = lu!(A)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0       0.0
 0.666667  1.0
U factor:
2×2 Matrix{Float64}:
 6.0  3.0
 0.0  1.0

julia> iA = [4 3; 6 3]
2×2 Matrix{Int64}:
 4  3
 6  3

julia> lu!(iA)
ERROR: InexactError: Int64(0.6666666666666666)
Stacktrace:
[...]
```
