```julia
cat(A...; dims)
```

入力配列を、`dims`で指定した次元に沿って連結します。

次元`d in dims`における出力配列のサイズは`sum(size(a,d) for a in A)`です。それ以外の次元では、すべての入力配列のサイズが同じである必要があり、そのサイズが出力配列の該当する次元のサイズになります。

`dims`が単一の数値の場合、各配列はその次元に沿って隙間なく配置されます。`dims`が複数の次元を含む反復可能オブジェクトの場合、各入力配列について、これらの次元に沿った位置が同時に進み、それ以外の位置はゼロで埋められます。これにより、ブロック対角行列を`cat(matrices...; dims=(1,2))`として構築できるほか、その高次元の類似物も構築できます。

特殊なケースとして、`dims=1`は[`vcat`](@ref)であり、`dims=2`は[`hcat`](@ref)です。[`hvcat`](@ref)、[`hvncat`](@ref)、[`stack`](@ref)、[`repeat`](@ref)も参照してください。

このキーワードは`Val(dims)`も受け取ります。

!!! compat "Julia 1.8"
    複数の次元を指定する`dims = Val(::Tuple)`は、Julia 1.8で追加されました。


# Examples

異なる次元に沿って2つの配列を連結します。

```jldoctest
julia> a = [1 2 3]
1×3 Matrix{Int64}:
 1  2  3

julia> b = [4 5 6]
1×3 Matrix{Int64}:
 4  5  6

julia> cat(a, b; dims=1)
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> cat(a, b; dims=2)
1×6 Matrix{Int64}:
 1  2  3  4  5  6

julia> cat(a, b; dims=(1, 2))
2×6 Matrix{Int64}:
 1  2  3  0  0  0
 0  0  0  4  5  6
```

# Extended Help

3次元配列を連結します。

```jldoctest
julia> a = ones(2, 2, 3);

julia> b = ones(2, 2, 4);

julia> c = cat(a, b; dims=3);

julia> size(c) == (2, 2, 7)
true
```

サイズの異なる配列を連結します。

```jldoctest
julia> cat([1 2; 3 4], [pi, pi], fill(10, 2,3,1); dims=2)  # same as hcat
2×6×1 Array{Float64, 3}:
[:, :, 1] =
 1.0  2.0  3.14159  10.0  10.0  10.0
 3.0  4.0  3.14159  10.0  10.0  10.0
```

ブロック対角行列を構築します。

```julia
julia> cat(true, trues(2,2), trues(4)', dims=(1,2))  # block-diagonal
4×7 Matrix{Bool}:
 1  0  0  0  0  0  0
 0  1  1  0  0  0  0
 0  1  1  0  0  0  0
 0  0  0  1  1  1  1
```

```julia
julia> cat(1, [2], [3;;]; dims=Val(2))
1×3 Matrix{Int64}:
 1  2  3
```

!!! note
    `cat`は2つの文字列を連結しません。文字列の連結には`*`を使用してください。


```jldoctest
julia> a = "aaa";

julia> b = "bbb";

julia> cat(a, b; dims=1)
2-element Vector{String}:
 "aaa"
 "bbb"

julia> cat(a, b; dims=2)
1×2 Matrix{String}:
 "aaa"  "bbb"

julia> a * b
"aaabbb"
```
