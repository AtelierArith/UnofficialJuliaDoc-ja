```
hcat(A...)
```

配列または数値を水平方向に連結します。これは、[`cat`](@ref)`(A...; dims=2)`と同等であり、構文`[a b c]`または`[a;; b;; c]`とも同じです。

大きな配列のベクトルに対しては、`reduce(hcat, A)`が効率的なメソッドを呼び出します。`A isa AbstractVector{<:AbstractVecOrMat}`の場合です。ベクトルのベクトルに対しては、これを[`stack`](@ref)`(A)`と書くこともできます。

他に[`vcat`](@ref)、[`hvcat`](@ref)も参照してください。

# 例

```jldoctest
julia> hcat([1,2], [3,4], [5,6])
2×3 Matrix{Int64}:
 1  3  5
 2  4  6

julia> hcat(1, 2, [30 40], [5, 6, 7]')  # 数値を受け入れます
1×7 Matrix{Int64}:
 1  2  30  40  5  6  7

julia> ans == [1 2 [30 40] [5, 6, 7]']  # 同じ操作のための構文
true

julia> Float32[1 2 [30 40] [5, 6, 7]']  # eltypeを指定するための構文
1×7 Matrix{Float32}:
 1.0  2.0  30.0  40.0  5.0  6.0  7.0

julia> ms = [zeros(2,2), [1 2; 3 4], [50 60; 70 80]];

julia> reduce(hcat, ms)  # hcat(ms...)よりも効率的
2×6 Matrix{Float64}:
 0.0  0.0  1.0  2.0  50.0  60.0
 0.0  0.0  3.0  4.0  70.0  80.0

julia> stack(ms) |> summary  # 行列のベクトルに対しては不一致
"2×2×3 Array{Float64, 3}"

julia> hcat(Int[], Int[], Int[])  # サイズ(0,)の空のベクトル
0×3 Matrix{Int64}

julia> hcat([1.1, 9.9], Matrix(undef, 2, 0))  # 空の2×0行列でのhcat
2×1 Matrix{Any}:
 1.1
 9.9
```
