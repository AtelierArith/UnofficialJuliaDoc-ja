```julia
@view A[inds...]
```

インデックス式 `A[inds...]` を、同等の [`view`](@ref) 呼び出しに変換します。

これは単一のインデックス式に対してのみ直接適用できます。特に、通常の [`view`](@ref) 関数ではサポートされない、`begin` や `end` などの特殊なインデックス構文（たとえば `A[begin, 2:end-1]`）を含む式で役立ちます。

`@view` は通常の代入（例: `@view(A[1, 2:end]) = ...`）の左辺には使えません。また、装飾のない [indexed assignment](@ref man-indexed-assignment)（`A[1, 2:end] = ...`）や、ブロードキャスト付きインデックス代入（`A[1, 2:end] .= ...`）ではコピーは作成されません。ただし、`@view(A[1, 2:end]) .+= 1` のようなブロードキャスト付き代入の*更新*には便利です。これは `@view(A[1, 2:end]) .= @view(A[1, 2:end]) + 1` を簡潔に記述できる構文であり、右辺のインデックス式は `@view` がなければコピーを作成してしまうためです。

非スカラーインデックスにビューを使うよう、コードブロック全体を切り替えるには [`@views`](@ref) も参照してください。

!!! compat "Julia 1.5"
    インデックス式で `begin` を使って最初のインデックスを参照するには、Julia 1.5 以降が必要です。


# Examples

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
