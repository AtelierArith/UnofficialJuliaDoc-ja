```
Base.infer_effects(
    f, types=default_tt(f);
    world::UInt=get_world_counter(),
    interp::Core.Compiler.AbstractInterpreter=Core.Compiler.NativeInterpreter(world)) -> effects::Effects
```

指定された `f` と `types` による関数呼び出しの可能な計算効果を返します。

# 引数

  * `f`: 分析する関数。
  * `types` (オプション): 関数の引数の型。デフォルトは `f` のデフォルトタプル型です。
  * `world` (オプション): 分析に使用するワールドカウンタ。デフォルトは現在のワールドカウンタです。
  * `interp` (オプション): 分析に使用する抽象インタープリタ。デフォルトは指定された `world` を持つ新しい `Core.Compiler.NativeInterpreter` です。

# 戻り値

  * `effects::Effects`: 指定された呼び出しシグネチャによる関数呼び出しの計算された効果。さまざまな効果の特性に関する詳細は [`Effects`](@ref Core.Compiler.Effects) または [`Base.@assume_effects`](@ref) のドキュメントを参照してください。

!!! note
    [`Base.return_types`](@ref) とは異なり、これは与えられた `f` と `types` に対してすべての可能な一致するメソッドのリスト効果分析結果を提供しません。与えられたシグネチャ型によって引き起こされる任意の関数呼び出しのすべての潜在的な結果を考慮に入れて、単一の効果を返します。


# 例

```julia
julia> f1(x) = x * 2;

julia> Base.infer_effects(f1, (Int,))
(+c,+e,+n,+t,+s,+m,+i)
```

この関数は、`Int` 引数で呼び出されたときの関数 `f1` の計算効果に関する情報を持つ `Effects` オブジェクトを返します。

```julia
julia> f2(x::Int) = x * 2;

julia> Base.infer_effects(f2, (Integer,))
(+c,+e,!n,+t,+s,+m,+i)
```

このケースは `f1` とほぼ同じですが、注目すべき重要な違いがあります。`f2` では引数の型が `Int` に制限されているのに対し、引数の型は `Tuple{Integer}` として与えられています。このため、呼び出しシグネチャによって引き起こされるメソッドエラーの可能性を考慮すると、`:nothrow` ビットが汚染されます。

!!! warning
    `Base.infer_effects` 関数は生成された関数から使用すべきではありません。そうするとエラーが発生します。


# 参照

  * [`Core.Compiler.Effects`](@ref): メソッド呼び出しの計算効果を表す型。
  * [`Base.@assume_effects`](@ref): メソッドの効果についての仮定を行うためのマクロ。
