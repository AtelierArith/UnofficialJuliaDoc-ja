```julia
Base.@assume_effects setting... [ex]
```

コンパイラのエフェクト推論を上書きします。このマクロは、次のような複数の場面で使用できます。

1. メソッド定義の直前に置き、対象メソッドのエフェクト推論全体を上書きする。
2. 引数なしで関数本体内に置き、包含するメソッドのエフェクト推論全体を上書きする。
3. コードブロックに適用し、対象コードブロックのローカルなエフェクト推論を上書きする。

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
    `Base.@assume_effects`を使用するには、Julia 1.8以降が必要です。


!!! compat "Julia 1.10"
    関数本体内で使用するには、Julia 1.10以降が必要です。


!!! compat "Julia 1.11"
    コードブロックへの注釈には、Julia 1.11以降が必要です。


!!! warning
    このマクロを誤って使用すると、未定義動作（クラッシュ、誤った結果、その他の追跡が困難なバグを含む）が発生します。慎重に、また絶対に必要な場合の最終手段としてのみ使用してください。その場合でも、エフェクトのアサーションをできる限り弱めるため、あらゆる手段を講じるべきです（たとえば、`:nothrow`で十分な場合に`:total`を使わないでください）。


一般に、各`setting`値は、コンパイラにその動作が真であることを証明させることなく、関数の動作についてアサーションを行います。これらのアサーションは、すべてのワールドエイジに対して行われます。そのため、後から拡張されて前提を無効にする可能性のある汎用関数の使用は制限することを推奨します（前提が無効になると未定義動作が発生します）。

次の`setting`がサポートされています。

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

`:consistent`設定は、egal（`===`）な入力に対して、次のことをアサートします。

  * 終了の仕方（戻り値、例外、非終了）は常に同じである。
  * メソッドが戻る場合、結果は常にegalである。

!!! note
    つまり、メソッドは新たに割り当てた可変オブジェクトを返してはなりません。可変オブジェクトを複数回割り当てた場合、内容が同一でもegalではありません。


!!! note
    `:consistent`-cyアサーションは、特定のワールド範囲`R`に対して行われます。より形式的には、ワールドエイジ``i``における``f``の評価を``fᵢ``と表すと、この設定は次を要求します。

    ```math
    ∀ i ∈ R, j ∈ R, x, y: x ≡ y → fᵢ(x) ≡ fⱼ(y)
    ```

    `@assume_effects`の場合、範囲`R`は、注釈対象またはそれを含むメソッドの`m.primary_world:m.deleted_world`です。

    通常のコードインスタンスでは、`R`は`ci.min_world:ci.max_world`です。

    さらに、`:consistent`関数は、指定されたワールドエイジ範囲全体で一定ではないヒープの状態やその他のグローバル状態に依存して、戻り値を決めてはなりません。


!!! note
    `:consistent`-cyには、オプティマイザーが行うすべての合法な書き換えが含まれます。たとえば、浮動小数点数に対するfastmath演算は`:consistent`とは見なされません。オプティマイザーが書き換えを行うと、同じワールドエイジであっても出力が`:consistent`でなくなる可能性があるためです（たとえば、一方がインタープリターで実行され、もう一方が最適化されていた場合）。


!!! note
    `:consistent`関数が例外をスローして終了する場合、その例外自体は上記のegal要件を満たす必要はありません。


---

## `:effect_free`

`:effect_free`設定は、そのメソッドに外部から意味的に観測可能な副作用がないことをアサートします。外部から意味的に観測可能な副作用の例を以下に示します（ただし、これらに限りません）。

  * グローバル変数の値を変更する。
  * ヒープを変更する（配列や可変値など。ただし、後述の例外を除く）。
  * メソッドテーブルを変更する（evalの呼び出しなど）。
  * ファイル、ネットワークなどへのI/O。
  * タスクの切り替え。

一方、観測可能な場合があっても、次のものは意味的に観測可能な副作用とは明示的に見なされません。

  * メモリの割り当て（可変・不変の両方）。
  * 経過時間。
  * ガベージコレクション。
  * メソッドの実行期間を超えて存続しないオブジェクト（メソッド内で割り当てられ、外部に逃げないオブジェクト）のヒープ変更。
  * 戻り値（外部からは見えるが、副作用ではない）。

目安として、関数が実行されなかった場合にプログラムの残りの実行に影響するものは、外部から観測可能な副作用です。

!!! note
    `:effect_free`アサーションは、メソッド自体と、そのメソッドが実行するすべてのコードに対して適用されます。このアサーションはすべてのワールドエイジで有効でなければならないため、使用は適切に制限してください。


---

## `:nothrow`

`:nothrow`設定は、このメソッドが例外をスローしない（つまり、値を返すか、戻らない）ことをアサートします。

!!! note
    `:nothrow`の注釈が付いたメソッドでも、例外をメソッドの外へ再スローしない限り、内部で例外処理を使用できます。


!!! note
    メソッドの実行によって`MethodError`などの例外が発生する可能性がある場合、そのメソッドは`:nothrow`とは見なされません。ただし、`StackOverflowError`や`InterruptException`のような環境依存のエラーは、このエフェクトではモデル化されません。そのため、`StackOverflowError`が発生する可能性のあるメソッドが、必ずしも`!:nothrow`である必要はありません（ただし、通常は`!:terminates`でもあるべきです）。


---

## `:terminates_globally`

`:terminates_globally`設定は、このメソッドが最終的に（正常または異常に）終了し、無限ループしないことをアサートします。

!!! note
    この`:terminates_globally`アサーションは、注釈対象のメソッドが呼び出す他のメソッドにも適用されます。


!!! note
    コンパイラは、このアサーションをメソッドが比較的*速く*終了する強い根拠として扱い、他の条件が許せばコンパイル時にこのメソッドを呼び出すことがあります。つまり、*理論上は*終了するものの、*実際には*終了しないメソッドにこの設定を注釈するのは避けてください。


---

## `:terminates_locally`

`:terminates_locally`設定は`:terminates_globally`と似ていますが、注釈対象メソッド*内*の構文上の制御フローにのみ適用されます。そのため、より弱く安全性の高いアサーションであり、終了しない別のメソッドを呼び出した場合には、対象メソッド自体が終了しない可能性を許容します。

!!! note
    `:terminates_globally`は`:terminates_locally`を含意します。


---

## `:notaskstate`

`:notaskstate`設定は、このメソッドがタスクローカルストレージや乱数生成器の状態など、ローカルなタスク状態を使用も変更もしないことをアサートします。したがって、観測可能な結果に影響を与えずにタスク間で安全に移動できます。

!!! note
    例外処理の実装では、タスクオブジェクトに保存された状態を使用します。ただし、この状態は現在`:notaskstate`の対象範囲とは見なされず、`:nothrow`エフェクトで別途追跡されます。


!!! note
    `:notaskstate`アサーションが対象とするのは、*現在実行中のタスク*の状態です。*現在*実行中のタスクを考慮しない別の手段で`Task`オブジェクトへの参照を取得した場合、`:notaskstate`エフェクトが汚染されるとは限りません。参照先のタスクオブジェクトが、現在実行中のタスクに対して`===`であっても同様です。


!!! note
    タスク状態へのアクセスは通常、他のエフェクトも汚染します。たとえば、タスク状態を変更する場合は`:effect_free`、結果の計算にタスク状態を使う場合は`:consistent`が汚染されます。特に、`:notaskstate`ではないものの、`:effect_free`かつ`:consistent`であるコードは、デッドコード除去の対象となり、`:total`へ昇格する場合があります。


---

## `:inaccessiblememonly`

`:inaccessiblememonly`設定は、このメソッドが外部からアクセス可能な可変メモリにアクセスも変更もしないことをアサートします。つまり、メソッドは新たに割り当てたオブジェクトの可変メモリであれば、メソッドから戻る前に他のメソッドやトップレベルの実行からアクセスできない限り、アクセスまたは変更できます。一方、可変なグローバル状態や、引数が指す可変メモリにはアクセスも変更もできません。

!!! note
    この前提を無効にする例を以下に示します（ただし、これらに限りません）。

      * グローバル参照、または可変なグローバル変数にアクセスするための`getglobal`呼び出し。
      * グローバルへの代入、または定数ではないグローバル変数に代入するための`setglobal!`呼び出し。
      * グローバルな可変変数のフィールドを変更する`setfield!`呼び出し。


!!! note
    この`:inaccessiblememonly`アサーションは、注釈対象のメソッドが呼び出す他のすべてのメソッドにも適用されます。


---

## `:noub`

`:noub`設定は、このメソッドが（どのような入力に対しても）未定義動作を実行しないことをアサートします。未定義動作によって、メソッドが`:consistent`や`:effect_free`など、他のエフェクトアサーションにも違反する可能性はあります。しかし、これはモデル化されておらず、他のアサーションは未定義動作がないことを前提としています。

---

## `:nortcall`

`:nortcall`設定は、このメソッドが`Core.Compiler.return_type`を呼び出さず、また、このメソッドが呼び出す可能性のある他のメソッドも`Core.Compiler.return_type`を呼び出さないことをアサートします。

!!! note
    厳密には、実行時に`Core.Compiler.return_type`が呼び出されない場合、つまり`Core.Compiler.return_type`の結果がコンパイル時に正確に分かり、オプティマイザーによって呼び出しが除去される場合には、このアサーションを使用できます。ただし、`Core.Compiler.return_type`の結果がコンパイル時に定数畳み込みされるかどうかは、コンパイラの実装に大きく依存します。そのため、対象メソッドが何らかの形で`Core.Compiler.return_type`を使用する場合、このアサーションを行うのは一般に危険です。


---

## `:foldable`

この設定は、コンパイル時に呼び出しを定数畳み込みするためにコンパイラが保証を必要とするエフェクトの組み合わせを、簡潔に指定するものです。現在は、次の`setting`と同等です。

  * `:consistent`
  * `:effect_free`
  * `:terminates_globally`
  * `:noub`
  * `:nortcall`

!!! note
    特に、このリストには`:nothrow`が含まれていません。コンパイラは引き続き定数伝播を試み、コンパイル時にスローされたエラーを記録します。ただし、`:consistent`-cyの要件により、この注釈が付いた呼び出しは、同じ引数値に対して常に一貫して例外をスローしなければなりません。


!!! note
    関数内に明示的な`@inbounds`注釈がある場合も定数畳み込みは無効になり、`:foldable`によって上書きされることはありません。


---

## `:removable`

この設定は、コンパイル時に結果が使われない呼び出しを削除するために、コンパイラが保証を必要とするエフェクトの組み合わせを簡潔に指定するものです。現在は、次の`setting`と同等です。

  * `:effect_free`
  * `:nothrow`
  * `:terminates_globally`

---

## `:total`

この`setting`は、指定可能なエフェクトの最大の組み合わせです。現在、次の他の`setting`を含意します。

  * `:consistent`
  * `:effect_free`
  * `:nothrow`
  * `:terminates_globally`
  * `:notaskstate`
  * `:inaccessiblememonly`
  * `:noub`
  * `:nortcall`

!!! warning
    `:total`は非常に強いアサーションであり、Juliaの将来のバージョンでは意味が追加される可能性があります（たとえば、エフェクトが追加され、`:total`の定義に含まれる場合など）。そのため、慎重に使用してください。可能な限り、特定の用途に必要な最小限のエフェクトアサーションを使用してください。多数の関数に多くのエフェクト上書きを適用する場合は、`:total`を使うより、カスタムマクロを作成することを推奨します。


---

## Negated effects

エフェクト名の前に`!`を付けると、先行するメタエフェクトからそのエフェクトを除外できます。たとえば、`:total !:nothrow`は、呼び出しが一般には全域的であるものの、例外をスローする可能性があることを示します。
