```julia
mapslices(f, A; dims)
```

配列 `A` の各スライス `A[..., :, ..., :, ...]` に関数 `f` を適用して、指定された次元を変換します。`dims` の各 `d` にはコロンを指定します。結果は、残りの次元に沿って連結されます。

たとえば、`dims = [1,2]` と `A` が4次元の場合、すべての `i` と `j` について、`f` が `x = A[:,:,i,j]` に対して呼び出されます。その結果、`f(x)` は `R` 内で `R[:,:,i,j]` になります。

[`eachcol`](@ref) または [`eachslice`](@ref) も参照してください。これらは [`map`](@ref) または [`stack`](@ref) と併用します。

# Examples

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

julia> f(x::Matrix) = fill(x[1,1], 1,4);  # returns a 1×4 matrix

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

julia> g(x) = x[begin] // x[end-1];  # returns a number

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

`eachslice(A; dims=2)` では、指定する次元はスライス内でコロンを付けない次元であることに注意してください。これは `view(A,:,i,:)` です。一方、`mapslices(f, A; dims=(1,3))` では `A[:,i,:]` を使用します。関数 `f` は、`A` に影響を与えずに、スライス内の値を変更することがあります。
