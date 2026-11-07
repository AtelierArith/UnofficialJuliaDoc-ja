# Control Flow

Juliaには、さまざまな制御フロー構文が用意されています。

  * [Compound Expressions](@ref man-compound-expressions): `begin`と`;`。
  * [Conditional Evaluation](@ref man-conditional-evaluation): `if`-`elseif`-`else`と`?:`（三項演算子）。
  * [Short-Circuit Evaluation](@ref): 論理演算子`&&`（「かつ」）と`||`（「または」）、および連鎖比較。
  * [Repeated Evaluation: Loops](@ref man-loops): `while`と`for`。
  * [Exception Handling](@ref): `try`-`catch`、[`error`](@ref)、[`throw`](@ref)。
  * [Tasks (aka Coroutines)](@ref man-tasks): [`yieldto`](@ref)。

最初の5つの制御フロー機構は、高水準プログラミング言語で標準的に使われているものです。一方、[`Task`](@ref)は、それほど一般的ではありません。これは非局所的な制御フローを提供し、一時停止した計算の間で実行を切り替えられるようにします。これは強力な構文であり、Juliaでは例外処理も協調的マルチタスクもタスクを使って実装されています。日常的なプログラミングでタスクを直接使う必要はありませんが、タスクを使うとはるかに簡単に解ける問題もあります。

## [Compound Expressions](@id man-compound-expressions)

複数の部分式を順に評価し、最後の部分式の値を自身の値として返す単一の式があると便利な場合があります。Juliaには、これを実現する構文が2つあります。`begin`ブロックと`;`による連鎖です。どちらの複合式も、その値は最後の部分式の値になります。次に`begin`ブロックの例を示します。

```jldoctest
julia> z = begin
           x = 1
           y = 2
           x + y
       end
3
```

これらはかなり短く単純な式なので、簡単に1行にまとめられます。そのような場合に便利なのが、`;`で式を連鎖させる構文です。

```jldoctest
julia> z = (x = 1; y = 2; x + y)
3
```

この構文は、[Functions](@ref man-functions)で紹介した簡潔な1行の関数定義形式で特に役立ちます。通常はそう書かれますが、`begin`ブロックを複数行にしたり、`;`による連鎖を1行にしたりする必要はありません。

```jldoctest
julia> begin x = 1; y = 2; x + y end
3

julia> (x = 1;
        y = 2;
        x + y)
3
```

## [Conditional Evaluation](@id man-conditional-evaluation)

条件付き評価では、ブール式の値に応じて、コードの一部を評価するかどうかを決められます。`if`-`elseif`-`else`条件構文は、次のような構造になっています。

```julia
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

条件式`x < y`が`true`であれば、対応するブロックが評価されます。そうでなければ条件式`x > y`が評価され、それが`true`であれば、対応するブロックが評価されます。どちらの式も真でなければ、`else`ブロックが評価されます。実際の動作を見てみましょう。

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

`elseif`ブロックと`else`ブロックは省略可能で、`elseif`ブロックはいくつでも使えます。`if`-`elseif`-`else`構文の条件式は、最初に`true`と評価されるものが見つかるまで順に評価されます。その後、対応するブロックが評価され、それ以降の条件式やブロックは評価されません。

`if`ブロックは「漏れ出す」性質を持ちます。つまり、ローカルスコープを導入しません。このため、`if`節の中で新たに定義した変数は、それ以前に定義されていなくても、`if`ブロックの後で使用できます。したがって、上の`test`関数は、次のようにも定義できます。

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

変数`relation`は`if`ブロックの中で宣言され、外で使われています。ただし、この動作を利用する場合は、考えられるすべてのコードパスで、その変数に値が定義されるようにしてください。上の関数を次のように変更すると、実行時エラーになります。

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

`if`ブロックは値も返します。ほかの多くの言語に慣れたユーザーには、直感的でないかもしれません。この値は単に、選択された分岐で最後に実行された文の返り値です。したがって、次のようになります。

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

Juliaでは、ごく短い条件文（1行で書けるもの）を、次の節で説明する短絡評価で表すことがよくあります。

C、MATLAB、Perl、Python、Rubyとは異なり、Javaや、より厳格な型を持ついくつかの言語と同様に、条件式の値が`true`または`false`以外であればエラーになります。

```jldoctest
julia> if 1
           println("true")
       end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

このエラーは、条件式の型が正しくなかったことを示しています。必要な[`Bool`](@ref)ではなく、[`Int64`](@ref)になっています。

いわゆる「三項演算子」`?:`は、`if`-`elseif`-`else`構文と密接に関連しています。ただし、長いコードブロックを条件付きで実行するのではなく、個々の式の値を条件に応じて選びたい場合に使います。この名前は、多くの言語で3つのオペランドを取る唯一の演算子であることに由来します。

```julia
a ? b : c
```

`?`の前にある式`a`が条件式です。三項演算では、条件`a`が`true`なら`:`の前にある式`b`を評価し、`false`なら`:`の後にある式`c`を評価します。`?`と`:`の前後には空白が必須であることに注意してください。`a?b:c`のような式は、有効な三項式ではありません（ただし、`?`と`:`のどちらの後にも改行を入れることはできます）。

この動作は、例を見ると最も簡単に理解できます。前の例では、3つの分岐すべてに`println`の呼び出しが共通しており、実際に選んでいるのは、どの文字列リテラルを出力するかだけです。これは三項演算子を使うと、より簡潔に書けます。わかりやすくするために、まずは2通りに分岐する版を試してみましょう。

```jldoctest
julia> x = 1; y = 2;

julia> println(x < y ? "less than" : "not less than")
less than

julia> x = 1; y = 0;

julia> println(x < y ? "less than" : "not less than")
not less than
```

式`x < y`が真であれば、三項演算子の式全体の評価結果は文字列`"less than"`になり、そうでなければ文字列`"not less than"`になります。元の3通りに分岐する例では、三項演算子を複数連鎖させる必要があります。

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

連鎖させやすいように、この演算子は右から左に結合します。

重要なのは、`if`-`elseif`-`else`と同様に、`:`の前後にある式は、条件式がそれぞれ`true`または`false`と評価された場合にだけ評価されることです。

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

Juliaの`&&`演算子と`||`演算子は、それぞれ論理「かつ」と「または」の演算に対応し、通常はその目的で使われます。ただし、これらには*短絡評価*という性質もあります。以下で説明するように、第2引数を必ずしも評価しません。（ビット単位の演算子`&`と`|`もあり、これらは短絡動作を*行わない*論理「かつ」と「または」として使えます。ただし、評価順序では`&`と`|`のほうが、`&&`と`||`より優先順位が高いことに注意してください。）

短絡評価は条件付き評価によく似ています。この動作は、ブール演算子`&&`と`||`を持つほとんどの命令型プログラミング言語に見られます。これらの演算子でつながれた一連のブール式では、連鎖全体の最終的なブール値を決めるために必要な、最小限の式だけが評価されます。一部の言語（Pythonなど）では、これらを`and`（`&&`）および`or`（`||`）と呼びます。具体的には、次のように動作します。

  * 式`a && b`では、`a`の評価結果が`true`である場合にだけ、部分式`b`が評価されます。
  * 式`a || b`では、`a`の評価結果が`false`である場合にだけ、部分式`b`が評価されます。

その理由は、`a`が`false`であれば、`b`の値にかかわらず、`a && b`は必ず`false`になるからです。同様に、`a`が`true`であれば、`b`の値にかかわらず、`a || b`の値は必ず真になります。`&&`と`||`はどちらも右結合ですが、`&&`は`||`より優先順位が高くなっています。この動作は簡単に試せます。

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

同じように、`&&`演算子と`||`演算子をさまざまに組み合わせて、結合規則と優先順位を簡単に試せます。

Juliaでは、この動作が非常に短い`if`文の代わりによく使われます。`if <cond> <statement> end`の代わりに、`<cond> && <statement>`と書けます（「<cond>が成り立ち、*その場合に*<statement>を実行する」と読めます）。同様に、`if ! <cond> <statement> end`の代わりに、`<cond> || <statement>`と書けます（「<cond>が成り立つか、*そうでなければ*<statement>を実行する」と読めます）。

たとえば、再帰的な階乗ルーチンは次のように定義できます。

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

短絡評価を*行わない*ブール演算には、[Mathematical Operations and Elementary Functions](@ref)で紹介したビット単位のブール演算子`&`と`|`を使えます。これらは中置演算子の構文にも対応している通常の関数であり、引数を常に評価します。

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

`if`、`elseif`、三項演算子で使う条件式と同様に、`&&`または`||`のオペランドはブール値（`true`または`false`）でなければなりません。条件の連鎖の最後の要素を除き、ブール値以外を使うとエラーになります。

```jldoctest
julia> 1 && true
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

一方、条件の連鎖の最後には、どの型の式でも使えます。それまでの条件に応じて、その式が評価され、返されます。

```jldoctest
julia> true && (x = (1, 2, 3))
(1, 2, 3)

julia> false && (x = (1, 2, 3))
false
```

## [Repeated Evaluation: Loops](@id man-loops)

式を繰り返し評価する構文には、`while`ループと`for`ループの2つがあります。次に`while`ループの例を示します。

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

`while`ループは条件式（この場合は`i <= 3`）を評価し、その値が`true`である間、`while`ループの本体も繰り返し評価します。`while`ループに最初に到達した時点で条件式が`false`であれば、本体は一度も評価されません。

`for`ループを使うと、よくある繰り返し評価のパターンを簡単に書けます。上の`while`ループのように数を増減させる処理は非常によく使われるため、`for`ループを使って、より簡潔に表せます。

```jldoctest
julia> for i = 1:3
           println(i)
       end
1
2
3
```

ここで、`1:3`は数列1、2、3を表す[`range`](@ref)オブジェクトです。`for`ループはこれらの値を順にたどり、それぞれを変数`i`に代入します。一般に、`for`構文では、任意の「反復可能な」オブジェクト（または「コンテナ」）に対してループを実行できます。対象には、`1:3`や`1:3:13`（1、4、7、…、13という3刻みの整数を表す[`StepRange`](@ref)）のような範囲から、配列のような汎用的なコンテナ、さらには[iterators defined by user code](@ref man-interface-iteration)や外部パッケージで提供されるものまで含まれます。範囲以外のコンテナでは、コードが読みやすくなるため、通常は`=`の代わりに、それと完全に等価なキーワード`in`または`∈`を使います。

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

反復可能なコンテナのさまざまな型は、このマニュアルの後の節で紹介し、説明します（たとえば[Multi-dimensional Arrays](@ref man-multi-dim-arrays)を参照してください）。

先ほどの`while`ループ形式と`for`ループ形式の重要な違いの1つは、変数が見えるスコープです。`for`ループは、外側のスコープに同じ名前の変数があるかどうかにかかわらず、本体内に常に新しい反復変数を導入します。このため、`i`をループの前に宣言する必要はありません。一方、その変数はループの外からは見えず、外側にある同名の変数にも影響しません。これを試すには、新しい対話セッションを開始するか、別の変数名を使う必要があります。

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

`while`の条件が偽になる前に繰り返しを終了したり、`for`ループで反復可能なオブジェクトの末尾に達する前に反復を終了したりすると便利な場合があります。これには`break`キーワードを使えます。

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

`break`キーワードがなければ、上の`while`ループは自力では終了せず、`for`ループは1000まで反復します。`break`を使うことで、どちらのループも途中で終了しています。

別の状況では、現在の反復を打ち切り、すぐに次の反復に進めると便利です。これを実現するのが`continue`キーワードです。

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

この例はやや作為的です。条件を否定し、`println`の呼び出しを`if`ブロック内に置けば、同じ動作をより明確に表せるためです。実際の用途では、`continue`の後に評価するコードがもっとあり、`continue`を呼び出す箇所も複数あることがよくあります。

入れ子になった複数の`for`ループは、1つの外側のループにまとめられます。このループは、各反復可能オブジェクトの直積をたどります。

```jldoctest
julia> for i = 1:2, j = 3:4
           println((i, j))
       end
(1, 3)
(1, 4)
(2, 3)
(2, 4)
```

この構文でも、反復可能オブジェクトは外側のループ変数を参照できます。たとえば、`for i = 1:n, j = 1:i`は有効です。ただし、このようなループ内の`break`文は、内側のループだけでなく、入れ子になったループ全体を終了します。内側のループが実行されるたびに、両方の変数（`i`と`j`）には、その時点の反復値が設定されます。そのため、`i`への代入は、その後の反復には反映されません。

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

この例を、変数ごとに`for`キーワードを使う形に書き換えると、出力は異なり、2番目と4番目の値には`0`が含まれます。

[`zip`](@ref)を使うと、1つの`for`ループで複数のコンテナを同時に反復できます。

```jldoctest
julia> for (j, k) in zip([1 2 3], [4 5 6 7])
           println((j,k))
       end
(1, 4)
(2, 5)
(3, 6)
```

[`zip`](@ref)を使うと、渡された各コンテナのサブイテレータを含むタプルからなるイテレータが作成されます。`zip`イテレータは、すべてのサブイテレータを順にたどり、`for`ループの``i``回目の反復で、各サブイテレータの``i``番目の要素を選びます。いずれかのサブイテレータが尽きると、`for`ループは終了します。

## Exception Handling

予期しない状況が発生すると、関数は呼び出し元に妥当な値を返せなくなることがあります。そのような場合は、診断用のエラーメッセージを出力してプログラムを終了するか、プログラマーがそのような例外的状況を処理するコードを用意していれば、そのコードに適切な対応を任せるのが最善である場合があります。

### Built-in `Exception`s

予期しない状況が発生すると、`Exception`がスローされます。以下に示す組み込みの`Exception`は、いずれも通常の制御フローを中断します。

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

たとえば、[`sqrt`](@ref)関数は、負の実数値に適用すると[`DomainError`](@ref)をスローします。

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

[`throw`](@ref)を使うと、明示的に例外を発生させられます。たとえば、非負の数に対してのみ定義される関数は、引数が負の場合に[`DomainError`](@ref)を[`throw`](@ref)するように書けます。

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

括弧を付けない[`DomainError`](@ref)は、例外そのものではなく、例外の型であることに注意してください。`Exception`オブジェクトを得るには、これを呼び出す必要があります。

```jldoctest
julia> typeof(DomainError(nothing)) <: Exception
true

julia> typeof(DomainError) <: Exception
false
```

また、例外の型によっては、エラーの報告に使う引数を1つ以上受け取ります。

```jldoctest
julia> throw(UndefVarError(:x))
ERROR: UndefVarError: `x` not defined
```

この仕組みは、[`UndefVarError`](@ref)の書き方に倣えば、独自の例外型でも簡単に実装できます。

```jldoctest
julia> struct MyUndefVarError <: Exception
           var::Symbol
       end

julia> Base.showerror(io::IO, e::MyUndefVarError) = print(io, e.var, " not defined")
```

!!! note
    エラーメッセージを書く際は、最初の単語を小文字で始めることが推奨されます。たとえば、

    `size(A) == size(B) || throw(DimensionMismatch("size of A not equal to size of B"))`

    のほうが、

    `size(A) == size(B) || throw(DimensionMismatch("Size of A not equal to size of B"))`

    より推奨されます。

    ただし、関数の引数が大文字である場合など、先頭の文字を大文字のままにするのが適切な場合もあります。

    `size(A,1) == size(B,2) || throw(DimensionMismatch("A has first dimension..."))`


### Errors

[`error`](@ref)関数は、通常の制御フローを中断する[`ErrorException`](@ref)を発生させるために使います。

負の数の平方根を求めようとしたら、ただちに実行を停止したいとします。このためには、引数が負の場合にエラーを発生させる、厳格な版の[`sqrt`](@ref)関数を定義できます。

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

別の関数から負の値を指定して`fussy_sqrt`を呼び出すと、呼び出し元の関数の実行を続けようとはせず、ただちに処理を抜けて、対話セッションにエラーメッセージを表示します。

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

`try/catch`文を使うと、`Exception`を検出し、通常ならアプリケーションを停止させてしまうような事態にも適切に対処できます。たとえば、以下のコードでは、平方根を求める関数は通常なら例外をスローします。これを`try/catch`ブロックで囲むことで、その影響を抑えられます。例外をログに記録する、代わりの値を返す、あるいは以下の例のように単にメッセージを出力するなど、処理方法は自由に選べます。予期しない状況への対処方法を決める際に考慮すべき点の1つは、`try/catch`ブロックを使う方法は、条件分岐で対処する方法よりはるかに遅いことです。以下では、`try/catch`ブロックで例外を処理する例をさらに示します。

```jldoctest
julia> try
           sqrt("ten")
       catch e
           println("You should have entered a numeric value")
       end
You should have entered a numeric value
```

`try/catch`文では、`Exception`を変数に保存することもできます。次の作為的な例では、`x`が添字アクセス可能であれば`x`の2番目の要素の平方根を計算し、そうでなければ`x`を実数とみなして、その平方根を返します。

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

上のように[`rethrow`](@ref)を使うと、元の例外を使ってスタックの巻き戻しを続け、上位の例外ハンドラーでその例外を処理できるようにします。上のように例外の型で処理を振り分ける場合、ほかの型の例外を呼び出し元から隠してしまわないように、`else rethrow()`を含めることが重要な場合がよくあります。

`catch`の直後のシンボルは、常に例外の名前として解釈されるため、`try/catch`式を1行で書く場合は注意が必要です。次のコードは、エラー時に`x`の値を返すようには*動作しません*。

```julia
try bad() catch x end
```

代わりに、`catch`の後にセミコロンを置くか、改行を入れてください。

```julia
try bad() catch; x end

try bad()
catch
    x
end
```

`try/catch`構文の強みは、深く入れ子になった計算から、呼び出しスタックのはるか上位へとただちに巻き戻せることにあります。エラーは発生していなくても、スタックを巻き戻して上位に値を渡したい状況もあります。Juliaでは、より高度なエラー処理のために、[`backtrace`](@ref)、[`catch_backtrace`](@ref)、[`current_exceptions`](@ref)の各関数を提供しています。

### `else` Clauses

!!! compat "Julia 1.8"
    この機能にはJulia 1.8以降が必要です。


エラーの場合に適切に対処するだけでなく、`try`ブロックが成功した場合にだけコードを実行したいこともあります。このために、`catch`ブロックの後に`else`節を指定できます。この節は、それまでにエラーがスローされなかった場合に実行されます。このコードを`try`ブロックに含める場合と比べた利点は、そこで新たに発生したエラーが`catch`節によって黙って捕捉されることがない点です。

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
    `try`、`catch`、`else`、`finally`の各節は、それぞれ独自のスコープブロックを導入します。そのため、`try`ブロックの中でのみ定義された変数には、`else`節や`finally`節からアクセスできません。

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

状態を変更したり、ファイルなどのリソースを使用したりするコードでは、通常、コードの実行が終わったときに後処理（ファイルを閉じるなど）が必要です。例外によってコードブロックが通常の終端に達する前に終了する可能性があるため、例外はこの処理を複雑にしかねません。`finally`キーワードを使うと、あるコードブロックを抜ける際に、抜け方にかかわらず特定のコードを実行できます。

たとえば、開いたファイルを確実に閉じるには、次のようにします。

```julia
f = open("file")
try
    # operate on file f
finally
    close(f)
end
```

制御が`try`ブロックを離れると（たとえば`return`による場合でも、単に正常に終了した場合でも）、`close(f)`が実行されます。例外によって`try`ブロックを抜けた場合、その例外は引き続き伝播します。`catch`ブロックは、`try`および`finally`と組み合わせることもできます。その場合、`finally`ブロックは、`catch`がエラーを処理した後で実行されます。

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

タスクは、計算を柔軟に一時停止したり再開したりできる制御フロー機能です。ここでは網羅性のために触れるにとどめます。詳しい説明は[Asynchronous Programming](@ref man-asynchronous)を参照してください。
