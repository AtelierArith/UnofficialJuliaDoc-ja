```julia
findall(
    pattern::Union{AbstractString,AbstractPattern},
    string::AbstractString;
    overlap::Bool = false,
)
findall(
    pattern::Vector{UInt8}
    A::Vector{UInt8};
    overlap::Bool = false,
)
```

`pattern`が`string`内で見つかったすべての一致の`Vector{UnitRange{Int}}`を返します。返されるベクターの各要素は、一致するシーケンスが見つかったインデックスの範囲であり、[`findnext`](@ref)の返り値のようになります。

`overlap=true`の場合、一致するシーケンスは元の文字列のインデックスで重複することが許可されます。そうでない場合は、互いに重ならない文字範囲からでなければなりません。

# 例

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
    このメソッドは少なくともJulia 1.3が必要です。

