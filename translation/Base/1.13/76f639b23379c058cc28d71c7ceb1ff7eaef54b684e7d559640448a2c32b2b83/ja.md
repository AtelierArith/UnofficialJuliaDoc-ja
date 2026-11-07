```julia
similar(array, [element_type=eltype(array)], [dims=size(array)])
```

指定された要素型とサイズを持つ、未初期化の可変配列を、指定されたソース配列に基づいて作成します。第2引数と第3引数はどちらも省略可能で、省略した場合は元の配列の `eltype` と `size` が使われます。次元は、単一のタプル引数として指定することも、複数の整数引数として指定することもできます。

カスタムの AbstractArray サブタイプでは、指定された要素型と次元数に最適な具体的配列型を選んで返すことができます。このメソッドを特殊化しない場合、既定では `Array{element_type}(undef, dims...)` が使われます。

たとえば、`similar(1:10, 1, 4)` は未初期化の `Array{Int,2}` を返します。範囲は可変ではなく、2次元にも対応していないためです。

```julia-repl
julia> similar(1:10, 1, 4)
1×4 Matrix{Int64}:
 4419743872  4374413872  4419743888  0
```

一方、`similar(trues(10,10), 2)` は、要素数が2の未初期化 `BitVector` を返します。`BitArray` は可変であり、1次元配列にも対応できるためです。

```jldoctest; filter = r"[01]"
julia> similar(trues(10,10), 2)
2-element BitVector:
 0
 0
```

ただし、`BitArray` は [`Bool`](@ref) 型の要素しか格納できません。そのため、別の要素型を指定すると、代わりに通常の `Array` が作成されます。

```julia-repl
julia> similar(falses(10), Float64, 2, 4)
2×4 Matrix{Float64}:
 2.18425e-314  2.18425e-314  2.18425e-314  2.18425e-314
 2.18425e-314  2.18425e-314  2.18425e-314  2.18425e-314
```

関連項目: [`undef`](@ref)、[`isassigned`](@ref)。
