```
findlast(A)
```

配列 `A` の最後の `true` 値のインデックスまたはキーを返します。`A` に `true` 値がない場合は `nothing` を返します。

インデックスまたはキーは、[`keys(A)`](@ref) および [`pairs(A)`](@ref) によって返されるものと同じ型です。

関連情報: [`findfirst`](@ref), [`findprev`](@ref), [`findall`](@ref).

# 例

```jldoctest
julia> A = [true, false, true, false]
4-element Vector{Bool}:
 1
 0
 1
 0

julia> findlast(A)
3

julia> A = falses(2,2);

julia> findlast(A) # 何も返さないが、REPL には表示されない

julia> A = [true false; true false]
2×2 Matrix{Bool}:
 1  0
 1  0

julia> findlast(A)
CartesianIndex(2, 1)
```
