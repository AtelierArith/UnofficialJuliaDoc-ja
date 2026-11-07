```julia
qr!(A, pivot = NoPivot(); blocksize)
```

`qr!`は、`A`が[`AbstractMatrix`](@ref)のサブタイプである場合、[`qr`](@ref)と同じですが、コピーを作成せずに入力の`A`を上書きするため、メモリを節約できます。因数分解の結果が`A`の要素型で表現できない数になる場合（整数型など）、[`InexactError`](@ref)例外がスローされます。

!!! compat "Julia 1.4"
    `blocksize`キーワード引数を使用するには、Julia 1.4以降が必要です。


# Examples

```jldoctest
julia> a = [1. 2.; 3. 4.]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> qr!(a)
LinearAlgebra.QRCompactWY{Float64, Matrix{Float64}, Matrix{Float64}}
Q factor: 2×2 LinearAlgebra.QRCompactWYQ{Float64, Matrix{Float64}, Matrix{Float64}}
R factor:
2×2 Matrix{Float64}:
 -3.16228  -4.42719
  0.0      -0.632456

julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> qr!(a)
ERROR: InexactError: Int64(3.1622776601683795)
Stacktrace:
[...]
```
