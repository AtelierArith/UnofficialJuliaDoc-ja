# [Functions](@id man-functions)

Juliaでは、関数は引数値のタプルを戻り値に対応付けるオブジェクトです。Juliaの関数は、プログラムのグローバルな状態を変更したり、その影響を受けたりするため、純粋な数学的関数ではありません。Juliaで関数を定義する基本的な構文は次のとおりです。

```jldoctest
julia> function f(x, y)
           x + y
       end
f (generic function with 1 method)
```

この関数は2つの引数 `x` と `y` を受け取り、最後に評価された式の値、つまり `x + y` を返します。

Juliaには、関数を定義するための、より簡潔な構文もあります。上に示した従来の関数宣言構文は、次のコンパクトな「代入形式」と等価です。

```jldoctest fofxy
julia> f(x, y) = x + y
f (generic function with 1 method)
```

代入形式では、関数本体は単一の式でなければなりません。ただし、複合式でもかまいません（[Compound Expressions](@ref man-compound-expressions) を参照）。Juliaでは、短く単純な関数定義がよく使われます。そのため、この短縮構文はJuliaらしい書き方として定着しており、入力の手間も見た目の煩雑さも大幅に減らせます。

関数の呼び出しには、通常の括弧を使った構文を用います。

```jldoctest fofxy
julia> f(2, 3)
5
```

括弧を付けない場合、式 `f` は関数オブジェクトを参照し、ほかの値と同様に受け渡しできます。

```jldoctest fofxy
julia> g = f;

julia> g(2, 3)
5
```

変数と同様に、関数名にもUnicodeを使用できます。

```jldoctest
julia> ∑(x, y) = x + y
∑ (generic function with 1 method)

julia> ∑(2, 3)
5
```

## [Argument Passing Behavior](@id man-argument-passing)

Juliaの関数の引数は、「共有渡し（pass-by-sharing）」と呼ばれる規約に従います。これは、値を関数に渡すときにコピーしないことを意味します。関数の引数自体は、[assignments](@ref man-assignment-expressions) `argument_name = argument_value` と同じように、新しい変数の*束縛*（値を参照するための新しい「名前」）として働きます。そのため、引数が参照するオブジェクトは、渡された値と同一です。関数内で可変な値（`Array` など）を変更すると、その変更は呼び出し元からも見えます。（これは、Scheme、ほとんどのLisp、Python、Ruby、Perlなどの動的言語と同じ動作です。）

たとえば、次の関数を考えます。

```jldoctest argpassing; output = false
function f(x, y)
    x[1] = 42    # mutates x
    y = 7 + y    # new binding for y, no mutation
    return y
end

# output

f (generic function with 1 method)
```

文 `x[1] = 42` は、オブジェクト `x` を*変更*します。したがって、この変更は、呼び出し元がこの引数に渡した配列に*反映されます*。一方、代入 `y = 7 + y` は、`y` という*束縛*（「名前」）を変更して、新しい値 `7 + y` を参照させます。`y` が参照していた*元の*オブジェクトを変更するわけではないため、呼び出し元が渡した対応する引数は変更*されません*。これは、`f(x, y)` を呼び出すと確認できます。

```jldoctest argpassing
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

Juliaで広く使われている規約では、このような関数には `f(x, y)` ではなく [typically be named `f!(x, y)`](@ref man-punctuation) とします。これは構文上の要件ではありませんが、少なくとも1つの引数（多くの場合は最初の引数）が変更されることを、呼び出し箇所で視覚的に示す目印になります。

!!! warning "引数間でのメモリ共有"
    変更対象の引数が別の引数とメモリを共有している場合、引数を変更する関数は予期しない動作をすることがあります。この状況はエイリアシングと呼ばれます（たとえば、一方が他方のビューである場合です）。エイリアシングがあっても期待どおりの結果になることが関数のdocstringに明記されていない限り、そのような入力に対して正しく動作することを確認する責任は呼び出し元にあります。


## Argument-type declarations

Juliaの [Type Declarations](@ref) で通常行うように、引数名に `::TypeName` を付けることで、関数の引数の型を宣言できます。たとえば、次の関数は [Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number) を再帰的に計算します。

```
fib(n::Integer) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)
```

ここで、`::Integer` という指定は、`n` が [abstract](@ref man-abstract-types) `Integer` 型のサブタイプである場合にのみ呼び出せることを意味します。

引数の型宣言は、**通常、性能に影響しません**。引数の型を宣言しているかどうか、またどの型を宣言しているかにかかわらず、Juliaは呼び出し元が実際に渡した引数の型に特化した関数をコンパイルします。たとえば、`fib(1)` を呼び出すと、`Int` 型の引数に特化して最適化された `fib` がコンパイルされます。その後、`fib(7)` や `fib(15)` を呼び出すと、そのコンパイル結果が再利用されます。（まれな例外として、引数の型宣言によってコンパイラが追加の特殊化を行うこともあります。[Be aware of when Julia avoids specializing](@ref) を参照してください。）Juliaで引数の型を宣言する主な理由は、むしろ次のようなものです。

  * **ディスパッチ：** [Methods](@ref) で説明するように、引数の型ごとに異なる関数の実装（「メソッド」）を用意できます。この場合、どの引数に対してどの実装を呼び出すかを、引数の型に基づいて決定します。たとえば、[Binet's formula](https://en.wikipedia.org/wiki/Fibonacci_number#Binet%27s_formula) を使って整数以外の値にも拡張することで、あらゆる `Number` 型に対応する、まったく異なるアルゴリズム `fib(x::Number) = ...` を実装できます。
  * **正しさ：** 関数が特定の引数型に対してのみ正しい結果を返す場合、型宣言が役立ちます。たとえば、引数の型を省略して `fib(n) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)` と書くと、`fib(1.5)` は何の警告もなく、意味のない答え `1.0` を返してしまいます。
  * **明確さ：** 型宣言は、想定される引数についてのドキュメントとしても機能します。

ただし、**引数の型を過度に制限してしまうのは、よくある間違いです**。これにより、関数を適用できる範囲が不必要に狭まり、想定していなかった状況で再利用できなくなることがあります。たとえば、上の `fib(n::Integer)` 関数は、`Int` 型の引数（機械整数）でも、`BigInt` 型の任意精度整数（[BigFloats and BigInts](@ref BigFloats-and-BigInts) を参照）でも、同じように動作します。フィボナッチ数は指数関数的に急速に増加し、`Int` のような固定精度の型ではすぐにオーバーフローするため、これは特に便利です（[Overflow behavior](@ref) を参照）。ところが、関数を `fib(n::Int)` と宣言していたら、理由もなく `BigInt` に適用できなくなっていたでしょう。一般に、引数には適用可能な範囲が最も広い抽象型を使うべきです。また、**迷った場合は引数の型を省略してください**。必要になれば後からいつでも引数の型指定を追加でき、省略しても性能や機能が損なわれることはありません。

## The `return` Keyword

関数が返す値は、最後に評価された式の値です。デフォルトでは、これは関数定義の本体にある最後の式です。前の節の関数例 `f` では、式 `x + y` の値になります。別の方法として、ほかの多くの言語と同様に、`return` キーワードを使うと関数から直ちに戻り、指定した式の値を返すことができます。

```julia
function g(x, y)
    return x * y
    x + y
end
```

関数定義は対話セッションでも入力できるため、これらの定義を簡単に比較できます。

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

もちろん、`g` のように処理が単純に上から下へ進む関数本体では、`return` を使う意味はありません。式 `x + y` は評価されないため、単に `x * y` を関数の最後の式にして、`return` を省略できるからです。しかし、ほかの制御フローと組み合わせると、`return` は実際に役立ちます。たとえば、次の関数は、オーバーフローを避けながら、2辺の長さが `x` と `y` である直角三角形の斜辺の長さを計算します。

```jldoctest
julia> function hypot(x, y)
           x = abs(x)
           y = abs(y)
           if x > y
               r = y/x
               return x*sqrt(1 + r*r)
           end
           if y == 0
               return float(x)
           end
           r = x/y
           return y*sqrt(1 + r*r)
       end
hypot (generic function with 1 method)

julia> hypot(3, 4)
5.0
```

この関数には、関数から戻る箇所が3つあり、`x` と `y` の値に応じて、3つの異なる式の値を返します。最終行は最後の式なので、`return` は省略できます。

### [Return type](@id man-functions-return-type)

関数宣言で `::` 演算子を使うと、戻り値の型を指定できます。これにより、戻り値が指定した型に変換されます。

```jldoctest
julia> function g(x, y)::Int8
           return x * y
       end;

julia> typeof(g(1, 2))
Int8
```

この関数は、`x` と `y` の型にかかわらず、常に `Int8` を返します。戻り値の型について詳しくは、[Type Declarations](@ref) を参照してください。

Juliaでは、戻り値の型宣言は**ほとんど使われません**。一般には、Juliaのコンパイラが戻り値の型を自動的に推論できる「型安定」な関数を書くべきです。詳しくは、[Performance Tips](@ref man-performance-tips) の章を参照してください。

### Returning nothing

値を返す必要がない関数（副作用のためだけに使う関数）では、値 [`nothing`](@ref) を返すのがJuliaの規約です。

```julia
function printx(x)
    println("x = $x")
    return nothing
end
```

これは、`nothing` がJuliaのキーワードではなく、`Nothing` 型のシングルトンオブジェクトにすぎないという意味で、*規約*です。また、上の `printx` 関数の例が説明のための作例であることに気付くかもしれません。`println` はすでに `nothing` を返すため、`return` の行は冗長だからです。

式 `return nothing` には、2つの短縮形があります。1つは、`return` キーワードが暗黙に `nothing` を返すことを利用して、このキーワードを単独で使う方法です。もう1つは、関数が最後に評価された式を暗黙に返すことを利用して、最後の式であれば `nothing` を単独で使う方法です。`return` や `nothing` を単独で使う代わりに、式 `return nothing` を使うかどうかは、コーディングスタイルの問題です。

## Operators Are Functions

Juliaでは、ほとんどの演算子は、特殊な構文に対応した通常の関数にすぎません。（例外は、`&&` や `||` のように、特殊な評価規則を持つ演算子です。[Short-Circuit Evaluation](@ref) では、演算子の評価前にオペランドを評価しないことが必要なため、これらの演算子を関数にすることはできません。）したがって、ほかの関数と同様に、括弧で囲んだ引数リストを使って演算子を適用することもできます。

```jldoctest
julia> 1 + 2 + 3
6

julia> +(1, 2, 3)
6
```

中置形式は関数適用形式と完全に等価です。実際、前者を構文解析すると、内部的には関数呼び出しが生成されます。これは、[`+`](@ref) や [`*`](@ref) のような演算子も、ほかの関数値と同じように代入したり、受け渡したりできることを意味します。

```jldoctest
julia> f = +;

julia> f(1, 2, 3)
6
```

ただし、`f` という名前では、この関数に中置記法を使うことはできません。

## Operators With Special Names

いくつかの特殊な式は、一見して分かりにくい名前の関数の呼び出しに対応しています。次の表に示します。

| 式                     | 呼び出される関数                                 |
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

`[A; B;; C; D;; ...]` に似た式で、`;` が3つ以上連続する場合も、`hvncat` の呼び出しに対応することに注意してください。

## [Anonymous Functions](@id man-anonymous-functions)

Juliaの関数は [first-class objects](https://en.wikipedia.org/wiki/First-class_citizen) です。変数に代入でき、代入先の変数から標準の関数呼び出し構文で呼び出せます。引数として使うことも、値として返すこともできます。また、次のいずれかの構文を使うと、名前を付けずに匿名で作成することもできます。

```jldoctest
julia> x -> x^2 + 2x - 1
#2 (generic function with 1 method)

julia> function (x)
           x^2 + 2x - 1
       end
#5 (generic function with 1 method)
```

どちらの文も、引数 `x` を1つ受け取り、その値における多項式 `x^2 + 2x - 1` の値を返す関数を作成します。結果はジェネリック関数ですが、その名前は連番に基づいてコンパイラが生成したものになることに注意してください。

無名関数の主な用途は、ほかの関数を引数に取る関数に渡すことです。典型的な例は [`map`](@ref) で、配列の各値に関数を適用し、その結果の値を含む新しい配列を返します。

```jldoctest
julia> map(round, [1.2, 3.5, 1.7])
3-element Vector{Float64}:
 1.0
 4.0
 2.0
```

[`map`](@ref) の第1引数として渡せる、目的の変換を行う名前付き関数がすでに存在するなら、これで問題ありません。しかし、すぐに使える名前付き関数が存在しないこともよくあります。そのような場合、無名関数の構文を使うと、名前を付けずに、その場限りの関数オブジェクトを簡単に作成できます。

```jldoctest
julia> map(x -> x^2 + 2x - 1, [1, 3, -1])
3-element Vector{Int64}:
  2
 14
 -2
```

複数の引数を受け取る無名関数は、構文 `(x,y,z)->2x+y-z` を使って記述できます。

無名関数の引数の型宣言は、名前付き関数と同じように機能します。たとえば、`x::Integer->2x` と記述できます。無名関数の戻り値の型は指定できません。

引数を取らない無名関数は、`()->2+2` と記述できます。引数のない関数という考え方は奇妙に思えるかもしれませんが、結果を事前に計算できない（または計算すべきでない）場合に役立ちます。たとえば、Juliaには現在時刻を秒単位で返す、引数なしの関数 [`time`](@ref) があります。そのため、`seconds = ()->round(Int, time())` は、その時刻を最も近い整数に丸めて返す無名関数を、変数 `seconds` に代入します。この無名関数を `seconds()` として呼び出すたびに、現在時刻が計算されて返されます。

## Tuples

Juliaには、関数の引数や戻り値と密接に関係する、*タプル*という組み込みのデータ構造があります。タプルは、任意の値を格納できる固定長のコンテナですが、変更はできません（*不変*です）。タプルはカンマと括弧を使って構築し、インデックスで要素にアクセスできます。

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

長さ1のタプルは、`(1,)` のように、カンマを付けて書く必要があることに注意してください。`(1)` では、単に値を括弧で囲んだだけになります。`()` は空の（長さ0の）タプルを表します。

## Named Tuples

タプルの各要素には名前を付けることもでき、その場合は*名前付きタプル*が構築されます。

```jldoctest
julia> x = (a=2, b=1+2)
(a = 2, b = 3)

julia> x[1]
2

julia> x.a
2
```

名前付きタプルのフィールドには、通常のインデックス構文（`x[1]` または `x[:a]`）に加えて、ドット構文（`x.a`）を使って名前でアクセスできます。

## [Destructuring Assignment and Multiple Return Values](@id destructuring-assignment)

代入の左辺には、カンマで区切った変数のリストを置くことができます（括弧で囲んでもかまいません）。右辺の値は、反復処理によって各変数に順番に代入され、*分解*されます。

```jldoctest
julia> (a, b, c) = 1:3
1:3

julia> b
2
```

右辺の値は、少なくとも左辺の変数の数と同じだけの要素を持つイテレータである必要があります（[Iteration interface](@ref man-interface-iteration) を参照）。イテレータの余分な要素は無視されます。

これを利用すると、タプルなどの反復可能な値を返すことで、関数から複数の値を返せます。たとえば、次の関数は2つの値を返します。

```jldoctest foofunc
julia> function foo(a, b)
           a+b, a*b
       end
foo (generic function with 1 method)
```

対話セッションで戻り値をどこにも代入せずに呼び出すと、返されたタプルが表示されます。

```jldoctest foofunc
julia> foo(2, 3)
(5, 6)
```

分解代入を使うと、各値を変数に取り出せます。

```jldoctest foofunc
julia> x, y = foo(2, 3)
(5, 6)

julia> x
5

julia> y
6
```

変数の値の交換も、よくある用途です。

```jldoctest foofunc
julia> y, x = x, y
(5, 6)

julia> x
6

julia> y
5
```

イテレータの要素の一部だけが必要な場合、無視する要素を、アンダースコアのみからなる変数 `_` に代入するのが一般的な規約です（これは、それ以外の用途では無効な変数名です。[Allowed Variable Names](@ref man-allowed-variable-names) を参照）。

```jldoctest
julia> _, _, _, d = 1:10
1:10

julia> d
4
```

代入リストの要素には、左辺として有効なほかの式も使えます。その場合、[`setindex!`](@ref) や [`setproperty!`](@ref) が呼び出されたり、イテレータの個々の要素が再帰的に分解されたりします。

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
    代入で `...` を使用するには、Julia 1.6が必要です。


代入リストの最後のシンボルに `...` を付けると（*slurping* と呼ばれます）、右辺のイテレータの残りの要素を含むコレクションまたは遅延イテレータが、その変数に代入されます。

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

厳密な処理方法や、特定のイテレータ向けのカスタマイズについて詳しくは、[`Base.rest`](@ref) を参照してください。

!!! compat "Julia 1.9"
    代入の最後以外の位置で `...` を使用するには、Julia 1.9が必要です。


代入でのslurpingは、最後以外の任意の位置でも使えます。ただし、コレクションの末尾をまとめて受け取る場合とは異なり、常に即時評価されます。

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

これは、関数 [`Base.split_rest`](@ref) を使って実装されています。

可変長引数を持つ関数の定義では、slurpingは依然として最後の位置でのみ許可されることに注意してください。ただし、[single argument destructuring](@ref man-argument-destructuring) にはこの制限は適用されません。メソッドディスパッチに影響しないためです。

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

反復処理に基づく分解の代わりに、プロパティ名を使って代入の右辺を分解することもできます。これはNamedTupleの構文に従い、`getproperty` を使って、左辺の各変数に、右辺の同じ名前のプロパティを代入します。

```jldoctest
julia> (; b, a) = (a=1, b=2, c=3)
(a = 1, b = 2, c = 3)

julia> a
1

julia> b
2
```

## [Argument destructuring](@id man-argument-destructuring)

分解の機能は、関数の引数でも使えます。関数の引数名を単なるシンボルではなくタプル（たとえば `(x, y)`）として記述すると、代入 `(x, y) = argument` が自動的に挿入されます。

```jldoctest
julia> minmax(x, y) = (y < x) ? (y, x) : (x, y)
minmax (generic function with 1 method)

julia> gap((min, max)) = max - min
gap (generic function with 1 method)

julia> gap(minmax(10, 2))
8
```

`gap` の定義に、括弧がもう一組あることに注意してください。これがないと、`gap` は2引数の関数になり、この例は動作しません。

同様に、関数の引数でもプロパティによる分解を使えます。

```jldoctest
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

無名関数で単一の引数を分解するには、カンマを追加する必要があります。

```jldoctest
julia> map(((x, y),) -> x + y, [(1, 2), (3, 4)])
2-element Vector{Int64}:
 3
 7
```

## Varargs Functions

任意の個数の引数を受け取る関数を書けると便利なことがよくあります。このような関数は、従来から「varargs」関数と呼ばれています。これは「variable number of arguments（可変個数の引数）」の略です。最後の位置引数の後に省略記号を付けることで、可変長引数関数を定義できます。

```jldoctest barfunc
julia> bar(a, b, x...) = (a, b, x)
bar (generic function with 1 method)
```

変数 `a` と `b` は、通常どおり最初の2つの引数の値に束縛されます。変数 `x` は、`bar` に最初の2引数に続いて渡された、0個以上の値からなる反復可能なコレクションに束縛されます。

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

これらのすべての場合で、`x` は、`bar` に渡された末尾の値からなるタプルに束縛されます。

可変長引数として渡す値の個数を制限することもできます。これについては、後で [Parametrically-constrained Varargs methods](@ref) で説明します。

逆に、反復可能なコレクションに含まれる値を、関数呼び出しの個々の引数として「展開（splat）」できると便利なこともよくあります。これにも `...` を使いますが、今度は関数呼び出しの中で使います。

```jldoctest barfunc
julia> x = (3, 4)
(3, 4)

julia> bar(1, 2, x...)
(1, 2, (3, 4))
```

この例では、可変長引数を受け取る箇所に、値のタプルをちょうど差し込んでいます。ただし、必ずしもその位置である必要はありません。

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

また、関数呼び出しで展開する反復可能オブジェクトは、タプルでなくてもかまいません。

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

さらに、引数の展開先となる関数も、可変長引数関数である必要はありません（そうであることは多いですが）。

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

このように、展開したコンテナの要素数が適切でなければ、関数呼び出しは失敗します。これは、明示的に引数を多く渡しすぎた場合と同じです。

## Optional Arguments

関数の引数には、妥当なデフォルト値を用意できることがよくあります。これにより、利用者は呼び出すたびにすべての引数を渡す必要がなくなります。たとえば、`Dates` モジュールの関数 [`Date(y, [m, d])`](@ref) は、指定した年 `y`、月 `m`、日 `d` に対して、`Date` 型の値を構築します。ただし、引数 `m` と `d` は省略可能で、デフォルト値は `1` です。この動作は、次のように簡潔に表せます。

```jldoctest date_default_args
julia> using Dates

julia> function date(y::Int64, m::Int64=1, d::Int64=1)
           err = Dates.validargs(Date, y, m, d)
           err === nothing || throw(err)
           return Date(Dates.UTD(Dates.totaldays(y, m, d)))
       end
date (generic function with 3 methods)
```

この定義は、`UTInstant{Day}` 型の引数を1つ受け取る、`Date` 関数の別のメソッドを呼び出していることに注意してください。

この定義により、関数は1個、2個、3個のいずれの引数でも呼び出せます。引数を1個または2個だけ指定した場合は、`1` が自動的に渡されます。

```jldoctest date_default_args
julia> date(2000, 12, 12)
2000-12-12

julia> date(2000, 12)
2000-12-01

julia> date(2000)
2000-01-01
```

省略可能な引数は、実際には、引数の個数が異なる複数のメソッド定義を書くための便利な構文にすぎません（[Note on Optional and keyword Arguments](@ref) を参照）。このことは、先ほどの `date` 関数の例で、`methods` 関数を呼び出すと確認できます。

```jldoctest date_default_args; filter = r"@ .*"a
julia> methods(date)
# 3 methods for generic function "date" from Main:
 [1] date(y::Int64, m::Int64, d::Int64)
     @ REPL[2]:1
 [2] date(y::Int64, m::Int64)
     @ REPL[2]:1
 [3] date(y::Int64)
     @ REPL[2]:1
```

## Keyword Arguments

多くの引数を必要とする関数や、多くの動作を備えた関数もあります。そのような関数の呼び出し方を覚えるのは大変です。キーワード引数を使うと、位置だけでなく名前で引数を指定できるため、このような複雑なインターフェースを使いやすく、拡張しやすくできます。

たとえば、線を描画する関数 `plot` を考えてみましょう。この関数には、線のスタイル、幅、色などを制御する多くのオプションがあるかもしれません。キーワード引数を受け取れるなら、線幅だけを指定して、`plot(x, y, width=2)` のように呼び出せます。これには2つの利点があります。引数の意味を名前で示せるので、呼び出しが読みやすくなります。また、多数の引数のうち任意の一部だけを、任意の順序で渡せるようになります。

キーワード引数を持つ関数は、シグネチャにセミコロンを使って定義します。

```julia
function plot(x, y; style="solid", width=1, color="black")
    ###
end
```

関数を呼び出す際、セミコロンは省略可能です。`plot(x, y, width=2)` と `plot(x, y; width=2)` のどちらでも呼び出せますが、前者の書き方のほうが一般的です。セミコロンを明示する必要があるのは、以下で説明する可変長引数や、計算で求めたキーワードを渡す場合だけです。

キーワード引数のデフォルト値は、必要な場合（対応するキーワード引数が渡されなかった場合）にのみ、左から右の順で評価されます。そのため、デフォルト値の式から、それより前のキーワード引数を参照できます。

キーワード引数の型は、次のように明示できます。

```julia
function f(; x::Int=1)
    ###
end
```

キーワード引数は、可変長引数関数でも使えます。

```julia
function plot(x...; style="solid")
    ###
end
```

可変長引数関数と同様に、`...` を使って追加のキーワード引数をまとめて受け取れます。

```julia
function f(x; y=0, kwargs...)
    ###
end
```

`f` の内部では、`kwargs` は名前付きタプルに対する不変のキー・値イテレータになります。名前付きタプルは、呼び出し時にセミコロンを使うことで、キーワード引数として渡せます。たとえば、`f(x, z=1; kwargs...)` と記述します。`Symbol` をキーとする辞書や、最初の値がシンボルである2要素のコレクションを返すほかのイテレータも、同様に渡せます。

メソッド定義でキーワード引数にデフォルト値を設定しなかった場合、その引数は*必須*になります。呼び出し元が値を指定しなければ、[`UndefKeywordError`](@ref) 例外が送出されます。

```julia
function f(x; y)
    ###
end
f(3, y=5) # ok, y is assigned
f(3)      # throws UndefKeywordError(:y)
```

セミコロンの後に `key => value` という式を渡すこともできます。たとえば、`plot(x, y; :width => 2)` は `plot(x, y, width=2)` と等価です。これは、キーワード名を実行時に計算する場合に便利です。

セミコロンの後に識別子だけ、またはドット式だけを記述した場合、キーワード引数名は、その識別子やフィールド名から暗黙に決まります。たとえば、`plot(x, y; width)` は `plot(x, y; width=width)` と等価で、`plot(x, y; options.width)` は `plot(x, y; width=options.width)` と等価です。

キーワード引数の性質上、同じ引数を複数回指定することが可能です。たとえば、呼び出し `plot(x, y; options..., width=2)` では、`options` という構造にも `width` の値が含まれている可能性があります。その場合、最も右にある指定が優先されます。この例では、`width` の値は必ず `2` になります。ただし、`plot(x, y, width=2, width=3)` のように、同じキーワード引数を明示的に複数回指定することは許可されず、構文エラーになります。

## Evaluation Scope of Default Values

省略可能な引数やキーワード引数のデフォルト値の式を評価するとき、スコープ内にあるのは、それより*前の*引数だけです。たとえば、次の定義を考えます。

```julia
function f(x, a=b, b=1)
    ###
end
```

`a=b` 内の `b` は、後続の引数 `b` ではなく、外側のスコープにある `b` を参照します。

## Do-Block Syntax for Function Arguments

関数をほかの関数に引数として渡すことは強力な手法ですが、その構文が常に使いやすいとは限りません。特に、引数として渡す関数が複数行にわたる場合、このような呼び出しは書きにくくなります。例として、複数の場合分けを持つ関数に対して [`map`](@ref) を呼び出す場合を考えます。

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

Juliaには、このコードをより明確に書き直すための予約語 `do` があります。

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

`do x` 構文は、`x` を引数に持つ無名関数を作成し、それを「外側」の関数（この例では [`map`](@ref)）の第1引数として渡します。同様に、`do a,b` は2引数の無名関数を作成します。一方、`do (a,b)` は、分解されるタプルを引数に取る、1引数の無名関数を作成することに注意してください。単に `do` と書くと、その後に続くものが `() -> ...` という形式の無名関数であることを宣言します。

これらの引数をどのように初期化するかは、「外側」の関数によって決まります。ここでは、[`map`](@ref) が `x` に `A`、`B`、`C` を順に設定し、それぞれについて無名関数を呼び出します。これは、構文 `map(func, [A, B, C])` を使った場合と同じです。

この構文では、呼び出しが通常のコードブロックのように見えるため、関数を使って言語を実質的に拡張しやすくなります。用途は [`map`](@ref) に限らず、システム状態の管理など、まったく異なるものも数多くあります。たとえば、[`open`](@ref) には、開いたファイルが最終的に必ず閉じられるようにしながらコードを実行するバージョンがあります。

```julia
open("outfile", "w") do io
    write(io, data)
end
```

これは、次の定義によって実現されています。

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

ここでは、[`open`](@ref) がまず書き込み用にファイルを開き、得られた出力ストリームを、`do ... end` ブロックで定義した無名関数に渡します。その関数が終了すると、正常終了したか例外を送出したかにかかわらず、[`open`](@ref) がストリームを確実に適切に閉じます。（`try/finally` 構文については、[Control Flow](@ref) で説明します。）

`do` ブロック構文を使うときは、ユーザーが定義した関数の引数がどのように初期化されるかを知るために、ドキュメントや実装を確認すると役立ちます。

`do` ブロックは、ほかの内部関数と同様に、外側のスコープの変数を「キャプチャ」できます。たとえば、上の `open...do` の例にある変数 `data` は、外側のスコープからキャプチャされています。キャプチャされた変数は、[performance tips](@ref man-performance-captured) で説明するように、性能上の課題を生じさせることがあります。

## Function composition and piping

Juliaの関数は、合成やパイプ（連鎖）によって組み合わせることができます。

関数合成とは、複数の関数を組み合わせ、その合成結果を引数に適用することです。関数の合成には関数合成演算子（`∘`）を使います。したがって、`(f ∘ g)(args...; kw...)` は `f(g(args...; kw...))` と同じです。

REPLや適切に設定されたエディタでは、`\circ<tab>` を使って合成演算子を入力できます。

たとえば、関数 `sqrt` と `+` は、次のように合成できます。

```jldoctest
julia> (sqrt ∘ +)(3, 6)
3.0
```

これは、まず数値を加算し、その結果の平方根を求めます。

次の例では、3つの関数を合成し、その合成結果を文字列の配列にマップします。

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

関数の連鎖とは、前の関数の出力に次の関数を適用することです。データを後続の関数に送ることから、「パイピング」や「パイプの使用」とも呼ばれます。

```jldoctest
julia> 1:10 |> sum |> sqrt
7.416198487095663
```

ここでは、`sum` が求めた合計が、関数 `sqrt` に渡されます。等価な関数合成は次のとおりです。

```jldoctest
julia> (sqrt ∘ sum)(1:10)
7.416198487095663
```

パイプ演算子は、`.|>` としてブロードキャストと組み合わせることもできます。これにより、連鎖・パイピングと、後述のドットによるベクトル化構文を便利に組み合わせられます。

```jldoctest
julia> ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
4-element Vector{Any}:
  "A"
  "tsil"
  "Of"
 7
```

パイプと無名関数を組み合わせる場合、後続のパイプが無名関数の本体の一部として解析されないようにするには、括弧が必要です。次を比較してください。

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

技術計算向けの言語では、関数の「ベクトル化」版を用意することが一般的です。これは、配列 `A` の各要素に関数 `f(x)` を適用し、`f(A)` によって新しい配列を生成するものです。この種の構文はデータ処理に便利ですが、ほかの言語では性能のためにもベクトル化が必要になることがよくあります。ループが遅い場合、関数の「ベクトル化」版を使うことで、低水準言語で書かれた高速なライブラリコードを呼び出せるからです。Juliaでは、性能のためにベクトル化された関数が必要なわけでは*ありません*。実際、自分でループを書いたほうがよいこともよくあります（[Performance Tips](@ref man-performance-tips) を参照）。それでも、ベクトル化された関数は便利です。そこでJuliaでは、*どの*関数 `f` でも、構文 `f.(A)` によって、任意の配列（またはほかのコレクション）の各要素に適用できます。たとえば、`sin` は、次のようにベクトル `A` のすべての要素に適用できます。

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

もちろん、たとえば `f(A::AbstractArray) = map(f, A)` のように、`f` にベクトル専用のメソッドを定義すれば、ドットを省略できます。これは `f.(A)` と同じくらい効率的です。`f.(A)` 構文の利点は、どの関数をベクトル化できるようにするかを、ライブラリの作者があらかじめ決める必要がないことです。

より一般には、`f.(args...)` は実際には `broadcast(f, args...)` と等価です。これにより、複数の配列（形状が異なっていてもかまいません）や、配列とスカラーを混在させたものに対して演算できます（[Broadcasting](@ref) を参照）。たとえば、`f(x, y) = 3x + 4y` がある場合、`f.(pi, A)` は、`A` 内の各 `a` に対する `f(pi,a)` からなる新しい配列を返します。また、`f.(vector1, vector2)` は、各インデックス `i` に対する `f(vector1[i], vector2[i])` からなる新しいベクトルを返します（ベクトルの長さが異なる場合は例外を送出します）。

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

キーワード引数はブロードキャストの対象にはならず、関数の各呼び出しにそのまま渡されます。たとえば、`round.(x, digits=3)` は `broadcast(x -> round(x, digits=3), x)` と等価です。

さらに、*入れ子になった* `f.(args...)` 呼び出しは、単一の `broadcast` ループに*融合*されます。たとえば、`sin.(cos.(X))` は `broadcast(x -> sin(cos(x)), X)` と等価で、`[sin(cos(x)) for x in X]` と同様です。`X` に対するループは1つだけで、結果のために確保される配列も1つだけです。［対照的に、典型的な「ベクトル化」言語で `sin(cos(X))` を実行すると、まず `tmp=cos(X)` 用の一時配列を1つ確保し、次に別のループで `sin(tmp)` を計算して、2つ目の配列を確保します。］このループ融合は、行われるかどうか分からないコンパイラの最適化ではありません。入れ子になった `f.(args...)` 呼び出しに対して、常に*構文上保証される*ものです。厳密には、「ドットなし」の関数呼び出しが現れた時点で融合は止まります。たとえば、`sin.(sort(cos.(X)))` では、関数 `sort` が間にあるため、`sin` と `cos` のループを融合することはできません。

最後に、通常は、ベクトル化演算の出力配列を*事前に確保*しておくと、最も高い効率が得られます。これにより、繰り返し呼び出すたびに結果用の新しい配列を確保せずに済みます（[Pre-allocate outputs](@ref) を参照）。これに便利な構文が `X .= ...` です。これは `broadcast!(identity, X, ...)` と等価ですが、上と同様に、`broadcast!` のループは、入れ子になったすべての「ドット」呼び出しと融合されます。たとえば、`X .= sin.(Y)` は `broadcast!(sin, X, Y)` と等価で、`X` を `sin.(Y)` でインプレースに上書きします。左辺が配列のインデックス式（たとえば `X[begin+1:end] .= sin.(Y)`）である場合は、`view` に対する `broadcast!` に変換されます。たとえば `broadcast!(sin, view(X, firstindex(X)+1:lastindex(X)), Y)` のようになり、左辺がインプレースに更新されます。

式の中の多くの演算や関数呼び出しにドットを付けるのは面倒で、コードも読みにくくなりがちです。そのため、式の中の*すべての*関数呼び出し、演算、代入を「ドット付き」の形式に変換するマクロ [`@.`](@ref @__dot__) が用意されています。

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

`.+` のような二項（または単項）演算子も、同じ仕組みで処理されます。これらは `broadcast` 呼び出しと等価であり、入れ子になったほかの「ドット」呼び出しと融合されます。`X .+= Y` などは `X .= X .+ Y` と等価で、融合されたインプレース代入になります。[dot operators](@ref man-dot-operators) も参照してください。

次の例のように、[`|>`](@ref) を使って、ドット演算と関数の連鎖を組み合わせることもできます。

```jldoctest
julia> 1:5 .|> [x->x^2, inv, x->2*x, -, isodd]
5-element Vector{Real}:
    1
    0.5
    6
   -4
 true
```

融合されたブロードキャスト内のすべての関数は、結果の各要素に対して必ず呼び出されます。したがって、`X .+ σ .* randn.()` は、配列 `X` の各要素に、同一の分布から独立に生成した乱数値からなるマスクを加えます。一方、`X .+ σ .* randn()` は、各要素に*同じ*乱数値を加えます。融合された計算が、ブロードキャストの反復処理における1つ以上の軸に沿って一定である場合は、中間値を格納する領域を確保し、空間と時間のトレードオフを利用することで、計算回数を減らせることがあります。詳しくは、[performance tips](@ref man-performance-unfuse) を参照してください。

## Further Reading

ここで述べた内容は、関数定義の全体像にはほど遠いことを付け加えておきます。Juliaには高度な型システムがあり、引数の型に基づく多重ディスパッチが可能です。ここで示した例はいずれも引数に型注釈を付けていないため、あらゆる型の引数に適用できます。型システムについては [Types](@ref man-types) で説明します。また、実行時の引数の型に基づく多重ディスパッチによって選択されるメソッドを使って関数を定義する方法については、[Methods](@ref) で説明します。
