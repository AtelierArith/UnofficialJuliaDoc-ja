```julia
Base.infer_return_type(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> rt::Type
```

`f` と `types` で指定された関数呼び出しの、推論された戻り値の型を返します。

# Arguments

  * `f`: 解析する関数。
  * `types`（省略可能）: 関数の引数の型。デフォルトは `f` のデフォルトのタプル型です。
  * `world`（省略可能）: 解析に使用するワールドカウンター。デフォルトは現在のワールドカウンターです。
  * `interp`（省略可能）: 解析に使用する抽象インタープリター。指定された `world` を持つ新しい `Core.Compiler.NativeInterpreter` がデフォルトで使用されます。

# Returns

  * `rt::Type`: 指定された呼び出しシグネチャで表される関数呼び出しの、推論された戻り値の型。

!!! note
    [`Base.return_types`](@ref) とは異なり、指定された `f` と `types` に一致するすべてのメソッドの戻り値の型の一覧は返しません。指定されたシグネチャ型が含意する関数呼び出しで起こり得るすべての結果を考慮し、単一の戻り値の型を返します。


# Examples

```julia
julia> checksym(::Symbol) = :symbol;

julia> checksym(x::Any) = x;

julia> Base.infer_return_type(checksym, (Union{Symbol,String},))
Union{String, Symbol}

julia> Base.return_types(checksym, (Union{Symbol,String},))
2-element Vector{Any}:
 Symbol
 Union{String, Symbol}
```

ここでの違いに注意してください。`Base.return_types` は、指定されたシグネチャ `checksum(::Union{Symbol,String})` に一致する各メソッドについて、推論された結果を返します。一方、`Base.infer_return_type` は、それらすべての可能性をまとめた単一の結果を返します。

!!! warning
    `Base.infer_return_type` 関数を生成関数から呼び出してはいけません。呼び出すとエラーになります。

