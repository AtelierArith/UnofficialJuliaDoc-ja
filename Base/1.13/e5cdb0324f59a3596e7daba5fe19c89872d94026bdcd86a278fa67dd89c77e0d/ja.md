```julia
@views expression
```

与えられた式（`begin`/`end`ブロック、ループ、関数など）に含まれるすべての配列スライス操作を、ビューを返すように変換します。スカラーインデックス、配列以外の型、および明示的な[`getindex`](@ref)呼び出し（`array[...]`とは異なります）は対象外です。

同様に、`@views`は文字列スライスを[`SubString`](@ref)ビューに変換します。

!!! note
    `@views`マクロの影響を受けるのは、与えられた`expression`内に明示的に記述された`array[...]`式だけです。そのコードから呼び出される関数内で行われる配列スライスには影響しません。


!!! compat "Julia 1.5"
    インデックス式で最初のインデックスを参照するために`begin`を使う機能はJulia 1.4で実装されましたが、`@views`でサポートされたのはJulia 1.5からです。


# Examples

```jldoctest
julia> A = zeros(3, 3);

julia> @views for row in 1:3
           b = A[row, :] # b is a view, not a copy
           b .= row      # assign every element to the row index
       end

julia> A
3×3 Matrix{Float64}:
 1.0  1.0  1.0
 2.0  2.0  2.0
 3.0  3.0  3.0
```
