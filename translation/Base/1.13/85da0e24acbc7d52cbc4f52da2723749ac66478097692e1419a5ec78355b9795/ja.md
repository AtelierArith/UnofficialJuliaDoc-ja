```julia
fill(value, dims::Tuple)
fill(value, dims...)
```

サイズが `dims` で、すべての要素が `value` に設定された配列を作成します。

たとえば、`fill(1.0, (5,5))` は、すべての要素が `1.0` である 5×5 の浮動小数点数配列を返します。

次元の長さ `dims` は、タプルまたは引数列のどちらでも指定できます。`value` の後に、長さが `N` のタプル、または `N` 個の引数を指定すると、`N` 次元の配列が作成されます。そのため、唯一の要素が `x` である 0 次元配列を作成する一般的な書き方は、`fill(x)` です。

返される配列のすべての要素には、渡された `value` が設定されます（つまり、[`===`](@ref)）。そのため、`value` 自体が変更されると、`fill` 配列のすべての要素にその変更が反映されます。これは、どの要素も *依然として* 同じ `value` だからです。`fill(1.0, (5,5))` の場合は、`value` `1.0` が不変で、それ自体を変更できないため問題ありません。しかし、配列など、変更可能な値では予期しない結果になることがあります。たとえば、`fill([], 3)` は、返されるベクトルの 3 つの要素すべてに *まったく同じ* 空の配列を格納します。

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

独立した内部配列を複数作成するには、代わりに [comprehension](@ref man-comprehensions) を使用します。これにより、ループの反復ごとに新しい別個の配列が作成されます。

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

関連項目: [`fill!`](@ref)、[`zeros`](@ref)、[`ones`](@ref)、[`similar`](@ref)。

# Examples

```jldoctest
julia> fill(1.0, (2,3))
2×3 Matrix{Float64}:
 1.0  1.0  1.0
 1.0  1.0  1.0

julia> fill(42)
0-dimensional Array{Int64, 0}:
42

julia> A = fill(zeros(2), 2) # sets both elements to the same [0.0, 0.0] vector
2-element Vector{Vector{Float64}}:
 [0.0, 0.0]
 [0.0, 0.0]

julia> A[1][1] = 42; # modifies the filled value to be [42.0, 0.0]

julia> A # both A[1] and A[2] are the very same vector
2-element Vector{Vector{Float64}}:
 [42.0, 0.0]
 [42.0, 0.0]
```
