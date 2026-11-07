# Control Flow

Juliaには、さまざまな制御フロー構文が用意されています。

  * [Compound Expressions](@ref man-compound-expressions): `begin`と`;`。
  * [Conditional Evaluation](@ref man-conditional-evaluation): `if`-`elseif`-`else`と`?:`（三項演算子）。
  * [Short-Circuit Evaluation](@ref): 論理演算子`&&`（「かつ」）と`||`（「または」）、および比較の連鎖。
  * [Repeated Evaluation: Loops](@ref man-loops): `while`と`for`。
  * [Exception Handling](@ref): `try`-`catch`、[`error`](@ref)、[`throw`](@ref)。
  * [Tasks (aka Coroutines)](@ref man-tasks): [`yieldto`](@ref)。

最初の5つの制御フローの仕組みは、高水準プログラミング言語では標準的なものです。一方、[`Task`](@ref)はそれほど一般的ではありません。これは非局所的な制御フローを提供し、一時停止中の計算を切り替えられるようにするものです。これは強力な構文であり、Juliaでは例外処理と協調的マルチタスクの両方がタスクを使って実装されています。日常的なプログラミングでタスクを直接使う必要はありませんが、タスクを使うとはるかに簡単に解ける問題もあります。

## [Compound Expressions](@id man-compound-expressions)

複数の部分式を順番に評価し、最後の部分式の値を全体の値として返す単一の式があると便利な場合があります。Juliaには、これを実現する構文が2つあります。`begin`ブロックと`;`による連鎖です。どちらの複合式も、その値は最後の部分式の値になります。`begin`ブロックの例を示します。

```jldoctest
julia> z = begin
           x = 1
           y = 2
           x + y
       end
3
```

これらはかなり短く単純な式なので、簡単に1行にまとめられます。そのようなときに便利なのが、`;`で式を連鎖させる構文です。

```jldoctest
julia> z = (x = 1; y = 2; x + y)
3
```

この構文は、[Functions](@ref man-functions)で紹介した簡潔な1行の関数定義形式で特に役立ちます。一般にはそのように書きますが、`begin`ブロックを複数行にする必要も、`;`による連鎖を1行にする必要もありません。

```jldoctest
julia> begin x = 1; y = 2; x + y end
3

julia> (x = 1;
        y = 2;
        x + y)
3
```

## [Conditional Evaluation](@id man-conditional-evaluation)

条件付き評価では、ブール式の値に応じて、コードの一部を評価するかどうかを決められます。`if`-`elseif`-`else`という条件構文は、次のような構造になっています。

```julia
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

条件式`x < y`が`true`なら、対応するブロックが評価されます。そうでなければ条件式`x > y`が評価され、それが`true`なら、対応するブロックが評価されます。どちらの式も真でなければ、`else`ブロックが評価されます。実際の動作を見てみましょう。

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

`elseif`ブロックと`else`ブロックは省略可能で、`elseif`ブロックは必要なだけ使用できます。`if`-`elseif`-`else`構文の条件式は、最初に`true`となる式が見つかるまで評価されます。その後、対応するブロックが評価され、それ以降の条件式やブロックは評価されません。

`if`ブロックは「外に漏れる」性質を持ちます。つまり、ローカルスコープを導入しません。このため、`if`の各節の内部で新しく定義した変数は、それ以前に定義されていなくても、`if`ブロックの後で使用できます。したがって、上記の`test`関数は次のようにも定義できます。

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

変数`relation`は`if`ブロックの内部で宣言されていますが、外部で使用されています。ただし、この動作を利用する場合は、考えられるすべてのコードパスで変数に値が定義されるようにしてください。上の関数を次のように変更すると、実行時エラーが発生します。

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

`if`ブロックも値を返します。多くの他の言語から移ってきたユーザーには、これは直感的でないかもしれません。その値は単に、選択された分岐で最後に実行された文の戻り値です。したがって、次のようになります。

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

Juliaでは、非常に短い条件文（1行で書けるもの）は、次の節で説明する短絡評価を使って表現されることが多い点に注意してください。

C、MATLAB、Perl、Python、Rubyとは異なり、Javaや、より厳密な型の規則を持ついくつかの言語と同様に、条件式の値が`true`でも`false`でもない場合はエラーになります。

```jldoctest
julia> if 1
           println("true")
       end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

このエラーは、条件の型が正しくないことを示しています。必要な型は[`Bool`](@ref)ですが、実際には[`Int64`](@ref)になっています。

いわゆる「三項演算子」`?:`は、`if`-`elseif`-`else`構文と密接に関連しています。ただし、長いコードブロックを条件に応じて実行するのではなく、単一の式の値を条件に応じて選択したい場合に使用します。この名前は、ほとんどの言語で3つのオペランドを取る唯一の演算子であることに由来します。

```julia
a ? b : c
```

`?`の前にある式`a`が条件式です。三項演算では、条件`a`が`true`なら、`:`の前にある式`b`を評価します。条件が`false`なら、`:`の後にある式`c`を評価します。`?`と`:`の前後の空白は必須であることに注意してください。`a?b:c`のような式は、有効な三項式ではありません。ただし、`?`と`:`の直後は、どちらも改行できます。

この動作を理解するには、例を見るのが一番です。先ほどの例では、`println`の呼び出しは3つの分岐すべてに共通しています。実際に選択しているのは、どの文字列リテラルを出力するかだけです。三項演算子を使えば、これをより簡潔に書けます。わかりやすいように、まずは2つの分岐がある場合を試してみましょう。

```jldoctest
julia> x = 1; y = 2;

julia> println(x < y ? "less than" : "not less than")
less than

julia> x = 1; y = 0;

julia> println(x < y ? "less than" : "not less than")
not less than
```

式`x < y`が真なら、三項演算式全体の評価結果は文字列`"less than"`となり、そうでなければ文字列`"not less than"`となります。元の3分岐の例では、三項演算子を複数つなげる必要があります。

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

連鎖しやすいように、この演算子は右から左に結合します。

重要なのは、`if`-`elseif`-`else`と同様に、`:`の前の式は条件式が`true`の場合にのみ、後の式は条件式が`false`の場合にのみ評価されることです。

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

Juliaの`&&`演算子と`||`演算子は、それぞれ論理積（「かつ」）と論理和（「または」）に対応し、通常はその目的で使われます。ただし、これらには*短絡評価*という追加の性質があります。以下で説明するように、第2引数を必ずしも評価しないのです。（ビット単位の演算子`&`と`|`もあり、短絡評価を*行わずに*論理積と論理和として使用できます。ただし、評価順序において`&`と`|`は、`&&`と`||`よりも優先順位が高い点に注意してください。）

短絡評価は、条件付き評価によく似ています。この動作は、ブール演算子`&&`と`||`を備えた、ほとんどの命令型プログラミング言語で見られます。これらの演算子でつながれた一連のブール式では、全体の最終的なブール値を決定するのに必要な最小限の式だけが評価されます。Pythonなどの一部の言語では、これらを`and`（`&&`）および`or`（`||`）と呼びます。具体的には、次のように動作します。

  * 式`a && b`では、`a`の評価結果が`true`の場合にのみ、部分式`b`が評価されます。
  * 式`a || b`では、`a`の評価結果が`false`の場合にのみ、部分式`b`が評価されます。

これは、`a`が`false`なら、`b`の値にかかわらず、`a && b`は必ず`false`になるためです。同様に、`a`が`true`なら、`b`の値にかかわらず、`a || b`の値は必ず真になります。`&&`と`||`はどちらも右結合ですが、`&&`は`||`より優先順位が高くなっています。この動作は簡単に試せます。

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

同じ方法で、`&&`演算子と`||`演算子のさまざまな組み合わせについて、結合規則と優先順位を簡単に試せます。

Juliaでは、この動作が非常に短い`if`文の代わりとしてよく使われます。`if <cond> <statement> end`の代わりに、`<cond> && <statement>`と書けます（「<cond>が成り立つ*ならば*<statement>」と読めます）。同様に、`if ! <cond> <statement> end`の代わりに、`<cond> || <statement>`と書けます（「<cond>が成り立つ、*さもなければ*<statement>」と読めます）。

たとえば、再帰的に階乗を計算するルーチンは、次のように定義できます。

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

短絡評価を*行わない*ブール演算には、[Mathematical Operations and Elementary Functions](@ref)で紹介したビット単位のブール演算子`&`と`|`を使用できます。これらは中置演算子の構文にも対応している通常の関数であり、引数は常に評価されます。

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

`if`、`elseif`、三項演算子で使う条件式と同様に、`&&`または`||`のオペランドはブール値（`true`または`false`）でなければなりません。条件の連鎖で、最後の要素以外にブール値でない値を使うとエラーになります。

```jldoctest
julia> 1 && true
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

一方、条件の連鎖の末尾には、どのような型の式でも使用できます。その式は、先行する条件に応じて評価され、その値が返されます。

```jldoctest
julia> true && (x = (1, 2, 3))
(1, 2, 3)

julia> false && (x = (1, 2, 3))
false
```

## [Repeated Evaluation: Loops](@id man-loops)

式を繰り返し評価するための構文は、`while`ループと`for`ループの2つです。`while`ループの例を示します。

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

`while`ループは条件式（この場合は`i <= 3`）を評価し、それが`true`である間、`while`ループの本体の評価も繰り返します。`while`ループに最初に到達したときに条件式が`false`なら、本体は一度も評価されません。

`for`ループを使うと、よくある反復評価のパターンを簡単に記述できます。上の`while`ループのように数値を増減させる処理は非常によく使われるため、`for`ループでより簡潔に表現できます。

```jldoctest
julia> for i = 1:3
           println(i)
       end
1
2
3
```

ここで`1:3`は、数列1、2、3を表す[`range`](@ref)オブジェクトです。`for`ループはこれらの値を順にたどり、それぞれを変数`i`に代入します。一般に、`for`構文は、任意の「反復可能」オブジェクト（または「コンテナ」）を反復処理できます。対象は、`1:3`や`1:3:13`（1、4、7、…、13という3刻みの整数を表す[`StepRange`](@ref)）のような範囲から、配列などのより一般的なコンテナ、さらには[iterators defined by user code](@ref man-interface-iteration)や外部パッケージで提供されるものまで含みます。範囲以外のコンテナでは、コードが読みやすくなるため、通常は`=`の代わりに、別のキーワード`in`または`∈`を使います。これらの意味は完全に同じです。

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

さまざまな種類の反復可能なコンテナについては、マニュアルの後の節で紹介し、説明します（たとえば[Multi-dimensional Arrays](@ref man-multi-dim-arrays)を参照してください）。

先ほどの`while`ループ形式と`for`ループ形式の重要な違いの1つは、変数が参照できるスコープです。`for`ループは、外側のスコープに同名の変数が存在するかどうかにかかわらず、本体内に新しい反復変数を常に導入します。つまり、`i`をループの前に宣言する必要はありません。一方、その変数をループの外から参照することはできず、外側にある同名の変数も影響を受けません。これを試すには、新しい対話セッションを開始するか、別の変数名を使う必要があります。

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

後者の動作を変更して既存のローカル変数を再利用するには、`for outer`を使ってください。

変数のスコープ、[`outer`](@ref)、およびJuliaでのその動作の詳細については、[Scope of Variables](@ref scope-of-variables)を参照してください。

`while`の条件が偽になる前に反復を終了したり、`for`ループで反復可能オブジェクトの末尾に達する前に反復を止めたりできると便利な場合があります。これには`break`キーワードを使用します。

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

`break`キーワードがなければ、上の`while`ループは自力では終了せず、`for`ループは1000まで反復します。`break`を使うことで、どちらのループも途中で抜けています。

別の状況では、現在の反復を打ち切って、すぐに次の反復に進めると便利です。これを実現するのが`continue`キーワードです。

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

この例はやや作為的です。条件を反転し、`println`の呼び出しを`if`ブロック内に置けば、同じ動作をもっと明確に表現できるためです。実際の使用では、`continue`の後にも評価すべきコードがあり、`continue`を呼び出す箇所も複数あることがよくあります。

入れ子になった複数の`for`ループは、1つの外側のループにまとめることができ、それぞれの反復可能オブジェクトの直積を構成します。

```jldoctest
julia> for i = 1:2, j = 3:4
           println((i, j))
       end
(1, 3)
(1, 4)
(2, 3)
(2, 4)
```

この構文でも、反復可能オブジェクトは外側のループ変数を参照できます。たとえば、`for i = 1:n, j = 1:i`は有効です。ただし、このようなループ内の`break`文は、内側のループだけでなく、入れ子のループ全体を終了します。両方の変数（`i`と`j`）は、内側のループが実行されるたびに、その反復での値に設定されます。そのため、`i`への代入は後続の反復には反映されません。

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

この例を、各変数にそれぞれ`for`キーワードを使う形に書き換えると、出力は異なります。2番目と4番目の値には`0`が含まれるようになります。

[`zip`](@ref)を使うと、1つの`for`ループで複数のコンテナを同時に反復処理できます。

```jldoctest
julia> for (j, k) in zip([1 2 3], [4 5 6 7])
           println((j,k))
       end
(1, 4)
(2, 5)
(3, 6)
```

[`zip`](@ref)を使うと、渡された各コンテナのサブイテレータを含むタプルからなるイテレータが作成されます。`zip`イテレータはすべてのサブイテレータを順にたどり、`for`ループの``i``回目の反復で、各サブイテレータの``i``番目の要素を選びます。いずれかのサブイテレータが尽きると、`for`ループは停止します。

## Exception Handling

予期しない状況が発生すると、関数は呼び出し元に妥当な値を返せなくなることがあります。そのような場合には、診断用のエラーメッセージを出力してプログラムを終了するか、プログラマーがその例外的な状況を処理するコードを用意していれば、そのコードで適切な処置を行えるようにするのが最善でしょう。

### Built-in `Exception`s

予期しない状況が発生すると、`Exception`がスローされます。以下に挙げる組み込みの`Exception`は、いずれも通常の制御フローを中断します。

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

たとえば、[`sqrt`](@ref)関数を負の実数値に適用すると、[`DomainError`](@ref)がスローされます。

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

独自の例外は、次のように定義できます。

```jldoctest
julia> struct MyCustomException <: Exception end
```

### The [`throw`](@ref) function

[`throw`](@ref)を使うと、明示的に例外を発生させられます。たとえば、非負の数に対してのみ定義される関数で、引数が負なら[`DomainError`](@ref)を[`throw`](@ref)するように記述できます。

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

括弧のない[`DomainError`](@ref)は、例外そのものではなく例外の型であることに注意してください。`Exception`オブジェクトを得るには、これを呼び出す必要があります。

```jldoctest
julia> typeof(DomainError(nothing)) <: Exception
true

julia> typeof(DomainError) <: Exception
false
```

また、一部の例外型は、エラーの報告に使う1つ以上の引数を取ります。

```jldoctest
julia> throw(UndefVarError(:x))
ERROR: UndefVarError: `x` not defined
```

この仕組みは、[`UndefVarError`](@ref)の実装方法にならえば、独自の例外型でも簡単に実装できます。

```jldoctest
julia> struct MyUndefVarError <: Exception
           var::Symbol
       end

julia> Base.showerror(io::IO, e::MyUndefVarError) = print(io, e.var, " not defined")
```

!!! note
    エラーメッセージを書く際には、最初の単語を小文字で始めることが推奨されます。たとえば、

    `size(A) == size(B) || throw(DimensionMismatch("size of A not equal to size of B"))`

    のほうが、次の書き方よりも推奨されます。

    `size(A) == size(B) || throw(DimensionMismatch("Size of A not equal to size of B"))`。

    ただし、関数の引数が大文字である場合など、先頭の大文字をそのままにするのが適切なこともあります。

    `size(A,1) == size(B,2) || throw(DimensionMismatch("A has first dimension..."))`。


### Errors

[`error`](@ref)関数は、通常の制御フローを中断する[`ErrorException`](@ref)を発生させるために使います。

負の数の平方根を求めようとしたら、すぐに実行を停止したいとします。そのためには、引数が負ならエラーを発生させる、厳格な[`sqrt`](@ref)関数を定義できます。

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

別の関数から負の値を渡して`fussy_sqrt`を呼び出すと、呼び出し元の関数の実行を続けようとはせず、直ちに制御を戻して対話セッションにエラーメッセージを表示します。

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

`try/catch`文を使うと、`Exception`の発生を検出し、通常ならアプリケーションを停止させかねない事態を適切に処理できます。たとえば、以下のコードでは、平方根を求める関数は通常なら例外をスローします。これを`try/catch`ブロックで囲むことで、その影響に対処できます。この例外をログに記録する、代わりの値を返す、あるいは以下の例のように単にメッセージを出力するなど、処理方法は自由に選べます。予期しない状況への対処方法を決める際には、`try/catch`ブロックを使うと、条件分岐でその状況を処理するよりもはるかに遅くなることを考慮してください。以下に、`try/catch`ブロックで例外を処理する例をさらに示します。

```jldoctest
julia> try
           sqrt("ten")
       catch e
           println("You should have entered a numeric value")
       end
You should have entered a numeric value
```

`try/catch`文では、`Exception`を変数に保存することもできます。次のやや作為的な例では、`x`に添字でアクセスできる場合、`x`の2番目の要素の平方根を計算します。それ以外の場合は、`x`を実数とみなし、その平方根を返します。

```jldoctest
julia> sqrt_second(x) = try
           sqrt(x[2])
       catch y
           if isa(y, DomainError)
               sqrt(complex(x[2], 0))
           elseif isa(y, BoundsError)
               sqrt(x)
           else
               rethrow() # ensure other exceptions can bubble up the call stack
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

julia> sqrt_second([1 nothing])
ERROR: MethodError: no method matching sqrt(::Nothing)
The function `sqrt` exists, but no method is defined for this combination of argument types.
[...]
```

上の例のように[`rethrow`](@ref)を使うと、元の例外を保持したままスタックの巻き戻しを続け、上位の例外ハンドラーでその例外を処理できるようになります。上のように例外の型で処理を振り分ける場合、他の型の例外が呼び出し元から隠されないよう、`else rethrow()`を含めることが重要な場合がよくあります。

`catch`の直後のシンボルは、常に例外の名前として解釈されることに注意してください。そのため、`try/catch`式を1行で書く際には注意が必要です。次のコードでは、エラー時に`x`の値を返すことは*できません*。

```julia
try bad() catch x end
```

代わりに、`catch`の後にセミコロンまたは改行を入れてください。

```julia
try bad() catch; x end

try bad()
catch
    x
end
```

`try/catch`構文の強みは、深く入れ子になった計算から、呼び出し関数のスタックのはるか上位の階層まで即座に巻き戻せることです。エラーが発生していなくても、スタックを巻き戻して上位の階層に値を渡したい状況もあります。Juliaには、より高度なエラー処理のために、[`backtrace`](@ref)、[`catch_backtrace`](@ref)、[`current_exceptions`](@ref)という関数が用意されています。

### `else` Clauses

!!! compat "Julia 1.8"
    この機能にはJulia 1.8以降が必要です。


エラー時に適切に対処するだけでなく、`try`ブロックが成功した場合にのみコードを実行したいこともあります。そのためには、`catch`ブロックの後に`else`節を指定できます。この節は、それ以前にエラーがスローされなかった場合に実行されます。このコードを`try`ブロック内に含める場合と比べた利点は、そこで新たに発生したエラーが`catch`節によって知らないうちに捕捉されることがない点です。

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
    `try`、`catch`、`else`、`finally`の各節は、それぞれ独自のスコープブロックを導入します。そのため、`try`ブロック内でのみ定義された変数には、`else`節や`finally`節からアクセスできません。

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

    外側のスコープ内のどこからでも変数にアクセスできるようにするには、`try`ブロックの外で[`local` keyword](@ref local-scope)を使ってください。


### `finally` Clauses

状態を変更したり、ファイルなどのリソースを使ったりするコードでは、通常、コードの終了時に後処理（ファイルを閉じるなど）が必要です。例外によって、コードブロックが通常の末尾に到達する前に終了することがあるため、この処理は複雑になりがちです。`finally`キーワードを使うと、指定したコードブロックをどのような形で抜けても、その際に特定のコードを実行できます。

たとえば、開いたファイルが確実に閉じられるようにするには、次のようにします。

```julia
f = open("file")
try
    # operate on file f
finally
    close(f)
end
```

制御が`try`ブロックを離れると（たとえば`return`による場合でも、単に正常終了した場合でも）、`close(f)`が実行されます。`try`ブロックが例外によって終了した場合、その例外の伝播は継続します。`catch`ブロックは、`try`や`finally`と組み合わせることもできます。その場合、`finally`ブロックは、`catch`がエラーを処理した後に実行されます。

`try/catch/else/finally`式を評価すると、式全体の値は、`finally`ブロックを除いて最後に実行されたブロックの値になります。たとえば、次のようになります。

```jldoctest
julia> try
           1
       finally
           2
       end
1

julia> try
           error("")
       catch
           1
       else
           2
       finally
           3
       end
1

julia> try
           0
       catch
           1
       else
           2
       finally
           3
       end
2
```

## [Tasks (aka Coroutines)](@id man-tasks)

タスクは、計算を柔軟に一時停止したり再開したりできる制御フロー機能です。ここでは網羅性のために触れるにとどめます。詳しい説明については、[Asynchronous Programming](@ref man-asynchronous)を参照してください。
