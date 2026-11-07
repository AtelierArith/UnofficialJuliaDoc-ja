```julia
Base.infer_effects(
    f, types=default_tt(f);
    optimize::Bool=true,
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> effects::Effects
```

`f`および`types`で指定された関数呼び出しで起こり得る計算エフェクトを返します。

# Arguments

  * `f`: 解析する関数。
  * `types`（省略可）: 関数の引数の型。デフォルトは`f`のデフォルトのタプル型です。
  * `optimize`（省略可）: 最適化後の解析に基づく追加のエフェクト精緻化を実行するかどうか。
  * `world`（省略可）: 解析に使用するワールドカウンター。デフォルトは現在のワールドカウンターです。
  * `interp`（省略可）: 解析に使用する抽象インタープリター。指定された`world`を持つ新しい`Core.Compiler.NativeInterpreter`がデフォルトです。

# Returns

  * `effects::Effects`: 指定された呼び出しシグネチャでの関数呼び出しについて計算されたエフェクト。各種エフェクトプロパティの詳細は、[`Effects`](@ref Core.Compiler.Effects)または[`Base.@assume_effects`](@ref)のドキュメントを参照してください。

!!! note
    [`Base.return_types`](@ref)とは異なり、指定された`f`および`types`に一致する可能性のある各メソッドについて、リスト形式のエフェクト解析結果を返すわけではありません。指定されたシグネチャ型が含意する関数呼び出しについて、起こり得るすべての結果を考慮した単一のエフェクトを返します。


# Examples

```julia
julia> f1(x) = x * 2;

julia> Base.infer_effects(f1, (Int,))
(+c,+e,+n,+t,+s,+m,+i)
```

この関数は、`f1`を`Int`型の引数で呼び出したときの計算エフェクトに関する情報を含む`Effects`オブジェクトを返します。

```julia
julia> f2(x::Int) = x * 2;

julia> Base.infer_effects(f2, (Integer,))
(+c,+e,!n,+t,+s,+m,+i)
```

このケースは`f1`の場合とほぼ同じですが、重要な違いがあります。`f2`では引数の型が`Int`に限定されるのに対し、こちらでは引数の型を`Tuple{Integer}`として指定します。そのため、呼び出しシグネチャに含まれるメソッドエラーの可能性を考慮すると、`:nothrow`ビットは不確定になります。

!!! warning
    `Base.infer_effects`関数を生成関数から呼び出してはいけません。呼び出すとエラーになります。


## Key for `show` output of Effects:

出力は、以下の順序で各種エフェクトプロパティの状態を表します。

1. `consistent`（`c`）:

      * `+c`（緑）: `ALWAYS_TRUE`
      * `-c`（赤）: `ALWAYS_FALSE`
      * `?c`（黄）: `CONSISTENT_IF_NOTRETURNED`および／または`CONSISTENT_IF_INACCESSIBLEMEMONLY`
2. `effect_free`（`e`）:

      * `+e`（緑）: `ALWAYS_TRUE`
      * `-e`（赤）: `ALWAYS_FALSE`
      * `?e`（黄）: `EFFECT_FREE_IF_INACCESSIBLEMEMONLY`
3. `nothrow`（`n`）:

      * `+n`（緑）: `true`
      * `-n`（赤）: `false`
4. `terminates`（`t`）:

      * `+t`（緑）: `true`
      * `-t`（赤）: `false`
5. `notaskstate`（`s`）:

      * `+s`（緑）: `true`
      * `-s`（赤）: `false`
6. `inaccessiblememonly`（`m`）:

      * `+m`（緑）: `ALWAYS_TRUE`
      * `-m`（赤）: `ALWAYS_FALSE`
      * `?m`（黄）: `INACCESSIBLEMEM_OR_ARGMEMONLY`
7. `noub`（`u`）:

      * `+u`（緑）: `true`
      * `-u`（赤）: `false`
      * `?u`（黄）: `NOUB_IF_NOINBOUNDS`
8. `:nonoverlayed`（`o`）:

      * `+o`（緑）: `ALWAYS_TRUE`
      * `-o`（赤）: `ALWAYS_FALSE`
      * `?o`（黄）: `CONSISTENT_OVERLAY`
9. `:nortcall`（`r`）:

      * `+r`（緑）: `true`
      * `-r`（赤）: `false`

# See Also

  * [`Compiler.Effects`](@ref): メソッド呼び出しの計算エフェクトを表す型。
  * [`Base.@assume_effects`](@ref): メソッドのエフェクトに関する仮定を設定するマクロ。
