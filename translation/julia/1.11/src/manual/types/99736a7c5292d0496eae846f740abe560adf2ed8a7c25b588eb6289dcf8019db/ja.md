# [Types](@id man-types)

型システムは伝統的に、静的型システムと動的型システムの2つの異なるキャンプに分類されてきました。静的型システムでは、プログラムの実行前にすべてのプログラム式に型が計算されなければなりません。一方、動的型システムでは、プログラムによって操作される実際の値が利用可能になるまで、型については何も知られていません。オブジェクト指向は、静的型付け言語において、コンパイル時に値の正確な型が知られていなくてもコードを書くことを可能にすることで、いくらかの柔軟性を提供します。異なる型で動作できるコードを書く能力はポリモーフィズムと呼ばれます。古典的な動的型付け言語のすべてのコードはポリモーフィックです。型を明示的にチェックするか、オブジェクトが実行時に操作をサポートしない場合にのみ、値の型が制限されます。

Juliaの型システムは動的ですが、特定の値が特定の型であることを示すことが可能であるため、静的型システムのいくつかの利点を得ることができます。これは効率的なコードを生成するのに大いに役立ちますが、さらに重要なのは、関数引数の型に基づくメソッドディスパッチが言語と深く統合されることを可能にする点です。メソッドディスパッチについては[Methods](@ref)で詳しく探求されていますが、ここで提示されている型システムに根ざしています。

デフォルトの動作は、型が省略された場合に値が任意の型であることを許可します。したがって、型を明示的に使用することなく、多くの便利なJulia関数を書くことができます。しかし、追加の表現力が必要な場合は、以前の「型なし」のコードに明示的な型注釈を徐々に導入することが簡単です。注釈を追加することには、主に3つの目的があります：Juliaの強力な多重ディスパッチ機構を活用すること、人間の可読性を向上させること、プログラマーのエラーを検出することです。

ジュリアを [type systems](https://en.wikipedia.org/wiki/Type_system) の言葉で説明すると、動的で、名義型で、パラメトリックです。ジェネリック型はパラメータ化でき、型間の階層関係は [explicitly declared](https://en.wikipedia.org/wiki/Nominal_type_system) であり、 [implied by compatible structure](https://en.wikipedia.org/wiki/Structural_type_system) ではありません。ジュリアの型システムの特に特徴的な点は、具体的な型が互いにサブタイプになれないことです：すべての具体的な型は最終的であり、抽象型のみがそのスーパタイプとして存在できます。これは最初は過度に制限的に思えるかもしれませんが、驚くほど少ない欠点で多くの有益な結果をもたらします。振る舞いを継承できることは、構造を継承できることよりもはるかに重要であり、両方を継承することは従来のオブジェクト指向言語において重大な困難を引き起こします。ジュリアの型システムの他の高レベルの側面で、最初に言及すべきことは次のとおりです：

  * オブジェクトと非オブジェクトの値の間に区別はありません：Juliaのすべての値は真のオブジェクトであり、単一の完全に接続された型グラフに属する型を持ち、そのすべてのノードは型として同等にファーストクラスです。
  * 「コンパイル時型」という意味のある概念は存在しません：値が持つ唯一の型は、プログラムが実行されているときの実際の型です。これは、静的コンパイルとポリモーフィズムの組み合わせがこの区別を重要にするオブジェクト指向言語において「実行時型」と呼ばれます。
  * 値のみが型を持ち、変数は単に値に結びつけられた名前です。ただし、簡潔さのために「変数の型」と言うことがありますが、これは「変数が参照する値の型」を短縮した表現です。
  * 抽象型と具体型の両方は、他の型によってパラメータ化することができます。また、シンボルや、[`isbits`](@ref) が true を返す任意の型の値（本質的には、C型のように格納された数値やブール値、または他のオブジェクトへのポインタを持たない `struct` など）によってもパラメータ化できます。さらに、それらのタプルによってもパラメータ化できます。型パラメータは、参照または制限する必要がない場合は省略することができます。

Juliaの型システムは、強力で表現力豊かでありながら、明確で直感的、かつ目立たないように設計されています。多くのJuliaプログラマーは、明示的に型を使用するコードを書く必要を感じないかもしれません。しかし、特定の種類のプログラミングでは、宣言された型を使用することで、より明確でシンプル、迅速かつ堅牢になります。

## Type Declarations

`::` 演算子は、プログラム内の式や変数に型注釈を付けるために使用できます。これを行う主な理由は2つあります：

1. あなたのプログラムが期待通りに動作することを確認するための主張として、そして
2. コンパイラに追加の型情報を提供することで、場合によってはパフォーマンスを向上させることができます。

値を計算する式に追加されると、`::` 演算子は「のインスタンスである」と読み取られます。これは、左側の式の値が右側の型のインスタンスであることを主張するためにどこでも使用できます。右側の型が具体的な場合、左側の値はその型を実装している必要があります。すべての具体的な型は最終的なものであるため、どの実装も他の型のサブタイプではないことを思い出してください。型が抽象的な場合、値は抽象型のサブタイプである具体的な型によって実装されているだけで十分です。型の主張が真でない場合、例外がスローされます。そうでない場合、左側の値が返されます：

```jldoctest
julia> (1+2)::AbstractFloat
ERROR: TypeError: in typeassert, expected AbstractFloat, got a value of type Int64

julia> (1+2)::Int
3
```

これにより、型アサーションを任意の式にインラインで付加することができます。

When appended to a variable on the left-hand side of an assignment, or as part of a `local` declaration, the `::` operator means something a bit different: it declares the variable to always have the specified type, like a type declaration in a statically-typed language such as C. Every value assigned to the variable will be converted to the declared type using [`convert`](@ref):

```jldoctest
julia> function foo()
           x::Int8 = 100
           x
       end
foo (generic function with 1 method)

julia> x = foo()
100

julia> typeof(x)
Int8
```

この機能は、変数への代入のいずれかが予期せずその型を変更した場合に発生する可能性のあるパフォーマンスの「落とし穴」を回避するのに役立ちます。

この「宣言」動作は特定の文脈でのみ発生します：

```julia
local x::Int8  # in a local declaration
x::Int8 = 10   # as the left-hand side of an assignment
```

現在のスコープ全体に適用され、宣言の前でも適用されます。

Julia 1.8以降、型宣言はグローバルスコープで使用できるようになりました。つまり、グローバル変数に型アノテーションを追加することで、それらにアクセスする際の型の安定性を向上させることができます。

```julia
julia> x::Int = 10
10

julia> x = 3.5
ERROR: InexactError: Int64(3.5)

julia> function foo(y)
           global x = 15.8    # throws an error when foo is called
           return x + y
       end
foo (generic function with 1 method)

julia> foo(10)
ERROR: InexactError: Int64(15.8)
```

関数定義に宣言を付けることもできます：

```julia
function sinc(x)::Float64
    if x == 0
        return 1
    end
    return sin(pi*x)/(pi*x)
end
```

この関数からの戻り値は、宣言された型の変数への代入と同じように振る舞います：値は常に `Float64` に変換されます。

## [Abstract Types](@id man-abstract-types)

抽象型はインスタンス化できず、型グラフのノードとしてのみ機能し、関連する具体型のセットを記述します：それらの子孫である具体型です。インスタンス化がないにもかかわらず、抽象型から始めるのは、型システムの基盤であるためです：それらは、Juliaの型システムを単なるオブジェクト実装のコレクション以上のものにする概念的な階層を形成します。

[Integers and Floating-Point Numbers](@ref)では、さまざまな具体的な数値型を導入しました：[`Int8`](@ref)、[`UInt8`](@ref)、[`Int16`](@ref)、[`UInt16`](@ref)、[`Int32`](@ref)、[`UInt32`](@ref)、[`Int64`](@ref)、[`UInt64`](@ref)、[`Int128`](@ref)、[`UInt128`](@ref)、[`Float16`](@ref)、[`Float32`](@ref)、および[`Float64`](@ref)。これらは異なる表現サイズを持っていますが、`Int8`、`Int16`、`Int32`、`Int64`、および`Int128`はすべて符号付き整数型であるという共通点があります。同様に、`UInt8`、`UInt16`、`UInt32`、`UInt64`、および`UInt128`はすべて符号なし整数型であり、`Float16`、`Float32`、および`Float64`は整数ではなく浮動小数点型であるという点で異なります。コードの一部が意味を持つのは、たとえば、その引数が何らかの整数型である場合のみであり、特定の*種類*の整数に依存するわけではありません。たとえば、最大公約数アルゴリズムはすべての種類の整数に対して機能しますが、浮動小数点数には機能しません。抽象型は型の階層を構築することを可能にし、具体的な型が適合できるコンテキストを提供します。これにより、たとえば、特定の整数型に制限することなく、整数型の任意の型に対して簡単にプログラムを作成することができます。

抽象型は [`abstract type`](@ref) キーワードを使用して宣言されます。抽象型を宣言するための一般的な構文は次のとおりです：

```
abstract type «name» end
abstract type «name» <: «supertype» end
```

`abstract type` キーワードは、新しい抽象型を導入します。その名前は `«name»` で指定されます。この名前の後にオプションで [`<:`](@ref) と既存の型を続けることができ、新しく宣言された抽象型がこの「親」型のサブタイプであることを示します。

スーパタイプが指定されていない場合、デフォルトのスーパタイプは `Any` です。これは、すべてのオブジェクトがインスタンスであり、すべてのタイプがサブタイプである事前定義された抽象型です。型理論において、`Any` は「トップ」と呼ばれ、型グラフの頂点に位置しています。Julia には、型グラフの底に位置する事前定義された抽象「ボトム」型もあり、これは `Union{}` として表記されます。これは `Any` の正反対であり、`Union{}` のインスタンスであるオブジェクトは存在せず、すべてのタイプが `Union{}` のスーパタイプです。

ジュリアの数値階層を構成するいくつかの抽象型を考えてみましょう：

```julia
abstract type Number end
abstract type Real          <: Number end
abstract type AbstractFloat <: Real end
abstract type Integer       <: Real end
abstract type Signed        <: Integer end
abstract type Unsigned      <: Integer end
```

[`Number`](@ref) 型は `Any` の直接の子型であり、[`Real`](@ref) はその子です。さらに、`Real` には2つの子があります（他にもありますが、ここでは2つだけが示されています。他のものについては後で説明します）：[`Integer`](@ref) と [`AbstractFloat`](@ref) で、整数の表現と実数の表現に世界を分けています。実数の表現には浮動小数点型が含まれますが、有理数などの他の型も含まれます。`AbstractFloat` は実数の浮動小数点表現のみを含みます。整数はさらに [`Signed`](@ref) と [`Unsigned`](@ref) の2つの種類に細分化されます。

`<:` 演算子は一般的に「サブタイプである」を意味し、上記のような宣言で使用されると、右側の型が新しく宣言された型の即時スーパタイプであることを宣言します。また、式の中でサブタイプ演算子として使用することもでき、左オペランドが右オペランドのサブタイプである場合に `true` を返します。

```jldoctest
julia> Integer <: Number
true

julia> Integer <: AbstractFloat
false
```

抽象型の重要な使用法は、具体型に対してデフォルトの実装を提供することです。簡単な例を考えてみましょう：

```julia
function myplus(x,y)
    x+y
end
```

最初に注目すべきことは、上記の引数宣言が `x::Any` および `y::Any` と同等であるということです。この関数が `myplus(2,5)` のように呼び出されると、ディスパッチャは与えられた引数に一致する最も特定的な `myplus` メソッドを選択します。（複数のディスパッチに関する詳細は [Methods](@ref) を参照してください。）

上記より具体的なメソッドが見つからない場合、Juliaは次に、上記の汎用関数に基づいて、2つの`Int`引数専用のメソッド`myplus`を内部的に定義し、コンパイルします。つまり、暗黙的に次のように定義し、コンパイルします：

```julia
function myplus(x::Int,y::Int)
    x+y
end
```

そして最後に、この特定のメソッドを呼び出します。

このように、抽象型はプログラマーが汎用関数を書くことを可能にし、後に多くの具体型の組み合わせによってデフォルトメソッドとして使用されることができます。複数のディスパッチのおかげで、プログラマーはデフォルトメソッドまたはより具体的なメソッドのどちらが使用されるかを完全に制御できます。

重要な点は、プログラマーが引数が抽象型の関数に依存してもパフォーマンスに損失がないということです。なぜなら、その関数は呼び出される具体的な引数型のタプルごとに再コンパイルされるからです。ただし、抽象型のコンテナである関数引数の場合にはパフォーマンスの問題があるかもしれません。詳細は [Performance Tips](@ref man-performance-abstract-container) を参照してください。

## Primitive Types

!!! warning
    既存のプリミティブ型を新しいコンポジット型でラップする方が、自分自身のプリミティブ型を定義するよりもほぼ常に好ましいです。

    この機能は、JuliaがLLVMがサポートする標準のプリミティブ型をブートストラップすることを可能にするために存在します。一度それらが定義されると、さらに多くを定義する理由はほとんどありません。


プリミティブ型は、データが単純なビットから成る具体的な型です。プリミティブ型の古典的な例には、整数や浮動小数点値があります。ほとんどの言語とは異なり、Juliaでは固定された組み込み型のセットだけでなく、自分自身のプリミティブ型を宣言することができます。実際、標準のプリミティブ型はすべて言語自体で定義されています：

```julia
primitive type Float16 <: AbstractFloat 16 end
primitive type Float32 <: AbstractFloat 32 end
primitive type Float64 <: AbstractFloat 64 end

primitive type Bool <: Integer 8 end
primitive type Char <: AbstractChar 32 end

primitive type Int8    <: Signed   8 end
primitive type UInt8   <: Unsigned 8 end
primitive type Int16   <: Signed   16 end
primitive type UInt16  <: Unsigned 16 end
primitive type Int32   <: Signed   32 end
primitive type UInt32  <: Unsigned 32 end
primitive type Int64   <: Signed   64 end
primitive type UInt64  <: Unsigned 64 end
primitive type Int128  <: Signed   128 end
primitive type UInt128 <: Unsigned 128 end
```

プリミティブ型を宣言するための一般的な構文は次のとおりです：

```
primitive type «name» «bits» end
primitive type «name» <: «supertype» «bits» end
```

ビット数は、型が必要とするストレージの量を示し、名前は新しい型に名前を付けます。プリミティブ型は、オプションであるスーパタイプのサブタイプとして宣言できます。スーパタイプが省略されると、型はデフォルトで `Any` を即時スーパタイプとして持ちます。したがって、上記の [`Bool`](@ref) の宣言は、ブール値がストレージに8ビットを必要とし、[`Integer`](@ref) を即時スーパタイプとして持つことを意味します。現在、サポートされているのは8ビットの倍数のみであり、上記以外のサイズではLLVMのバグが発生する可能性があります。したがって、ブール値は実際には1ビットだけで済むにもかかわらず、8ビット未満に宣言することはできません。

タイプ [`Bool`](@ref)、[`Int8`](@ref)、および [`UInt8`](@ref) はすべて同一の表現を持っています：それらは8ビットのメモリチャンクです。しかし、Juliaの型システムは名義的であるため、同一の構造を持っていても相互に交換可能ではありません。これらの間の根本的な違いは、異なるスーパタイプを持つことです：`4d61726b646f776e2e436f64652822222c2022426f6f6c2229_40726566` の直接のスーパタイプは [`Integer`](@ref) であり、`4d61726b646f776e2e436f64652822222c2022496e74382229_40726566` のスーパタイプは [`Signed`](@ref)、そして `4d61726b646f776e2e436f64652822222c202255496e74382229_40726566` のスーパタイプは [`Unsigned`](@ref) です。`4d61726b646f776e2e436f64652822222c2022426f6f6c2229_40726566`、`4d61726b646f776e2e436f64652822222c2022496e74382229_40726566`、および `4d61726b646f776e2e436f64652822222c202255496e74382229_40726566` の間の他のすべての違いは、これらの型のオブジェクトを引数として与えたときに関数がどのように動作するかという振る舞いの問題です。これが名義的型システムが必要な理由です：もし構造が型を決定し、それが振る舞いを規定するならば、`4d61726b646f776e2e436f64652822222c2022426f6f6c2229_40726566` を `4d61726b646f776e2e436f64652822222c2022496e74382229_40726566` や `4d61726b646f776e2e436f64652822222c202255496e74382229_40726566` とは異なる振る舞いをさせることは不可能になるでしょう。

## Composite Types

[Composite types](https://en.wikipedia.org/wiki/Composite_data_type) は、さまざまな言語でレコード、構造体、またはオブジェクトと呼ばれます。複合型は、名前付きフィールドのコレクションであり、そのインスタンスは単一の値として扱うことができます。多くの言語では、複合型がユーザー定義型の唯一の種類であり、Juliaでも最も一般的に使用されるユーザー定義型です。

主流のオブジェクト指向言語、例えばC++、Java、Python、Rubyでは、複合型にも名前付きの関数が関連付けられており、その組み合わせを「オブジェクト」と呼びます。RubyやSmalltalkのようなより純粋なオブジェクト指向言語では、すべての値がオブジェクトであり、複合型であるかどうかに関わらずそうです。C++やJavaを含むあまり純粋でないオブジェクト指向言語では、整数や浮動小数点値のような一部の値はオブジェクトではなく、ユーザー定義の複合型のインスタンスは関連するメソッドを持つ真のオブジェクトです。Juliaでは、すべての値がオブジェクトですが、関数はそれが操作するオブジェクトとバンドルされていません。これは、Juliaが関数のどのメソッドを使用するかを複数のディスパッチによって選択するために必要です。つまり、メソッドを選択する際には、関数のすべての引数の型が考慮され、最初の引数だけではありません（メソッドとディスパッチに関する詳細は[Methods](@ref)を参照してください）。したがって、関数が最初の引数だけに「属する」ことは不適切です。メソッドを関数オブジェクトに整理することは、各オブジェクトの「内部」に名前付きのメソッドの袋を持つよりも、言語設計の非常に有益な側面となります。

コンポジット型は、[`struct`](@ref) キーワードで導入され、その後にフィールド名のブロックが続き、オプションで `::` 演算子を使用して型が注釈されます。

```jldoctest footype
julia> struct Foo
           bar
           baz::Int
           qux::Float64
       end
```

型注釈がないフィールドはデフォルトで `Any` となり、したがって任意の型の値を保持できます。

新しい `Foo` 型のオブジェクトは、フィールドの値に対して関数のように `Foo` 型オブジェクトを適用することによって作成されます：

```jldoctest footype
julia> foo = Foo("Hello, world.", 23, 1.5)
Foo("Hello, world.", 23, 1.5)

julia> typeof(foo)
Foo
```

型が関数のように適用されると、それは*コンストラクタ*と呼ばれます。2つのコンストラクタが自動的に生成されます（これらは*デフォルトコンストラクタ*と呼ばれます）。1つは任意の引数を受け取り、[`convert`](@ref)を呼び出してそれらをフィールドの型に変換し、もう1つはフィールドの型と正確に一致する引数を受け取ります。これらの両方が生成される理由は、新しい定義を追加する際にデフォルトコンストラクタを誤って置き換えることを避けるためです。

`bar` フィールドは型に制約がないため、どんな値でも構いません。しかし、`baz` の値は `Int` に変換可能でなければなりません:

```jldoctest footype
julia> Foo((), 23.5, 1)
ERROR: InexactError: Int64(23.5)
Stacktrace:
[...]
```

[`fieldnames`](@ref) 関数を使用して、フィールド名のリストを見つけることができます。

```jldoctest footype
julia> fieldnames(Foo)
(:bar, :baz, :qux)
```

複合オブジェクトのフィールド値には、従来の `foo.bar` 表記を使用してアクセスできます:

```jldoctest footype
julia> foo.bar
"Hello, world."

julia> foo.baz
23

julia> foo.qux
1.5
```

`struct` で宣言された複合オブジェクトは *不変* です。構築後に変更することはできません。最初は奇妙に思えるかもしれませんが、いくつかの利点があります：

  * より効率的にすることができます。いくつかの構造体は配列に効率的にパックでき、場合によってはコンパイラが不変オブジェクトの割り当てを完全に回避できることがあります。
  * 型のコンストラクタによって提供される不変条件を違反することは不可能です。
  * 不変オブジェクトを使用したコードは、理解しやすい場合があります。

不変オブジェクトは、フィールドとして配列などの可変オブジェクトを含むことがあります。それらの含まれるオブジェクトは引き続き可変ですが、不変オブジェクト自体のフィールドは異なるオブジェクトを指すように変更することはできません。

必要に応じて、可変コンポジットオブジェクトはキーワード [`mutable struct`](@ref) を使用して宣言できます。次のセクションで詳しく説明します。

すべての不変構造体のフィールドが区別できない（`===`）場合、それらのフィールドを含む2つの不変値もまた区別できません：

```jldoctest
julia> struct X
           a::Int
           b::Float64
       end

julia> X(1, 2) === X(1, 2)
true
```

複合型のインスタンスがどのように作成されるかについては、さらに多くのことを言うことができますが、その議論は [Parametric Types](@ref) と [Methods](@ref) の両方に依存しており、十分に重要であるため、独自のセクションで扱う必要があります: [Constructors](@ref man-constructors)。

多くのユーザー定義型 `X` に対して、インスタンスが [broadcasting](@ref Broadcasting) の 0 次元「スカラー」として機能するように、メソッド [`Base.broadcastable(x::X) = Ref(x)`](@ref man-interfaces-broadcasting) を定義したい場合があります。

## Mutable Composite Types

`mutable struct`で宣言されたコンポジット型は、`struct`の代わりに使用されると、そのインスタンスを変更することができます：

```jldoctest bartype
julia> mutable struct Bar
           baz
           qux::Float64
       end

julia> bar = Bar("Hello", 1.5);

julia> bar.qux = 2.0
2.0

julia> bar.baz = 1//2
1//2
```

フィールドとユーザーの間に追加のインターフェースを提供することができます [Instance Properties](@ref man-instance-properties)。これにより、`bar.baz` 表記を使用してアクセスおよび変更できる内容に対するより多くの制御が可能になります。

ミューテーションをサポートするために、そのようなオブジェクトは一般的にヒープ上に割り当てられ、安定したメモリアドレスを持ちます。ミュータブルオブジェクトは、時間の経過とともに異なる値を保持する可能性のある小さなコンテナのようなものであり、そのためアドレスでのみ信頼性を持って識別できます。それに対して、イミュータブル型のインスタンスは特定のフィールド値に関連付けられています – フィールド値だけでオブジェクトに関するすべての情報がわかります。型をミュータブルにするかどうかを決定する際には、同じフィールド値を持つ2つのインスタンスが同一と見なされるか、または時間の経過とともに独立して変更される必要があるかを尋ねてください。もし同一と見なされるのであれば、その型はおそらくイミュータブルであるべきです。

要約すると、Juliaにおける不変性を定義する2つの重要な特性があります：

  * 不変型の値を変更することは許可されていません。

      * ビット型にとって、これは一度設定された値のビットパターンは決して変わらず、その値がビット型のアイデンティティであることを意味します。
      * 複合型にとって、これはそのフィールドの値のアイデンティティが決して変わらないことを意味します。フィールドがビット型である場合、それはそのビットが決して変わらないことを意味します。配列のような可変型の値を持つフィールドの場合、それはそのフィールドが常に同じ可変値を参照し続けることを意味しますが、その可変値の内容自体は変更される可能性があります。
  * 不変型のオブジェクトは、その不変性により、元のオブジェクトとコピーをプログラム的に区別することが不可能であるため、コンパイラによって自由にコピーされる可能性があります。

      * 特に、これは整数や浮動小数点数のような小さな不変値が通常、レジスタ（またはスタックに割り当てられた）で関数に渡されることを意味します。
      * 可変値は、他方ではヒープに割り当てられ、関数にはヒープに割り当てられた値へのポインタとして渡されます。ただし、コンパイラがこれが発生していないことを確信している場合を除きます。

不変の構造体の最適化の一部ではありますが、そうでない場合もあるため、通常は可変の構造体の1つ以上のフィールドが不変であることが知られている場合、以下のように`const`を使用してこれらのフィールドを宣言できます。これにより、特定のフィールドに対して不変条件を強制することができます。

!!! compat "Julia 1.8"
    `const` を可変構造体のフィールドに注釈を付けるには、少なくとも Julia 1.8 が必要です。


```jldoctest baztype
julia> mutable struct Baz
           a::Int
           const b::Float64
       end

julia> baz = Baz(1, 1.5);

julia> baz.a = 2
2

julia> baz.b = 2.0
ERROR: setfield!: const field .b of type Baz cannot be changed
[...]
```

## [Declared Types](@id man-declared-types)

前のセクションで議論された3種類の型（抽象型、プリミティブ型、コンポジット型）は、実際にはすべて密接に関連しています。彼らは同じ重要な特性を共有しています：

  * それらは明示的に宣言されています。
  * 彼らには名前があります。
  * 彼らは明示的にスーパタイプを宣言しました。
  * 彼らはパラメータを持っているかもしれません。

これらの共有プロパティのため、これらのタイプは内部的に同じ概念である `DataType` のインスタンスとして表現されます。これは、これらのタイプのいずれかの型です：

```jldoctest
julia> typeof(Real)
DataType

julia> typeof(Int)
DataType
```

`DataType` は抽象または具体的である可能性があります。具体的である場合、指定されたサイズ、ストレージレイアウト、および（オプションで）フィールド名を持っています。したがって、プリミティブ型はサイズがゼロでない `DataType` ですが、フィールド名はありません。複合型はフィールド名を持つか、空（サイズゼロ）である `DataType` です。

システム内のすべての具体的な値は、ある `DataType` のインスタンスです。

## Type Unions

タイプユニオンは、特別な抽象型であり、その引数型のいずれかのインスタンスをすべてオブジェクトとして含む型です。これは、特別な [`Union`](@ref) キーワードを使用して構築されます。

```jldoctest
julia> IntOrString = Union{Int,AbstractString}
Union{Int64, AbstractString}

julia> 1 :: IntOrString
1

julia> "Hello!" :: IntOrString
"Hello!"

julia> 1.0 :: IntOrString
ERROR: TypeError: in typeassert, expected Union{Int64, AbstractString}, got a value of type Float64
```

多くの言語のコンパイラには、型について推論するための内部のユニオン構造がありますが、Juliaはそれをプログラマーに公開しています。Juliaコンパイラは、少数の型を持つ`Union`型が存在する場合に効率的なコードを生成することができ[^1]、各可能な型のために別々のブランチで特化したコードを生成します。

A particularly useful case of a `Union` type is `Union{T, Nothing}`, where `T` can be any type and [`Nothing`](@ref) is the singleton type whose only instance is the object [`nothing`](@ref). This pattern is the Julia equivalent of [`Nullable`, `Option` or `Maybe`](https://en.wikipedia.org/wiki/Nullable_type) types in other languages. Declaring a function argument or a field as `Union{T, Nothing}` allows setting it either to a value of type `T`, or to `nothing` to indicate that there is no value. See [this FAQ entry](@ref faq-nothing) for more information.

## Parametric Types

Juliaの型システムの重要で強力な特徴は、パラメトリックであることです。型はパラメータを取ることができるため、型宣言は実際には新しい型の全ファミリーを導入します - 各パラメータ値の可能な組み合わせごとに1つずつです。データ構造とそれを操作するアルゴリズムを、関与する正確な型を指定せずに指定できる[generic programming](https://en.wikipedia.org/wiki/Generic_programming)のバージョンをサポートする言語は多くあります。例えば、ML、Haskell、Ada、Eiffel、C++、Java、C#、F#、Scalaなど、いくつかの言語には何らかの形のジェネリックプログラミングが存在します。これらの言語の中には、真のパラメトリック多態性をサポートするもの（例：ML、Haskell、Scala）もあれば、アドホックでテンプレートベースのスタイルのジェネリックプログラミングをサポートするもの（例：C++、Java）もあります。さまざまな言語におけるジェネリックプログラミングとパラメトリック型の異なるバリエーションが多いため、Juliaのパラメトリック型を他の言語と比較することは試みませんが、代わりにJuliaのシステムを独自に説明することに焦点を当てます。ただし、Juliaは動的型付けの言語であり、すべての型決定をコンパイル時に行う必要がないため、静的パラメトリック型システムで遭遇する多くの伝統的な困難は比較的簡単に処理できることに注意します。

すべての宣言された型（`DataType`のバラエティ）は、同じ構文でパラメータ化できます。これらについては、次の順序で説明します。まず、パラメトリックコンポジット型、次にパラメトリック抽象型、最後にパラメトリックプリミティブ型です。

### [Parametric Composite Types](@id man-parametric-composite-types)

型パラメータは、型名の直後に波括弧で囲まれて導入されます：

```jldoctest pointtype
julia> struct Point{T}
           x::T
           y::T
       end
```

この宣言は、新しいパラメトリック型 `Point{T}` を定義し、型 `T` の2つの「座標」を保持します。では、`T` とは何でしょうか？それがまさにパラメトリック型のポイントです：それは全く任意の型（実際には任意のビット型の値でも構いませんが、ここでは明らかに型として使用されています）である可能性があります。`Point{Float64}` は、`Point` の定義における `T` を [`Float64`](@ref) に置き換えた型に相当する具体的な型です。したがって、この単一の宣言は実際には無限の数の型を宣言します：`Point{Float64}`、`Point{AbstractString}`、`Point{Int64}` などです。これらの各々は、現在使用可能な具体的な型です：

```jldoctest pointtype
julia> Point{Float64}
Point{Float64}

julia> Point{AbstractString}
Point{AbstractString}
```

型 `Point{Float64}` は、座標が64ビット浮動小数点値である点を表し、型 `Point{AbstractString}` は、座標が文字列オブジェクトである「点」を表します（[Strings](@ref) を参照）。

`Point` 自体も有効な型オブジェクトであり、すべてのインスタンス `Point{Float64}`、`Point{AbstractString}` などをサブタイプとして含んでいます:

```jldoctest pointtype
julia> Point{Float64} <: Point
true

julia> Point{AbstractString} <: Point
true
```

もちろん、他のタイプはそれのサブタイプではありません:

```jldoctest pointtype
julia> Float64 <: Point
false

julia> AbstractString <: Point
false
```

具体的な `Point` 型は、異なる `T` の値を持つ場合、互いにサブタイプにはなりません:

```jldoctest pointtype
julia> Point{Float64} <: Point{Int64}
false

julia> Point{Float64} <: Point{Real}
false
```

!!! warning
    この最後のポイントは*非常に*重要です：`Float64 <: Real`であるにもかかわらず、私たちは**持っていません**`Point{Float64} <: Point{Real}`。


言い換えれば、型理論の用語で言うと、Juliaの型パラメータは*不変*であり、[covariant (or even contravariant)](https://en.wikipedia.org/wiki/Covariance_and_contravariance_%28computer_science%29)ではありません。これは実用的な理由によるものです：`Point{Float64}`の任意のインスタンスは概念的には`Point{Real}`のインスタンスのように見えるかもしれませんが、これらの2つの型はメモリ内で異なる表現を持っています。

  * `Point{Float64}`のインスタンスは、64ビットの値の即時ペアとしてコンパクトかつ効率的に表現できます;
  * `Point{Real}`のインスタンスは、任意の[`Real`](@ref)のインスタンスのペアを保持できる必要があります。`Real`のインスタンスは任意のサイズと構造を持つことができるため、実際には`Point{Real}`のインスタンスは、個別に割り当てられた`Real`オブジェクトへのポインタのペアとして表現される必要があります。

`Point{Float64}` オブジェクトを即値で格納できることによって得られる効率は、配列の場合において非常に大きくなります。`Array{Float64}` は 64 ビット浮動小数点値の連続したメモリブロックとして格納できるのに対し、`Array{Real}` は個別に割り当てられた [`Real`](@ref) オブジェクトへのポインタの配列でなければなりません。これらは [boxed](https://en.wikipedia.org/wiki/Object_type_%28object-oriented_programming%29#Boxing) の 64 ビット浮動小数点値である可能性もありますが、任意に大きく、複雑なオブジェクトである可能性もあり、これらは `Real` 抽象型の実装として宣言されています。

`Point{Float64}`は`Point{Real}`のサブタイプではないため、次のメソッドは`Point{Float64}`型の引数には適用できません:

```julia
function norm(p::Point{Real})
    sqrt(p.x^2 + p.y^2)
end
```

`Point{T}`のすべての引数を受け入れるメソッドを定義する正しい方法は、`T`が[`Real`](@ref)のサブタイプである場合です。

```julia
function norm(p::Point{<:Real})
    sqrt(p.x^2 + p.y^2)
end
```

（同等に、`function norm(p::Point{T} where T<:Real)` または `function norm(p::Point{T}) where T<:Real` を定義することもできます。詳細は [UnionAll Types](@ref) を参照してください。）

後で [Methods](@ref) でさらに例が議論されます。

`Point`オブジェクトはどのように構築しますか？複合型のカスタムコンストラクタを定義することが可能であり、これは[Constructors](@ref man-constructors)で詳細に説明されますが、特別なコンストラクタ宣言がない場合、新しい複合オブジェクトを作成するための2つのデフォルトの方法があります。1つは型パラメータが明示的に指定される方法、もう1つはオブジェクトコンストラクタへの引数によって暗黙的に指定される方法です。

`Point{Float64}`型は、`T`の代わりに[`Float64`](@ref)で宣言された`Point`と同等の具体的な型であるため、それに応じてコンストラクタとして適用できます。

```jldoctest pointtype
julia> p = Point{Float64}(1.0, 2.0)
Point{Float64}(1.0, 2.0)

julia> typeof(p)
Point{Float64}
```

デフォルトコンストラクタの場合、各フィールドに対して正確に1つの引数を供給する必要があります：

```jldoctest pointtype
julia> Point{Float64}(1.0)
ERROR: MethodError: no method matching Point{Float64}(::Float64)
The type `Point{Float64}` exists, but no method is defined for this combination of argument types when trying to construct it.
[...]

julia> Point{Float64}(1.0, 2.0, 3.0)
ERROR: MethodError: no method matching Point{Float64}(::Float64, ::Float64, ::Float64)
The type `Point{Float64}` exists, but no method is defined for this combination of argument types when trying to construct it.
[...]
```

パラメトリック型にはデフォルトコンストラクタが1つだけ生成されます。これはオーバーライドできないためです。このコンストラクタは任意の引数を受け取り、それらをフィールドの型に変換します。

多くの場合、構築したい `Point` オブジェクトの型を提供することは冗長です。なぜなら、コンストラクタ呼び出しの引数の型がすでに暗黙的に型情報を提供しているからです。そのため、パラメータ型 `T` の暗黙の値が明確である限り、`Point` 自体をコンストラクタとして適用することもできます。

```jldoctest pointtype
julia> p1 = Point(1.0,2.0)
Point{Float64}(1.0, 2.0)

julia> typeof(p1)
Point{Float64}

julia> p2 = Point(1,2)
Point{Int64}(1, 2)

julia> typeof(p2)
Point{Int64}
```

`Point`の場合、`T`の型は、`Point`への2つの引数が同じ型である場合にのみ明確に示されます。これが当てはまらない場合、コンストラクタは[`MethodError`](@ref)で失敗します。

```jldoctest pointtype
julia> Point(1,2.5)
ERROR: MethodError: no method matching Point(::Int64, ::Float64)
The type `Point` exists, but no method is defined for this combination of argument types when trying to construct it.

Closest candidates are:
  Point(::T, !Matched::T) where T
   @ Main none:2

Stacktrace:
[...]
```

適切にそのような混合ケースを処理するためのコンストラクタメソッドを定義することはできますが、それについては後で [Constructors](@ref man-constructors) で議論される予定です。

### Parametric Abstract Types

パラメトリック抽象型宣言は、ほぼ同じ方法で抽象型のコレクションを宣言します：

```jldoctest pointytype
julia> abstract type Pointy{T} end
```

この宣言により、`Pointy{T}` は `T` の各型または整数値に対して異なる抽象型となります。パラメトリックコンポジット型と同様に、各インスタンスは `Pointy` のサブタイプです：

```jldoctest pointytype
julia> Pointy{Int64} <: Pointy
true

julia> Pointy{1} <: Pointy
true
```

パラメトリック抽象型は不変であり、パラメトリック合成型と同様です：

```jldoctest pointytype
julia> Pointy{Float64} <: Pointy{Real}
false

julia> Pointy{Real} <: Pointy{Float64}
false
```

`Pointy{<:Real}`という表記は、Juliaにおける*共変*型の類似を表現するために使用され、`Pointy{>:Int}`は*反変*型の類似を表しますが、技術的にはこれらは*型の集合*を表しています（[UnionAll Types](@ref)を参照）。

```jldoctest pointytype
julia> Pointy{Float64} <: Pointy{<:Real}
true

julia> Pointy{Real} <: Pointy{>:Int}
true
```

従来の抽象型が具体的な型に対して有用な型の階層を作成するのと同様に、パラメトリック抽象型はパラメトリック合成型に関して同じ目的を果たします。例えば、`Point{T}`を`Pointy{T}`のサブタイプとして次のように宣言することができます:

```jldoctest pointytype
julia> struct Point{T} <: Pointy{T}
           x::T
           y::T
       end
```

そのような宣言がある場合、`T`の各選択に対して、`Point{T}`は`Pointy{T}`のサブタイプとなります：

```jldoctest pointytype
julia> Point{Float64} <: Pointy{Float64}
true

julia> Point{Real} <: Pointy{Real}
true

julia> Point{AbstractString} <: Pointy{AbstractString}
true
```

この関係も不変です：

```jldoctest pointytype
julia> Point{Float64} <: Pointy{Real}
false

julia> Point{Float64} <: Pointy{<:Real}
true
```

パラメトリック抽象型 `Pointy` はどのような目的を果たすのでしょうか？もし、点が対角線 *x = y* 上にあるため、単一の座標のみを必要とする点のような実装を作成した場合を考えてみてください。

```jldoctest pointytype
julia> struct DiagPoint{T} <: Pointy{T}
           x::T
       end
```

現在、`Point{Float64}` と `DiagPoint{Float64}` は `Pointy{Float64}` 抽象の実装であり、同様に他のすべての型 `T` の選択肢に対しても同様です。これにより、`Point` と `DiagPoint` の両方に実装されたすべての `Pointy` オブジェクトが共有する共通インターフェースにプログラミングすることが可能になります。ただし、次のセクション [Methods](@ref) でメソッドとディスパッチを導入するまで、これを完全に示すことはできません。

型パラメータがすべての可能な型に自由に範囲を持つことが理にかなっていない状況があります。そのような状況では、次のようにして `T` の範囲を制約することができます：

```jldoctest realpointytype
julia> abstract type Pointy{T<:Real} end
```

そのような宣言を行うことで、`T`の代わりに[`Real`](@ref)のサブタイプである任意の型を使用することが許可されますが、`Real`のサブタイプでない型は使用できません:

```jldoctest realpointytype
julia> Pointy{Float64}
Pointy{Float64}

julia> Pointy{Real}
Pointy{Real}

julia> Pointy{AbstractString}
ERROR: TypeError: in Pointy, in T, expected T<:Real, got Type{AbstractString}

julia> Pointy{1}
ERROR: TypeError: in Pointy, in T, expected T<:Real, got a value of type Int64
```

パラメトリックコンポジット型の型パラメータは、同様の方法で制限できます：

```julia
struct Point{T<:Real} <: Pointy{T}
    x::T
    y::T
end
```

実世界の例として、これらのパラメトリック型の仕組みがどのように役立つかを示すために、Juliaの[`Rational`](@ref)不変型の実際の定義を以下に示します（簡潔さのためにコンストラクタは省略しています）。これは整数の正確な比率を表しています。

```julia
struct Rational{T<:Integer} <: Real
    num::T
    den::T
end
```

整数値の比を取ることは理にかなっているため、パラメータ型 `T` は [`Integer`](@ref) のサブタイプに制限されています。また、整数の比は実数直線上の値を表すため、任意の [`Rational`](@ref) は [`Real`](@ref) 抽象のインスタンスです。

### Tuple Types

タプルは、関数の引数の抽象化であり、関数自体は含まれていません。関数の引数の重要な側面は、その順序と型です。したがって、タプル型は、各パラメータが1つのフィールドの型であるパラメータ化された不変型に似ています。たとえば、2要素のタプル型は、次の不変型に似ています：

```julia
struct Tuple2{A,B}
    a::A
    b::B
end
```

しかし、3つの重要な違いがあります：

  * タプル型は任意の数のパラメータを持つことができます。
  * タプル型はそのパラメータにおいて*共変*です：`Tuple{Int}`は`Tuple{Any}`のサブタイプです。したがって、`Tuple{Any}`は抽象型と見なされ、タプル型はそのパラメータが具体的である場合にのみ具体的です。
  * タプルにはフィールド名がなく、フィールドはインデックスによってのみアクセスされます。

タプルの値は、括弧とカンマで書かれます。タプルが構築されると、適切なタプル型が必要に応じて生成されます：

```jldoctest
julia> typeof((1,"foo",2.5))
Tuple{Int64, String, Float64}
```

共分散の意味を考慮してください：

```jldoctest
julia> Tuple{Int,AbstractString} <: Tuple{Real,Any}
true

julia> Tuple{Int,AbstractString} <: Tuple{Real,Real}
false

julia> Tuple{Int,AbstractString} <: Tuple{Real,}
false
```

直感的には、これは関数の引数の型が関数のシグネチャのサブタイプであることに対応しています（シグネチャが一致する場合）。

### Vararg Tuple Types

タプル型の最後のパラメータは、特別な値 [`Vararg`](@ref) であり、これは任意の数の末尾要素を示します：

```jldoctest
julia> mytupletype = Tuple{AbstractString,Vararg{Int}}
Tuple{AbstractString, Vararg{Int64}}

julia> isa(("1",), mytupletype)
true

julia> isa(("1",1), mytupletype)
true

julia> isa(("1",1,2), mytupletype)
true

julia> isa(("1",1,2,3.0), mytupletype)
false
```

さらに `Vararg{T}` は、型 `T` のゼロ個以上の要素に対応します。Vararg タプル型は、varargs メソッドによって受け入れられる引数を表すために使用されます（参照： [Varargs Functions](@ref)）。

特別な値 `Vararg{T,N}`（タプル型の最後のパラメータとして使用される場合）は、型 `T` の要素が正確に `N` 個であることに対応します。 `NTuple{N,T}` は `Tuple{Vararg{T,N}}` の便利なエイリアスであり、つまり型 `T` の要素が正確に `N` 個含まれるタプル型です。

### Named Tuple Types

名前付きタプルは、[`NamedTuple`](@ref) 型のインスタンスであり、フィールド名を与えるシンボルのタプルとフィールドタイプを与えるタプルの2つのパラメータを持っています。便利のために、`NamedTuple` 型は [`@NamedTuple`](@ref) マクロを使用して印刷され、`key::Type` 宣言を介してこれらの型を宣言するための便利な `struct`-のような構文を提供します。省略された `::Type` は `::Any` に対応します。

```jldoctest
julia> typeof((a=1,b="hello")) # prints in macro form
@NamedTuple{a::Int64, b::String}

julia> NamedTuple{(:a, :b), Tuple{Int64, String}} # long form of the type
@NamedTuple{a::Int64, b::String}
```

`@NamedTuple`マクロの`begin ... end`形式は、宣言を複数行に分けることを可能にします（構造体宣言に似ています）が、それ以外は同等です：

```jldoctest
julia> @NamedTuple begin
           a::Int
           b::String
       end
@NamedTuple{a::Int64, b::String}
```

`NamedTuple` 型は、単一のタプル引数を受け取るコンストラクタとして使用できます。構築された `NamedTuple` 型は、両方のパラメータが指定された具体的な型であるか、フィールド名のみを指定する型である可能性があります。

```jldoctest
julia> @NamedTuple{a::Float32,b::String}((1, ""))
(a = 1.0f0, b = "")

julia> NamedTuple{(:a, :b)}((1, ""))
(a = 1, b = "")
```

フィールドタイプが指定されている場合、引数は変換されます。そうでない場合は、引数のタイプが直接使用されます。

### Parametric Primitive Types

プリミティブ型は、パラメトリックに宣言することもできます。たとえば、ポインタはプリミティブ型として表現され、Juliaでは次のように宣言されます：

```julia
# 32-bit system:
primitive type Ptr{T} 32 end

# 64-bit system:
primitive type Ptr{T} 64 end
```

これらの宣言の少し奇妙な特徴は、典型的なパラメトリック合成型と比較して、型パラメータ `T` が型自体の定義に使用されていないことです。これは単なる抽象的なタグであり、基本的に同一の構造を持つ型の全体のファミリーを定義し、型パラメータによってのみ区別されます。したがって、`Ptr{Float64}` と `Ptr{Int64}` は異なる型であり、同一の表現を持っているにもかかわらず、異なります。そしてもちろん、すべての特定のポインタ型は、傘型 [`Ptr`](@ref) のサブタイプです。

```jldoctest
julia> Ptr{Float64} <: Ptr
true

julia> Ptr{Int64} <: Ptr
true
```

## UnionAll Types

私たちは、`Ptr`のようなパラメトリック型がそのすべてのインスタンス（`Ptr{Int64}`など）のスーパタイプとして機能することを述べました。これはどのように機能するのでしょうか？`Ptr`自体は通常のデータ型ではあり得ません。参照されるデータの型を知らなければ、メモリ操作にその型を明確に使用することはできません。答えは、`Ptr`（または`Array`のような他のパラメトリック型）は、[`UnionAll`](@ref)型と呼ばれる異なる種類の型であるということです。このような型は、あるパラメータのすべての値に対する型の*反復和*を表現します。

`UnionAll` 型は通常、キーワード `where` を使用して記述されます。例えば、`Ptr` は `Ptr{T} where T` とより正確に書くことができ、これは `T` の値に対して `Ptr{T}` 型のすべての値を意味します。この文脈では、パラメータ `T` は「型変数」とも呼ばれることが多く、これは型を範囲とする変数のようなものです。各 `where` は単一の型変数を導入するため、これらの式は複数のパラメータを持つ型に対してネストされます。例えば、`Array{T,N} where N where T` のようになります。

タイプアプリケーション構文 `A{B,C}` は、`A` が `UnionAll` タイプであることを要求し、最初に `B` を `A` の最外部の型変数に置き換えます。その結果は別の `UnionAll` タイプであることが期待され、次に `C` が置き換えられます。したがって、`A{B,C}` は `A{B}{C}` と同等です。これにより、`Array{Float64}` のように型を部分的にインスタンス化することが可能である理由が説明されます：最初のパラメータ値は固定されていますが、2番目はまだすべての可能な値にわたって変動します。明示的な `where` 構文を使用することで、パラメータの任意のサブセットを固定することができます。たとえば、すべての1次元配列の型は `Array{T,1} where T` と書くことができます。

型変数はサブタイプ関係で制限できます。 `Array{T} where T<:Integer` は、要素型が何らかの [`Integer`](@ref) の配列を指します。 `Array{<:Integer}` という構文は、 `Array{T} where T<:Integer` の便利な省略形です。 型変数には下限と上限の両方を持たせることができます。 `Array{T} where Int<:T<:Number` は、 `Int` を含むことができる [`Number`](@ref) の配列を指します（`T` は少なくとも `Int` と同じ大きさでなければなりません）。 `where T>:Int` という構文も、型変数の下限のみを指定するために機能し、 `Array{>:Int}` は `Array{T} where T>:Int` と同等です。

`where`式はネストできるため、型変数の境界は外側の型変数を参照できます。例えば、`Tuple{T,Array{S}} where S<:AbstractArray{T} where T<:Real`は、最初の要素が任意の[`Real`](@ref)である2タプルを指し、2番目の要素が最初のタプル要素の型を含む任意の種類の配列の`Array`であることを示します。

`where` キーワード自体は、より複雑な宣言の中にネストすることができます。たとえば、次の宣言によって作成された2つの型を考えてみましょう：

```jldoctest
julia> const T1 = Array{Array{T, 1} where T, 1}
Vector{Vector} (alias for Array{Array{T, 1} where T, 1})

julia> const T2 = Array{Array{T, 1}, 1} where T
Array{Vector{T}, 1} where T
```

型 `T1` は、1次元配列の1次元配列を定義します。各内部配列は同じ型のオブジェクトで構成されていますが、この型は内部配列ごとに異なる場合があります。一方、型 `T2` は、すべての内部配列が同じ型でなければならない1次元配列の1次元配列を定義します。注意すべきは、`T2` は抽象型であり、例えば `Array{Array{Int,1},1} <: T2` のようになりますが、`T1` は具体的な型です。その結果、`T1` は引数なしのコンストラクタ `a=T1()` で構築できますが、`T2` はできません。

そのような型に名前を付けるための便利な構文があり、関数定義構文の短縮形に似ています：

```julia
Vector{T} = Array{T, 1}
```

これは `const Vector = Array{T,1} where T` と同等です。`Vector{Float64}` と書くことは `Array{Float64,1}` と書くことと同じです。また、傘型 `Vector` は、要素型に関係なく、第二のパラメータ – 配列の次元数 – が 1 であるすべての `Array` オブジェクトをインスタンスとして持っています。パラメトリック型を常に完全に指定しなければならない言語では、これは特に役に立ちませんが、Julia では、任意の要素型のすべての一次元密な配列を含む抽象型として単に `Vector` と書くことができます。

## [Singleton types](@id man-singleton-types)

フィールドを持たない不変の複合型は*シングルトン*と呼ばれます。正式には、もし

1. `T` は不変の複合型（つまり、`struct` で定義された）です。
2. `aがTのインスタンスであり、bがTのインスタンスである`は`a === b`を意味します。

その場合、`T` はシングルトン型です。[^2] [`Base.issingletontype`](@ref) を使用して、型がシングルトン型であるかどうかを確認できます。[Abstract types](@ref man-abstract-types) は構造上シングルトン型にはなりません。

定義から、こうしたタイプのインスタンスは1つだけ存在することができることがわかります：

```jldoctest
julia> struct NoFields
       end

julia> NoFields() === NoFields()
true

julia> Base.issingletontype(NoFields)
true
```

[`===`](@ref) 関数は、構築された `NoFields` のインスタンスが実際に同一であることを確認します。

パラメトリック型は、上記の条件が成り立つ場合にシングルトン型になることがあります。例えば、

```jldoctest
julia> struct NoFieldsParam{T}
       end

julia> Base.issingletontype(NoFieldsParam) # Can't be a singleton type ...
false

julia> NoFieldsParam{Int}() isa NoFieldsParam # ... because it has ...
true

julia> NoFieldsParam{Bool}() isa NoFieldsParam # ... multiple instances.
true

julia> Base.issingletontype(NoFieldsParam{Int}) # Parametrized, it is a singleton.
true

julia> NoFieldsParam{Int}() === NoFieldsParam{Int}()
true
```

## Types of functions

各関数には独自の型があり、それは `Function` のサブタイプです。

```jldoctest foo41
julia> foo41(x) = x + 1
foo41 (generic function with 1 method)

julia> typeof(foo41)
typeof(foo41) (singleton type of function foo41, subtype of Function)
```

`typeof(foo41)` がそのまま印刷されることに注意してください。これは単なる印刷のための慣習であり、他の値と同様に使用できる第一級オブジェクトです。

```jldoctest foo41
julia> T = typeof(foo41)
typeof(foo41) (singleton type of function foo41, subtype of Function)

julia> T <: Function
true
```

トップレベルで定義された関数の種類はシングルトンです。必要に応じて、[`===`](@ref)と比較することができます。

[Closures](@ref man-anonymous-functions) も独自の型を持ち、通常は `#<number>` で終わる名前で表示されます。異なる場所で定義された関数の名前と型は異なりますが、セッション間で同じ方法で表示されることは保証されていません。

```jldoctest; filter = r"[0-9\.]+"
julia> typeof(x -> x + 1)
var"#9#10"
```

クロージャの種類は必ずしもシングルトンではありません。

```jldoctest
julia> addy(y) = x -> x + y
addy (generic function with 1 method)

julia> typeof(addy(1)) === typeof(addy(2))
true

julia> addy(1) === addy(2)
false

julia> Base.issingletontype(typeof(addy(1)))
false
```

## [`Type{T}` type selectors](@id man-typet-type)

各タイプ `T` に対して、`Type{T}` は抽象的なパラメトリックタイプで、その唯一のインスタンスはオブジェクト `T` です。[Parametric Methods](@ref) と [conversions](@ref conversion-and-promotion) について議論するまで、この構造の有用性を説明するのは難しいですが、簡単に言うと、特定のタイプを *値* として関数の動作を特化させることを可能にします。これは、引数のタイプによって暗黙的に決まるのではなく、明示的な引数として与えられたタイプに依存する動作を持つメソッド（特にパラメトリックなもの）を書くのに役立ちます。

定義は少し理解しにくいので、いくつかの例を見てみましょう：

```jldoctest
julia> isa(Float64, Type{Float64})
true

julia> isa(Real, Type{Float64})
false

julia> isa(Real, Type{Real})
true

julia> isa(Float64, Type{Real})
false
```

言い換えれば、[`isa(A, Type{B})`](@ref) は、`A` と `B` が同じオブジェクトであり、そのオブジェクトが型である場合に限り真です。

特に、パラメトリック型は [invariant](@ref man-parametric-composite-types) であるため、私たちは次のようになります。

```jldoctest
julia> struct TypeParamExample{T}
           x::T
       end

julia> TypeParamExample isa Type{TypeParamExample}
true

julia> TypeParamExample{Int} isa Type{TypeParamExample}
false

julia> TypeParamExample{Int} isa Type{TypeParamExample{Int}}
true
```

パラメータなしでは、`Type`はすべての型オブジェクトをインスタンスとして持つ単なる抽象型です：

```jldoctest
julia> isa(Type{Float64}, Type)
true

julia> isa(Float64, Type)
true

julia> isa(Real, Type)
true
```

`Type`のインスタンスでないオブジェクトは、型ではない。

```jldoctest
julia> isa(1, Type)
false

julia> isa("foo", Type)
false
```

`Type`は、他の抽象パラメトリック型と同様にJuliaの型階層の一部ですが、特別な場合を除いてメソッドシグネチャ以外では一般的に使用されません。`Type`のもう一つの重要な使用ケースは、そうでなければあまり正確にキャプチャされないフィールドタイプをシャープにすることです。例えば、以下の例では、デフォルトコンストラクタが正確なラップされた型に依存するコードでパフォーマンスの問題を引き起こす可能性があるため、[`DataType`](@ref man-declared-types)として示されています（同様に、[abstract type parameters](@ref man-performance-abstract-container)）。

```jldoctest
julia> struct WrapType{T}
       value::T
       end

julia> WrapType(Float64) # default constructor, note DataType
WrapType{DataType}(Float64)

julia> WrapType(::Type{T}) where T = WrapType{Type{T}}(T)
WrapType

julia> WrapType(Float64) # sharpened constructor, note more precise Type{Float64}
WrapType{Type{Float64}}(Float64)
```

## Type Aliases

時には、すでに表現可能な型に新しい名前を付けることが便利です。これは、単純な代入文で行うことができます。たとえば、`UInt`は、システムのポインタのサイズに応じて、[`UInt32`](@ref)または[`UInt64`](@ref)にエイリアスされています。

```julia-repl
# 32-bit system:
julia> UInt
UInt32

# 64-bit system:
julia> UInt
UInt64
```

これは `base/boot.jl` の以下のコードによって達成されます:

```julia
if Int === Int64
    const UInt = UInt64
else
    const UInt = UInt32
end
```

もちろん、これは `Int` が何にエイリアスされているかによりますが、それは正しい型に事前定義されています – つまり、[`Int32`](@ref) または [`Int64`](@ref) のいずれかです。

(Note that unlike `Int`, `Float` does not exist as a type alias for a specific sized [`AbstractFloat`](@ref). Unlike with integer registers, where the size of `Int` reflects the size of a native pointer on that machine, the floating point register sizes are specified by the IEEE-754 standard.)

型エイリアスはパラメータ化できます：

```jldoctest
julia> const Family{T} = Set{T}
Set

julia> Family{Char} === Set{Char}
true
```

## Operations on Types

Juliaでは、型自体がオブジェクトであるため、通常の関数がそれらに対して操作を行うことができます。型を扱ったり探索したりするのに特に便利な関数がいくつか既に紹介されています。例えば、`<:` 演算子は、左辺のオペランドが右辺のオペランドのサブタイプであるかどうかを示します。

[`isa`](@ref) 関数は、オブジェクトが指定された型であるかどうかをテストし、真または偽を返します：

```jldoctest
julia> isa(1, Int)
true

julia> isa(1, AbstractFloat)
false
```

[`typeof`](@ref) 関数は、マニュアルの例で既に使用されており、引数の型を返します。上記のように、型はオブジェクトであるため、それらにも型があり、それらの型が何であるかを尋ねることができます。

```jldoctest
julia> typeof(Rational{Int})
DataType

julia> typeof(Union{Real,String})
Union
```

もしこのプロセスを繰り返したらどうなるでしょうか？型の型の型とは何でしょうか？実際、型はすべて複合値であり、したがってすべてが `DataType` の型を持っています：

```jldoctest
julia> typeof(DataType)
DataType

julia> typeof(Union)
DataType
```

`DataType`はそれ自体の型です。

別の操作は、いくつかのタイプに適用される [`supertype`](@ref) であり、タイプのスーパタイプを明らかにします。宣言されたタイプ（`DataType`）のみが明確なスーパタイプを持っています：

```jldoctest
julia> supertype(Float64)
AbstractFloat

julia> supertype(Number)
Any

julia> supertype(AbstractString)
Any

julia> supertype(Any)
Any
```

もし [`supertype`](@ref) を他の型オブジェクト（または非型オブジェクト）に適用すると、[`MethodError`](@ref) が発生します：

```jldoctest; filter = r"Closest candidates.*"s
julia> supertype(Union{Float64,Int64})
ERROR: MethodError: no method matching supertype(::Type{Union{Float64, Int64}})
The function `supertype` exists, but no method is defined for this combination of argument types.

Closest candidates are:
[...]
```

## [Custom pretty-printing](@id man-custom-pretty-printing)

しばしば、型のインスタンスがどのように表示されるかをカスタマイズしたいと思うことがあります。これは、[`show`](@ref) 関数をオーバーロードすることで実現されます。たとえば、極形式の複素数を表す型を定義するとします：

```jldoctest polartype
julia> struct Polar{T<:Real} <: Number
           r::T
           Θ::T
       end

julia> Polar(r::Real,Θ::Real) = Polar(promote(r,Θ)...)
Polar
```

ここでは、異なる [`Real`](@ref) 型の引数を受け取ることができ、共通の型に昇格させるためのカスタムコンストラクタ関数を追加しました（[Constructors](@ref man-constructors) と [Conversion and Promotion](@ref conversion-and-promotion) を参照）。 （もちろん、[`Number`](@ref) のように動作させるために、`+`、`*`、`one`、`zero`、昇格ルールなど、他の多くのメソッドも定義する必要があります。）デフォルトでは、この型のインスタンスは、型名とフィールド値に関する情報を表示し、例えば `Polar{Float64}(3.0,4.0)` のようになります。

もしそれを `3.0 * exp(4.0im)` として表示したい場合、次のメソッドを定義して、指定された出力オブジェクト `io`（ファイル、端末、バッファなどを表す; [Networking and Streams](@ref) を参照）にオブジェクトを印刷します:

```jldoctest polartype
julia> Base.show(io::IO, z::Polar) = print(io, z.r, " * exp(", z.Θ, "im)")
```

`Polar`オブジェクトの表示に対するより細かい制御が可能です。特に、REPLや他のインタラクティブな環境で単一のオブジェクトを表示するために使用される冗長なマルチライン印刷形式と、[`print`](@ref)や他のオブジェクトの一部としてオブジェクトを表示するために使用されるよりコンパクトなシングルライン形式の両方が必要な場合があります。デフォルトでは、`show(io, z)`関数が両方のケースで呼び出されますが、`text/plain` MIMEタイプを第二引数として受け取る`show`の三引数形式をオーバーロードすることで、オブジェクトを表示するための*異なる*マルチライン形式を定義できます（例：[Multimedia I/O](@ref Multimedia-I/O)）。

```jldoctest polartype
julia> Base.show(io::IO, ::MIME"text/plain", z::Polar{T}) where{T} =
           print(io, "Polar{$T} complex number:\n   ", z)
```

（ここで `print(..., z)` は2引数の `show(io, z)` メソッドを呼び出します。）これにより、次のようになります：

```jldoctest polartype
julia> Polar(3, 4.0)
Polar{Float64} complex number:
   3.0 * exp(4.0im)

julia> [Polar(3, 4.0), Polar(4.0,5.3)]
2-element Vector{Polar{Float64}}:
 3.0 * exp(4.0im)
 4.0 * exp(5.3im)
```

単一行の `show(io, z)` 形式は、`Polar` 値の配列に対してまだ使用されています。技術的には、REPLは行を実行した結果を表示するために `display(z)` を呼び出し、これはデフォルトで `show(stdout, MIME("text/plain"), z)` を呼び出し、さらにデフォルトで `show(stdout, z)` を呼び出しますが、新しい [`display`](@ref) メソッドを定義すべきではありません。新しいマルチメディア表示ハンドラーを定義する場合を除いて（[Multimedia I/O](@ref Multimedia-I/O) を参照）。

さらに、他のMIMEタイプのために`show`メソッドを定義することもでき、これにより、これをサポートする環境（例：IJulia）でのオブジェクトのリッチな表示（HTML、画像など）が可能になります。たとえば、上付き文字やイタリック体を使用した`Polar`オブジェクトのフォーマットされたHTML表示を次のように定義できます：

```jldoctest polartype
julia> Base.show(io::IO, ::MIME"text/html", z::Polar{T}) where {T} =
           println(io, "<code>Polar{$T}</code> complex number: ",
                   z.r, " <i>e</i><sup>", z.Θ, " <i>i</i></sup>")
```

`Polar` オブジェクトは、HTML 表示をサポートする環境で自動的に表示されますが、必要に応じて手動で `show` を呼び出して HTML 出力を取得することもできます。

```jldoctest polartype
julia> show(stdout, "text/html", Polar(3.0,4.0))
<code>Polar{Float64}</code> complex number: 3.0 <i>e</i><sup>4.0 <i>i</i></sup>
```

```@raw html
<p>An HTML renderer would display this as: <code>Polar{Float64}</code> complex number: 3.0 <i>e</i><sup>4.0 <i>i</i></sup></p>
```

一般的なルールとして、単一行の `show` メソッドは、表示されるオブジェクトを作成するための有効な Julia 式を印刷する必要があります。この `show` メソッドに、上記の `Polar` の単一行 `show` メソッドにあるような乗算演算子（`*`）のような中置演算子が含まれている場合、別のオブジェクトの一部として印刷されると正しく解析されないことがあります。これを確認するために、特定の `Polar` 型のインスタンスの平方を取る式オブジェクト（参照: [Program representation](@ref)）を考えてみてください。

```jldoctest polartype
julia> a = Polar(3, 4.0)
Polar{Float64} complex number:
   3.0 * exp(4.0im)

julia> print(:($a^2))
3.0 * exp(4.0im) ^ 2
```

演算子 `^` は `*` よりも優先順位が高いため（[Operator Precedence and Associativity](@ref) を参照）、この出力は `a ^ 2` の式を正確に表していません。これは `(3.0 * exp(4.0im)) ^ 2` と等しいはずです。この問題を解決するために、`Base.show_unquoted(io::IO, z::Polar, indent::Int, precedence::Int)` のカスタムメソッドを作成する必要があります。このメソッドは、印刷時に式オブジェクトによって内部的に呼び出されます。

```jldoctest polartype
julia> function Base.show_unquoted(io::IO, z::Polar, ::Int, precedence::Int)
           if Base.operator_precedence(:*) <= precedence
               print(io, "(")
               show(io, z)
               print(io, ")")
           else
               show(io, z)
           end
       end

julia> :($a^2)
:((3.0 * exp(4.0im)) ^ 2)
```

上記で定義されたメソッドは、呼び出し演算子の優先順位が乗算の優先順位以上である場合に、`show`への呼び出しの周りに括弧を追加します。このチェックにより、括弧なしで正しく解析される式（例えば、`:($a + 2)`や`:($a == 2)`）は、印刷時にそれらを省略することができます：

```jldoctest polartype
julia> :($a + 2)
:(3.0 * exp(4.0im) + 2)

julia> :($a == 2)
:(3.0 * exp(4.0im) == 2)
```

場合によっては、コンテキストに応じて `show` メソッドの動作を調整することが有用です。これは、コンテキストプロパティをラップされた IO ストリームと一緒に渡すことを可能にする [`IOContext`](@ref) タイプを介して実現できます。たとえば、`:compact` プロパティが `true` に設定されている場合、`show` メソッドで短い表現を構築し、プロパティが `false` または存在しない場合は長い表現にフォールバックすることができます。

```jldoctest polartype
julia> function Base.show(io::IO, z::Polar)
           if get(io, :compact, false)::Bool
               print(io, z.r, "ℯ", z.Θ, "im")
           else
               print(io, z.r, " * exp(", z.Θ, "im)")
           end
       end
```

この新しいコンパクト表現は、渡されたIOストリームが`:compact`プロパティが設定された`IOContext`オブジェクトである場合に使用されます。特に、複数の列を持つ配列を印刷する際（水平スペースが限られている場合）に該当します：

```jldoctest polartype
julia> show(IOContext(stdout, :compact=>true), Polar(3, 4.0))
3.0ℯ4.0im

julia> [Polar(3, 4.0) Polar(4.0,5.3)]
1×2 Matrix{Polar{Float64}}:
 3.0ℯ4.0im  4.0ℯ5.3im
```

[`IOContext`](@ref) のドキュメントを参照して、印刷を調整するために使用できる一般的なプロパティのリストを確認してください。

## "Value types"

Juliaでは、`true`や`false`のような*値*に対してディスパッチすることはできません。しかし、パラメトリック型に対してディスパッチすることは可能であり、Juliaは「プレーンビット」値（型、シンボル、整数、浮動小数点数、タプルなど）を型パラメータとして含めることを許可しています。一般的な例は、`Array{T,N}`における次元パラメータであり、ここで`T`は型（例：[`Float64`](@ref)）ですが、`N`は単なる`Int`です。

独自のカスタムタイプを作成し、値をパラメータとして受け取ることができ、それを使用してカスタムタイプのディスパッチを制御することができます。このアイデアを説明するために、パラメトリックタイプ `Val{x}` とそのコンストラクタ `Val(x) = Val{x}()` を紹介します。これは、より複雑な階層が必要ない場合にこの技術を利用するための一般的な方法として機能します。

[`Val`](@ref) は次のように定義されています:

```jldoctest valtype
julia> struct Val{x}
       end

julia> Val(x) = Val{x}()
Val
```

`Val`の実装はこれ以上のものではありません。Juliaの標準ライブラリのいくつかの関数は`Val`インスタンスを引数として受け入れ、また自分自身の関数を書くためにも使用できます。例えば：

```jldoctest valtype
julia> firstlast(::Val{true}) = "First"
firstlast (generic function with 1 method)

julia> firstlast(::Val{false}) = "Last"
firstlast (generic function with 2 methods)

julia> firstlast(Val(true))
"First"

julia> firstlast(Val(false))
"Last"
```

Juliaの一貫性のために、呼び出し元は常に`Val`の*インスタンス*を渡すべきであり、*型*を使用すべきではありません。つまり、`foo(Val(:bar))`を使用し、`foo(Val{:bar})`は使用しないでください。

注意すべきは、`Val`を含むパラメトリックな「値」型を誤って使用するのは非常に簡単であり、不利な場合にはコードのパフォーマンスが大幅に*悪化*する可能性があることです。特に、上記のように実際のコードを書くことは決して望ましくありません。`Val`の適切（および不適切）な使用法についての詳細は、[the more extensive discussion in the performance tips](@ref man-performance-value-type)をお読みください。

[^1]: "Small" is defined by the `max_union_splitting` configuration, which currently defaults to 4.

[^2]: A few popular languages have singleton types, including Haskell, Scala and Ruby.
