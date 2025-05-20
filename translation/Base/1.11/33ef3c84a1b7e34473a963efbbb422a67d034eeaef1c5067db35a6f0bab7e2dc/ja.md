```
cat(A...; dims)
```

指定された次元 `dims` に沿って入力配列を連結します。

次元 `d in dims` に沿った出力配列のサイズは `sum(size(a,d) for a in A)` です。他の次元に沿っては、すべての入力配列が同じサイズである必要があり、それが出力配列のサイズにもなります。

`dims` が単一の数値の場合、異なる配列はその次元に沿って密に詰められます。`dims` が複数の次元を含むイテラブルの場合、これらの次元に沿った位置は各入力配列に対して同時に増加し、他の場所はゼロで埋められます。これにより、`cat(matrices...; dims=(1,2))` のようにブロック対角行列やその高次元の類似物を構築することができます。

特別なケース `dims=1` は [`vcat`](@ref)、`dims=2` は [`hcat`](@ref) です。さらに [`hvcat`](@ref)、[`hvncat`](@ref)、[`stack`](@ref)、[`repeat`](@ref) も参照してください。

キーワードは `Val(dims)` も受け入れます。

!!! compat "Julia 1.8"
    複数の次元 `dims = Val(::Tuple)` は Julia 1.8 で追加されました。


# 例

異なる次元で2つの配列を連結します：

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

# 拡張ヘルプ

3D配列を連結します：

```jldoctest
julia> a = ones(2, 2, 3);

julia> b = ones(2, 2, 4);

julia> c = cat(a, b; dims=3);

julia> size(c) == (2, 2, 7)
true
```

異なるサイズの配列を連結します：

```jldoctest
julia> cat([1 2; 3 4], [pi, pi], fill(10, 2,3,1); dims=2)  # hcat と同じ
2×6×1 Array{Float64, 3}:
[:, :, 1] =
 1.0  2.0  3.14159  10.0  10.0  10.0
 3.0  4.0  3.14159  10.0  10.0  10.0
```

ブロック対角行列を構築します：

```
julia> cat(true, trues(2,2), trues(4)', dims=(1,2))  # ブロック対角
4×7 Matrix{Bool}:
 1  0  0  0  0  0  0
 0  1  1  0  0  0  0
 0  1  1  0  0  0  0
 0  0  0  1  1  1  1
```

```
julia> cat(1, [2], [3;;]; dims=Val(2))
1×3 Matrix{Int64}:
 1  2  3
```

!!! note
    `cat` は2つの文字列を結合しません。`*` を使用することをお勧めします。


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
