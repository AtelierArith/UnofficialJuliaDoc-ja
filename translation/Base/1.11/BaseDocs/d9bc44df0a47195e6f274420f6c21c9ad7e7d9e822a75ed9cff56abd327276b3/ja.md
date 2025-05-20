```
-(x)
```

単項マイナス演算子。

参照: [`abs`](@ref), [`flipsign`](@ref)。

# 例

```jldoctest
julia> -1
-1

julia> -(2)
-2

julia> -[1 2; 3 4]
2×2 Matrix{Int64}:
 -1  -2
 -3  -4

julia> -(true)  # Intに昇格
-1

julia> -(0x003)
0xfffd
```
