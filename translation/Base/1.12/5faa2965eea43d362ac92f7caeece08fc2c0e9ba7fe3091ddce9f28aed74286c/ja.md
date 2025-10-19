```julia
similar(array, [element_type=eltype(array)], [dims=size(array)])
```

指定された要素型とサイズを持つ初期化されていない可変配列を、指定されたソース配列に基づいて作成します。第二引数と第三引数はどちらもオプションで、指定された配列の `eltype` と `size` にデフォルト設定されています。次元は、単一のタプル引数として指定するか、一連の整数引数として指定できます。

カスタム `AbstractArray` サブタイプは、指定された要素型と次元に最も適した配列型を返すことを選択できます。このメソッドを特化しない場合、デフォルトは `Array{element_type}(undef, dims...)` です。

例えば、`similar(1:10, 1, 4)` は初期化されていない `Array{Int,2}` を返します。なぜなら、範囲は可変でもなく、2次元をサポートしていないからです：

```julia-repl
julia> similar(1:10, 1, 4)
1×4 Matrix{Int64}:
 4419743872  4374413872  4419743888  0
```

逆に、`similar(trues(10,10), 2)` は2つの要素を持つ初期化されていない `BitVector` を返します。なぜなら、`BitArray` は可変であり、1次元配列をサポートできるからです：

```julia-repl
julia> similar(trues(10,10), 2)
2-element BitVector:
 0
 0
```

ただし、`BitArray` は [`Bool`](@ref) 型の要素しか格納できないため、異なる要素型を要求すると、通常の `Array` が作成されます：

```julia-repl
julia> similar(falses(10), Float64, 2, 4)
2×4 Matrix{Float64}:
 2.18425e-314  2.18425e-314  2.18425e-314  2.18425e-314
 2.18425e-314  2.18425e-314  2.18425e-314  2.18425e-314
```

参照： [`undef`](@ref), [`isassigned`](@ref).
