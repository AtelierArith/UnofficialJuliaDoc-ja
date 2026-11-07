```julia
effects::Effects
```

メソッド呼び出しの計算効果を表します。

効果は、解析対象のメソッドのプログラム上の特性を表す複数の効果ビットを組み合わせたものです。これらは `Bool` または `UInt8` のビットで表され、それぞれ次の意味を持ちます。

  * `consistent::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、必ず一貫して戻るか終了します。
      * `ALWAYS_FALSE`: このメソッドは、一貫して戻らない、または終了しない可能性があります。この効果特性については、結論が今後精緻化されることがないため、これ以上解析する必要はありません。
      * `CONSISTENT_IF_NOTRETURNED`: このメソッドの `:consistent` 性は、戻り値に新たに割り当てられた可変オブジェクトが一切含まれない場合に、後から `ALWAYS_TRUE` へ精緻化できます。
      * `CONSISTENT_IF_INACCESSIBLEMEMONLY`: このメソッドの `:consistent` 性は、`:inaccessiblememonly` が証明された場合に、後から `ALWAYS_TRUE` へ精緻化できます。
  * `effect_free::UInt8`:

      * `ALWAYS_TRUE`: このメソッドには、外部から意味的に観測可能な副作用がありません。
      * `ALWAYS_FALSE`: このメソッドには、外部から意味的に観測可能な副作用がある可能性があります。この効果特性については、結論が今後精緻化されることがないため、これ以上解析する必要はありません。
      * `EFFECT_FREE_IF_INACCESSIBLEMEMONLY`: このメソッドの `:effect-free` 性は、`:inaccessiblememonly` が証明された場合に、後から `ALWAYS_TRUE` へ精緻化できます。
  * `nothrow::Bool`: このメソッドは、例外をスローしないことが保証されています。このメソッドの実行によって `MethodError` などの例外が発生する可能性がある場合、そのメソッドは `:nothrow` とは見なされません。ただし、`StackOverflowError` や `InterruptException` のような環境依存のエラーは、この効果ではモデル化されません。そのため、`StackOverflowError` を引き起こす可能性のあるメソッドでも、必ずしも `:nothrow` を汚染する必要はありません（ただし通常は `:terminates` も汚染するはずです）。
  * `terminates::Bool`: このメソッドは、必ず終了します。
  * `notaskstate::Bool`: このメソッドは、現在のタスクに紐づく状態にアクセスしないため、観測可能な動作を変えずに別のタスクへ移動できます。現時点では、yield は現在のタスクの状態を変更するため、これには `noyield` も含まれます。ただし、将来的には分離される可能性があります。
  * `inaccessiblememonly::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、外部からアクセス可能な可変メモリにアクセスも変更もしません。この状態は、LLVM の `inaccessiblememonly` 関数属性に対応します。
      * `ALWAYS_FALSE`: このメソッドは、外部からアクセス可能な可変メモリにアクセスまたは変更する可能性があります。
      * `INACCESSIBLEMEM_OR_ARGMEMONLY`: このメソッドは、呼び出し引数が指す可変メモリにアクセスまたは変更する可能性を除き、外部からアクセス可能な可変メモリにアクセスも変更もしません。呼び出し引数が不変であると判明した場合、後から `ALWAYS_TRUE` へ精緻化できます。この状態は、LLVM の `inaccessiblemem_or_argmemonly` 関数属性に対応します。
  * `noub::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、どのような入力に対しても未定義動作を実行しないことが保証されています。
      * `ALWAYS_FALSE`: このメソッドは、未定義動作を実行する可能性があります。
      * `NOUB_IF_NOINBOUNDS`: このメソッドは、`@boundscheck` コードが省略されないという前提のもとで、未定義動作を実行しないことが保証されています（呼び出し元が `@inbounds` コンテキストを設定も伝播もしない場合、このコードは省略されます）。

    未定義動作によって、メソッドが `:consistent` や `:effect_free` など、ほかの効果に関するアサーションにも違反する可能性は技術的にはあります。しかし、これはモデル化しておらず、これらのアサーションは未定義動作がないことを前提としています。
  * `nonoverlayed::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、[overlayed method table](@ref OverlayMethodTable) で定義されたメソッドを呼び出さないことが保証されています。
      * `CONSISTENT_OVERLAY`: このメソッドはオーバーレイされたメソッドを呼び出す可能性がありますが、そのようなメソッドはすべて、オーバーレイされていない元のメソッドと `:consistent` です（[`Base.@assume_effects`](@ref) を参照。`:consistenct` 性の正確な定義が記載されています）。
      * `ALWAYS_FALSE`: このメソッドは、オーバーレイされたメソッドを呼び出す可能性があります。
  * `nortcall::Bool`: このメソッドは `Core.Compiler.return_type` を呼び出しません。また、このメソッドが呼び出す可能性のあるほかのメソッドも、いずれも `Core.Compiler.return_type` を呼び出さないことが保証されています。

上記の表現は内部実装の詳細にすぎず、将来変更される可能性が高いことに注意してください。これらの特性の定義について詳しくは、[`Base.@assume_effects`](@ref) を参照してください。

抽象解釈では、各文における `Effects` を局所的に解析し、それらを統合して、解析対象メソッドの効果全体を表す単一のグローバルな `Effects` を生成します（`merge_effects!` の実装を参照）。各効果特性は `ALWAYS_TRUE`/`true` で初期化され、その後 `ALWAYS_FALSE`/`false` へ遷移します。現在のフロー非依存な解析設計では、各文の局所解析で検出された効果は通常、保守的にグローバルな結論を汚染します。

## Key for `show` output of Effects:

出力は、次の順序で各効果特性の状態を表します。

1. `consistent` (`c`):

      * `+c` (緑): `ALWAYS_TRUE`
      * `-c` (赤): `ALWAYS_FALSE`
      * `?c` (黄): `CONSISTENT_IF_NOTRETURNED` および/または `CONSISTENT_IF_INACCESSIBLEMEMONLY`
2. `effect_free` (`e`):

      * `+e` (緑): `ALWAYS_TRUE`
      * `-e` (赤): `ALWAYS_FALSE`
      * `?e` (黄): `EFFECT_FREE_IF_INACCESSIBLEMEMONLY`
3. `nothrow` (`n`):

      * `+n` (緑): `true`
      * `-n` (赤): `false`
4. `terminates` (`t`):

      * `+t` (緑): `true`
      * `-t` (赤): `false`
5. `notaskstate` (`s`):

      * `+s` (緑): `true`
      * `-s` (赤): `false`
6. `inaccessiblememonly` (`m`):

      * `+m` (緑): `ALWAYS_TRUE`
      * `-m` (赤): `ALWAYS_FALSE`
      * `?m` (黄): `INACCESSIBLEMEM_OR_ARGMEMONLY`
7. `noub` (`u`):

      * `+u` (緑): `true`
      * `-u` (赤): `false`
      * `?u` (黄): `NOUB_IF_NOINBOUNDS`
8. `:nonoverlayed` (`o`):

      * `+o` (緑): `ALWAYS_TRUE`
      * `-o` (赤): `ALWAYS_FALSE`
      * `?o` (黄): `CONSISTENT_OVERLAY`
9. `:nortcall` (`r`):

      * `+r` (緑): `true`
      * `-r` (赤): `false`
