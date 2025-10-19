# Control Flow

Juliaはさまざまな制御フロー構文を提供します：

  * [Compound Expressions](@ref man-compound-expressions): `開始` と `;`。
  * [Conditional Evaluation](@ref man-conditional-evaluation): `if`-`elseif`-`else` と `?:` (三項演算子)。
  * [Short-Circuit Evaluation](@ref): 論理演算子 `&&` （「かつ」）および `||` （「または」）、さらに連鎖比較。
  * [Repeated Evaluation: Loops](@ref man-loops): `while` と `for`.
  * [Exception Handling](@ref): `try`-`catch`、[`error`](@ref) と [`throw`](@ref)。
  * [Tasks (aka Coroutines)](@ref man-tasks): [`yieldto`](@ref).

最初の5つの制御フローメカニズムは、高水準プログラミング言語に標準的です。 [`Task`](@ref) は標準的ではなく、非局所的な制御フローを提供し、一時的に中断された計算の間で切り替えることを可能にします。これは強力な構造であり、例外処理と協調的マルチタスクの両方がJuliaでタスクを使用して実装されています。日常のプログラミングではタスクを直接使用する必要はありませんが、特定の問題はタスクを使用することではるかに簡単に解決できます。

## [Compound Expressions](@id man-compound-expressions)

時々、いくつかのサブ式を順に評価し、最後のサブ式の値をその値として返す単一の式を持つことが便利です。これを達成するための2つのJulia構文があります：`begin`ブロックと`;`チェーンです。両方の複合式構文の値は、最後のサブ式の値です。以下は`begin`ブロックの例です：

```jldoctest
julia> z = begin
           x = 1
           y = 2
           x + y
       end
3
```

これらは比較的小さく、シンプルな式であるため、簡単に1行にまとめることができ、そこで `;` チェーン構文が役立ちます：

```jldoctest
julia> z = (x = 1; y = 2; x + y)
3
```

この構文は、[Functions](@ref man-functions) で導入された簡潔な単一行関数定義形式で特に便利です。典型的ではありますが、`begin` ブロックが複数行である必要はなく、`;` チェーンが単一行である必要もありません。

```jldoctest
julia> begin x = 1; y = 2; x + y end
3

julia> (x = 1;
        y = 2;
        x + y)
3
```

## [Conditional Evaluation](@id man-conditional-evaluation)

条件評価により、ブール式の値に応じてコードの一部を評価するかどうかを決定できます。以下は、`if`-`elseif`-`else` 条件構文の構造です：

```julia
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

条件式 `x < y` が `true` の場合、対応するブロックが評価されます。そうでない場合、条件式 `x > y` が評価され、もしそれが `true` であれば、対応するブロックが評価されます。どちらの式も `true` でない場合、`else` ブロックが評価されます。ここで実際に動作している様子です：

```jldoctest
julia> function test(x, y)
           if x < y
               println("x is less than y")
           elseif x > y
               println("x is greater than y")
           else
               println("x is equal to y")
           end
       end
test (generic function with 1 method)

julia> test(1, 2)
x is less than y

julia> test(2, 1)
x is greater than y

julia> test(1, 1)
x is equal to y
```

`elseif` および `else` ブロックはオプションであり、必要に応じて任意の数の `elseif` ブロックを使用できます。 `if`-`elseif`-`else` 構造内の条件式は、最初に `true` と評価されるものが見つかるまで評価され、その後、関連するブロックが評価され、以降の条件式やブロックは評価されません。

`if` ブロックは「漏れやすい」、つまりローカルスコープを導入しません。これは、`if` 条件内で定義された新しい変数が、`if` ブロックの後でも使用できることを意味します。したがって、上記の `test` 関数を次のように定義することができました。

```jldoctest
julia> function test(x,y)
           if x < y
               relation = "less than"
           elseif x == y
               relation = "equal to"
           else
               relation = "greater than"
           end
           println("x is ", relation, " y.")
       end
test (generic function with 1 method)

julia> test(2, 1)
x is greater than y.
```

変数 `relation` は `if` ブロック内で宣言されていますが、外部で使用されています。しかし、この動作に依存する場合は、すべての可能なコードパスで変数に値が定義されていることを確認してください。上記の関数への次の変更は、ランタイムエラーを引き起こします。

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> function test(x,y)
           if x < y
               relation = "less than"
           elseif x == y
               relation = "equal to"
           end
           println("x is ", relation, " y.")
       end
test (generic function with 1 method)

julia> test(1,2)
x is less than y.

julia> test(2,1)
ERROR: UndefVarError: `relation` not defined in local scope
Stacktrace:
 [1] test(::Int64, ::Int64) at ./none:7
```

`if` ブロックは値を返すこともあり、他の多くの言語から来たユーザーには直感的でないかもしれません。この値は、選択されたブランチで最後に実行されたステートメントの戻り値に過ぎません。

```jldoctest
julia> x = 3
3

julia> if x > 0
           "positive!"
       else
           "negative..."
       end
"positive!"
```

非常に短い条件文（ワンライナー）は、次のセクションで説明されているように、Juliaではショートサーキット評価を使用して頻繁に表現されます。

CやMATLAB、Perl、Python、Rubyとは異なり、Javaやいくつかの他の厳密な型付け言語のように、条件式の値が`true`または`false`以外である場合はエラーになります。

```jldoctest
julia> if 1
           println("true")
       end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

このエラーは、条件が間違ったタイプであったことを示しています： [`Int64`](@ref) ではなく、必要な [`Bool`](@ref) です。

いわゆる「三項演算子」、`?:`は、`if`-`elseif`-`else`構文に密接に関連していますが、単一の式値の間で条件付きの選択が必要な場合に使用され、長いコードブロックの条件付き実行とは対照的です。ほとんどの言語で三つのオペランドを取る唯一の演算子であることから、その名前が付けられています。

```julia
a ? b : c
```

式 `a` は `?` の前にある条件式であり、三項演算子は条件 `a` が `true` の場合は `:` の前にある式 `b` を評価し、`false` の場合は `:` の後にある式 `c` を評価します。`?` と `:` の周りのスペースは必須です：`a?b:c` のような式は有効な三項式ではありません（ただし、`?` と `:` の後に改行があるのは許容されます）。

この動作を理解する最も簡単な方法は、例を見ることです。前の例では、`println`の呼び出しは3つのブランチすべてで共有されています：実際の選択はどのリテラル文字列を印刷するかだけです。これは三項演算子を使用してより簡潔に書くことができます。明確さのために、まずは二項バージョンを試してみましょう：

```jldoctest
julia> x = 1; y = 2;

julia> println(x < y ? "less than" : "not less than")
less than

julia> x = 1; y = 0;

julia> println(x < y ? "less than" : "not less than")
not less than
```

`x < y`が真であれば、全体の三項演算子の式は文字列`"less than"`に評価され、そうでなければ文字列`"not less than"`に評価されます。元の三者の例では、三項演算子を複数回連鎖させる必要があります：

```jldoctest
julia> test(x, y) = println(x < y ? "x is less than y"    :
                            x > y ? "x is greater than y" : "x is equal to y")
test (generic function with 1 method)

julia> test(1, 2)
x is less than y

julia> test(2, 1)
x is greater than y

julia> test(1, 1)
x is equal to y
```

チェイニングを容易にするために、演算子は右から左に結合します。

`if`-`elseif`-`else`と同様に、`:`の前後の式は、条件式がそれぞれ`true`または`false`に評価される場合にのみ評価されることが重要です。

```jldoctest
julia> v(x) = (println(x); x)
v (generic function with 1 method)

julia> 1 < 2 ? v("yes") : v("no")
yes
"yes"

julia> 1 > 2 ? v("yes") : v("no")
no
"no"
```

## Short-Circuit Evaluation

`&&` および `||` 演算子は、Julia において論理の「かつ」と「または」の操作に対応しており、通常はこの目的で使用されます。しかし、これらには *ショートサーキット* 評価の追加の特性があります：以下に説明するように、必ずしも第二引数を評価するわけではありません。（ビット単位の `&` および `|` 演算子もあり、ショートサーキットの動作なしに論理の「かつ」と「または」として使用できますが、評価順序において `&` と `|` は `&&` と `||` よりも優先順位が高いことに注意してください。）

ショートサーキット評価は、条件評価に非常に似ています。この動作は、`&&` および `||` ブール演算子を持つほとんどの命令型プログラミング言語に見られます：これらの演算子で接続された一連のブール式の中で、全体のチェーンの最終的なブール値を決定するために必要な最小限の式のみが評価されます。一部の言語（Pythonのような）は、これらを `and` (`&&`) および `or` (`||`) と呼びます。明示的には、これは次のことを意味します：

  * 式 `a && b` において、部分式 `b` は `a` が `true` に評価される場合にのみ評価されます。
  * 式 `a || b` において、部分式 `b` は `a` が `false` に評価される場合にのみ評価されます。

理由は、`a && b`は`a`が`false`であれば`false`でなければならず、`b`の値に関係なく、同様に`a || b`の値は`a`が`true`であれば`true`でなければならないということです。`&&`と`||`は右に結合しますが、`&&`は`||`よりも優先順位が高いです。この動作を実験するのは簡単です：

```jldoctest tandf
julia> t(x) = (println(x); true)
t (generic function with 1 method)

julia> f(x) = (println(x); false)
f (generic function with 1 method)

julia> t(1) && t(2)
1
2
true

julia> t(1) && f(2)
1
2
false

julia> f(1) && t(2)
1
false

julia> f(1) && f(2)
1
false

julia> t(1) || t(2)
1
true

julia> t(1) || f(2)
1
true

julia> f(1) || t(2)
1
2
true

julia> f(1) || f(2)
1
2
false
```

`&&` および `||` 演算子のさまざまな組み合わせの結合性と優先順位を使って、同じように簡単に実験できます。

この動作は、非常に短い `if` 文の代替を形成するために、Julia で頻繁に使用されます。`if <cond> <statement> end` の代わりに、`<cond> && <statement>` と書くことができます（これは、<cond> *そしてその後* <statement> と読むことができます）。同様に、`if ! <cond> <statement> end` の代わりに、`<cond> || <statement>` と書くことができます（これは、<cond> *またはそうでなければ* <statement> と読むことができます）。

例えば、再帰的な階乗ルーチンは次のように定義できます：

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> function fact(n::Int)
           n >= 0 || error("n must be non-negative")
           n == 0 && return 1
           n * fact(n-1)
       end
fact (generic function with 1 method)

julia> fact(5)
120

julia> fact(0)
1

julia> fact(-1)
ERROR: n must be non-negative
Stacktrace:
 [1] error at ./error.jl:33 [inlined]
 [2] fact(::Int64) at ./none:2
 [3] top-level scope
```

ブール演算は、[Mathematical Operations and Elementary Functions](@ref)で導入されたビット単位のブール演算子`&`と`|`を使用して、ショートサーキット評価なしで行うことができます。これらは通常の関数であり、偶然にも中置演算子構文をサポートしていますが、常にその引数を評価します：

```jldoctest tandf
julia> f(1) & t(2)
1
2
false

julia> t(1) | t(2)
1
2
true
```

`if`、`elseif`、または三項演算子で使用される条件式と同様に、`&&` または `||` のオペランドはブール値（`true` または `false`）でなければなりません。条件チェーンの最後のエントリ以外で非ブール値を使用することはエラーです：

```jldoctest
julia> 1 && true
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

一方で、条件チェーンの最後には任意のタイプの式を使用できます。それは評価され、前の条件に応じて返されます：

```jldoctest
julia> true && (x = (1, 2, 3))
(1, 2, 3)

julia> false && (x = (1, 2, 3))
false
```

## [Repeated Evaluation: Loops](@id man-loops)

繰り返し評価のための2つの構文があります：`while` ループと `for` ループ。以下は `while` ループの例です：

```jldoctest
julia> i = 1;

julia> while i <= 3
           println(i)
           global i += 1
       end
1
2
3
```

`while` ループは条件式（この場合は `i <= 3`）を評価し、それが `true` の間は `while` ループの本体も評価し続けます。最初に `while` ループに到達したときに条件式が `false` であれば、本体は決して評価されません。

`for` ループは、一般的な繰り返し評価のイディオムを簡単に記述できるようにします。上記の `while` ループのようにカウントアップやカウントダウンを行うことは非常に一般的であるため、`for` ループを使ってより簡潔に表現できます。

```jldoctest
julia> for i = 1:3
           println(i)
       end
1
2
3
```

Here the `1:3` is a [`range`](@ref) object, representing the sequence of numbers 1, 2, 3. The `for` loop iterates through these values, assigning each one in turn to the variable `i`. In general, the `for` construct can loop over any "iterable" object (or "container"), from a  range like `1:3` or `1:3:13` (a [`StepRange`](@ref) indicating every 3rd integer 1, 4, 7, …, 13) to more generic containers like arrays, including [iterators defined by user code](@ref man-interface-iteration) or external packages. For containers other than ranges, the alternative (but fully equivalent) keyword `in` or `∈` is typically used instead of `=`, since it makes the code read more clearly:

```jldoctest
julia> for i in [1,4,0]
           println(i)
       end
1
4
0

julia> for s ∈ ["foo","bar","baz"]
           println(s)
       end
foo
bar
baz
```

マニュアルの後のセクションでは、さまざまなタイプのイテラブルコンテナが紹介され、議論されます（例えば、[Multi-dimensional Arrays](@ref man-multi-dim-arrays)を参照）。

前の `while` ループ形式と `for` ループ形式の間の重要な違いの一つは、変数が可視である期間のスコープです。`for` ループは、同じ名前の変数が囲むスコープに存在するかどうかに関わらず、常にその本体内で新しい反復変数を導入します。これは、一方で `i` をループの前に宣言する必要がないことを意味します。他方で、ループの外では `i` は可視ではなく、同じ名前の外部変数にも影響を与えません。これをテストするには、新しいインタラクティブセッションインスタンスまたは異なる変数名が必要です。

```jldoctest
julia> for j = 1:3
           println(j)
       end
1
2
3

julia> j
ERROR: UndefVarError: `j` not defined in `Main`
```

```jldoctest
julia> j = 0;

julia> for j = 1:3
           println(j)
       end
1
2
3

julia> j
0
```

`for outer`を使用して後者の動作を修正し、既存のローカル変数を再利用します。

[Scope of Variables](@ref scope-of-variables)の詳細な説明を参照してください。変数のスコープについて、[`outer`](@ref)、およびそれがJuliaでどのように機能するかについて説明しています。

`while`の繰り返しをテスト条件が偽になる前に終了させたり、`for`ループでイテラブルオブジェクトの最後に達する前に繰り返しを停止させることが便利な場合があります。これは`break`キーワードを使って実現できます：

```jldoctest
julia> i = 1;

julia> while true
           println(i)
           if i >= 3
               break
           end
           global i += 1
       end
1
2
3

julia> for j = 1:1000
           println(j)
           if j >= 3
               break
           end
       end
1
2
3
```

`break` キーワードがなければ、上記の `while` ループは自動的に終了することはなく、`for` ループは 1000 回まで繰り返されます。これらのループはどちらも `break` を使用して早期に終了します。

他の状況では、イテレーションを停止してすぐに次のイテレーションに移ることができるのは便利です。`continue`キーワードはこれを実現します：

```jldoctest
julia> for i = 1:10
           if i % 3 != 0
               continue
           end
           println(i)
       end
3
6
9
```

これはやや作り込まれた例です。なぜなら、条件を否定し、`if`ブロック内に`println`呼び出しを置くことで、同じ動作をより明確に示すことができるからです。現実的な使用では、`continue`の後に評価されるコードがもっとあり、しばしば`continue`を呼び出すポイントが複数存在します。

複数のネストされた `for` ループは、単一の外側のループに結合することができ、そのイテラブルの直積を形成します：

```jldoctest
julia> for i = 1:2, j = 3:4
           println((i, j))
       end
(1, 3)
(1, 4)
(2, 3)
(2, 4)
```

この構文では、イテラブルは外側のループ変数を参照することができます。例えば、`for i = 1:n, j = 1:i` は有効です。しかし、そのようなループ内の `break` 文は、内側のループだけでなく、すべてのループのネストを終了します。両方の変数（`i` と `j`）は、内側のループが実行されるたびに現在のイテレーション値に設定されます。したがって、`i` への代入は、後続のイテレーションには表示されません。

```jldoctest
julia> for i = 1:2, j = 3:4
           println((i, j))
           i = 0
       end
(1, 3)
(1, 4)
(2, 3)
(2, 4)
```

この例が各変数に対して `for` キーワードを使用するように書き直されると、出力は異なります：2 番目と 4 番目の値は `0` を含むことになります。

複数のコンテナを同時に単一の `for` ループで反復処理することができます [`zip`](@ref)：

```jldoctest
julia> for (j, k) in zip([1 2 3], [4 5 6 7])
           println((j,k))
       end
(1, 4)
(2, 5)
(3, 6)
```

[`zip`](@ref)を使用すると、渡されたコンテナのサブイテレータを含むタプルを持つイテレータが作成されます。`zip`イテレータは、すべてのサブイテレータを順番に反復し、`for`ループの$i$回目の反復で各サブイテレータの$i$番目の要素を選択します。いずれかのサブイテレータが尽きると、`for`ループは停止します。

## Exception Handling

予期しない条件が発生した場合、関数は呼び出し元に合理的な値を返すことができない場合があります。そのような場合、例外的な条件は、診断エラーメッセージを印刷しながらプログラムを終了させるか、プログラマーがそのような例外的な状況を処理するためのコードを提供している場合は、そのコードに適切なアクションを取らせるのが最善かもしれません。

### Built-in `Exception`s

`Exception`は、予期しない条件が発生したときにスローされます。以下に示す組み込みの`Exception`はすべて、制御の通常の流れを中断します。

| `Exception`                   |
|:----------------------------- |
| [`ArgumentError`](@ref)       |
| [`BoundsError`](@ref)         |
| [`CompositeException`](@ref)  |
| [`DimensionMismatch`](@ref)   |
| [`DivideError`](@ref)         |
| [`DomainError`](@ref)         |
| [`EOFError`](@ref)            |
| [`ErrorException`](@ref)      |
| [`FieldError`](@ref)          |
| [`InexactError`](@ref)        |
| [`InitError`](@ref)           |
| [`InterruptException`](@ref)  |
| `InvalidStateException`       |
| [`KeyError`](@ref)            |
| [`LoadError`](@ref)           |
| [`OutOfMemoryError`](@ref)    |
| [`ReadOnlyMemoryError`](@ref) |
| [`RemoteException`](@ref)     |
| [`MethodError`](@ref)         |
| [`OverflowError`](@ref)       |
| [`Meta.ParseError`](@ref)     |
| [`SystemError`](@ref)         |
| [`TypeError`](@ref)           |
| [`UndefRefError`](@ref)       |
| [`UndefVarError`](@ref)       |
| [`StringIndexError`](@ref)    |

例えば、[`sqrt`](@ref) 関数は、負の実数値に適用されると [`DomainError`](@ref) をスローします：

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

独自の例外を次のように定義できます：

```jldoctest
julia> struct MyCustomException <: Exception end
```

### The [`throw`](@ref) function

例外は、[`throw`](@ref)を使用して明示的に作成できます。たとえば、非負の数に対してのみ定義された関数は、引数が負の場合に[`DomainError`](@ref)を書くことができます。

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> f(x) = x>=0 ? exp(-x) : throw(DomainError(x, "argument must be non-negative"))
f (generic function with 1 method)

julia> f(1)
0.36787944117144233

julia> f(-1)
ERROR: DomainError with -1:
argument must be non-negative
Stacktrace:
 [1] f(::Int64) at ./none:1
```

[`DomainError`](@ref) の括弧なしは例外ではなく、例外の一種です。`Exception` オブジェクトを取得するには呼び出す必要があります：

```jldoctest
julia> typeof(DomainError(nothing)) <: Exception
true

julia> typeof(DomainError) <: Exception
false
```

さらに、一部の例外タイプは、エラー報告に使用される1つ以上の引数を取ります：

```jldoctest
julia> throw(UndefVarError(:x))
ERROR: UndefVarError: `x` not defined
```

このメカニズムは、[`UndefVarError`](@ref) の書き方に従ってカスタム例外タイプを使用することで簡単に実装できます。

```jldoctest
julia> struct MyUndefVarError <: Exception
           var::Symbol
       end

julia> Base.showerror(io::IO, e::MyUndefVarError) = print(io, e.var, " not defined")
```

!!! note
    エラーメッセージを書く際は、最初の単語を小文字にすることが推奨されます。例えば、

    `size(A) == size(B) || throw(DimensionMismatch("AのサイズはBのサイズと等しくありません"))`

    好ましいのは

    `size(A) == size(B) || throw(DimensionMismatch("AのサイズはBのサイズと等しくありません"))`

    しかし、時には関数への引数が大文字の文字である場合など、大文字の最初の文字を保持することが理にかなうことがあります。

    `size(A,1) == size(B,2) || throw(DimensionMismatch("Aの最初の次元が..."))`


### Errors

[`error`](@ref) 関数は、通常の制御フローを中断する [`ErrorException`](@ref) を生成するために使用されます。

負の数の平方根を取る場合に即座に実行を停止したいとします。これを実現するために、引数が負の場合にエラーを発生させる[`sqrt`](@ref)関数のファジー版を定義できます：

```jldoctest fussy_sqrt; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> fussy_sqrt(x) = x >= 0 ? sqrt(x) : error("negative x not allowed")
fussy_sqrt (generic function with 1 method)

julia> fussy_sqrt(2)
1.4142135623730951

julia> fussy_sqrt(-1)
ERROR: negative x not allowed
Stacktrace:
 [1] error at ./error.jl:33 [inlined]
 [2] fussy_sqrt(::Int64) at ./none:1
 [3] top-level scope
```

`fussy_sqrt`が別の関数から負の値で呼び出された場合、呼び出し元の関数の実行を続行しようとするのではなく、すぐに戻り、インタラクティブセッションにエラーメッセージを表示します:

```jldoctest fussy_sqrt; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> function verbose_fussy_sqrt(x)
           println("before fussy_sqrt")
           r = fussy_sqrt(x)
           println("after fussy_sqrt")
           return r
       end
verbose_fussy_sqrt (generic function with 1 method)

julia> verbose_fussy_sqrt(2)
before fussy_sqrt
after fussy_sqrt
1.4142135623730951

julia> verbose_fussy_sqrt(-1)
before fussy_sqrt
ERROR: negative x not allowed
Stacktrace:
 [1] error at ./error.jl:33 [inlined]
 [2] fussy_sqrt at ./none:1 [inlined]
 [3] verbose_fussy_sqrt(::Int64) at ./none:3
 [4] top-level scope
```

### The `try/catch` statement

`try/catch` 文は、`Exception` をテストし、通常はアプリケーションを壊す可能性のある事柄を優雅に処理することを可能にします。例えば、以下のコードでは平方根の関数が通常例外をスローします。それを `try/catch` ブロックで囲むことで、ここでそれを軽減できます。この例外をどのように処理するかは、ログを記録する、プレースホルダー値を返す、または以下のケースのように単にステートメントを出力するなど、あなたの選択次第です。予期しない状況を処理する方法を決定する際に考慮すべきことの一つは、`try/catch` ブロックを使用することは、条件分岐を使用してそれらの状況を処理するよりもはるかに遅いということです。以下には、`try/catch` ブロックを使用した例外処理のさらなる例があります。

```jldoctest
julia> try
           sqrt("ten")
       catch e
           println("You should have entered a numeric value")
       end
You should have entered a numeric value
```

`try/catch` 文は、`Exception` を変数に保存することも可能です。以下の例では、`x` がインデックス可能であれば `x` の2番目の要素の平方根を計算し、そうでなければ `x` が実数であると仮定してその平方根を返します：

```jldoctest
julia> sqrt_second(x) = try
           sqrt(x[2])
       catch y
           if isa(y, DomainError)
               sqrt(complex(x[2], 0))
           elseif isa(y, BoundsError)
               sqrt(x)
           end
       end
sqrt_second (generic function with 1 method)

julia> sqrt_second([1 4])
2.0

julia> sqrt_second([1 -4])
0.0 + 2.0im

julia> sqrt_second(9)
3.0

julia> sqrt_second(-9)
ERROR: DomainError with -9.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

`catch`の後に続くシンボルは常に例外の名前として解釈されるため、1行で`try/catch`式を書く際には注意が必要です。以下のコードは、エラーが発生した場合に`x`の値を返すためには*機能しません*：

```julia
try bad() catch x end
```

代わりに、`catch`の後にセミコロンを使用するか、改行を挿入してください：

```julia
try bad() catch; x end

try bad()
catch
    x
end
```

`try/catch` 構文の力は、深くネストされた計算を呼び出し関数のスタックのはるか上のレベルに即座に戻す能力にあります。エラーが発生していない状況でも、スタックを戻して値を上位レベルに渡す能力が望ましい場合があります。Julia は、より高度なエラーハンドリングのために [`rethrow`](@ref)、[`backtrace`](@ref)、[`catch_backtrace`](@ref) および [`current_exceptions`](@ref) 関数を提供しています。

### `else` Clauses

!!! compat "Julia 1.8"
    この機能は少なくともJulia 1.8が必要です。


場合によっては、エラーケースを適切に処理するだけでなく、`try`ブロックが成功した場合にのみコードを実行したいこともあります。そのためには、`catch`ブロックの後に`else`句を指定することができ、これは以前にエラーがスローされなかった場合に実行されます。このコードを`try`ブロックに含めることの利点は、さらなるエラーが`catch`句によって静かに捕まえられないことです。

```julia
local x
try
    x = read("file", String)
catch
    # handle read errors
else
    # do something with x
end
```

!!! note
    `try`、`catch`、`else`、および `finally` の各節はそれぞれ独自のスコープブロックを導入するため、変数が `try` ブロック内でのみ定義されている場合、`else` または `finally` 節からはアクセスできません。

    ```jldoctest
    julia> try
               foo = 1
           catch
           else
               foo
           end
    ERROR: UndefVarError: `foo` not defined in `Main`
    Suggestion: check for spelling errors or missing imports.
    ```

    Use the [`local` keyword](@ref local-scope) outside the `try` block to make the variable accessible from anywhere within the outer scope.


### `finally` Clauses

状態変更を行ったり、ファイルのようなリソースを使用するコードでは、コードが終了したときに行う必要があるクリーンアップ作業（ファイルを閉じるなど）が通常あります。例外はこの作業を複雑にする可能性があり、例外が発生するとコードのブロックが通常の終了に達する前に終了することがあります。`finally`キーワードは、特定のコードブロックがどのように終了しても、コードを実行する方法を提供します。

例えば、開いたファイルが閉じられていることを保証する方法は次のとおりです：

```julia
f = open("file")
try
    # operate on file f
finally
    close(f)
end
```

`try` ブロックを制御が離れると（例えば `return` による場合や、単に正常に終了する場合）、`close(f)` が実行されます。`try` ブロックが例外によって終了した場合、例外は引き続き伝播します。`catch` ブロックは `try` と `finally` と組み合わせることもできます。この場合、`finally` ブロックは `catch` がエラーを処理した後に実行されます。

## [Tasks (aka Coroutines)](@id man-tasks)

タスクは、計算を柔軟に一時停止および再開できる制御フロー機能です。ここでは完全性のために言及するだけです。詳細な議論については [Asynchronous Programming](@ref man-asynchronous) を参照してください。
