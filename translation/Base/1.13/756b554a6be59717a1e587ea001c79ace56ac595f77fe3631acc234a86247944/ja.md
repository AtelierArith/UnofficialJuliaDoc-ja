```julia
Base.return_types(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::NativeInterpreter=Core.Compiler.NativeInterpreter(world)) -> rts::Vector{Any}
```

指定した関数 `f` と引数の型 `types` に対して、戻り値の型として考えられるものの一覧を返します。この一覧は、`f` と `types` に一致するすべてのメソッド候補について、型推論を行った結果に対応します（[`methods(f, types)`](@ref methods) も参照）。

# Arguments

  * `f`: 解析する関数。
  * `types`（省略可）: 関数の引数の型。既定値は、`f` の既定のタプル型です。
  * `world`（省略可）: 解析に使用するワールドカウンター。既定値は現在のワールドカウンターです。
  * `interp`（省略可）: 解析に使用する抽象インタープリター。指定した `world` を持つ新しい `Core.Compiler.NativeInterpreter` が既定で使用されます。

# Returns

  * `rts::Vector{Any}`: 指定した `f` と `types` に一致するメソッドを推論して得られる、戻り値の型の一覧。この一覧の順序は、`methods(f, types)` が返す順序と一致します。

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

