```julia
cholesky!(A::AbstractMatrix, RowMaximum(); tol = 0.0, check = true) -> CholeskyPivoted
```

[`cholesky`](@ref)と同じですが、コピーを作成せず、入力の`A`を上書きするため、メモリを節約できます。因数分解の結果が`A`の要素型で表現できない数値になる場合（整数型の場合など）、[`InexactError`](@ref)例外がスローされます。
