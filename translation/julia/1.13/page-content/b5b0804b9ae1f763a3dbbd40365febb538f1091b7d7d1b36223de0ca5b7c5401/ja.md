# [Functions](@id man-functions)

Juliaでは、関数は引数の値のタプルを戻り値に写像するオブジェクトです。Juliaの関数は、プログラムのグローバルな状態を変更したり、その影響を受けたりするため、純粋な数学的関数ではありません。Juliaで関数を定義する基本的な構文は次のとおりです。

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

代入形式では、関数本体は単一の式でなければなりませんが、複合式でもかまいません（[Compound Expressions](@ref man-compound-expressions) を参照）。Juliaでは短く単純な関数定義がよく使われます。そのため、この短縮構文はJuliaらしい書き方として定着しており、入力の手間も見た目の煩雑さも大幅に減らせます。

関数の呼び出しには、一般的な丸括弧を使う構文を用います。

```jldoctest fofxy
julia> f(2, 3)
5
```

丸括弧を付けない場合、式 `f` は関数オブジェクトを指し、ほかの値と同様に受け渡しできます。

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

Juliaの関数の引数は、「共有渡し（pass-by-sharing）」と呼ばれることもある規則に従います。これは、関数に渡す際に値がコピーされないことを意味します。関数の引数自体は、[assignments](@ref man-assignment-expressions) `argument_name = argument_value` とよく似た、新しい変数の*束縛*（値を参照できる新しい「名前」）として働くため、引数が参照するオブジェクトは、渡された値と同一です。関数内で可変な値（`Array` など）に加えた変更は、呼び出し元からも見えます。（これは、Scheme、ほとんどのLisp、Python、Ruby、Perlなどの動的言語と同じ動作です。）

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

文 `x[1] = 42` はオブジェクト `x` *自体を変更する*ため、呼び出し元がこの引数として渡した配列にも、その変更が*反映されます*。一方、代入 `y = 7 + y` は、`y` という*束縛*（「名前」）を変更し、新しい値 `7 + y` を参照させます。`y` が参照していた*元の*オブジェクトを変更するわけではないため、呼び出し元が渡した対応する引数は*変更されません*。これは、`f(x, y)` を呼び出すと確認できます。

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

Juliaで一般的に使われる慣例（構文上の要件ではありません）では、このような関数には、`f(x, y)` ではなく [typically be named `f!(x, y)`](@ref man-punctuation)。これは、引数の少なくとも1つ（多くの場合は最初の引数）が変更されることを、呼び出し箇所で視覚的に知らせるためです。

!!! warning "引数間でのメモリの共有"
    変更される引数が別の引数とメモリを共有している場合、変更を伴う関数は予期しない動作をすることがあります。この状況はエイリアシングと呼ばれます（たとえば、一方が他方のビューである場合です）。エイリアシングがあっても期待どおりの結果になると関数のdocstringに明記されていない限り、そのような入力に対して正しく動作することを保証する責任は呼び出し元にあります。


## Argument-type declarations

Juliaの [Type Declarations](@ref) で通常行うように、引数名に `::TypeName` を付けることで、関数の引数の型を宣言できます。たとえば、次の関数は [Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number) を再帰的に計算します。

```
fib(n::Integer) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)
```

ここで、`::Integer` という指定は、`n` が [abstract](@ref man-abstract-types) `Integer` 型のサブタイプである場合にのみ、この関数を呼び出せることを意味します。

引数の型宣言は、**通常、パフォーマンスに影響しません**。引数の型を宣言しているかどうか、またどの型を宣言しているかにかかわらず、Juliaは呼び出し元から実際に渡された引数の型に特化した関数をコンパイルします。たとえば、`fib(1)` を呼び出すと、`Int` 型の引数に特化して最適化された `fib` がコンパイルされます。その後、`fib(7)` または `fib(15)` が呼び出された際には、そのコンパイル済みの関数が再利用されます。（まれな例外として、引数の型宣言によってコンパイラによる追加の特殊化が行われる場合もあります。[Be aware of when Julia avoids specializing](@ref) を参照してください。）Juliaで引数の型を宣言する主な理由は、むしろ次のとおりです。

  * **ディスパッチ：** [Methods](@ref) で説明するように、引数の型ごとに異なるバージョン（「メソッド」）の関数を用意できます。この場合、引数の型に基づいて、どの引数に対してどの実装を呼び出すかが決まります。たとえば、[Binet's formula](https://en.wikipedia.org/wiki/Fibonacci_number#Binet%27s_formula) を用いて整数以外の値にも拡張することで、任意の `Number` 型で動作する、まったく異なるアルゴリズム `fib(x::Number) = ...` を実装できます。
  * **正確性：** 特定の引数の型に対してのみ正しい結果を返す関数では、型宣言が役立つことがあります。たとえば、引数の型を省略して `fib(n) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)` と書くと、`fib(1.5)` はエラーを出さずに、意味のない答え `1.0` を返してしまいます。
  * **明確さ：** 型宣言は、想定される引数を示すドキュメントとしても機能します。

ただし、**引数の型を過度に制限するのは、よくある間違いです**。関数の適用範囲を不必要に狭め、想定していなかった状況で再利用できなくなるおそれがあります。たとえば、上記の `fib(n::Integer)` 関数は、`Int` 型の引数（マシン整数）でも、`BigInt` 型の任意精度整数でも、同じように動作します（[BigFloats and BigInts](@ref BigFloats-and-BigInts) を参照）。これは特に便利です。フィボナッチ数は指数関数的に急速に増大するため、`Int` のような固定精度の型では、すぐにオーバーフローするからです（[Overflow behavior](@ref) を参照）。しかし、関数を `fib(n::Int)` と宣言していたら、理由もなく `BigInt` への適用が妨げられてしまいます。一般に、引数には適用可能な最も一般的な抽象型を使い、**迷ったら引数の型を省略してください**。必要になれば、引数の型指定はいつでも後から追加できます。省略しても、パフォーマンスや機能が犠牲になることはありません。

## The `return` Keyword

関数が返す値は、最後に評価された式の値です。デフォルトでは、これは関数定義の本体の最後の式になります。前の節の関数 `f` の例では、式 `x + y` の値です。別の方法として、多くのほかの言語と同様に、`return` キーワードに式を指定すると、その値を返して関数を即座に終了できます。

```julia
function g(x, y)
    return x * y
    x + y
end
```

関数定義は対話セッションでも入力できるため、これらの定義は簡単に比較できます。

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

もちろん、`g` のように処理が一直線に進むだけの関数本体では、`return` を使う意味はありません。式 `x + y` は評価されないので、単に `x * y` を関数の最後の式にして、`return` を省略すればよいからです。しかし、ほかの制御フローと組み合わせると、`return` は実際に役立ちます。たとえば、次の関数はオーバーフローを避けながら、2辺の長さが `x` と `y` の直角三角形の斜辺の長さを計算します。

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

この関数にはリターンする箇所が3つあり、`x` と `y` の値に応じて、3つの異なる式のいずれかの値を返します。最終行は最後の式なので、`return` は省略できます。

### [Return type](@id man-functions-return-type)

関数宣言では、`::` 演算子を使って戻り値の型を指定できます。これにより、戻り値は指定した型に変換されます。

```jldoctest
julia> function g(x, y)::Int8
           return x * y
       end;

julia> typeof(g(1, 2))
Int8
```

この関数は、`x` と `y` の型にかかわらず、常に `Int8` を返します。戻り値の型について詳しくは、[Type Declarations](@ref) を参照してください。

Juliaでは、戻り値の型宣言は**ほとんど使われません**。一般には、代わりに、Juliaのコンパイラが戻り値の型を自動的に推論できる「型安定な」関数を書くべきです。詳しくは、[Performance Tips](@ref man-performance-tips) の章を参照してください。

### Returning nothing

値を返す必要のない関数（副作用だけを目的に使う関数）では、値 [`nothing`](@ref) を返すのがJuliaの慣例です。

```julia
function printx(x)
    println("x = $x")
    return nothing
end
```

これを*慣例*と呼ぶのは、`nothing` がJuliaのキーワードではなく、単に `Nothing` 型のシングルトンオブジェクトだからです。また、上の `printx` 関数の例は、説明のためにあえて冗長にしてあることに気づくかもしれません。`println` はすでに `nothing` を返すため、`return` の行は不要です。

式 `return nothing` には、2通りの短縮形があります。1つは、`return` キーワードだけを使う方法です。これは暗黙的に `nothing` を返します。もう1つは、関数が最後に評価された式の値を暗黙的に返すことを利用し、最後の式であれば `nothing` だけを書く方法です。`return` や `nothing` だけではなく、式 `return nothing` を好むかどうかは、コーディングスタイルの問題です。

## Operators Are Functions

Juliaでは、ほとんどの演算子は、特別な構文を使えるようにした関数にすぎません。（例外は、`&&` や `||` のように、評価に特別な意味論を持つ演算子です。[Short-Circuit Evaluation](@ref) では演算子の評価前にオペランドを評価してはならないため、これらの演算子は関数にはできません。）したがって、ほかの関数と同様に、丸括弧で囲んだ引数リストを使って適用することもできます。

```jldoctest
julia> 1 + 2 + 3
6

julia> +(1, 2, 3)
6
```

中置形式は、関数適用形式と完全に等価です。実際、中置形式は構文解析によって内部的に関数呼び出しへ変換されます。つまり、[`+`](@ref) や [`*`](@ref) といった演算子も、ほかの関数の値と同様に代入したり受け渡したりできます。

```jldoctest
julia> f = +;

julia> f(1, 2, 3)
6
```

ただし、`f` という名前では、この関数を中置記法で使うことはできません。

## Operators With Special Names

いくつかの特殊な式は、式からはわかりにくい名前の関数呼び出しに対応しています。具体的には次のとおりです。

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

`[A; B;; C; D;; ...]` に似た式で、`;` が3つ以上連続するものも、`hvncat` の呼び出しに対応することに注意してください。

## [Anonymous Functions](@id man-anonymous-functions)

Juliaの関数は [first-class objects](https://en.wikipedia.org/wiki/First-class_citizen) です。変数に代入でき、代入先の変数から標準的な関数呼び出し構文で呼び出せます。また、引数として使うことも、値として返すこともできます。さらに、次のいずれかの構文を使えば、名前を付けずに無名関数として作成できます。

```jldoctest
julia> x -> x^2 + 2x - 1
#2 (generic function with 1 method)

julia> function (x)
           x^2 + 2x - 1
       end
#5 (generic function with 1 method)
```

どちらの文も、引数 `x` を1つ受け取り、その値における多項式 `x^2 + 2x - 1` の値を返す関数を作成します。作成されるのはジェネリック関数ですが、名前は連番に基づいてコンパイラが生成する点に注意してください。

無名関数の主な用途は、ほかの関数を引数に取る関数へ渡すことです。典型的な例は [`map`](@ref) です。これは配列の各値に関数を適用し、結果の値を含む新しい配列を返します。

```jldoctest
julia> map(round, [1.2, 3.5, 1.7])
3-element Vector{Float64}:
 1.0
 4.0
 2.0
```

この変換を行う名前付き関数がすでに存在し、[`map`](@ref) の第1引数として渡せるのであれば、これで十分です。しかし、そのまま使える名前付き関数がないこともよくあります。そのような場合、無名関数の構文を使えば、名前を付けることなく、一度だけ使う関数オブジェクトを簡単に作成できます。

```jldoctest
julia> map(x -> x^2 + 2x - 1, [1, 3, -1])
3-element Vector{Int64}:
  2
 14
 -2
```

複数の引数を受け取る無名関数は、`(x,y,z)->2x+y-z` という構文で書けます。

無名関数でも、名前付き関数と同様に引数の型を宣言できます。たとえば、`x::Integer->2x` のように書きます。無名関数の戻り値の型は指定できません。

引数を取らない無名関数は、`()->2+2` と書けます。引数のない関数という考え方は奇妙に思えるかもしれませんが、結果を事前に計算できない場合や、事前に計算すべきでない場合に役立ちます。たとえば、Juliaには、現在時刻を秒単位で返す、引数を取らない [`time`](@ref) 関数があります。したがって、`seconds = ()->round(Int, time())` は、この時刻を最も近い整数に丸めて返す無名関数を変数 `seconds` に代入します。この無名関数を `seconds()` として呼び出すたびに、現在時刻が計算されて返されます。

## Tuples

Juliaには、関数の引数や戻り値と密接に関係する、*タプル*と呼ばれる組み込みのデータ構造があります。タプルは任意の値を保持できる固定長のコンテナですが、変更はできません（*不変*です）。タプルはカンマと丸括弧を使って構築し、インデックスで要素にアクセスできます。

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

長さ1のタプルは、`(1,)` のように、必ずカンマを付けて書く必要があります。`(1)` では、単に値を丸括弧で囲んだだけになるためです。`()` は空の（長さ0の）タプルを表します。

## Named Tuples

タプルの各要素には名前を付けることもできます。その場合は、*名前付きタプル*が構築されます。

```jldoctest
julia> x = (a=2, b=1+2)
(a = 2, b = 3)

julia> x[1]
2

julia> x.a
2
```

名前付きタプルのフィールドには、通常のインデックス構文（`x[1]` または `x[:a]`）に加え、ドット構文（`x.a`）を使って名前でアクセスできます。

## [Destructuring Assignment and Multiple Return Values](@id destructuring-assignment)

代入の左辺には、カンマ区切りの変数リストを置くことができます（丸括弧で囲んでもかまいません）。右辺の値を反復処理し、各変数に順に代入することで、値が*分解*されます。

```jldoctest
julia> (a, b, c) = 1:3
1:3

julia> b
2
```

右辺の値は、左辺の変数の数以上の要素を持つイテレータである必要があります（[Iteration interface](@ref man-interface-iteration) を参照）。イテレータの余分な要素は無視されます。

これを利用すれば、タプルなどの反復可能な値を返すことで、関数から複数の値を返せます。たとえば、次の関数は2つの値を返します。

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

変数の値を入れ替えるのも、よくある用途です。

```jldoctest foofunc
julia> y, x = x, y
(5, 6)

julia> x
6

julia> y
5
```

イテレータの要素の一部だけが必要な場合、無視する要素を、アンダースコアだけで構成される変数 `_` に代入するのが一般的な慣例です（これは、それ以外の用途では使えない変数名です。[Allowed Variable Names](@ref man-allowed-variable-names) を参照）。

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
    代入で `...` を使うにはJulia 1.6が必要です。


代入リストの最後のシンボルに `...` を付けると（*slurping*と呼ばれます）、右辺のイテレータの残りの要素を含むコレクションまたは遅延イテレータが、その変数に代入されます。

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
    代入の末尾以外の位置で `...` を使うにはJulia 1.9が必要です。


代入でのslurpingは、末尾以外のどの位置でも使えます。ただし、コレクションの末尾をslurpingする場合とは異なり、常に即時に評価されます。

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

可変長引数を持つ関数の定義では、slurpingは依然として末尾でしか使えない点に注意してください。ただし、[single argument destructuring](@ref man-argument-destructuring) にはこの制限はありません。これはメソッドのディスパッチに影響しないためです。

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

代入の右辺は、反復に基づいて分解する代わりに、プロパティ名を使って分解することもできます。これはNamedTupleの構文に従い、`getproperty` を使って、代入の右辺にある同名のプロパティを左辺の各変数へ代入します。

```jldoctest
julia> (; b, a) = (a=1, b=2, c=3)
(a = 1, b = 2, c = 3)

julia> a
1

julia> b
2
```

## [Argument destructuring](@id man-argument-destructuring)

分解の機能は、関数の引数内でも使えます。関数の引数名を単なるシンボルではなくタプル（たとえば `(x, y)`）として書くと、代入 `(x, y) = argument` が自動的に挿入されます。

```jldoctest
julia> minmax(x, y) = (y < x) ? (y, x) : (x, y)
minmax (generic function with 1 method)

julia> gap((min, max)) = max - min
gap (generic function with 1 method)

julia> gap(minmax(10, 2))
8
```

`gap` の定義に、丸括弧がもう1組あることに注意してください。これがないと、`gap` は2引数の関数になり、この例は動作しません。

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

無名関数で単一の引数を分解するには、カンマをもう1つ付ける必要があります。

```jldoctest
julia> map(((x, y),) -> x + y, [(1, 2), (3, 4)])
2-element Vector{Int64}:
 3
 7
```

## Varargs Functions

任意の個数の引数を受け取る関数を書けると、便利なことがよくあります。このような関数は、従来「varargs」関数と呼ばれます。これは「variable number of arguments（可変個数の引数）」の略です。最後の位置引数に省略記号を付けることで、可変長引数を持つ関数を定義できます。

```jldoctest barfunc
julia> bar(a, b, x...) = (a, b, x)
bar (generic function with 1 method)
```

変数 `a` と `b` は、通常どおり最初の2つの引数の値に束縛されます。変数 `x` は、`bar` の最初の2引数の後に渡された、0個以上の値を含む反復可能なコレクションに束縛されます。

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

いずれの場合も、`x` は、`bar` に渡された末尾の値のタプルに束縛されます。

可変長引数として渡す値の個数を制約することもできます。これについては、後の [Parametrically-constrained Varargs methods](@ref) で説明します。

逆に、反復可能なコレクションに含まれる値を、関数呼び出しの個々の引数として展開（splat）できると便利なこともよくあります。この場合も `...` を使いますが、関数呼び出し側に記述します。

```jldoctest barfunc
julia> x = (3, 4)
(3, 4)

julia> bar(1, 2, x...)
(1, 2, (3, 4))
```

この例では、値のタプルが、可変長引数の呼び出しでちょうど可変個数の引数に当たる位置に展開されています。しかし、その位置でなければならないわけではありません。

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

また、関数呼び出しで展開する反復可能なオブジェクトは、タプルである必要はありません。

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

さらに、引数を展開して渡す先の関数は、可変長引数を持つ関数でなくてもかまいません（そうであることは多いですが）。

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

このように、展開するコンテナの要素数が正しくないと、引数を明示的に多く渡しすぎた場合と同様に、関数呼び出しは失敗します。

## Optional Arguments

関数の引数には、多くの場合、妥当なデフォルト値を設定できます。これにより、ユーザーが呼び出しのたびにすべての引数を渡す手間を省けます。たとえば、`Dates` モジュールの関数 [`Date(y, [m, d])`](@ref) は、指定された年 `y`、月 `m`、日 `d` から `Date` 型の値を構築します。ただし、引数 `m` と `d` は省略可能で、デフォルト値は `1` です。この動作は、次のように簡潔に表現できます。

```jldoctest date_default_args
julia> using Dates

julia> function date(y::Int64, m::Int64=1, d::Int64=1)
           err = Dates.validargs(Date, y, m, d)
           err === nothing || throw(err)
           return Date(Dates.UTD(Dates.totaldays(y, m, d)))
       end
date (generic function with 3 methods)
```

この定義では、`UTInstant{Day}` 型の引数を1つ受け取る、`Date` 関数の別のメソッドを呼び出していることに注意してください。

この定義により、関数は1個、2個、3個のいずれの引数でも呼び出せます。引数を1個または2個だけ指定すると、省略された引数には `1` が自動的に渡されます。

```jldoctest date_default_args
julia> date(2000, 12, 12)
2000-12-12

julia> date(2000, 12)
2000-12-01

julia> date(2000)
2000-01-01
```

省略可能な引数は、実際には、引数の個数が異なる複数のメソッド定義を書くための便利な構文にすぎません（[Note on Optional and keyword Arguments](@ref) を参照）。このことは、上記の `date` 関数の例について、`methods` 関数を呼び出すと確認できます。

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

多くの引数を必要とする関数や、多様な動作を持つ関数もあります。そのような関数の呼び出し方を覚えるのは大変です。キーワード引数を使うと、位置だけでなく名前で引数を識別できるため、複雑なインターフェースを使いやすく、拡張しやすくできます。

たとえば、線を描画する関数 `plot` を考えます。この関数には、線のスタイル、太さ、色などを制御する多くのオプションがあるかもしれません。キーワード引数を受け取る場合、線の太さだけを指定して、`plot(x, y, width=2)` のように呼び出せます。これには2つの利点があります。引数にその意味を表すラベルを付けられるため、呼び出しが読みやすくなります。また、多くの引数のうち任意の一部だけを、任意の順序で渡せるようになります。

キーワード引数を持つ関数は、シグネチャ内でセミコロンを使って定義します。

```julia
function plot(x, y; style="solid", width=1, color="black")
    ###
end
```

関数を呼び出す際、セミコロンは省略可能です。`plot(x, y, width=2)` と `plot(x, y; width=2)` のどちらでも呼び出せますが、前者の書き方のほうが一般的です。明示的なセミコロンが必要なのは、後述する可変長引数や、計算で求めたキーワードを渡す場合だけです。

キーワード引数のデフォルト値は、必要な場合（対応するキーワード引数が渡されなかった場合）にのみ、左から右の順で評価されます。そのため、デフォルト値の式では、先にあるキーワード引数を参照できます。

キーワード引数の型は、次のように明示できます。

```julia
function f(; x::Int=1)
    ###
end
```

キーワード引数は、可変長引数を持つ関数でも使えます。

```julia
function plot(x...; style="solid")
    ###
end
```

可変長引数を持つ関数と同様に、`...` を使って追加のキーワード引数をまとめて受け取れます。

```julia
function f(x; y=0, kwargs...)
    ###
end
```

`f` の内部では、`kwargs` は名前付きタプル上の不変なキーと値のイテレータになります。名前付きタプル（および、キーが `Symbol` の辞書や、最初の値がシンボルである2要素のコレクションを返すほかのイテレータ）は、呼び出しでセミコロンを使うと、キーワード引数として渡せます。たとえば、`f(x, z=1; kwargs...)` のように書きます。

メソッド定義でキーワード引数にデフォルト値を設定しなかった場合、その引数は*必須*になります。呼び出し元が値を指定しなければ、[`UndefKeywordError`](@ref) 例外が送出されます。

```julia
function f(x; y)
    ###
end
f(3, y=5) # ok, y is assigned
f(3)      # throws UndefKeywordError(:y)
```

セミコロンの後に `key => value` という式を渡すこともできます。たとえば、`plot(x, y; :width => 2)` は `plot(x, y, width=2)` と等価です。これは、キーワード名を実行時に計算する場合に役立ちます。

セミコロンの後に識別子単独、またはドット式を置くと、キーワード引数名はその識別子名またはフィールド名から暗黙的に決まります。たとえば、`plot(x, y; width)` は `plot(x, y; width=width)` と等価で、`plot(x, y; options.width)` は `plot(x, y; width=options.width)` と等価です。

キーワード引数の性質上、同じ引数を複数回指定することが可能です。たとえば、呼び出し `plot(x, y; options..., width=2)` では、`options` という構造にも `width` の値が含まれている可能性があります。その場合、最も右にある指定が優先されます。この例では、`width` の値は必ず `2` になります。ただし、`plot(x, y, width=2, width=3)` のように、同じキーワード引数を明示的に複数回指定することはできず、構文エラーになります。

## Evaluation Scope of Default Values

省略可能な引数やキーワード引数のデフォルト式が評価されるとき、スコープ内にあるのは*それより前の*引数だけです。たとえば、次の定義を考えます。

```julia
function f(x, a=b, b=1)
    ###
end
```

この場合、`a=b` 内の `b` は、後に続く引数 `b` ではなく、外側のスコープにある `b` を参照します。

## Do-Block Syntax for Function Arguments

関数をほかの関数の引数として渡すのは強力な手法ですが、その構文は必ずしも使いやすいとは限りません。特に、引数として渡す関数が複数行にわたると、呼び出しが書きにくくなります。例として、複数の場合分けを持つ関数に対して [`map`](@ref) を呼び出すことを考えます。

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

`do x` という構文は、引数 `x` を持つ無名関数を作成し、「外側の」関数（この例では [`map`](@ref)）の第1引数として渡します。同様に、`do a,b` は2引数の無名関数を作成します。一方、`do (a,b)` は、分解対象のタプルを引数に取る、1引数の無名関数を作成する点に注意してください。単に `do` と書くと、それに続く部分が `() -> ...` という形式の無名関数であることを宣言します。

これらの引数がどのように初期化されるかは、「外側の」関数によって決まります。ここでは、[`map`](@ref) が `x` に `A`、`B`、`C` を順に設定し、それぞれについて無名関数を呼び出します。これは、`map(func, [A, B, C])` という構文で行われる処理と同じです。

この構文では、呼び出しが通常のコードブロックのように見えるため、関数を使って実質的に言語を拡張しやすくなります。用途は [`map`](@ref) とは大きく異なるものも多く、システムの状態管理などにも使えます。たとえば、[`open`](@ref) には、開いたファイルが最終的に必ず閉じられるようにしながらコードを実行するバージョンがあります。

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

ここでは、[`open`](@ref) が最初にファイルを書き込み用に開き、得られた出力ストリームを、`do ... end` ブロックで定義した無名関数に渡します。その関数が終了した後、[`open`](@ref) は、関数が正常終了したか例外を送出したかにかかわらず、ストリームが適切に閉じられることを保証します。（`try/finally` 構文については、[Control Flow](@ref) で説明します。）

`do` ブロック構文を使う際は、ユーザーが定義する関数の引数がどのように初期化されるのかを知るために、ドキュメントや実装を確認すると役立ちます。

`do` ブロックは、ほかの内部関数と同様に、それを囲むスコープの変数を「キャプチャ」できます。たとえば、上記の `open...do` の例にある変数 `data` は、外側のスコープからキャプチャされています。キャプチャされた変数は、[performance tips](@ref man-performance-captured) で説明するように、パフォーマンス上の課題を生むことがあります。

## Function composition and piping

Juliaの関数は、合成したり、パイプでつないだり（連鎖させたり）することで組み合わせられます。

関数合成とは、関数を組み合わせ、得られた合成関数を引数に適用することです。関数を合成するには、関数合成演算子（`∘`）を使います。したがって、`(f ∘ g)(args...; kw...)` は `f(g(args...; kw...))` と同じです。

REPLや適切に設定されたエディタでは、`\circ<tab>` を使って合成演算子を入力できます。

たとえば、`sqrt` 関数と `+` 関数は、次のように合成できます。

```jldoctest
julia> (sqrt ∘ +)(3, 6)
3.0
```

これは、まず数値を足し合わせ、その結果の平方根を求めます。

次の例では、3つの関数を合成し、その合成関数を文字列の配列にマップしています。

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

関数の連鎖とは、前の関数の出力に次の関数を適用することです。後続の関数にデータを送ることから、「パイピング」や「パイプを使う」と呼ばれることもあります。

```jldoctest
julia> 1:10 |> sum |> sqrt
7.416198487095663
```

ここでは、`sum` で求めた合計が `sqrt` 関数に渡されます。これと等価な関数合成は、次のようになります。

```jldoctest
julia> (sqrt ∘ sum)(1:10)
7.416198487095663
```

パイプ演算子は、`.|>` のようにブロードキャストと組み合わせることもできます。これにより、連鎖・パイプの構文と、後述するドットによるベクトル化構文を便利に組み合わせられます。

```jldoctest
julia> ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
4-element Vector{Any}:
  "A"
  "tsil"
  "Of"
 7
```

パイプと無名関数を組み合わせる場合、後続のパイプを無名関数の本体の一部として構文解析させたくなければ、丸括弧を使う必要があります。次を比較してください。

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

技術計算用の言語には、関数の「ベクトル化」バージョンが用意されているのが一般的です。これは、`f(A)` によって、配列 `A` の各要素に関数 `f(x)` を適用し、新しい配列を生成するものです。この種の構文はデータ処理に便利ですが、ほかの言語では、パフォーマンスのためにもベクトル化が必要になることがよくあります。ループが遅い場合、関数の「ベクトル化」バージョンなら、低水準言語で書かれた高速なライブラリコードを呼び出せるからです。Juliaでは、パフォーマンスのためにベクトル化された関数を使う*必要はなく*、実際、自分でループを書いたほうがよいこともよくあります（[Performance Tips](@ref man-performance-tips) を参照）。それでも、ベクトル化された関数が便利であることに変わりはありません。そのため、Juliaの*どの*関数 `f` も、`f.(A)` という構文を使って、任意の配列（またはほかのコレクション）の各要素に適用できます。たとえば、`sin` は、ベクトル `A` のすべての要素に、次のように適用できます。

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

もちろん、たとえば `f(A::AbstractArray) = map(f, A)` のように、`f` の「ベクトル」専用メソッドを書けば、ドットは省略できます。この方法も `f.(A)` と同じくらい効率的です。`f.(A)` 構文の利点は、どの関数をベクトル化できるようにするかを、ライブラリの作成者が事前に決める必要がないことです。

より一般には、`f.(args...)` は実際には `broadcast(f, args...)` と等価です。これにより、複数の配列（形状が異なっていてもかまいません）や、配列とスカラーの組み合わせを扱えます（[Broadcasting](@ref) を参照）。たとえば、`f(x, y) = 3x + 4y` があるとすると、`f.(pi, A)` は、`A` 内の各 `a` について `f(pi,a)` を計算し、その結果からなる新しい配列を返します。また、`f.(vector1, vector2)` は、各インデックス `i` について `f(vector1[i], vector2[i])` を計算し、その結果からなる新しいベクトルを返します（ベクトルの長さが異なる場合は例外を送出します）。

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

さらに、*入れ子になった* `f.(args...)` 呼び出しは、単一の `broadcast` ループに*融合*されます。たとえば、`sin.(cos.(X))` は `broadcast(x -> sin(cos(x)), X)` と等価で、`[sin(cos(x)) for x in X]` と同様です。`X` を走査するループは1つだけで、結果用の配列も1つだけ確保されます。［対照的に、一般的な「ベクトル化」言語で `sin(cos(X))` を実行すると、まず `tmp=cos(X)` 用の一時配列を1つ確保し、次に別のループで `sin(tmp)` を計算して、2つ目の配列を確保します。］このループ融合は、行われるかどうかわからないコンパイラの最適化ではなく、入れ子の `f.(args...)` 呼び出しが現れたときに必ず行われるという、*構文上の保証*です。厳密には、「ドットなし」の関数呼び出しに遭遇すると、そこで融合が止まります。たとえば、`sin.(sort(cos.(X)))` では、途中に `sort` 関数があるため、`sin` と `cos` のループを融合できません。

最後に、通常、最も効率がよいのは、ベクトル化演算の出力配列を*事前に確保*し、呼び出しを繰り返すたびに結果用の配列を新たに確保しない方法です（[Pre-allocate outputs](@ref) を参照）。このための便利な構文が `X .= ...` です。これは `broadcast!(identity, X, ...)` と等価ですが、上記と同様に、`broadcast!` のループが、入れ子になった「ドット」呼び出しと融合される点が異なります。たとえば、`X .= sin.(Y)` は `broadcast!(sin, X, Y)` と等価で、`X` を `sin.(Y)` でインプレースに上書きします。左辺が `X[begin+1:end] .= sin.(Y)` のような配列のインデックス式であれば、`view` に対する `broadcast!`、たとえば `broadcast!(sin, view(X, firstindex(X)+1:lastindex(X)), Y)` へと変換され、左辺がインプレースに更新されます。

式の中の多くの演算や関数呼び出しにドットを付けるのは面倒で、コードも読みにくくなりがちです。そのため、式の中の*すべての*関数呼び出し、演算、代入を「ドット付き」バージョンに変換するマクロ [`@.`](@ref @__dot__) が用意されています。

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

次の例のように、[`|>`](@ref) を使えば、ドット演算と関数の連鎖を組み合わせることもできます。

```jldoctest
julia> 1:5 .|> [x->x^2, inv, x->2*x, -, isodd]
5-element Vector{Real}:
    1
    0.5
    6
   -4
 true
```

融合されたブロードキャスト内のすべての関数は、結果の各要素について必ず呼び出されます。そのため、`X .+ σ .* randn.()` は、配列 `X` の各要素に、同じ分布から独立にサンプリングされた乱数値のマスクを加えます。一方、`X .+ σ .* randn()` は、各要素に*同じ*乱数サンプルを加えます。融合された計算がブロードキャストの反復の1つ以上の軸に沿って一定である場合、メモリ使用量と計算時間のトレードオフを利用し、中間値を格納する領域を確保することで計算回数を減らせることがあります。詳しくは、[performance tips](@ref man-performance-unfuse) を参照してください。

## Further Reading

ここまでの説明は、関数定義の全体像を網羅するものではないことを付け加えておきます。Juliaには高度な型システムがあり、引数の型に基づく多重ディスパッチが可能です。ここで示した例には、引数に型注釈が付いていないものがあり、それらはあらゆる型の引数に適用できます。型システムについては [Types](@ref man-types) で説明しています。また、実行時の引数の型に基づく多重ディスパッチによって選ばれるメソッドを使った関数定義については、[Methods](@ref) で説明しています。
