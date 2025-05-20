```
fill(value, dims::Tuple)
fill(value, dims...)
```

サイズ `dims` の配列を作成し、すべての位置を `value` に設定します。

例えば、`fill(1.0, (5,5))` は、5×5 の浮動小数点数の配列を返し、配列のすべての位置に `1.0` が入ります。

次元の長さ `dims` は、タプルまたは引数のシーケンスとして指定できます。`N` 長のタプルまたは `value` に続く `N` の引数は、`N` 次元の配列を指定します。したがって、ゼロ次元の配列を作成するための一般的な慣用句は `fill(x)` です。

返された配列のすべての位置は、渡された `value` に設定されており、したがって [`===`](@ref) です。これは、`value` 自体が変更されると、`fill` された配列のすべての要素がその変更を反映することを意味します。なぜなら、それらは *まだ* その `value` だからです。`fill(1.0, (5,5))` では、`value` `1.0` は不変であり、変更できないため問題ありませんが、配列のような可変値では予期しない結果になることがあります。例えば、`fill([], 3)` は、返されたベクトルのすべての3つの位置に *まったく同じ* 空の配列を配置します：

```jldoctest
julia> v = fill([], 3)
3-element Vector{Vector{Any}}:
 []
 []
 []

julia> v[1] === v[2] === v[3]
true

julia> value = v[1]
Any[]

julia> push!(value, 867_5309)
1-element Vector{Any}:
 8675309

julia> v
3-element Vector{Vector{Any}}:
 [8675309]
 [8675309]
 [8675309]
```

多くの独立した内部配列を作成するには、代わりに [comprehension](@ref man-comprehensions) を使用してください。これにより、ループの各反復で新しく異なる配列が作成されます：

```jldoctest
julia> v2 = [[] for _ in 1:3]
3-element Vector{Vector{Any}}:
 []
 []
 []

julia> v2[1] === v2[2] === v2[3]
false

julia> push!(v2[1], 8675309)
1-element Vector{Any}:
 8675309

julia> v2
3-element Vector{Vector{Any}}:
 [8675309]
 []
 []
```

関連項目: [`fill!`](@ref), [`zeros`](@ref), [`ones`](@ref), [`similar`](@ref).

# 例

```jldoctest
julia> fill(1.0, (2,3))
2×3 Matrix{Float64}:
 1.0  1.0  1.0
 1.0  1.0  1.0

julia> fill(42)
0-dimensional Array{Int64, 0}:
42

julia> A = fill(zeros(2), 2) # 両方の要素を同じ [0.0, 0.0] ベクトルに設定
2-element Vector{Vector{Float64}}:
 [0.0, 0.0]
 [0.0, 0.0]

julia> A[1][1] = 42; # 塗りつぶされた値を [42.0, 0.0] に変更

julia> A # A[1] と A[2] はまったく同じベクトル
2-element Vector{Vector{Float64}}:
 [42.0, 0.0]
 [42.0, 0.0]
```
