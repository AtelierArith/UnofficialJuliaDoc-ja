```julia
findall(
    pattern::Union{AbstractString,AbstractPattern},
    string::AbstractString;
    overlap::Bool = false,
)
findall(
    pattern::Vector{UInt8},
    A::Vector{UInt8};
    overlap::Bool = false,
)
```

`string` 内で `pattern` に一致するすべての箇所を返す `Vector{UnitRange{Int}}` を返します。返されるベクトルの各要素は、一致する並びが見つかったインデックス範囲です。これは [`findnext`](@ref) の戻り値と同様です。

`overlap=true` の場合、一致する並びは元の文字列内でインデックスが重複してもかまいません。それ以外の場合は、互いに重ならない文字範囲にある必要があります。

# Examples

```jldoctest
julia> findall("a", "apple")
1-element Vector{UnitRange{Int64}}:
 1:1

julia> findall("nana", "banana")
1-element Vector{UnitRange{Int64}}:
 3:6

julia> findall("a", "banana")
3-element Vector{UnitRange{Int64}}:
 2:2
 4:4
 6:6

julia> findall(UInt8[1,2], UInt8[1,2,3,1,2])
2-element Vector{UnitRange{Int64}}:
 1:2
 4:5
```

!!! compat "Julia 1.3"
    このメソッドを使用するには、Julia 1.3 以降が必要です。

