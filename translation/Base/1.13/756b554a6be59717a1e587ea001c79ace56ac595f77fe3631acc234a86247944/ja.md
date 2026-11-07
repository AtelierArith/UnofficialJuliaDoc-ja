```julia
Base.return_types(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::NativeInterpreter=Core.Compiler.NativeInterpreter(world)) -> rts::Vector{Any}
```

指定した関数 `f` と引数の型 `types` に対して、戻り値の型の候補を一覧で返します。この一覧は、`f` と `types` に一致するすべてのメソッド候補について、型推論を行った結果に対応します（[`methods(f, types)`](@ref methods) も参照）。

# Arguments

  * `f`: 解析する関数。
  * `types`（省略可）: 関数の引数の型。既定値は、`f` の既定のタプル型です。
  * `world`（省略可）: 解析に使用するワールドカウンター。既定値は現在のワールドカウンターです。
  * `interp`（省略可）: 解析に使用する抽象インタープリター。既定値は、指定された `world` を持つ新しい `Core.Compiler.NativeInterpreter` です。

# Returns

  * `rts::Vector{Any}`: 指定された `f` と `types` に一致するメソッドについて、型推論によって求められた戻り値の型の一覧です。一覧の順序は、`methods(f, types)` が返す順序と一致します。

# Examples

```julia
julia> Base.return_types(sum, Tuple{Vector{Int}})
1-element Vector{Any}:
 Int64

julia> methods(sum, (Union{Vector{Int},UnitRange{Int}},))
# 2 methods for generic function "sum" from Base:
 [1] sum(r::AbstractRange{<:Real})
     @ range.jl:1399
 [2] sum(a::AbstractArray; dims, kw...)
     @ reducedim.jl:1010

julia> Base.return_types(sum, (Union{Vector{Int},UnitRange{Int}},))
2-element Vector{Any}:
 Int64 # the result of inference on sum(r::AbstractRange{<:Real})
 Int64 # the result of inference on sum(a::AbstractArray; dims, kw...)
```

!!! warning
    `Base.return_types` 関数を生成関数から呼び出してはいけません。呼び出すとエラーになります。

