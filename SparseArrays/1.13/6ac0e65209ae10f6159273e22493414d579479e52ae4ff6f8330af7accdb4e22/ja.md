```julia
permute!(X::AbstractSparseMatrixCSC{Tv,Ti}, A::AbstractSparseMatrixCSC{Tv,Ti},
         p::AbstractVector{<:Integer}, q::AbstractVector{<:Integer},
         [C::AbstractSparseMatrixCSC{Tv,Ti}]) where {Tv,Ti}
```

`A`を両側から並べ替え、結果を`X`に格納します（`PAQ`（`A[p,q]`））。中間結果`(AQ)^T`（`transpose(A[:,q])`）は、存在する場合、オプション引数`C`に格納されます。`X`、`A`、および存在する場合は`C`が互いにエイリアスでないことが必要です。結果`PAQ`を`A`に戻して格納するには、`X`を使わない次の方法を使用してください。

```julia
permute!(A::AbstractSparseMatrixCSC{Tv,Ti}, p::AbstractVector{<:Integer},
         q::AbstractVector{<:Integer}[, C::AbstractSparseMatrixCSC{Tv,Ti},
         [workcolptr::Vector{Ti}]]) where {Tv,Ti}
```

`X`の次元は`A`（`size(X, 1) == size(A, 1)`および`size(X, 2) == size(A, 2)`）の次元と一致している必要があります。また、`X`には、`A`（`length(rowvals(X)) >= nnz(A)`および`length(nonzeros(X)) >= nnz(A)`）内の割り当て済みエントリをすべて格納できるだけの容量が必要です。列置換`q`の長さは、`A`の列数（`length(q) == size(A, 2)`）と一致している必要があります。行置換`p`の長さは、`A`の行数（`length(p) == size(A, 1)`）と一致している必要があります。

`C`の次元は`transpose(A)`（`size(C, 1) == size(A, 2)`および`size(C, 2) == size(A, 1)`）の次元と一致している必要があります。また、`C`には、`A`（`length(rowvals(C)) >= nnz(A)`および`length(nonzeros(C)) >= nnz(A)`）内の割り当て済みエントリをすべて格納できるだけの容量が必要です。

アルゴリズムの詳細、および引数チェックを省略するこれらのメソッドのバージョンについては、非公開の親メソッド`unchecked_noalias_permute!`および`unchecked_aliasing_permute!`を参照してください。

[`permute`](@ref)も参照してください。
