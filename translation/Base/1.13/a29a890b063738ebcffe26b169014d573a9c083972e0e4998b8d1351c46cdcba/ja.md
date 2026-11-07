```julia
permute!(v, p)
```

ベクトル `v` を置換 `p` に従って並べ替え、結果を `v` に書き戻します。`p` が置換であるかどうかの検証は行われません。

新しい置換を返すには、`v[p]` を使用してください。通常、これは `permute!(v, p)` より高速です。事前に確保した出力配列に `u .= @view v[p]` を使って書き込むと、さらに高速になります。（`permute!` は `v` をインプレースで上書きしますが、内部では一部のメモリ確保が必要です。）

!!! warning
    変更対象の引数が、ほかのいずれかの引数とメモリを共有している場合、予期しない動作になることがあります。


[`invpermute!`](@ref) も参照してください。

# Examples

```jldoctest
julia> A = [1, 1, 3, 4];

julia> perm = [2, 4, 3, 1];

julia> permute!(A, perm);

julia> A
4-element Vector{Int64}:
 1
 4
 3
 1
```
