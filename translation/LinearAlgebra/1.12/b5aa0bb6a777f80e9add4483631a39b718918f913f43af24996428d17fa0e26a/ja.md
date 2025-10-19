```julia
cholesky!(A::AbstractMatrix, RowMaximum(); tol = 0.0, check = true) -> CholeskyPivoted
```

[`cholesky`](@ref) と同様ですが、入力 `A` を上書きすることでスペースを節約し、コピーを作成しません。因子分解が `A` の要素型で表現できない数を生成した場合、例えば整数型の場合、[`InexactError`](@ref) 例外がスローされます。
