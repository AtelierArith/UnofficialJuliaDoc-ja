```julia
@views expression
```

与えられた式（`begin`/`end` ブロック、ループ、関数などの可能性があります）内のすべての配列スライス操作をビューを返すように変換します。スカラーインデックス、非配列型、および明示的な [`getindex`](@ref) 呼び出し（`array[...]` とは対照的に）は影響を受けません。

同様に、`@views` は文字列スライスを [`SubString`](@ref) ビューに変換します。

!!! note
    `@views` マクロは、与えられた `expression` に明示的に現れる `array[...]` 式にのみ影響し、そのコードによって呼び出される関数内で発生する配列スライスには影響しません。


!!! compat "Julia 1.5"
    インデックス式で `begin` を使用して最初のインデックスを参照することは、Julia 1.4 で実装されましたが、Julia 1.5 から `@views` によってのみサポートされました。


# 例

```jldoctest
julia> A = zeros(3, 3);

julia> @views for row in 1:3
           b = A[row, :] # b はコピーではなくビューです
           b .= row      # 各要素を行インデックスに割り当てる
       end

julia> A
3×3 Matrix{Float64}:
 1.0  1.0  1.0
 2.0  2.0  2.0
 3.0  3.0  3.0
```
