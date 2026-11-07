```julia
cholesky!(A::AbstractMatrix, NoPivot(); check = true) -> Cholesky
```

[`cholesky`](@ref)と同じですが、コピーを作成せずに入力の`A`を上書きするため、メモリを節約できます。因数分解の結果が`A`の要素型で表現できない数になる場合（整数型の場合など）、[`InexactError`](@ref)例外がスローされます。

# Examples

```jldoctest
julia> A = [1 2; 2 50]
2×2 Matrix{Int64}:
 1   2
 2  50

julia> cholesky!(A)
ERROR: InexactError: Int64(6.782329983125268)
Stacktrace:
[...]
```
