```julia
sparse_with_lmul(Tv, Ti, Q) -> SparseMatrixCSC
```

`Q`の`SparseMatrixCSC{Tv,Ti}`表現を作成するヘルパー関数です。`Q`は高速な`getindex`を持たないか、そもそも反復プロトコルをサポートしない代わりに、密ベクトル`v`に対する高速な`lmul!(Q, v)`を備えることを想定しています。このような`Q`の代表例は、（疎な）QR分解のQ因子です。
