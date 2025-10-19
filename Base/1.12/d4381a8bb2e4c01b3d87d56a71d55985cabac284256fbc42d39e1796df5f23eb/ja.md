```julia
@view A[inds...]
```

インデックス式 `A[inds...]` を同等の [`view`](@ref) 呼び出しに変換します。

これは単一のインデックス式に直接適用でき、特に `A[begin, 2:end-1]` のような特別な `begin` または `end` インデックス構文を含む式に役立ちます（これらは通常の [`view`](@ref) 関数ではサポートされていません）。

`@view` は通常の代入のターゲットとして使用することはできません（例： `@view(A[1, 2:end]) = ...`）、また、装飾されていない [インデックス代入](@ref man-indexed-assignment) (`A[1, 2:end] = ...`) やブロードキャストされたインデックス代入 (`A[1, 2:end] .= ...`) はコピーを作成しません。しかし、`@view(A[1, 2:end]) .+= 1` のようなブロードキャストされた代入を*更新する*ためには便利です。これは `@view(A[1, 2:end]) .= @view(A[1, 2:end]) + 1` の簡単な構文であり、右辺のインデックス式は `@view` がなければコピーを作成します。

非スカラーインデックスに対してビューを使用するためにコードの全ブロックを切り替えるには、[`@views`](@ref) も参照してください。

!!! compat "Julia 1.5"
    インデックス式で最初のインデックスを参照するために `begin` を使用するには、少なくとも Julia 1.5 が必要です。


# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> b = @view A[:, 1]
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 1
 3

julia> fill!(b, 0)
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 0
 0

julia> A
2×2 Matrix{Int64}:
 0  2
 0  4
```
