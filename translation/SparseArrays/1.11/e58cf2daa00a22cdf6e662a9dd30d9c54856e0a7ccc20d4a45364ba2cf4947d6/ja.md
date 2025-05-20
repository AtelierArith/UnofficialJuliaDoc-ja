```
sparse_with_lmul(Tv, Ti, Q) -> SparseMatrixCSC
```

`Q`の`SparseMatrixCSC{Tv,Ti}`表現を作成するヘルパー関数で、`Q`は高速な`getindex`を持たないか、全くイテレーションプロトコルを許可しないことが想定されていますが、代わりに密なベクトル`v`に対して高速な`lmul!(Q, v)`を持っています。このような`Q`の代表的な例は、(スパース) QR分解のQ因子です。
