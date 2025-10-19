```julia
mapslices(f, A; dims)
```

与えられた配列 `A` の次元を、各スライス `A[..., :, ..., :, ...]` に関数 `f` を適用することで変換します。`dims` の各 `d` にはコロンが入ります。結果は残りの次元に沿って連結されます。

例えば、`dims = [1,2]` で `A` が4次元の場合、`f` はすべての `i` と `j` に対して `x = A[:,:,i,j]` に対して呼び出され、`f(x)` は結果 `R` の中で `R[:,:,i,j]` になります。

[`eachcol`](@ref) や [`eachslice`](@ref) も参照してください。これらは [`map`](@ref) や [`stack`](@ref) と一緒に使用されます。

# 例

```jldoctest
julia> A = reshape(1:30,(2,5,3))
2×5×3 reshape(::UnitRange{Int64}, 2, 5, 3) with eltype Int64:
[:, :, 1] =
 1  3  5  7   9
 2  4  6  8  10

[:, :, 2] =
 11  13  15  17  19
 12  14  16  18  20

[:, :, 3] =
 21  23  25  27  29
 22  24  26  28  30

julia> f(x::Matrix) = fill(x[1,1], 1,4);  # 1×4 行列を返す

julia> B = mapslices(f, A, dims=(1,2))
1×4×3 Array{Int64, 3}:
[:, :, 1] =
 1  1  1  1

[:, :, 2] =
 11  11  11  11

[:, :, 3] =
 21  21  21  21

julia> f2(x::AbstractMatrix) = fill(x[1,1], 1,4);

julia> B == stack(f2, eachslice(A, dims=3))
true

julia> g(x) = x[begin] // x[end-1];  # 数値を返す

julia> mapslices(g, A, dims=[1,3])
1×5×1 Array{Rational{Int64}, 3}:
[:, :, 1] =
 1//21  3//23  1//5  7//27  9//29

julia> map(g, eachslice(A, dims=2))
5-element Vector{Rational{Int64}}:
 1//21
 3//23
 1//5
 7//27
 9//29

julia> mapslices(sum, A; dims=(1,3)) == sum(A; dims=(1,3))
true
```

`eachslice(A; dims=2)` では、指定された次元はスライス内でコロンがない次元です。これは `view(A,:,i,:)` ですが、`mapslices(f, A; dims=(1,3))` は `A[:,i,:]` を使用します。関数 `f` はスライス内の値を変更することができますが、`A` には影響を与えません。
