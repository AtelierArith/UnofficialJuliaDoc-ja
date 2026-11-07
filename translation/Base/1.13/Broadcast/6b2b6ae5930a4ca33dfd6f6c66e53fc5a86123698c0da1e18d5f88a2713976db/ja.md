```julia
BroadcastFunction{F} <: Function
```

演算子の「ドット付き」バージョンを表します。引数に対して演算子をブロードキャストするため、`BroadcastFunction(op)` は機能的に `(x...) -> (op).(x...)` と同等です。

高階関数に、演算子の前にドットを付けて渡すだけで作成できます。

# Examples

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
    `BroadcastFunction` と、単独で使う `.op` 構文は、Julia 1.6 以降で利用できます。

