```julia
map!(function, destination, collection...)
```

[`map`](@ref)と同様ですが、新しいコレクションではなく`destination`に結果を格納します。`destination`は、最小のコレクション以上の大きさでなければなりません。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作が起こることがあります。


関連項目: [`map`](@ref)、[`foreach`](@ref)、[`zip`](@ref)、[`copyto!`](@ref)。

# Examples

```jldoctest
julia> a = zeros(3);

julia> map!(x -> x * 2, a, [1, 2, 3]);

julia> a
3-element Vector{Float64}:
 2.0
 4.0
 6.0

julia> map!(+, zeros(Int, 5), 100:999, 1:3)
5-element Vector{Int64}:
 101
 103
 105
   0
   0
```
