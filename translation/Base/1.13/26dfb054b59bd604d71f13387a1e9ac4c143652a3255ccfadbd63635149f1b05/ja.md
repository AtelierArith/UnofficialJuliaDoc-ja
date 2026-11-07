```julia
Base.infer_exception_type(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> exct::Type
```

`f` と `types` で指定された関数呼び出しがスローする可能性のある例外の型を返します。

# Arguments

  * `f`: 解析対象の関数。
  * `types`（省略可能）: 関数の引数の型。デフォルトは `f` のデフォルトタプル型です。
  * `world`（省略可能）: 解析に使用するワールドカウンター。デフォルトは現在のワールドカウンターです。
  * `interp`（省略可能）: 解析に使用する抽象インタープリター。デフォルトでは、指定された `world` を持つ新しい `Core.Compiler.NativeInterpreter` が使われます。

# Returns

  * `exct::Type`: 指定された呼び出しシグネチャで関数を呼び出したときにスローされる可能性がある例外の、推論された型。

!!! note
    [`Base.infer_exception_types`](@ref) とは異なり、指定された `f` と `types` に一致するすべてのメソッドについて、例外型の一覧を返すわけではありません。指定されたシグネチャ型が含意する関数呼び出しのあらゆる結果を考慮し、単一の例外型を返します。


# Examples

```julia
julia> f1(x) = x * 2;

julia> Base.infer_exception_type(f1, (Int,))
Union{}
```

例外型が `Union{}` と推論された場合、`f1(::Int)` は例外をスローしないことを示します。

```julia
julia> f2(x::Int) = x * 2;

julia> Base.infer_exception_type(f2, (Integer,))
MethodError
```

このケースは `f1` の場合とほぼ同じですが、重要な違いがあります。`f2` では引数の型が `Int` に制限されているのに対し、こちらでは引数の型が `Tuple{Integer}` として与えられます。そのため、呼び出しシグネチャが含意するメソッドエラーの可能性を考慮すると、例外型は `MethodError` に拡大されます。

!!! warning
    `Base.infer_exception_type` 関数を生成関数から呼び出してはいけません。呼び出すとエラーになります。

