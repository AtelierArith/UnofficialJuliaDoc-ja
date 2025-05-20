```
sparse_with_lmul(Tv, Ti, Q) -> SparseMatrixCSC
```

Helper function that creates a `SparseMatrixCSC{Tv,Ti}` representation of `Q`, where `Q` is supposed to not have fast `getindex` or not admit an iteration protocol at all, but instead a fast `lmul!(Q, v)` for dense vectors `v`. The prime example for such `Q`s is the Q factor of a (sparse) QR decomposition.
