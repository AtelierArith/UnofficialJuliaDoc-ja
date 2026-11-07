```julia
Base.infer_exception_types(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::NativeInterpreter=Core.Compiler.NativeInterpreter(world)) -> excts::Vector{Any}
```

指定した関数 `f` と引数型 `types` に対して、発生しうる例外型の一覧を返します。この一覧は、`f` と `types` に一致するすべてのメソッド候補について、型推論を行った結果に対応します（[`methods(f, types)`](@ref methods) も参照）。[`Base.return_types`](@ref) と同様に動作しますが、戻り値の型ではなく例外型を推論します。

# Arguments

  * `f`: 解析する関数。
  * `types`（省略可）: 関数の引数型。デフォルトは `f` のデフォルトのタプル型です。
  * `world`（省略可）: 解析に使用するワールドカウンター。デフォルトは現在のワールドカウンターです。
  * `interp`（省略可）: 解析に使用する抽象インタープリター。指定した `world` を使って、新しい `Core.Compiler.NativeInterpreter` を作成するのがデフォルトです。

# Returns

  * `excts::Vector{Any}`: 指定した `f` と `types` に一致するメソッドについて、推論によって特定された例外型の一覧。この一覧の順序は、`methods(f, types)` が返す順序と一致します。

# Examples

```julia
julia> throw_if_number(::Number) = error("number is given");

julia> throw_if_number(::Any) = nothing;

julia> Base.infer_exception_types(throw_if_number, (Int,))
1-element Vector{Any}:
 ErrorException

julia> methods(throw_if_number, (Any,))
# 2 methods for generic function "throw_if_number" from Main:
 [1] throw_if_number(x::Number)
     @ REPL[1]:1
 [2] throw_if_number(::Any)
     @ REPL[2]:1

julia> Base.infer_exception_types(throw_if_number, (Any,))
2-element Vector{Any}:
 ErrorException # the result of inference on `throw_if_number(::Number)`
 Union{}        # the result of inference on `throw_if_number(::Any)`
```

!!! warning
    `Base.infer_exception_types` 関数を生成関数から呼び出してはいけません。呼び出すとエラーになります。

