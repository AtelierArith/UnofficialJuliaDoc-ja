# [Functions](@id man-functions)

Juliaにおいて、関数は引数の値のタプルを戻り値にマッピングするオブジェクトです。Juliaの関数は純粋な数学的関数ではなく、プログラムのグローバルな状態を変更したり、影響を受けたりすることがあります。Juliaで関数を定義するための基本的な構文は次のとおりです：

```jldoctest
julia> function f(x, y)
           x + y
       end
f (generic function with 1 method)
```

この関数は2つの引数 `x` と `y` を受け取り、評価された最後の式の値、つまり `x + y` を返します。

Julia には、関数を定義するための2番目の、より簡潔な構文があります。上で示した従来の関数宣言構文は、以下のコンパクトな「代入形式」と同等です：

```jldoctest fofxy
julia> f(x, y) = x + y
f (generic function with 1 method)
```

割り当てフォームでは、関数の本体は単一の式でなければなりませんが、複合式であることは可能です（[Compound Expressions](@ref man-compound-expressions)を参照）。短くシンプルな関数定義はJuliaでは一般的です。したがって、短い関数構文は非常に慣用的であり、タイピングと視覚的なノイズの両方を大幅に減少させます。

関数は従来の括弧構文を使用して呼び出されます：

```jldoctest fofxy
julia> f(2, 3)
5
```

括弧なしで、式 `f` は関数オブジェクトを指し、他の値と同様に渡すことができます：

```jldoctest fofxy
julia> g = f;

julia> g(2, 3)
5
```

変数と同様に、Unicodeは関数名にも使用できます：

```jldoctest
julia> ∑(x, y) = x + y
∑ (generic function with 1 method)

julia> ∑(2, 3)
5
```

## [Argument Passing Behavior](@id man-argument-passing)

Juliaの関数引数は「共有渡し」と呼ばれる慣習に従っており、関数に渡されるときに値がコピーされることはありません。関数引数自体は新しい変数の*バインディング*（値を参照する新しい「名前」）として機能し、[assignments](@ref man-assignment-expressions) `argument_name = argument_value`のように、参照するオブジェクトは渡された値と同一です。関数内で行われた可変値（例えば`Array`）への変更は、呼び出し元に対しても見えるようになります。（これは、Scheme、ほとんどのLisp、Python、Ruby、Perlなどの他の動的言語でも見られる同様の動作です。）

例えば、関数内で

```julia
function f(x, y)
    x[1] = 42    # mutates x
    y = 7 + y    # new binding for y, no mutation
    return y
end
```

ステートメント `x[1] = 42` はオブジェクト `x` を *変異* させるため、この変更はこの引数のために呼び出し元が渡した配列に *表示されます*。 一方、代入 `y = 7 + y` は *バインディング* ("名前") `y` を新しい値 `7 + y` を参照するように変更し、`y` が参照する *元の* オブジェクトを変異させるのではないため、呼び出し元が渡した対応する引数を *変更しません*。 これは `f(x, y)` を呼び出すと確認できます：

```julia-repl
julia> a = [4, 5, 6]
3-element Vector{Int64}:
 4
 5
 6

julia> b = 3
3

julia> f(a, b) # returns 7 + b == 10
10

julia> a  # a[1] is changed to 42 by f
3-element Vector{Int64}:
 42
  5
  6

julia> b  # not changed
3
```

ジュリアの一般的な慣習として（構文上の要件ではありません）、そのような関数は [typically be named `f!(x, y)`](@ref man-punctuation) ではなく `f(x, y)` と記述され、呼び出し元で少なくとも1つの引数（しばしば最初の引数）が変更されることを視覚的に思い出させる役割を果たします。

!!! warning "Shared memory between arguments"
    ミューテーション関数の動作は、ミューテートされた引数が別の引数とメモリを共有している場合、予期しないものになることがあります。この状況はエイリアシングとして知られています（例えば、一方が他方のビューである場合）。関数のドキュメント文字列がエイリアシングが期待される結果を生むことを明示的に示さない限り、そのような入力に対して適切な動作を保証するのは呼び出し元の責任です。


## Argument-type declarations

関数の引数の型を宣言するには、引数名に `::TypeName` を追加します。これは、Juliaの [Type Declarations](@ref) に通常の方法です。例えば、以下の関数は [Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number) を再帰的に計算します：

```
fib(n::Integer) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)
```

`::Integer` の仕様は、`n` が [abstract](@ref man-abstract-types) の `Integer` 型のサブタイプである場合にのみ呼び出し可能であることを意味します。

引数型の宣言は**通常、パフォーマンスに影響を与えません**：宣言された引数型が何であれ、Juliaは呼び出し元によって渡された実際の引数型に対して関数の特化版をコンパイルします。たとえば、`fib(1)`を呼び出すと、`Int`引数に特化して最適化された`fib`の特化版がコンパイルされ、その後`fib(7)`や`fib(15)`が呼び出された場合に再利用されます。（引数型の宣言が追加のコンパイラ特化を引き起こす稀な例外もあります。詳細は：[Be aware of when Julia avoids specializing](@ref)を参照してください。）Juliaで引数型を宣言する最も一般的な理由は、むしろ次の通りです：

  * **ディスパッチ:** [Methods](@ref)で説明されているように、異なる引数タイプに対して関数の異なるバージョン（「メソッド」）を持つことができ、その場合、引数タイプがどの実装がどの引数に対して呼び出されるかを決定するために使用されます。 例えば、`fib(x::Number) = ...`のように、任意の`Number`タイプに対して機能するまったく異なるアルゴリズムを実装し、[Binet's formula](https://en.wikipedia.org/wiki/Fibonacci_number#Binet%27s_formula)を使用して非整数値に拡張することができます。
  * **正確性:** 型宣言は、関数が特定の引数の型に対してのみ正しい結果を返す場合に役立ちます。たとえば、引数の型を省略して `fib(n) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)` と書いた場合、`fib(1.5)` は静かに意味のない答え `1.0` を返すことになります。
  * **明確さ:** 型宣言は、期待される引数についてのドキュメントの一形態として機能することがあります。

しかし、**引数の型を過度に制限するのは一般的な間違いです**。これにより、関数の適用可能性が不必要に制限され、予期しなかった状況で再利用できなくなる可能性があります。たとえば、上記の `fib(n::Integer)` 関数は、`Int` 引数（マシン整数）と `BigInt` 任意精度整数の両方に対して同様に機能します（[BigFloats and BigInts](@ref BigFloats-and-BigInts) を参照）。これは特に便利です。なぜなら、フィボナッチ数は指数関数的に急速に増加し、`Int` のような固定精度型ではすぐにオーバーフローしてしまうからです（[Overflow behavior](@ref) を参照）。しかし、もし私たちが関数を `fib(n::Int)` と宣言していた場合、理由もなく `BigInt` への適用が妨げられてしまったでしょう。一般的に、引数には最も一般的な適用可能な抽象型を使用すべきであり、**疑問がある場合は引数の型を省略するべきです**。必要になった場合は、後で引数の型指定を追加することができ、型を省略することでパフォーマンスや機能を犠牲にすることはありません。

## The `return` Keyword

関数が返す値は、評価された最後の式の値であり、デフォルトでは関数定義の本体の最後の式です。前のセクションの例の関数 `f` では、これは式 `x + y` の値です。多くの他の言語と同様に、`return` キーワードを使用すると、関数は即座に戻り、返される値を持つ式を提供します：

```julia
function g(x, y)
    return x * y
    x + y
end
```

関数定義はインタラクティブセッションに入力できるため、これらの定義を比較するのは簡単です：

```jldoctest
julia> f(x, y) = x + y
f (generic function with 1 method)

julia> function g(x, y)
           return x * y
           x + y
       end
g (generic function with 1 method)

julia> f(2, 3)
5

julia> g(2, 3)
6
```

もちろん、`g`のような純粋に線形の関数本体では、`return`の使用は無意味です。なぜなら、式`x + y`は決して評価されず、単に`x * y`を関数の最後の式にして`return`を省略することができるからです。しかし、他の制御フローと組み合わせると、`return`は実際に役立ちます。ここに、長さ`x`と`y`の辺を持つ直角三角形の斜辺の長さを計算し、オーバーフローを避ける関数の例があります：

```jldoctest
julia> function hypot(x, y)
           x = abs(x)
           y = abs(y)
           if x > y
               r = y/x
               return x*sqrt(1 + r*r)
           end
           if y == 0
               return zero(x)
           end
           r = x/y
           return y*sqrt(1 + r*r)
       end
hypot (generic function with 1 method)

julia> hypot(3, 4)
5.0
```

この関数からは、`x` と `y` の値に応じて、3 つの異なる式の値を返す可能性のある 3 つの戻りポイントがあります。最後の行の `return` は、最後の式であるため、省略することができます。

### [Return type](@id man-functions-return-type)

関数宣言では、`::` 演算子を使用して戻り値の型を指定できます。これにより、戻り値が指定された型に変換されます。

```jldoctest
julia> function g(x, y)::Int8
           return x * y
       end;

julia> typeof(g(1, 2))
Int8
```

この関数は、`x` と `y` の型に関係なく、常に `Int8` を返します。戻り値の型については、[Type Declarations](@ref) を参照してください。

戻り値の型宣言は**ほとんど使用されません**。一般的に、Juliaのコンパイラが自動的に戻り値の型を推論できる「型安定」な関数を書くべきです。詳細については、[Performance Tips](@ref man-performance-tips)章を参照してください。

### Returning nothing

値を返す必要のない関数（副作用のためだけに使用される関数）について、Juliaの慣習は値[`nothing`](@ref)を返すことです：

```julia
function printx(x)
    println("x = $x")
    return nothing
end
```

これは、`nothing`がJuliaのキーワードではなく、単に`Nothing`型のシングルトンオブジェクトであるという意味での*慣習*です。また、上記の`printx`関数の例は不自然であることに気付くかもしれません。なぜなら、`println`はすでに`nothing`を返すため、`return`行は冗長だからです。

`return nothing` 表現には2つの短縮形があります。一方では、`return` キーワードは暗黙的に `nothing` を返すため、単独で使用できます。もう一方では、関数は暗黙的に最後に評価された式を返すため、最後の式が `nothing` の場合は単独で使用できます。`return nothing` の表現を `return` や `nothing` 単独よりも好むかどうかは、コーディングスタイルの問題です。

## Operators Are Functions

In Julia, most operators are just functions with support for special syntax. (The exceptions are operators with special evaluation semantics like `&&` and `||`. These operators cannot be functions since [Short-Circuit Evaluation](@ref) requires that their operands are not evaluated before evaluation of the operator.) Accordingly, you can also apply them using parenthesized argument lists, just as you would any other function:

```jldoctest
julia> 1 + 2 + 3
6

julia> +(1, 2, 3)
6
```

中置形式は関数適用形式と正確に同等であり、実際には前者は内部で関数呼び出しを生成するために解析されます。これは、[`+`](@ref) や [`*`](@ref) のような演算子を、他の関数値と同様に割り当てたり渡したりできることも意味します。

```jldoctest
julia> f = +;

julia> f(1, 2, 3)
6
```

`f`という名前の下では、関数は中置記法をサポートしていません。

## Operators With Special Names

いくつかの特別な表現は、明白でない名前の関数への呼び出しに対応しています。これらは：

| Expression            | Calls                                    |
|:--------------------- |:---------------------------------------- |
| `[A B C ...]`         | [`hcat`](@ref)                           |
| `[A; B; C; ...]`      | [`vcat`](@ref)                           |
| `[A B; C D; ...]`     | [`hvcat`](@ref)                          |
| `[A; B;; C; D;; ...]` | [`hvncat`](@ref)                         |
| `A'`                  | [`adjoint`](@ref)                        |
| `A[i]`                | [`getindex`](@ref)                       |
| `A[i] = x`            | [`setindex!`](@ref)                      |
| `A.n`                 | [`getproperty`](@ref Base.getproperty)   |
| `A.n = x`             | [`setproperty!`](@ref Base.setproperty!) |

`[A; B;; C; D;; ...]`のような表現で、2つ以上の連続した`;`があるものも`hvncat`呼び出しに対応します。

## [Anonymous Functions](@id man-anonymous-functions)

Juliaの関数は[first-class objects](https://en.wikipedia.org/wiki/First-class_citizen)です。変数に割り当てることができ、割り当てられた変数から標準の関数呼び出し構文を使用して呼び出すことができます。引数として使用することもでき、値として返すこともできます。また、名前を付けずに匿名で作成することもでき、次のいずれかの構文を使用します：

```jldoctest
julia> x -> x^2 + 2x - 1
#1 (generic function with 1 method)

julia> function (x)
           x^2 + 2x - 1
       end
#3 (generic function with 1 method)
```

各ステートメントは、1つの引数 `x` を取り、その値における多項式 `x^2 + 2x - 1` の値を返す関数を作成します。結果は一般的な関数ですが、連続番号に基づいてコンパイラ生成の名前が付けられています。

匿名関数の主な用途は、他の関数を引数として受け取る関数に渡すことです。古典的な例は [`map`](@ref) で、これは配列の各値に関数を適用し、結果の値を含む新しい配列を返します：

```jldoctest
julia> map(round, [1.2, 3.5, 1.7])
3-element Vector{Float64}:
 1.0
 4.0
 2.0
```

これは、変換を行う名前付き関数が既に存在していて、[`map`](@ref)の最初の引数として渡すことができる場合は問題ありません。しかし、しばしば、すぐに使える名前付き関数は存在しません。こうした状況では、無名関数構文を使用することで、名前を必要とせずに単一使用の関数オブジェクトを簡単に作成できます。

```jldoctest
julia> map(x -> x^2 + 2x - 1, [1, 3, -1])
3-element Vector{Int64}:
  2
 14
 -2
```

複数の引数を受け取る匿名関数は、構文 `(x,y,z)->2x+y-z` を使用して記述できます。

匿名関数の引数型宣言は、名前付き関数と同様に機能します。例えば、`x::Integer->2x`のように記述します。匿名関数の戻り値の型は指定できません。

ゼロ引数の匿名関数は `()->2+2` のように書くことができます。引数のない関数のアイデアは奇妙に思えるかもしれませんが、結果を事前に計算できない（またはすべきでない）場合に便利です。たとえば、Julia には現在の時間を秒単位で返すゼロ引数の [`time`](@ref) 関数があります。したがって、`seconds = ()->round(Int, time())` はこの時間を最も近い整数に丸めて変数 `seconds` に割り当てる匿名関数です。この匿名関数が `seconds()` として呼び出されるたびに、現在の時間が計算されて返されます。

## Tuples

Juliaには、関数の引数や戻り値に密接に関連した*タプル*という組み込みデータ構造があります。タプルは固定長のコンテナで、任意の値を保持できますが、変更することはできません（*不変*です）。タプルはカンマと括弧を使って構築され、インデックスを介してアクセスできます：

```jldoctest
julia> (1, 1+1)
(1, 2)

julia> (1,)
(1,)

julia> x = (0.0, "hello", 6*7)
(0.0, "hello", 42)

julia> x[2]
"hello"
```

長さ1のタプルはカンマを付けて書かなければならないことに注意してください、`(1,)`、なぜなら`(1)`は単に括弧で囲まれた値に過ぎないからです。`()`は空の（長さ0の）タプルを表します。

## Named Tuples

タプルの要素にはオプションで名前を付けることができ、その場合は*名前付きタプル*が構築されます：

```jldoctest
julia> x = (a=2, b=1+2)
(a = 2, b = 3)

julia> x[1]
2

julia> x.a
2
```

名前付きタプルのフィールドは、通常のインデックス構文（`x[1]` または `x[:a]`）に加えて、ドット構文（`x.a`）を使用して名前でアクセスできます。

## [Destructuring Assignment and Multiple Return Values](@id destructuring-assignment)

変数のカンマ区切りリスト（オプションで括弧で囲むことができます）は、代入の左側に現れることができます：右側の値は、各変数に順番に割り当てることによって*分解*されます。

```jldoctest
julia> (a, b, c) = 1:3
1:3

julia> b
2
```

右側の値はイテレータであるべきです（[Iteration interface](@ref man-interface-iteration)を参照）。左側の変数の数と同じかそれ以上の長さでなければなりません（イテレータの余分な要素は無視されます）。

これは、タプルや他のイテラブルな値を返すことによって、関数から複数の値を返すために使用できます。たとえば、次の関数は2つの値を返します：

```jldoctest foofunc
julia> function foo(a, b)
           a+b, a*b
       end
foo (generic function with 1 method)
```

インタラクティブセッションで戻り値をどこにも割り当てずに呼び出すと、返されるタプルが表示されます：

```jldoctest foofunc
julia> foo(2, 3)
(5, 6)
```

分割代入は、各値を変数に抽出します：

```jldoctest foofunc
julia> x, y = foo(2, 3)
(5, 6)

julia> x
5

julia> y
6
```

別の一般的な使用法は、変数の入れ替えです：

```jldoctest foofunc
julia> y, x = x, y
(5, 6)

julia> x
6

julia> y
5
```

If only a subset of the elements of the iterator are required, a common convention is to assign ignored elements to a variable consisting of only underscores `_` (which is an otherwise invalid variable name, see [Allowed Variable Names](@ref man-allowed-variable-names)):

```jldoctest
julia> _, _, _, d = 1:10
1:10

julia> d
4
```

他の有効な左辺式は、代入リストの要素として使用でき、[`setindex!`](@ref) または [`setproperty!`](@ref) を呼び出すか、イテレータの個々の要素を再帰的に分解します：

```jldoctest
julia> X = zeros(3);

julia> X[1], (a, b) = (1, (2, 3))
(1, (2, 3))

julia> X
3-element Vector{Float64}:
 1.0
 0.0
 0.0

julia> a
2

julia> b
3
```

!!! compat "Julia 1.6"
    `...` の代入には Julia 1.6 が必要です。


もし代入リストの最後のシンボルが `...` でサフィックスされている場合（*スラーピング*として知られています）、右側のイテレータの残りの要素のコレクションまたは遅延イテレータが代入されます：

```jldoctest
julia> a, b... = "hello"
"hello"

julia> a
'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)

julia> b
"ello"

julia> a, b... = Iterators.map(abs2, 1:4)
Base.Generator{UnitRange{Int64}, typeof(abs2)}(abs2, 1:4)

julia> a
1

julia> b
Base.Iterators.Rest{Base.Generator{UnitRange{Int64}, typeof(abs2)}, Int64}(Base.Generator{UnitRange{Int64}, typeof(abs2)}(abs2, 1:4), 1)
```

[`Base.rest`](@ref)の詳細については、特定のイテレータの正確な処理とカスタマイズを参照してください。

!!! compat "Julia 1.9"
    `...` の非最終位置での代入は、Julia 1.9 が必要です。


スラーピングは、他のどの位置でも発生する可能性があります。ただし、コレクションの最後をスラーピングするのとは異なり、これは常に熱心です。

```jldoctest
julia> a, b..., c = 1:5
1:5

julia> a
1

julia> b
3-element Vector{Int64}:
 2
 3
 4

julia> c
5

julia> front..., tail = "Hi!"
"Hi!"

julia> front
"Hi"

julia> tail
'!': ASCII/Unicode U+0021 (category Po: Punctuation, other)
```

これは関数 [`Base.split_rest`](@ref) に基づいて実装されています。

可変引数関数の定義において、スラーピングは依然として最終位置でのみ許可されていることに注意してください。ただし、[single argument destructuring](@ref man-argument-destructuring) には適用されません。これはメソッドディスパッチに影響を与えないためです。

```jldoctest
julia> f(x..., y) = x
ERROR: syntax: invalid "..." on non-final argument
Stacktrace:
[...]

julia> f((x..., y)) = x
f (generic function with 1 method)

julia> f((1, 2, 3))
(1, 2)
```

## Property destructuring

反復に基づく分割代入の代わりに、代入の右側はプロパティ名を使用しても分割代入できます。これはNamedTuplesの構文に従い、左側の各変数に対して、代入の右側の同じ名前のプロパティを`getproperty`を使用して割り当てることによって機能します。

```jldoctest
julia> (; b, a) = (a=1, b=2, c=3)
(a = 1, b = 2, c = 3)

julia> a
1

julia> b
2
```

## [Argument destructuring](@id man-argument-destructuring)

関数の引数内でも分割代入機能を使用できます。引数名が単なるシンボルではなくタプル（例：`(x, y)`）として書かれている場合、`(x, y) = argument` という代入が自動的に挿入されます：

```julia-repl
julia> minmax(x, y) = (y < x) ? (y, x) : (x, y)

julia> gap((min, max)) = max - min

julia> gap(minmax(10, 2))
8
```

`gap`の定義に余分な括弧があることに注意してください。これがなければ、`gap`は二引数の関数になり、この例は機能しません。

同様に、プロパティの分割代入は関数の引数にも使用できます：

```julia-repl
julia> foo((; x, y)) = x + y
foo (generic function with 1 method)

julia> foo((x=1, y=2))
3

julia> struct A
           x
           y
       end

julia> foo(A(3, 4))
7
```

匿名関数の場合、単一の引数を分解するには余分なカンマが必要です：

```
julia> map(((x, y),) -> x + y, [(1, 2), (3, 4)])
2-element Array{Int64,1}:
 3
 7
```

## Varargs Functions

任意の数の引数を取る関数を書くことができると便利なことがよくあります。このような関数は伝統的に「varargs」関数として知られており、これは「可変数の引数」の略です。varargs関数は、最後の位置引数の後に省略記号を付けることで定義できます：

```jldoctest barfunc
julia> bar(a, b, x...) = (a, b, x)
bar (generic function with 1 method)
```

変数 `a` と `b` は通常通り最初の2つの引数の値にバインドされ、変数 `x` は `bar` に最初の2つの引数の後に渡された0個以上の値のイテラブルコレクションにバインドされます：

```jldoctest barfunc
julia> bar(1, 2)
(1, 2, ())

julia> bar(1, 2, 3)
(1, 2, (3,))

julia> bar(1, 2, 3, 4)
(1, 2, (3, 4))

julia> bar(1, 2, 3, 4, 5, 6)
(1, 2, (3, 4, 5, 6))
```

これらすべての場合において、`x`は`bar`に渡された末尾の値のタプルにバインドされます。

変数引数として渡される値の数を制限することは可能です。これは後で [Parametrically-constrained Varargs methods](@ref) で議論されます。

逆に、イテラブルコレクションに含まれる値を個々の引数として関数呼び出しに「スプラット」するのは便利です。これを行うには、関数呼び出しの中でも `...` を使用します。

```jldoctest barfunc
julia> x = (3, 4)
(3, 4)

julia> bar(1, 2, x...)
(1, 2, (3, 4))
```

この場合、値のタプルが可変引数呼び出しの正確な位置にスライスされます。これは必ずしもそうである必要はありませんが：

```jldoctest barfunc
julia> x = (2, 3, 4)
(2, 3, 4)

julia> bar(1, x...)
(1, 2, (3, 4))

julia> x = (1, 2, 3, 4)
(1, 2, 3, 4)

julia> bar(x...)
(1, 2, (3, 4))
```

さらに、関数呼び出しにスプラットされたイテラブルオブジェクトはタプルである必要はありません:

```jldoctest barfunc
julia> x = [3, 4]
2-element Vector{Int64}:
 3
 4

julia> bar(1, 2, x...)
(1, 2, (3, 4))

julia> x = [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4

julia> bar(x...)
(1, 2, (3, 4))
```

また、引数がスプラットされる関数は、可変引数関数である必要はありません（ただし、しばしばそうであることが多いです）：

```jldoctest
julia> baz(a, b) = a + b;

julia> args = [1, 2]
2-element Vector{Int64}:
 1
 2

julia> baz(args...)
3

julia> args = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3

julia> baz(args...)
ERROR: MethodError: no method matching baz(::Int64, ::Int64, ::Int64)
The function `baz` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  baz(::Any, ::Any)
   @ Main none:1

Stacktrace:
[...]
```

ご覧のとおり、スプラットコンテナに要素の数が間違っている場合、関数呼び出しは失敗します。これは、引数が明示的に多すぎる場合と同様です。

## Optional Arguments

関数引数に対して合理的なデフォルト値を提供することがしばしば可能です。これにより、ユーザーは毎回すべての引数を渡す必要がなくなります。例えば、`Dates`モジュールの関数[`Date(y, [m, d])`](@ref)は、指定された年`y`、月`m`、日`d`のための`Date`型を構築します。しかし、`m`と`d`の引数はオプションであり、そのデフォルト値は`1`です。この動作は簡潔に次のように表現できます：

```jldoctest date_default_args
julia> using Dates

julia> function date(y::Int64, m::Int64=1, d::Int64=1)
           err = Dates.validargs(Date, y, m, d)
           err === nothing || throw(err)
           return Date(Dates.UTD(Dates.totaldays(y, m, d)))
       end
date (generic function with 3 methods)
```

この定義は、`Date`関数の別のメソッドを呼び出しており、そのメソッドは`UTInstant{Day}`型の引数を1つ取ります。

この定義により、関数は1つ、2つ、または3つの引数で呼び出すことができ、引数が1つまたは2つだけ指定された場合は自動的に`1`が渡されます。

```jldoctest date_default_args
julia> date(2000, 12, 12)
2000-12-12

julia> date(2000, 12)
2000-12-01

julia> date(2000)
2000-01-01
```

オプション引数は、実際には異なる数の引数を持つ複数のメソッド定義を書くための便利な構文に過ぎません（[Note on Optional and keyword Arguments](@ref)を参照）。これは、`methods`関数を呼び出すことで、私たちの`date`関数の例で確認できます：

```julia-repl
julia> methods(date)
# 3 methods for generic function "date":
[1] date(y::Int64) in Main at REPL[1]:1
[2] date(y::Int64, m::Int64) in Main at REPL[1]:1
[3] date(y::Int64, m::Int64, d::Int64) in Main at REPL[1]:1
```

## Keyword Arguments

いくつかの関数は多くの引数を必要としたり、多くの動作を持っていたりします。そのような関数を呼び出す方法を覚えるのは難しいことがあります。キーワード引数を使用すると、引数を位置だけでなく名前で特定できるため、これらの複雑なインターフェースをより使いやすく、拡張しやすくすることができます。

例えば、線をプロットする関数 `plot` を考えてみましょう。この関数には、線のスタイル、幅、色などを制御するための多くのオプションがあるかもしれません。キーワード引数を受け入れる場合、呼び出しの例は `plot(x, y, width=2)` のようになります。ここでは、線の幅だけを指定することにしました。この呼び出しには二つの目的があります。一つは、引数にその意味をラベル付けできるため、読みやすくなることです。もう一つは、大量の引数の任意の部分集合を、任意の順序で渡すことが可能になることです。

キーワード引数を持つ関数は、シグネチャでセミコロンを使用して定義されます：

```julia
function plot(x, y; style="solid", width=1, color="black")
    ###
end
```

関数が呼び出されるとき、セミコロンはオプションです：`plot(x, y, width=2)` または `plot(x, y; width=2)` のいずれかを呼び出すことができますが、前者のスタイルがより一般的です。明示的なセミコロンは、以下に説明するように varargs または計算されたキーワードを渡す場合にのみ必要です。

キーワード引数のデフォルト値は、必要なとき（対応するキーワード引数が渡されていないとき）にのみ評価され、左から右の順序で評価されます。したがって、デフォルトの式は前のキーワード引数を参照することができます。

キーワード引数の種類は次のように明示できます：

```julia
function f(; x::Int=1)
    ###
end
```

キーワード引数は、可変長引数関数でも使用できます：

```julia
function plot(x...; style="solid")
    ###
end
```

追加のキーワード引数は、varargs関数のように `...` を使用して収集できます:

```julia
function f(x; y=0, kwargs...)
    ###
end
```

`f`の内部では、`kwargs`は名前付きタプルの不変のキー-バリューイテレータになります。名前付きタプル（および`Symbol`のキーを持つ辞書、最初の値がシンボルである2値コレクションを生成する他のイテレータ）は、呼び出し時にセミコロンを使用してキーワード引数として渡すことができます。例：`f(x, z=1; kwargs...)`。

キーワード引数がメソッド定義でデフォルト値を割り当てられていない場合、それは*必須*です：呼び出し元が値を割り当てないと、[`UndefKeywordError`](@ref)例外がスローされます。

```julia
function f(x; y)
    ###
end
f(3, y=5) # ok, y is assigned
f(3)      # throws UndefKeywordError(:y)
```

セミコロンの後に `key => value` の式を渡すこともできます。例えば、`plot(x, y; :width => 2)` は `plot(x, y, width=2)` と同等です。これは、キーワード名が実行時に計算される状況で便利です。

セミコロンの後に裸の識別子またはドット式が現れると、キーワード引数の名前は識別子またはフィールド名によって暗示されます。例えば、`plot(x, y; width)`は`plot(x, y; width=width)`と同等であり、`plot(x, y; options.width)`は`plot(x, y; width=options.width)`と同等です。

キーワード引数の性質により、同じ引数を複数回指定することが可能です。例えば、`plot(x, y; options..., width=2)`という呼び出しでは、`options`構造体にも`width`の値が含まれている可能性があります。この場合、右側の出現が優先されます。この例では、`width`は確実に値`2`を持ちます。しかし、同じキーワード引数を複数回明示的に指定すること、例えば`plot(x, y, width=2, width=3)`は許可されておらず、構文エラーが発生します。

## Evaluation Scope of Default Values

オプショナルおよびキーワード引数のデフォルト式が評価されるとき、スコープ内にあるのは*前の*引数のみです。たとえば、次の定義を考えてみましょう：

```julia
function f(x, a=b, b=1)
    ###
end
```

`a=b` の `b` は、後続の引数 `b` ではなく、外部スコープの `b` を指します。

## Do-Block Syntax for Function Arguments

他の関数に引数として関数を渡すことは強力なテクニックですが、その構文は常に便利とは限りません。このような呼び出しは、関数の引数が複数行を必要とする場合、特に書きにくくなります。例として、いくつかのケースを持つ関数に対して [`map`](@ref) を呼び出すことを考えてみましょう：

```julia
map(x->begin
           if x < 0 && iseven(x)
               return 0
           elseif x == 0
               return 1
           else
               return x
           end
       end,
    [A, B, C])
```

Juliaは、このコードをより明確に書き直すための予約語`do`を提供しています：

```julia
map([A, B, C]) do x
    if x < 0 && iseven(x)
        return 0
    elseif x == 0
        return 1
    else
        return x
    end
end
```

`do x` 構文は、引数 `x` を持つ匿名関数を作成し、その匿名関数を「外側」関数 - この例では [`map`](@ref) の最初の引数として渡します。同様に、`do a,b` は二つの引数を持つ匿名関数を作成します。`do (a,b)` は、引数がデコンストラクトされるタプルである一つの引数を持つ匿名関数を作成します。単純な `do` は、続くものが `() -> ...` という形式の匿名関数であることを宣言します。

これらの引数がどのように初期化されるかは「外側」の関数に依存します。ここで、[`map`](@ref) は、`x` を `A`、`B`、`C` に順次設定し、各々に対して無名関数を呼び出します。これは、`map(func, [A, B, C])` の構文で起こることと同じです。

この構文は、関数を使用して言語を効果的に拡張するのを容易にします。呼び出しは通常のコードブロックのように見えるからです。[`map`](@ref)とは異なる多くの可能な用途があり、システム状態の管理などがあります。たとえば、開かれたファイルが最終的に閉じられることを保証するコードを実行する[`open`](@ref)のバージョンがあります：

```julia
open("outfile", "w") do io
    write(io, data)
end
```

これは次の定義によって達成されます：

```julia
function open(f::Function, args...)
    io = open(args...)
    try
        f(io)
    finally
        close(io)
    end
end
```

ここで、[`open`](@ref) はファイルをライティング用に開き、その後、`do ... end` ブロックで定義した無名関数に結果の出力ストリームを渡します。あなたの関数が終了すると、`4d61726b646f776e2e436f64652822222c20226f70656e2229_40726566` は、関数が正常に終了したか、例外をスローしたかに関わらず、ストリームが適切に閉じられることを確認します。（`try/finally` 構文については [Control Flow](@ref) で説明されます。）

`do`ブロック構文を使用すると、ユーザー関数の引数がどのように初期化されるかを知るために、ドキュメントや実装を確認するのが役立ちます。

`do` ブロックは、他の内部関数と同様に、外部スコープから変数を「キャプチャ」することができます。たとえば、`open...do` の上記の例における変数 `data` は外部スコープからキャプチャされています。キャプチャされた変数は、[performance tips](@ref man-performance-captured) で議論されているように、パフォーマンス上の課題を引き起こす可能性があります。

## Function composition and piping

Juliaの関数は、合成やパイピング（チェイニング）によって組み合わせることができます。

関数合成とは、関数を組み合わせて、その結果の合成を引数に適用することです。関数合成演算子（`∘`）を使用して関数を合成しますので、`(f ∘ g)(args...; kw...)` は `f(g(args...; kw...))` と同じです。

REPLや適切に設定されたエディタで合成演算子を入力するには、`\circ<tab>`を使用できます。

例えば、`sqrt` と `+` 関数はこのように合成できます:

```jldoctest
julia> (sqrt ∘ +)(3, 6)
3.0
```

これは最初に数字を加算し、その後結果の平方根を求めます。

次の例では、3つの関数を合成し、その結果を文字列の配列にマッピングします：

```jldoctest
julia> map(first ∘ reverse ∘ uppercase, split("you can compose functions like this"))
6-element Vector{Char}:
 'U': ASCII/Unicode U+0055 (category Lu: Letter, uppercase)
 'N': ASCII/Unicode U+004E (category Lu: Letter, uppercase)
 'E': ASCII/Unicode U+0045 (category Lu: Letter, uppercase)
 'S': ASCII/Unicode U+0053 (category Lu: Letter, uppercase)
 'E': ASCII/Unicode U+0045 (category Lu: Letter, uppercase)
 'S': ASCII/Unicode U+0053 (category Lu: Letter, uppercase)
```

関数チェイニング（時には「パイピング」または「パイプを使用する」と呼ばれる）は、前の関数の出力に関数を適用することです：

```jldoctest
julia> 1:10 |> sum |> sqrt
7.416198487095663
```

ここでは、`sum`によって生成された合計が`sqrt`関数に渡されます。同等の合成は次のようになります：

```jldoctest
julia> (sqrt ∘ sum)(1:10)
7.416198487095663
```

パイプ演算子は、ブロードキャスティングとともに `.|>` を使用することもでき、チェイニング/パイピングとドットベクトル化構文（以下で説明）を組み合わせるのに便利です。

```jldoctest
julia> ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
4-element Vector{Any}:
  "A"
  "tsil"
  "Of"
 7
```

パイプと匿名関数を組み合わせる場合、後続のパイプが匿名関数の本体の一部として解析されないようにするには、括弧を使用する必要があります。比較してください：

```jldoctest
julia> 1:3 .|> (x -> x^2) |> sum |> sqrt
3.7416573867739413

julia> 1:3 .|> x -> x^2 |> sum |> sqrt
3-element Vector{Float64}:
 1.0
 2.0
 3.0
```

## [Dot Syntax for Vectorizing Functions](@id man-vectorized)

技術計算言語では、関数 `f(x)` を配列 `A` の各要素に適用して新しい配列を生成する「ベクトル化」されたバージョンの関数が一般的です。このような構文はデータ処理に便利ですが、他の言語ではパフォーマンスのためにベクトル化が必要とされることもよくあります。ループが遅い場合、関数の「ベクトル化」バージョンは低レベル言語で書かれた高速ライブラリコードを呼び出すことができます。Juliaでは、パフォーマンスのためにベクトル化された関数は*必要ではなく*、実際には自分自身のループを書くことがしばしば有益です（参照: [Performance Tips](@ref man-performance-tips)）。しかし、それでも便利です。したがって、*任意の* Julia関数 `f` は、構文 `f.(A)` を使用して任意の配列（または他のコレクション）に要素ごとに適用できます。たとえば、`sin` をベクトル `A` のすべての要素に次のように適用できます:

```jldoctest
julia> A = [1.0, 2.0, 3.0]
3-element Vector{Float64}:
 1.0
 2.0
 3.0

julia> sin.(A)
3-element Vector{Float64}:
 0.8414709848078965
 0.9092974268256817
 0.1411200080598672
```

もちろん、`f`の専門的な「ベクトル」メソッドを書く場合は、ドットを省略できます。例えば、`f(A::AbstractArray) = map(f, A)`のように書くと、`f.(A)`と同じくらい効率的です。`f.(A)`構文の利点は、どの関数がベクトル化可能かをライブラリ作成者が事前に決定する必要がないことです。

より一般的には、`f.(args...)`は実際には`broadcast(f, args...)`と同等であり、異なる形状の複数の配列や、配列とスカラーの混合に対して操作を行うことができます（[Broadcasting](@ref)を参照）。例えば、`f(x, y) = 3x + 4y`の場合、`f.(pi, A)`は`A`の各`a`に対して`f(pi, a)`を含む新しい配列を返し、`f.(vector1, vector2)`は各インデックス`i`に対して`f(vector1[i], vector2[i])`を含む新しいベクトルを返します（ベクトルの長さが異なる場合は例外がスローされます）。

```jldoctest
julia> f(x, y) = 3x + 4y;

julia> A = [1.0, 2.0, 3.0];

julia> B = [4.0, 5.0, 6.0];

julia> f.(pi, A)
3-element Vector{Float64}:
 13.42477796076938
 17.42477796076938
 21.42477796076938

julia> f.(A, B)
3-element Vector{Float64}:
 19.0
 26.0
 33.0
```

キーワード引数はブロードキャストされず、単に関数の各呼び出しに渡されます。例えば、`round.(x, digits=3)`は`broadcast(x -> round(x, digits=3), x)`と同等です。

さらに、*ネストされた* `f.(args...)` 呼び出しは *融合* されて単一の `broadcast` ループにまとめられます。例えば、`sin.(cos.(X))` は `broadcast(x -> sin(cos(x)), X)` と同等であり、`[sin(cos(x)) for x in X]` に似ています：`X` に対しては単一のループしかなく、結果のために単一の配列が割り当てられます。[対照的に、典型的な「ベクトル化」言語では、最初に `tmp=cos(X)` のために一時的な配列が割り当てられ、その後別のループで `sin(tmp)` が計算され、二つ目の配列が割り当てられます。] このループ融合は、発生するかもしれないコンパイラの最適化ではなく、ネストされた `f.(args...)` 呼び出しが遭遇するたびに *構文的保証* です。技術的には、融合は「ドットでない」関数呼び出しが遭遇するとすぐに停止します；例えば、`sin.(sort(cos.(X)))` では、介在する `sort` 関数のために `sin` と `cos` のループは統合できません。

最終的に、最大の効率は通常、ベクトル化された操作の出力配列が*事前に割り当てられている*ときに達成されます。これにより、繰り返し呼び出す際に結果のために新しい配列を何度も割り当てることがなくなります（[Pre-allocating outputs](@ref)を参照）。これに便利な構文は`X .= ...`で、これは`broadcast!(identity, X, ...)`と同等ですが、上記のように`broadcast!`ループがネストされた「ドット」呼び出しと融合されます。例えば、`X .= sin.(Y)`は`broadcast!(sin, X, Y)`と同等で、`X`を`sin.(Y)`でその場で上書きします。左辺が配列インデックス式である場合、例えば`X[begin+1:end] .= sin.(Y)`は、`broadcast!`を`view`に対して行うことに変換されます。例えば、`broadcast!(sin, view(X, firstindex(X)+1:lastindex(X)), Y)`のように、左辺がその場で更新されます。

多くの操作や関数呼び出しにドットを追加することは面倒であり、読みづらいコードにつながる可能性があるため、式内の*すべての*関数呼び出し、操作、および代入を「ドット」バージョンに変換するために、マクロ [`@.`](@ref @__dot__) が提供されています。

```jldoctest
julia> Y = [1.0, 2.0, 3.0, 4.0];

julia> X = similar(Y); # pre-allocate output array

julia> @. X = sin(cos(Y)) # equivalent to X .= sin.(cos.(Y))
4-element Vector{Float64}:
  0.5143952585235492
 -0.4042391538522658
 -0.8360218615377305
 -0.6080830096407656
```

バイナリ（またはユニアリ）演算子のような `.+` は同じメカニズムで処理されます：それらは `broadcast` 呼び出しに相当し、他のネストされた「ドット」呼び出しと融合されます。 `X .+= Y` などは `X .= X .+ Y` に相当し、融合されたインプレース代入を結果として得ます；詳細は [dot operators](@ref man-dot-operators) を参照してください。

ドット演算を関数チェイニングと組み合わせることもできます。例えば、[`|>`](@ref)のように使用します。

```jldoctest
julia> 1:5 .|> [x->x^2, inv, x->2*x, -, isodd]
5-element Vector{Real}:
    1
    0.5
    6
   -4
 true
```

すべての関数は、結果の各要素に対して常に呼び出されるため、`X .+ σ .* randn.()`は配列`X`の各要素に独立して同一にサンプリングされたランダム値のマスクを追加しますが、`X .+ σ .* randn()`は各要素に*同じ*ランダムサンプルを追加します。ブロードキャストの反復の1つ以上の軸に沿って融合計算が定数である場合、中間値を割り当てて計算回数を減らすためにスペース・タイムトレードオフを活用できる可能性があります。詳細は[performance tips](@ref man-performance-unfuse)を参照してください。

## Further Reading

ここで言及すべきは、これは関数を定義するための完全な図ではないということです。Juliaは洗練された型システムを持ち、引数の型に基づく多重ディスパッチを許可します。ここで示された例のいずれも引数に型注釈を提供していないため、すべての型の引数に適用可能です。型システムについては [Types](@ref man-types) で説明されており、実行時の引数の型に基づいて選択されたメソッドによる関数の定義については [Methods](@ref) で説明されています。
