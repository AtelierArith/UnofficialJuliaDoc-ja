```julia
Base.@assume_effects setting... [ex]
```

コンパイラーのエフェクト解析をオーバーライドします。このマクロは、次のような複数のコンテキストで使用できます。

1. メソッド定義の直前に置き、対象メソッドのエフェクト解析全体をオーバーライドする。
2. 引数なしで関数本体内に置き、包含するメソッドのエフェクト解析全体をオーバーライドする。
3. コードブロックに適用し、対象コードブロックのローカルなエフェクト解析をオーバーライドする。

# Examples

```jldoctest
julia> Base.@assume_effects :terminates_locally function fact(x)
           # usage 1:
           # this :terminates_locally allows `fact` to be constant-folded
           res = 1
           0 ≤ x < 20 || error("bad fact")
           while x > 1
               res *= x
               x -= 1
           end
           return res
       end
fact (generic function with 1 method)

julia> code_typed() do
           fact(12)
       end |> only
CodeInfo(
1 ─     return 479001600
) => Int64

julia> code_typed() do
           map((2,3,4)) do x
               # usage 2:
               # this :terminates_locally allows this anonymous function to be constant-folded
               Base.@assume_effects :terminates_locally
               res = 1
               0 ≤ x < 20 || error("bad fact")
               while x > 1
                   res *= x
                   x -= 1
               end
               return res
           end
       end |> only
CodeInfo(
1 ─     return (2, 6, 24)
) => Tuple{Int64, Int64, Int64}

julia> code_typed() do
           map((2,3,4)) do x
               res = 1
               0 ≤ x < 20 || error("bad fact")
               # usage 3:
               # with this :terminates_locally annotation the compiler skips tainting
               # `:terminates` effect within this `while` block, allowing the parent
               # anonymous function to be constant-folded
               Base.@assume_effects :terminates_locally while x > 1
                   res *= x
                   x -= 1
               end
               return res
           end
       end |> only
CodeInfo(
1 ─     return (2, 6, 24)
) => Tuple{Int64, Int64, Int64}
```

!!! compat "Julia 1.8"
    `Base.@assume_effects` を使用するには、Julia 1.8 以降が必要です。


!!! compat "Julia 1.10"
    関数本体内で使用するには、Julia 1.10 以降が必要です。


!!! compat "Julia 1.11"
    コードブロックの注釈には、Julia 1.11 以降が必要です。


!!! warning
    このマクロを不適切に使用すると、未定義動作（クラッシュ、誤った結果、その他追跡が困難なバグを含む）が発生します。慎重に扱い、絶対に必要な場合の最後の手段としてのみ使用してください。その場合でも、エフェクトのアサーションをできる限り弱めるためのあらゆる手段を講じるべきです（たとえば、`:nothrow` で十分な場合に `:total` を使わないでください）。


一般に、各 `setting` 値は、コンパイラーがその動作を証明することなく、関数の動作についてアサーションを行います。これらのアサーションは、すべてのワールドエイジに対して行われます。そのため、後から拡張されて前提を無効にする可能性のあるジェネリック関数の使用は制限することをお勧めします（前提が無効になると未定義動作が発生します）。

次の `setting` がサポートされています。

  * `:consistent`
  * `:effect_free`
  * `:nothrow`
  * `:terminates_globally`
  * `:terminates_locally`
  * `:notaskstate`
  * `:inaccessiblememonly`
  * `:noub`
  * `:noub_if_noinbounds`
  * `:nortcall`
  * `:foldable`
  * `:removable`
  * `:total`

# Extended help

---

## `:consistent`

`:consistent` の設定は、egal（`===`）な入力に対して、次のことをアサートします。

  * 終了の仕方（戻り値、例外、非終了）は常に同じである。
  * メソッドが戻る場合、結果は常に egal である。

!!! note
    これは特に、メソッドが新たに割り当てた可変オブジェクトを返してはならないことを意味します。可変オブジェクトを複数回割り当てた場合、内容が同一でも egal ではありません。


!!! note
    `:consistent`-cy アサーションは、特定のワールド範囲 `R` に対して行われます。より形式的には、ワールドエイジ ``i`` における ``f`` の評価を ``fᵢ`` と表すと、この設定は次を要求します。

    ```math
    ∀ i ∈ R, j ∈ R, x, y: x ≡ y → fᵢ(x) ≡ fⱼ(y)
    ```

    `@assume_effects` の場合、範囲 `R` は、注釈対象またはそれを含むメソッドの `m.primary_world:m.deleted_world` です。

    通常のコードインスタンスでは、`R` は `ci.min_world:ci.max_world` です。

    さらに、`:consistent` 関数は、指定されたワールドエイジ範囲内で一定でないヒープの状態やその他のグローバル状態に依存して戻り値を決めてはならないことも意味します。


!!! note
    `:consistent`-cy には、オプティマイザーが行うすべての合法な書き換えが含まれます。たとえば、浮動小数点数に対する fastmath 演算は `:consistent` とは見なされません。オプティマイザーが書き換えを行うと、同じワールドエイジであっても出力が `:consistent` でなくなる可能性があるためです（たとえば、一方がインタープリターで実行され、もう一方が最適化されて実行された場合）。


!!! note
    `:consistent` 関数が例外を投げて終了する場合、その例外自体は、上記の egal 性の要件を満たす必要はありません。


---

## `:effect_free`

`:effect_free` の設定は、メソッドに外部から意味的に観測可能な副作用がないことをアサートします。外部から意味的に観測可能な副作用の例を以下に示します（ただし、これらに限りません）。

  * グローバル変数の値を変更する。
  * 以下に記載する場合を除き、ヒープ（配列や可変値など）を変更する。
  * メソッドテーブルを変更する（たとえば、eval の呼び出しによる変更）。
  * ファイル、ネットワークなどへの入出力。
  * タスクの切り替え。

一方、観測可能な場合があっても、次のものは意味的に観測可能な副作用とは明示的に見なされません。

  * メモリの割り当て（可変・不変の両方）。
  * 経過時間。
  * ガベージコレクション。
  * メソッドの実行期間を超えて存続しないオブジェクト（つまり、メソッド内で割り当てられ、外部に逃げないオブジェクト）のヒープ変更。
  * 戻り値（外部からは見えますが、副作用ではありません）。

目安としては、関数が実行されなかった場合にプログラムの残りの実行に影響するものは、外部から観測可能な副作用です。

!!! note
    `:effect_free` アサーションは、メソッド自体と、そのメソッドによって実行されるすべてのコードに対して適用されます。このアサーションはすべてのワールドエイジで有効でなければならないため、使用は適切に制限してください。


---

## `:nothrow`

`:nothrow` の設定は、このメソッドが例外を投げないこと（つまり、値を返すか、戻らないかのいずれかであること）をアサートします。

!!! note
    `:nothrow` の注釈が付いたメソッドでも、例外をメソッドの外へ再送出しない限り、内部で例外処理を使用できます。


!!! note
    メソッドの実行によって `MethodError` などの例外が発生する可能性がある場合、そのメソッドは `:nothrow` とは見なされません。ただし、`StackOverflowError` や `InterruptException` のような環境依存のエラーは、このエフェクトではモデル化されません。そのため、`StackOverflowError` になる可能性のあるメソッドが、必ずしも `!:nothrow` である必要はありません（ただし、通常は `!:terminates` でもあるべきです）。


---

## `:terminates_globally`

`:terminates_globally` の設定は、このメソッドが最終的に（正常または異常に）終了し、無限ループしないことをアサートします。

!!! note
    この `:terminates_globally` アサーションは、注釈対象のメソッドが呼び出す他のすべてのメソッドにも適用されます。


!!! note
    コンパイラーは、この設定をメソッドが比較的*速く*終了する強い根拠と見なし、（他の条件が許せば）コンパイル時にこのメソッドを呼び出すことがあります。つまり、技術的には終了するものの、実用上は終了しないようなメソッドにこの設定を付けるのは得策ではありません。


---

## `:terminates_locally`

`:terminates_locally` の設定は `:terminates_globally` と似ていますが、注釈対象メソッド内の構文上の制御フローにのみ適用されます。そのため、より弱く安全性の高いアサーションであり、終了しない別のメソッドを呼び出した場合には、注釈対象メソッド自体が終了しない可能性を許容します。

!!! note
    `:terminates_globally` は `:terminates_locally` を含意します。


---

## `:notaskstate`

`:notaskstate` の設定は、このメソッドがタスクローカルストレージや RNG の状態など、ローカルなタスク状態を使用も変更もしないことをアサートします。そのため、観測可能な結果を変えることなく、タスク間で安全に移動できます。

!!! note
    例外処理の実装では、タスクオブジェクトに保存された状態を使用します。ただし、この状態は現在 `:notaskstate` の対象範囲とは見なされず、`:nothrow` エフェクトによって別途追跡されます。


!!! note
    `:notaskstate` アサーションが対象とするのは、*現在実行中のタスク*の状態です。どのタスクが*現在*実行中かを考慮しない別の手段で `Task` オブジェクトへの参照を取得した場合、`:notaskstate` エフェクトは汚染されないことがあります。そのタスクオブジェクトが現在実行中のタスクに対して `===` であっても同様です。


!!! note
    タスク状態へのアクセスは、通常、他のエフェクトも汚染します。たとえば、タスク状態を変更する場合は `:effect_free`、結果の計算にタスク状態を使用する場合は `:consistent` が汚染されます。特に、`:notaskstate` ではないものの、`:effect_free` かつ `:consistent` であるコードは、依然としてデッドコード除去の対象となり、`:total` に昇格することがあります。


---

## `:inaccessiblememonly`

`:inaccessiblememonly` の設定は、このメソッドが外部からアクセス可能な可変メモリにアクセスも変更もしないことをアサートします。つまり、メソッドから戻る前に他のメソッドやトップレベルの実行からアクセスできない新規割り当てオブジェクトの可変メモリであれば、アクセスや変更が可能です。一方、可変なグローバル状態や、引数が指す可変メモリにはアクセスも変更もできません。

!!! note
    この前提を無効にする例を以下に示します（ただし、これらに限りません）。

      * グローバル参照、または可変なグローバル変数にアクセスする `getglobal` 呼び出し。
      * グローバルへの代入、または定数でないグローバル変数に代入する `setglobal!` 呼び出し。
      * グローバルな可変変数のフィールドを変更する `setfield!` 呼び出し。


!!! note
    この `:inaccessiblememonly` アサーションは、注釈対象のメソッドが呼び出す他のすべてのメソッドにも適用されます。


---

## `:noub`

`:noub` の設定は、このメソッドが（どのような入力に対しても）未定義動作を実行しないことをアサートします。未定義動作によって、`:consistent` や `:effect_free` など、他のエフェクトに関するアサーションにも違反する可能性はあります。しかし、これはモデル化されておらず、各エフェクトは未定義動作がないことを前提としています。

---

## `:nortcall`

`:nortcall` の設定は、このメソッドが `Core.Compiler.return_type` を呼び出さず、また、このメソッドが呼び出す可能性のある他のメソッドも `Core.Compiler.return_type` を呼び出さないことをアサートします。

!!! note
    厳密には、実行時に `Core.Compiler.return_type` の呼び出しが行われない場合、つまり `Core.Compiler.return_type` の結果がコンパイル時に正確に判明し、オプティマイザーによって呼び出しが除去される場合には、このアサーションを使用できます。ただし、`Core.Compiler.return_type` の結果がコンパイル時に定数畳み込みされるかどうかは、コンパイラーの実装に大きく依存します。そのため、対象メソッドが何らかの形で `Core.Compiler.return_type` を使用する場合、このアサーションを行うのは一般に危険です。


---

## `:foldable`

この設定は、コンパイル時に呼び出しを定数畳み込みするためにコンパイラーが保証を必要とするエフェクト一式を、簡潔に指定するものです。現在は、次の `setting` と同等です。

  * `:consistent`
  * `:effect_free`
  * `:terminates_globally`
  * `:noub`
  * `:nortcall`

!!! note
    このリストには、特に `:nothrow` が含まれていません。コンパイラーは引き続き定数伝播を試み、コンパイル時に発生したエラーを記録します。ただし、`:consistent`-cy の要件により、この注釈が付いた呼び出しは、同じ引数値に対して常に一貫して例外を投げなければなりません。


!!! note
    関数内に明示的な `@inbounds` 注釈がある場合も、定数畳み込みは無効になります。この注釈は `:foldable` によってオーバーライドされません。


---

## `:removable`

この設定は、コンパイル時に結果が使われない呼び出しを確実に除去するためにコンパイラーが必要とするエフェクト一式を、簡潔に指定するものです。現在は、次の `setting` と同等です。

  * `:effect_free`
  * `:nothrow`
  * `:terminates_globally`

---

## `:total`

この `setting` は、可能な限り最大のエフェクト集合です。現在、次の他の `setting` を含意します。

  * `:consistent`
  * `:effect_free`
  * `:nothrow`
  * `:terminates_globally`
  * `:notaskstate`
  * `:inaccessiblememonly`
  * `:noub`
  * `:nortcall`

!!! warning
    `:total` は非常に強いアサーションであり、Julia の将来のバージョンでは追加の意味が加わる可能性があります（たとえば、エフェクトが追加され、`:total` の定義に含まれる場合）。そのため、慎重に使用してください。可能な限り、用途に必要な最小限の具体的なエフェクトアサーションを使用してください。多数のエフェクトのオーバーライドを複数の関数に適用する場合は、`:total` を使うより、カスタムマクロを使うことをお勧めします。


---

## Negated effects

エフェクト名の前に `!` を付けると、先行するメタエフェクトからそのエフェクトを取り除くことを示せます。たとえば、`:total !:nothrow` は、呼び出しが一般には全域的である一方、例外を投げる可能性があることを示します。
