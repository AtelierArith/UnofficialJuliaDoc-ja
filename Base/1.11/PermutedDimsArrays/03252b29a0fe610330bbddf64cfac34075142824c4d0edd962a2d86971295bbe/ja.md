```
PermutedDimsArray(A, perm) -> B
```

与えられた AbstractArray `A` に対して、次元が順序を変えたように見えるビュー `B` を作成します。`permutedims` に似ていますが、コピーは行われず (`B` は `A` とストレージを共有します)。

関連情報として [`permutedims`](@ref)、[`invperm`](@ref) を参照してください。

# 例

```jldoctest
julia> A = rand(3,5,4);

julia> B = PermutedDimsArray(A, (3,1,2));

julia> size(B)
(4, 3, 5)

julia> B[3,1,2] == A[1,2,3]
true
```
