```julia
BroadcastFunction{F} <: Function
```

演算子の「ドット」バージョンを表し、演算子をその引数に対してブロードキャストします。したがって、`BroadcastFunction(op)`は機能的に`(x...) -> (op).(x...)`と同等です。

ドットの前に演算子を付けて高階関数に渡すだけで作成できます。

# 例

```jldoctest
julia> a = [[1 3; 2 4], [5 7; 6 8]];

julia> b = [[9 11; 10 12], [13 15; 14 16]];

julia> map(.*, a, b)
2-element Vector{Matrix{Int64}}:
 [9 33; 20 48]
 [65 105; 84 128]

julia> Base.BroadcastFunction(+)(a, b) == a .+ b
true
```

!!! compat "Julia 1.6"
    `BroadcastFunction`とスタンドアロンの`.op`構文は、Julia 1.6以降で利用可能です。

