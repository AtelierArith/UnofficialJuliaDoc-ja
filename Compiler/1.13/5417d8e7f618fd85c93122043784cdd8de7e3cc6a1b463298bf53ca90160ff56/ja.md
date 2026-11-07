```julia
effects::Effects
```

メソッド呼び出しの計算効果を表します。

効果は、解析対象のメソッドのプログラム上の性質を表す複数の効果ビットを組み合わせたものです。これらは`Bool`または`UInt8`のビットで表され、それぞれ次の意味を持ちます。

  * `consistent::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、常に一貫して戻るか終了することが保証されています。
      * `ALWAYS_FALSE`: このメソッドは、一貫して戻らない、または終了しない可能性があります。この効果の性質については、結論が今後精緻化されることがないため、これ以上解析する必要はありません。
      * `CONSISTENT_IF_NOTRETURNED`: このメソッドの`:consistent`性は、戻り値に新たに割り当てられた可変オブジェクトが含まれない場合、後から`ALWAYS_TRUE`へ精緻化できます。
      * `CONSISTENT_IF_INACCESSIBLEMEMONLY`: `:inaccessiblememonly`が証明された場合、このメソッドの`:consistent`性は、後から`ALWAYS_TRUE`へ精緻化できます。
  * `effect_free::UInt8`:

      * `ALWAYS_TRUE`: このメソッドには、外部から意味的に観測可能な副作用がありません。
      * `ALWAYS_FALSE`: このメソッドには、外部から意味的に観測可能な副作用がある可能性があります。この効果の性質については、結論が今後精緻化されることがないため、これ以上解析する必要はありません。
      * `EFFECT_FREE_IF_INACCESSIBLEMEMONLY`: `:inaccessiblememonly`が証明された場合、このメソッドの`:effect-free`性は、後から`ALWAYS_TRUE`へ精緻化できます。
  * `nothrow::Bool`: このメソッドは例外を投げないことが保証されています。このメソッドの実行によって`MethodError`などの例外が発生する可能性がある場合、このメソッドは`:nothrow`とは見なされません。ただし、`StackOverflowError`や`InterruptException`のような環境依存のエラーは、この効果ではモデル化されません。そのため、`StackOverflowError`を引き起こす可能性があるメソッドでも、必ずしも`:nothrow`を汚染する必要はありません（ただし、通常は`:terminates`も汚染するはずです）。
  * `terminates::Bool`: このメソッドは必ず終了します。
  * `notaskstate::Bool`: このメソッドは現在のタスクに紐づく状態にアクセスしないため、観測可能な動作を変えずに別のタスクへ移動できます。現在のところ、yieldは現在のタスクの状態を変更するため、これは`noyield`も含意します。ただし、将来的には分離される可能性があります。
  * `inaccessiblememonly::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、外部からアクセス可能な可変メモリにアクセスも変更もしません。この状態は、LLVMの`inaccessiblememonly`関数属性に対応します。
      * `ALWAYS_FALSE`: このメソッドは、外部からアクセス可能な可変メモリにアクセスまたは変更する可能性があります。
      * `INACCESSIBLEMEM_OR_ARGMEMONLY`: このメソッドは、外部からアクセス可能な可変メモリにアクセスも変更もしません。ただし、呼び出し引数が指す可変メモリにはアクセスまたは変更する可能性があります。呼び出し引数が不変であると判明した場合、後から`ALWAYS_TRUE`へ精緻化できます。この状態は、LLVMの`inaccessiblemem_or_argmemonly`関数属性に対応します。
  * `noub::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、どのような入力に対しても未定義動作を実行しないことが保証されています。
      * `ALWAYS_FALSE`: このメソッドは未定義動作を実行する可能性があります。
      * `NOUB_IF_NOINBOUNDS`: このメソッドは、`@boundscheck`コードが削除されないという前提のもとで、未定義動作を実行しないことが保証されています（呼び出し元が`@inbounds`コンテキストを設定も伝播もしない場合、コードは削除されます）。

    未定義動作によって、技術的には`:consistent`や`:effect_free`など、ほかの効果に関するアサーションにも違反する可能性があります。ただし、これはモデル化しておらず、これらのアサーションは未定義動作がないことを前提としています。
  * `nonoverlayed::UInt8`:

      * `ALWAYS_TRUE`: このメソッドは、[overlayed method table](@ref OverlayMethodTable)で定義されたメソッドを呼び出さないことが保証されています。
      * `CONSISTENT_OVERLAY`: このメソッドはオーバーレイされたメソッドを呼び出す可能性がありますが、そのようなメソッドはすべて、オーバーレイされていない元の対応メソッドと`:consistent`です（[`Base.@assume_effects`](@ref)に、`:consistenct`性の厳密な定義があります）。
      * `ALWAYS_FALSE`: このメソッドはオーバーレイされたメソッドを呼び出す可能性があります。
  * `nortcall::Bool`: このメソッドは`Core.Compiler.return_type`を呼び出しません。また、このメソッドが呼び出す可能性のあるほかのメソッドも、`Core.Compiler.return_type`を呼び出さないことが保証されています。

上記の表現は内部実装の詳細にすぎないため、将来変更される可能性があります。これらの性質の定義について詳しくは、[`Base.@assume_effects`](@ref)を参照してください。

抽象解釈では、各文における`Effects`を個別に解析し、それらを統合して、解析対象のメソッド全体の効果を表す単一のグローバルな`Effects`を求めます（`merge_effects!`の実装を参照）。各効果の性質は`ALWAYS_TRUE`/`true`で初期化され、その後`ALWAYS_FALSE`/`false`へ遷移します。現在のフロー非依存な解析設計では、各文の局所解析で検出された効果は通常、保守的にグローバルな結論を汚染することに注意してください。

## Key for `show` output of Effects:

出力は、次の順序で各効果の性質の状態を表します。

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
