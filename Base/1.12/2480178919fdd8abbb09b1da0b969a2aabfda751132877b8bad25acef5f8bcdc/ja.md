```julia
setindex!(A, X, inds...)
A[inds...] = X
```

配列 `X` の値を、`inds` で指定された `A` の一部に格納します。構文 `A[inds...] = X` は `(setindex!(A, X, inds...); X)` と同等です。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

```jldoctest
julia> A = zeros(2,2);

julia> setindex!(A, [10, 20], [1, 2]);

julia> A[[3, 4]] = [30, 40];

julia> A
2×2 Matrix{Float64}:
 10.0  30.0
 20.0  40.0
```
