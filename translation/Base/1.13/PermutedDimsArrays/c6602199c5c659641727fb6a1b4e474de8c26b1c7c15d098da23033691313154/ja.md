```julia
PermutedDimsArray(A, perm) -> B
```

AbstractArray `A` を受け取り、次元が並べ替えられたように見えるビュー `B` を作成します。`permutedims` と似ていますが、コピーは行われません（`B` は `A` とストレージを共有します）。

関連項目: [`permutedims`](@ref)、[`invperm`](@ref)。

# Examples

```jldoctest
julia> A = rand(3,5,4);

julia> B = PermutedDimsArray(A, (3,1,2));

julia> size(B)
(4, 3, 5)

julia> B[3,1,2] == A[1,2,3]
true
```
