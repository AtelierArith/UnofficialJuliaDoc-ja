# [Types](@id man-types)

型システムは従来、大きく異なる2つの系統に分かれてきました。静的型システムでは、プログラム中のすべての式について、プログラムの実行前に型を計算できなければなりません。一方、動的型システムでは、プログラムが操作する実際の値が得られる実行時まで、型については何もわかりません。オブジェクト指向は、コンパイル時に値の正確な型がわからなくてもコードを書けるようにすることで、静的型付け言語にある程度の柔軟性を与えます。異なる型に対して動作するコードを書ける性質を、多相性（ポリモーフィズム）と呼びます。従来の動的型付け言語では、すべてのコードが多相的です。値の型が制限されるのは、型を明示的に検査した場合か、実行時にオブジェクトが操作をサポートしていないことが判明した場合だけです。

Juliaの型システムは動的ですが、特定の値が特定の型であることを指定できるため、静的型システムの利点の一部も得られます。これは効率的なコードの生成に大いに役立ちますが、さらに重要なのは、関数の引数の型に基づくメソッドディスパッチを言語に深く統合できることです。メソッドディスパッチについては[Methods](@ref)で詳しく説明しますが、その基盤となるのが、ここで紹介する型システムです。

Juliaでは型を省略すると、デフォルトで任意の型の値を許容します。そのため、型を明示的に使わなくても、多くの有用なJulia関数を書くことができます。一方、さらに高い表現力が必要になった場合は、それまで「型のなかった」コードに明示的な型注釈を少しずつ導入することも簡単です。型注釈を追加する主な目的は3つあります。Juliaの強力な多重ディスパッチ機構を活用すること、人間にとっての読みやすさを向上させること、そしてプログラマの誤りを検出することです。

[type systems](https://en.wikipedia.org/wiki/Type_system)の用語でJuliaを説明すると、動的で、名前的で、パラメトリックな型システムを持つ言語です。ジェネリック型はパラメータ化でき、型間の階層関係は[implied by compatible structure](https://en.wikipedia.org/wiki/Structural_type_system)ではなく[explicitly declared](https://en.wikipedia.org/wiki/Nominal_type_system)です。Juliaの型システムで特に際立った特徴の1つは、具象型同士がサブタイプ関係を持てないことです。すべての具象型はfinalであり、そのスーパータイプになれるのは抽象型だけです。一見すると過度な制限に思えるかもしれませんが、実際には欠点が驚くほど少なく、多くの利点があります。構造を継承できることよりも振る舞いを継承できることのほうがはるかに重要であり、両方を継承すると、従来のオブジェクト指向言語では大きな困難が生じます。具象型に抽象サブタイプが存在することはありますが、その例は2つ（[`Union{}`](@ref man-abstract-types)と[`Type{T}`](@ref man-typet-type)）だけで、具象型のサブタイプを追加で宣言することはできません。

Juliaの型システムの全体像について、最初に触れておくべき点がほかにもあります。

  * 値をオブジェクトとそれ以外に分けることはありません。Juliaのすべての値は真のオブジェクトであり、その型は、全体がつながった単一の型グラフに属します。このグラフのすべてのノードは、型として等しく第一級です。
  * 「コンパイル時の型」という概念に実質的な意味はありません。値が持つ型は、プログラムの実行中にその値が実際に持っている型だけです。静的コンパイルと多相性を組み合わせるためにこの区別が重要になるオブジェクト指向言語では、これを「実行時の型」と呼びます。
  * 型を持つのは値だけであり、変数ではありません。変数は値に束縛された名前にすぎません。ただし、簡潔にするため、「変数が参照する値の型」を略して「変数の型」と呼ぶことがあります。
  * 抽象型も具象型も、ほかの型でパラメータ化できます。また、シンボル、[`isbits`](@ref)がtrueを返す任意の型の値（基本的には、数値や真偽値のようにCの型と同様に格納されるもの、またはほかのオブジェクトへのポインタを持たない`struct`）、およびそれらのタプルでもパラメータ化できます。型パラメータを参照したり制限したりする必要がなければ、省略できます。

Juliaの型システムは、強力で表現力が高く、それでいて明快で直感的であり、邪魔にならないように設計されています。Juliaのプログラマの多くは、型を明示的に使うコードを書く必要を一度も感じないかもしれません。しかし、プログラミングの種類によっては、型を宣言することで、コードがより明快、簡潔、高速、堅牢になります。

## Type Declarations

`::`演算子を使うと、プログラム中の式や変数に型注釈を付けることができます。主な目的は次の2つです。

1. プログラムが期待どおりに動作していることを確認するためのアサーションとして使う。
2. コンパイラに追加の型情報を与え、場合によっては性能を向上させる。

値を計算する式の後ろに付けた`::`演算子は、「〜のインスタンスである」と読みます。この演算子はどこでも使うことができ、左辺の式の値が右辺の型のインスタンスであることを表明します。右辺の型が具象型であれば、左辺の値はその型で実装されていなければなりません。すべての具象型はfinalなので、ある実装が別の実装のサブタイプになることはない点を思い出してください。右辺の型が抽象型であれば、その抽象型のサブタイプである具象型で値が実装されていれば十分です。型アサーションが成立しない場合は例外が送出され、成立する場合は左辺の値が返されます。

```jldoctest
julia> (1+2)::AbstractFloat
ERROR: TypeError: in typeassert, expected AbstractFloat, got a value of type Int64

julia> (1+2)::Int
3
```

このようにして、任意の式にその場で型アサーションを付けることができます。

代入の左辺にある変数の後ろに付けた場合や、`local`宣言の一部として使った場合、`::`演算子の意味は少し異なります。Cなどの静的型付け言語における型宣言と同様に、その変数が常に指定された型を持つことを宣言します。変数に代入されるすべての値は、[`convert`](@ref)によって宣言された型に変換されます。

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

この機能は、変数への代入のいずれかで型が予期せず変わることによって生じる、性能上の「落とし穴」を避けるのに役立ちます。

この「宣言」としての振る舞いが生じるのは、特定の文脈だけです。

```julia
local x::Int8  # in a local declaration
x::Int8 = 10   # as the left-hand side of an assignment
```

また、この宣言は、宣言箇所より前も含めて、現在のスコープ全体に適用されます。

Julia 1.8以降では、グローバルスコープでも型宣言を使えるようになりました。つまり、グローバル変数に型注釈を付け、その変数へのアクセスを型安定にできます。

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

型宣言は関数定義にも付けられます。

```julia
function sinc(x)::Float64
    if x == 0
        return 1
    end
    return sin(pi*x)/(pi*x)
end
```

この関数から値を返すときの動作は、型が宣言された変数への代入と同じです。値は常に`Float64`に変換されます。

## [Abstract Types](@id man-abstract-types)

抽象型はインスタンス化できず、型グラフのノードとしてのみ機能します。これにより、関連する具象型の集合、すなわちその抽象型の子孫にあたる具象型の集合を表します。インスタンス化できないにもかかわらず抽象型から説明を始めるのは、抽象型が型システムの骨格だからです。抽象型は概念的な階層を形成し、Juliaの型システムを単なるオブジェクト実装の集まり以上のものにしています。

[Integers and Floating-Point Numbers](@ref)では、数値のさまざまな具象型を紹介しました。[`Int8`](@ref)、[`UInt8`](@ref)、[`Int16`](@ref)、[`UInt16`](@ref)、[`Int32`](@ref)、[`UInt32`](@ref)、[`Int64`](@ref)、[`UInt64`](@ref)、[`Int128`](@ref)、[`UInt128`](@ref)、[`Float16`](@ref)、[`Float32`](@ref)、[`Float64`](@ref)です。`Int8`、`Int16`、`Int32`、`Int64`、`Int128`は、表現に必要なサイズこそ異なりますが、すべて符号付き整数型という共通点があります。同様に、`UInt8`、`UInt16`、`UInt32`、`UInt64`、`UInt128`はすべて符号なし整数型です。一方、`Float16`、`Float32`、`Float64`は整数型ではなく浮動小数点型である点で異なります。あるコードが、たとえば引数が何らかの整数である場合にだけ意味を持ち、整数の具体的な*種類*には依存しないということはよくあります。たとえば、最大公約数を求めるアルゴリズムはあらゆる種類の整数に対して機能しますが、浮動小数点数には機能しません。抽象型を使うと型の階層を構築でき、具象型を位置付ける枠組みが得られます。これにより、たとえばアルゴリズムを特定の整数型に限定することなく、任意の整数型を対象としたプログラムを簡単に書けます。

抽象型は[`abstract type`](@ref)キーワードを使って宣言します。抽象型を宣言する一般的な構文は次のとおりです。

```
abstract type «name» end
abstract type «name» <: «supertype» end
```

`abstract type`キーワードは、`«name»`を名前とする新しい抽象型を導入します。この名前の後ろには、必要に応じて[`<:`](@ref)と既存の型を続けられます。これは、新しく宣言する抽象型が、その「親」型のサブタイプであることを示します。

スーパータイプを指定しない場合、デフォルトのスーパータイプは`Any`です。これは定義済みの抽象型であり、すべてのオブジェクトがそのインスタンスで、すべての型がそのサブタイプです。型理論では、`Any`は型グラフの頂点にあるため、通常「トップ」と呼ばれます。Juliaには、型グラフの最下部に位置する定義済みの抽象型「ボトム」もあり、`Union{}`と表記します。これは`Any`とは正反対です。`Union{}`のインスタンスであるオブジェクトは存在せず、すべての型（具象型を含む）が`Union{}`のスーパータイプです。

Juliaの数値型の階層を構成する抽象型をいくつか見てみましょう。

```julia
abstract type Number end
abstract type Real          <: Number end
abstract type AbstractFloat <: Real end
abstract type Integer       <: Real end
abstract type Signed        <: Integer end
abstract type Unsigned      <: Integer end
```

[`Number`](@ref)型は`Any`の直接の子型で、[`Real`](@ref)はその子型です。さらに、`Real`には[`Integer`](@ref)と[`AbstractFloat`](@ref)という2つの子型があり、整数の表現と実数の表現に分かれています（実際にはほかにも子型がありますが、ここでは2つだけ示しています。残りは後で説明します）。実数の表現には浮動小数点型だけでなく、有理数などの型も含まれます。`AbstractFloat`に含まれるのは、実数の浮動小数点表現だけです。整数はさらに[`Signed`](@ref)と[`Unsigned`](@ref)に分かれます。

`<:`演算子は、一般に「〜のサブタイプである」を意味します。上のような宣言で使うと、右辺の型が新しく宣言する型の直接のスーパータイプであることを宣言します。また、式の中ではサブタイプ演算子として使うことができ、左オペランドが右オペランドのサブタイプであれば`true`を返します。

```jldoctest
julia> Integer <: Number
true

julia> Integer <: AbstractFloat
false
```

抽象型の重要な用途の1つは、具象型に対するデフォルトの実装を提供することです。簡単な例として、次を考えます。

```julia
function myplus(x,y)
    x+y
end
```

まず、上の引数宣言は`x::Any`および`y::Any`と同等であることに注意してください。この関数を、たとえば`myplus(2,5)`として呼び出すと、ディスパッチャは、指定された引数に一致する`myplus`という名前のメソッドのうち、最も具体的なものを選択します。（多重ディスパッチの詳細は[Methods](@ref)を参照してください。）

上記よりも具体的なメソッドが見つからない場合、Juliaは次に、上のジェネリック関数に基づいて、2つの`Int`引数専用の`myplus`というメソッドを内部で定義し、コンパイルします。つまり、暗黙的に次を定義してコンパイルします。

```julia
function myplus(x::Int,y::Int)
    x+y
end
```

そして最後に、この特化されたメソッドを呼び出します。

このように、抽象型を使うと、具象型のさまざまな組み合わせに対してデフォルトのメソッドとして使えるジェネリック関数を書けます。多重ディスパッチにより、デフォルトのメソッドを使うか、より具体的なメソッドを使うかを、プログラマが完全に制御できます。

重要なのは、引数が抽象型の関数を使っても性能が低下するわけではないという点です。関数は、呼び出し時の具象引数型のタプルごとに再コンパイルされるためです。（ただし、関数の引数が抽象型のコンテナである場合には、性能上の問題が生じる可能性があります。[Performance Tips](@ref man-performance-abstract-container)を参照してください。）

## Primitive Types

!!! warning
    独自のプリミティブ型を定義するよりも、既存のプリミティブ型を新しい複合型でラップするほうが、ほぼ常に適切です。

    この機能は、LLVMがサポートする標準のプリミティブ型をJulia自身で定義できるようにするために存在します。それらを定義した後は、プリミティブ型をさらに定義する理由はほとんどありません。


プリミティブ型とは、データが単なるビット列で構成される具象型です。代表的な例は整数や浮動小数点数です。ほとんどの言語とは異なり、Juliaでは固定された組み込みのプリミティブ型が提供されるだけでなく、独自のプリミティブ型も宣言できます。実際、標準のプリミティブ型はすべて、Julia言語自体で定義されています。

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

プリミティブ型を宣言する一般的な構文は次のとおりです。

```
primitive type «name» «bits» end
primitive type «name» <: «supertype» «bits» end
```

ビット数はその型に必要な記憶領域の大きさを示し、名前は新しい型の名前になります。プリミティブ型の宣言では、必要に応じてスーパータイプを指定し、そのサブタイプにすることができます。スーパータイプを省略すると、デフォルトで`Any`が直接のスーパータイプになります。したがって、上の[`Bool`](@ref)の宣言は、真偽値の格納に8ビットを使い、[`Integer`](@ref)を直接のスーパータイプとすることを意味します。現在サポートされているのは8ビットの倍数のサイズだけで、上記で使われていないサイズではバグに遭遇する可能性が高くなります。そのため、真偽値は本来1ビットしか必要としませんが、8ビット未満のサイズでは宣言できません。

[`Bool`](@ref)、[`Int8`](@ref)、[`UInt8`](@ref)の表現はすべて同じで、8ビットのメモリ領域です。しかし、Juliaの型システムは名前的なので、構造が同じでも互いに置き換えることはできません。これらの根本的な違いの1つは、スーパータイプが異なることです。[`Bool`](@ref)の直接のスーパータイプは[`Integer`](@ref)、[`Int8`](@ref)の直接のスーパータイプは[`Signed`](@ref)、[`UInt8`](@ref)の直接のスーパータイプは[`Unsigned`](@ref)です。[`Bool`](@ref)、[`Int8`](@ref)、[`UInt8`](@ref)のそれ以外の違いは、すべて振る舞いの違いです。つまり、これらの型のオブジェクトを引数として与えたときに、関数がどのように動作するよう定義されているかという違いです。名前的型システムが必要なのはこのためです。構造によって型が決まり、その型によって振る舞いが決まるのであれば、[`Bool`](@ref)を[`Int8`](@ref)や[`UInt8`](@ref)とは異なるように振る舞わせることができなくなります。

## Composite Types

[Composite types](https://en.wikipedia.org/wiki/Composite_data_type)は、言語によってレコード、構造体、オブジェクトなどと呼ばれます。複合型は名前付きフィールドの集まりであり、そのインスタンスを1つの値として扱えます。多くの言語では、ユーザーが定義できる型は複合型だけです。Juliaでも、ユーザー定義型の中では複合型が圧倒的によく使われます。

C++、Java、Python、Rubyなどの主流のオブジェクト指向言語では、複合型に名前付きの関数も関連付けられ、その組み合わせが「オブジェクト」と呼ばれます。RubyやSmalltalkのような、より純粋なオブジェクト指向言語では、複合型かどうかにかかわらず、すべての値がオブジェクトです。C++やJavaなど、純粋さを抑えたオブジェクト指向言語では、整数や浮動小数点数など一部の値はオブジェクトではありませんが、ユーザー定義の複合型のインスタンスは、メソッドが関連付けられた真のオブジェクトです。Juliaでは、すべての値がオブジェクトですが、関数は操作対象のオブジェクトに組み込まれていません。これは、Juliaが多重ディスパッチによって関数のどのメソッドを使うかを選ぶために必要です。つまり、メソッドの選択では、最初の引数だけでなく、関数の*すべての*引数の型を考慮します（メソッドとディスパッチの詳細は[Methods](@ref)を参照してください）。したがって、関数が最初の引数だけに「属する」のは適切ではありません。各オブジェクトの「内部」に名前付きのメソッド群を持たせるのではなく、メソッドを関数オブジェクトにまとめる設計は、結果としてこの言語の大きな利点となっています。

複合型は、[`struct`](@ref)キーワードに続けてフィールド名のブロックを書くことで導入します。各フィールドには、必要に応じて`::`演算子で型注釈を付けられます。

```jldoctest footype
julia> struct Foo
           bar
           baz::Int
           qux::Float64
       end
```

型注釈のないフィールドの型はデフォルトで`Any`となり、任意の型の値を保持できます。

`Foo`型の新しいオブジェクトは、各フィールドの値を引数として、`Foo`型オブジェクトを関数のように呼び出すことで作成します。

```jldoctest footype
julia> foo = Foo("Hello, world.", 23, 1.5)
Foo("Hello, world.", 23, 1.5)

julia> typeof(foo)
Foo
```

関数のように呼び出される型を*コンストラクタ*と呼びます。コンストラクタは2つ自動生成されます（これらを*デフォルトコンストラクタ*と呼びます）。一方は任意の引数を受け取り、[`convert`](@ref)を呼び出してフィールドの型に変換します。もう一方は、フィールドの型に完全に一致する引数を受け取ります。両方を生成するのは、デフォルトコンストラクタを意図せず置き換えることなく、新しい定義を追加しやすくするためです。

`bar`フィールドには型の制約がないため、どのような値でも使えます。ただし、`baz`の値は`Int`に変換できなければなりません。

```jldoctest footype
julia> Foo((), 23.5, 1)
ERROR: InexactError: Int64(23.5)
Stacktrace:
[...]
```

フィールド名の一覧は、[`fieldnames`](@ref)関数で取得できます。

```jldoctest footype
julia> fieldnames(Foo)
(:bar, :baz, :qux)
```

複合オブジェクトのフィールド値には、従来どおりの`foo.bar`記法でアクセスできます。

```jldoctest footype
julia> foo.bar
"Hello, world."

julia> foo.baz
23

julia> foo.qux
1.5
```

`struct`で宣言された複合オブジェクトは*不変（immutable）*であり、構築後に変更できません。最初は奇妙に思えるかもしれませんが、これにはいくつかの利点があります。

  * 効率が向上する場合があります。構造体によっては配列に効率よく詰め込めます。また、コンパイラが不変オブジェクトの割り当て自体を完全に省略できる場合もあります。
  * 型のコンストラクタが保証する不変条件を破ることができません。
  * 不変オブジェクトを使ったコードは、その動作を考えやすくなります。

不変オブジェクトのフィールドに、配列などの可変オブジェクトが含まれることもあります。含まれているオブジェクトは引き続き変更可能です。変更できないのは、不変オブジェクト自体のフィールドを別のオブジェクトに向け直すことだけです。

必要な場合は、次の節で説明する[`mutable struct`](@ref)キーワードで、可変の複合オブジェクトを宣言できます。

不変構造体のすべてのフィールドが区別不能（`===`）であれば、それらのフィールドを持つ2つの不変値も区別不能です。

```jldoctest
julia> struct X
           a::Int
           b::Float64
       end

julia> X(1, 2) === X(1, 2)
true
```

複合型のインスタンスの作成方法については、まだ多くのことを説明する必要があります。ただし、その説明には[Parametric Types](@ref)と[Methods](@ref)の両方が関係し、独立した節で扱うほど重要なので、[Constructors](@ref man-constructors)で取り上げます。

多くのユーザー定義型`X`では、その型のインスタンスが[broadcasting](@ref Broadcasting)において0次元の「スカラー」として振る舞うよう、[`Base.broadcastable(x::X) = Ref(x)`](@ref man-interfaces-broadcasting)メソッドを定義するとよいでしょう。

## Mutable Composite Types

複合型を`struct`ではなく`mutable struct`で宣言すると、そのインスタンスを変更できるようになります。

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

[Instance Properties](@ref man-instance-properties)を通じて、フィールドとユーザーの間に追加のインターフェースを設けることもできます。これにより、`bar.baz`記法で何にアクセスでき、何を変更できるかを、より細かく制御できます。

変更を可能にするため、このようなオブジェクトは通常ヒープに割り当てられ、一定のメモリアドレスを持ちます。可変オブジェクトは、時間とともに異なる値を保持しうる小さな容器のようなものなので、確実に識別するにはアドレスを使うしかありません。これに対して、不変型のインスタンスは特定のフィールド値と結び付いており、フィールド値だけでそのオブジェクトについてのすべてがわかります。型を可変にするかどうかを決める際には、同じフィールド値を持つ2つのインスタンスを同一とみなすのか、それとも時間とともに独立に変化する必要があるのかを考えてください。同一とみなすのであれば、その型はおそらく不変にすべきです。

まとめると、Juliaにおける不変性は、次の2つの本質的な性質で定義されます。

  * 不変型の値を変更することは許されません。

      * ビット型では、一度設定された値のビットパターンは変わらず、その値がビット型の値の同一性を決めるという意味です。
      * 複合型では、各フィールドの値の同一性が変わらないという意味です。フィールドがビット型なら、そのビット列は変わりません。フィールドの値が配列のような可変型なら、その内容自体は変更できても、フィールドは常に同じ可変値を参照し続けます。
  * 不変型のオブジェクトは、コンパイラが自由にコピーできます。不変性により、元のオブジェクトとコピーをプログラムで区別することが不可能だからです。

      * 特に、整数や浮動小数点数のように十分小さい不変値は、通常、レジスタを使って関数に渡されます（またはスタックに割り当てられます）。
      * 一方、可変値はヒープに割り当てられ、ヒープ上の値へのポインタとして関数に渡されます。ただし、別の方法を使っても見分ける手段がないとコンパイラが確信できる場合は例外です。

可変構造体であっても、1つ以上のフィールドを不変にしてよいとわかっている場合は、以下のように`const`を使って宣言できます。これにより、不変構造体に対する最適化の一部（すべてではありません）が可能になり、`const`を付けた特定のフィールドに不変条件を課すこともできます。

!!! compat "Julia 1.8"
    可変構造体のフィールドに`const`注釈を付けるには、Julia 1.8以降が必要です。


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

これまでの節で説明した3種類の型（抽象型、プリミティブ型、複合型）は、実際にはすべて密接に関連しています。次の重要な性質を共有しています。

  * 明示的に宣言される。
  * 名前を持つ。
  * スーパータイプが明示的に宣言される。
  * パラメータを持つことができる。

これらの性質を共有しているため、これらの型は内部では同じ概念である`DataType`のインスタンスとして表現されます。これは、これらすべての型の型です。

```jldoctest
julia> typeof(Real)
DataType

julia> typeof(Int)
DataType
```

`DataType`は抽象型にも具象型にもなれます。具象型の場合は、サイズ、格納レイアウト、および必要に応じてフィールド名が定まっています。したがって、プリミティブ型は、サイズがゼロではなく、フィールド名を持たない`DataType`です。複合型は、フィールド名を持つか、空（サイズがゼロ）である`DataType`です。

システム内のすべての具象値は、何らかの`DataType`のインスタンスです。

## Type Unions

型の共用体は、引数として指定した型のいずれかのインスタンスをすべて含む、特別な抽象型です。特別な[`Union`](@ref)キーワードを使って構築します。

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

多くの言語のコンパイラは、型について推論するための共用体構造を内部に持っています。Juliaはそれをプログラマにも公開しているだけです。Juliaのコンパイラは、少数の型からなる`Union`型[^1]に対して、型ごとに分岐を分けて特化したコードを生成することで、効率的なコードを生成できます。

`Union`型の特に有用な例が`Union{T, Nothing}`です。ここで、`T`には任意の型を指定でき、[`Nothing`](@ref)は、オブジェクト[`nothing`](@ref)だけをインスタンスとして持つシングルトン型です。このパターンは、ほかの言語の[`Nullable`, `Option` or `Maybe`](https://en.wikipedia.org/wiki/Nullable_type)型に相当するJuliaでの表現です。関数の引数やフィールドを`Union{T, Nothing}`として宣言すると、`T`型の値、または値がないことを示す`nothing`のいずれかを設定できます。詳細は[this FAQ entry](@ref faq-nothing)を参照してください。

## Parametric Types

Juliaの型システムの重要で強力な特徴は、パラメトリックであることです。型はパラメータを受け取れるため、型宣言は実際には新しい型の族全体を導入します。パラメータ値の可能な組み合わせごとに、1つの型が対応します。多くの言語が何らかの形の[generic programming](https://en.wikipedia.org/wiki/Generic_programming)をサポートしており、そこでは、扱う正確な型を指定せずにデータ構造やそれを操作するアルゴリズムを記述できます。たとえば、ML、Haskell、Ada、Eiffel、C++、Java、C#、F#、Scalaなどには、何らかの形のジェネリックプログラミングが存在します。これらのうち、真のパラメトリック多相性をサポートする言語（ML、Haskell、Scalaなど）もあれば、アドホックでテンプレートベースのジェネリックプログラミングをサポートする言語（C++、Javaなど）もあります。言語ごとにジェネリックプログラミングやパラメトリック型には非常に多くの種類があるため、ここではJuliaのパラメトリック型をほかの言語と比較しようとはせず、Julia自身の仕組みを説明することに集中します。ただし、Juliaは動的型付け言語であり、型に関するすべての決定をコンパイル時に行う必要がないため、静的なパラメトリック型システムで従来生じていた多くの難題を、比較的容易に扱える点は指摘しておきます。

宣言される型（`DataType`に属する型）はすべて、同じ構文でパラメータ化できます。以下では、まずパラメトリック複合型、次にパラメトリック抽象型、最後にパラメトリックプリミティブ型の順に説明します。

### [Parametric Composite Types](@id man-parametric-composite-types)

型パラメータは、型名の直後に波括弧で囲んで記述します。

```jldoctest pointtype
julia> struct Point{T}
           x::T
           y::T
       end
```

この宣言は、`T`型の2つの「座標」を保持する、新しいパラメトリック型`Point{T}`を定義します。では、`T`とは何でしょうか。まさにそこがパラメトリック型の要点です。これはどのような型でもかまいません（実際には任意のビット型の値でもかまいませんが、ここでは明らかに型として使われています）。`Point{Float64}`は、`Point`の定義内の`T`を[`Float64`](@ref)に置き換えて定義した型に相当する具象型です。したがって、この1つの宣言は、実際には`Point{Float64}`、`Point{AbstractString}`、`Point{Int64}`など、無限に多くの型を宣言しています。これらはそれぞれ、そのまま使える具象型です。

```jldoctest pointtype
julia> Point{Float64}
Point{Float64}

julia> Point{AbstractString}
Point{AbstractString}
```

`Point{Float64}`型は座標が64ビット浮動小数点数である点を表し、`Point{AbstractString}`型は「座標」が文字列オブジェクトである「点」を表します（[Strings](@ref)を参照）。

`Point`自体も有効な型オブジェクトであり、`Point{Float64}`、`Point{AbstractString}`など、パラメータを具体化したすべての型をサブタイプとして含みます。

```jldoctest pointtype
julia> Point{Float64} <: Point
true

julia> Point{AbstractString} <: Point
true
```

もちろん、それ以外の型はそのサブタイプではありません。

```jldoctest pointtype
julia> Float64 <: Point
false

julia> AbstractString <: Point
false
```

`T`の値が異なる具象`Point`型同士が、サブタイプ関係になることはありません。

```jldoctest pointtype
julia> Point{Float64} <: Point{Int64}
false

julia> Point{Float64} <: Point{Real}
false
```

!!! warning
    この最後の点は*非常に*重要です。`Float64 <: Real`であっても、`Point{Float64} <: Point{Real}`は**成立しません**。


つまり、型理論の用語で言えば、Juliaの型パラメータは[covariant (or even contravariant)](https://en.wikipedia.org/wiki/Covariance_and_contravariance_%28computer_science%29)ではなく、*不変*です。これは実用上の理由によります。`Point{Float64}`のどのインスタンスも、概念的には`Point{Real}`のインスタンスのように扱えそうですが、この2つの型はメモリ上の表現が異なります。

  * `Point{Float64}`のインスタンスは、64ビット値のペアを直接格納することで、コンパクトかつ効率的に表現できます。
  * `Point{Real}`のインスタンスは、[`Real`](@ref)の任意のインスタンスのペアを保持できなければなりません。`Real`のインスタンスであるオブジェクトは、任意のサイズと構造を持ちうるため、実際には`Point{Real}`のインスタンスを、個別に割り当てられた`Real`オブジェクトへのポインタのペアとして表現する必要があります。

`Point{Float64}`オブジェクトの値を直接格納できることによる効率上の利点は、配列の場合には飛躍的に大きくなります。`Array{Float64}`は64ビット浮動小数点値の連続したメモリブロックとして格納できますが、`Array{Real}`は、個別に割り当てられた[`Real`](@ref)オブジェクトへのポインタの配列でなければなりません。そのオブジェクトは[boxed](https://en.wikipedia.org/wiki/Object_type_%28object-oriented_programming%29#Boxing)の64ビット浮動小数点値かもしれませんが、`Real`抽象型の実装として宣言された、任意に大きく複雑なオブジェクトかもしれません。

`Point{Float64}`は`Point{Real}`のサブタイプではないため、次のメソッドを`Point{Float64}`型の引数に適用することはできません。

```julia
function norm(p::Point{Real})
    sqrt(p.x^2 + p.y^2)
end
```

`T`が[`Real`](@ref)のサブタイプであるような、すべての`Point{T}`型の引数を受け取るメソッドを正しく定義するには、次のようにします。

```julia
function norm(p::Point{<:Real})
    sqrt(p.x^2 + p.y^2)
end
```

（同等の定義として、`function norm(p::Point{T} where T<:Real)`または`function norm(p::Point{T}) where T<:Real`と書くこともできます。[UnionAll Types](@ref)を参照してください。）

後ほど、[Methods](@ref)でさらに例を紹介します。

`Point`オブジェクトは、どのように構築するのでしょうか。複合型には独自のコンストラクタを定義でき、その詳細は[Constructors](@ref man-constructors)で説明します。特別なコンストラクタ宣言がない場合、新しい複合オブジェクトを作成するデフォルトの方法は2つあります。一方は型パラメータを明示的に指定する方法で、もう一方はオブジェクトのコンストラクタに渡す引数から型パラメータを推定する方法です。

`Point{Float64}`型は、`T`の代わりに[`Float64`](@ref)を使って宣言した`Point`に相当する具象型なので、次のようにコンストラクタとして使えます。

```jldoctest pointtype
julia> p = Point{Float64}(1.0, 2.0)
Point{Float64}(1.0, 2.0)

julia> typeof(p)
Point{Float64}
```

デフォルトコンストラクタには、各フィールドにつきちょうど1つの引数を渡す必要があります。

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

パラメトリック型では、デフォルトコンストラクタを上書きできないため、生成されるデフォルトコンストラクタは1つだけです。このコンストラクタは任意の引数を受け取り、フィールドの型に変換します。

多くの場合、構築したい`Point`オブジェクトの型を指定するのは冗長です。コンストラクタ呼び出しの引数の型が、すでに暗黙の型情報を与えているためです。このため、型パラメータ`T`の値が一意に定まる場合は、`Point`自体もコンストラクタとして使えます。

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

`Point`の場合、`T`の型が一意に推定できるのは、`Point`に渡す2つの引数の型が同じ場合に限られます。そうでなければ、コンストラクタは[`MethodError`](@ref)で失敗します。

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

このように型が混在する場合を適切に処理するコンストラクタメソッドも定義できますが、それについては後ほど[Constructors](@ref man-constructors)で説明します。

### Parametric Abstract Types

パラメトリック抽象型の宣言も、ほぼ同じ方法で抽象型の集まりを宣言します。

```jldoctest pointytype
julia> abstract type Pointy{T} end
```

この宣言により、`T`に指定する型または整数値ごとに、`Pointy{T}`は別々の抽象型になります。パラメトリック複合型と同様に、このようにパラメータを具体化した各型は`Pointy`のサブタイプです。

```jldoctest pointytype
julia> Pointy{Int64} <: Pointy
true

julia> Pointy{1} <: Pointy
true
```

パラメトリック抽象型も、パラメトリック複合型と同じく不変です。

```jldoctest pointytype
julia> Pointy{Float64} <: Pointy{Real}
false

julia> Pointy{Real} <: Pointy{Float64}
false
```

`Pointy{<:Real}`という記法は、Juliaで*共変*型に相当するものを表すために使えます。同様に、`Pointy{>:Int}`は*反変*型に相当するものを表せます。ただし、厳密にはこれらは型の*集合*を表します（[UnionAll Types](@ref)を参照）。

```jldoctest pointytype
julia> Pointy{Float64} <: Pointy{<:Real}
true

julia> Pointy{Real} <: Pointy{>:Int}
true
```

通常の抽象型が具象型に対して有用な型階層を作るのと同じように、パラメトリック抽象型はパラメトリック複合型に対して同じ役割を果たします。たとえば、`Point{T}`を`Pointy{T}`のサブタイプとして、次のように宣言することもできます。

```jldoctest pointytype
julia> struct Point{T} <: Pointy{T}
           x::T
           y::T
       end
```

このように宣言すると、`T`の選び方ごとに、`Point{T}`は`Pointy{T}`のサブタイプになります。

```jldoctest pointytype
julia> Point{Float64} <: Pointy{Float64}
true

julia> Point{Real} <: Pointy{Real}
true

julia> Point{AbstractString} <: Pointy{AbstractString}
true
```

この関係も不変です。

```jldoctest pointytype
julia> Point{Float64} <: Pointy{Real}
false

julia> Point{Float64} <: Pointy{<:Real}
true
```

`Pointy`のようなパラメトリック抽象型は、何の役に立つのでしょうか。点が対角線*x = y*上にあるため、座標が1つだけで済む、点のような実装を作る場合を考えましょう。

```jldoctest pointytype
julia> struct DiagPoint{T} <: Pointy{T}
           x::T
       end
```

これで、`Point{Float64}`と`DiagPoint{Float64}`はどちらも`Pointy{Float64}`という抽象概念の実装になります。型`T`としてほかのどの型を選んでも同様です。これにより、`Point`と`DiagPoint`の両方に実装された、すべての`Pointy`オブジェクトが共有する共通インターフェースに対してプログラムを書けます。ただし、これを十分に示すには、次の節である[Methods](@ref)でメソッドとディスパッチを導入する必要があります。

型パラメータがあらゆる型を自由に取れることが適切でない場合もあります。その場合は、次のように`T`の範囲を制限できます。

```jldoctest realpointytype
julia> abstract type Pointy{T<:Real} end
```

このように宣言すると、`T`には[`Real`](@ref)のサブタイプである任意の型を指定できますが、`Real`のサブタイプでない型は指定できません。

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

パラメトリック複合型の型パラメータも、同じ方法で制限できます。

```julia
struct Point{T<:Real} <: Pointy{T}
    x::T
    y::T
end
```

このようなパラメトリック型の仕組みがどのように役立つかを示す実例として、整数の正確な比を表すJuliaの不変型[`Rational`](@ref)の実際の定義を示します（ただし、簡単にするためコンストラクタは省略しています）。

```julia
struct Rational{T<:Integer} <: Real
    num::T
    den::T
end
```

ここで比を取る対象として意味があるのは整数値だけなので、型パラメータ`T`は[`Integer`](@ref)のサブタイプに制限されています。また、整数の比は実数直線上の値を表すため、すべての[`Rational`](@ref)は[`Real`](@ref)という抽象概念のインスタンスです。

### Tuple Types

タプルは、関数そのものを除いた、関数の引数の抽象表現です。関数の引数で重要なのは、その順序と型です。したがって、タプル型は、各パラメータが1つのフィールドの型を表す、パラメータ化された不変型に似ています。たとえば、2要素のタプル型は、次の不変型に似ています。

```julia
struct Tuple2{A,B}
    a::A
    b::B
end
```

ただし、重要な違いが3つあります。

  * タプル型は任意の個数のパラメータを持てます。
  * タプル型はパラメータについて*共変*です。`Tuple{Int}`は`Tuple{Any}`のサブタイプです。したがって、`Tuple{Any}`は抽象型とみなされ、タプル型が具象型になるのは、パラメータがすべて具象型の場合だけです。
  * タプルにはフィールド名がなく、フィールドにはインデックスでのみアクセスします。

タプル値は丸括弧とカンマで記述します。タプルを構築すると、必要に応じて適切なタプル型が生成されます。

```jldoctest
julia> typeof((1,"foo",2.5))
Tuple{Int64, String, Float64}
```

共変性から何が導かれるかに注意してください。

```jldoctest
julia> Tuple{Int,AbstractString} <: Tuple{Real,Any}
true

julia> Tuple{Int,AbstractString} <: Tuple{Real,Real}
false

julia> Tuple{Int,AbstractString} <: Tuple{Real,}
false
```

直感的には、これは関数の引数の型が、その関数のシグネチャのサブタイプになることに対応します（シグネチャが一致する場合）。

### Vararg Tuple Types

タプル型の最後のパラメータには、任意の個数の末尾要素を表す特別な値[`Vararg`](@ref)を指定できます。

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

さらに、`Vararg{T}`は、`T`型の0個以上の要素に対応します。可変長引数タプル型は、可変長引数メソッドが受け取る引数を表すために使われます（[Varargs Functions](@ref)を参照）。

特別な値`Vararg{T,N}`をタプル型の最後のパラメータとして使うと、`T`型のちょうど`N`個の要素に対応します。`NTuple{N,T}`は`Tuple{Vararg{T,N}}`の便利な別名であり、`T`型の要素をちょうど`N`個含むタプル型を表します。

### Named Tuple Types

名前付きタプルは[`NamedTuple`](@ref)型のインスタンスです。この型は、フィールド名を表すシンボルのタプルと、フィールドの型を表すタプル型という2つのパラメータを持ちます。利便性のため、`NamedTuple`型は[`@NamedTuple`](@ref)マクロを使った形式で表示されます。このマクロは、`key::Type`宣言によってこれらの型を宣言するための、`struct`に似た便利な構文を提供します。`::Type`を省略すると、`::Any`に対応します。

```jldoctest
julia> typeof((a=1,b="hello")) # prints in macro form
@NamedTuple{a::Int64, b::String}

julia> NamedTuple{(:a, :b), Tuple{Int64, String}} # long form of the type
@NamedTuple{a::Int64, b::String}
```

`@NamedTuple`マクロの`begin ... end`形式では、構造体の宣言と同じように宣言を複数行に分けられますが、それ以外は同等です。

```jldoctest
julia> @NamedTuple begin
           a::Int
           b::String
       end
@NamedTuple{a::Int64, b::String}
```

`NamedTuple`型は、1つのタプル引数を受け取るコンストラクタとして使えます。構築に使う`NamedTuple`型には、両方のパラメータを指定した具象型と、フィールド名だけを指定した型のどちらも使えます。

```jldoctest
julia> @NamedTuple{a::Float32,b::String}((1, ""))
(a = 1.0f0, b = "")

julia> NamedTuple{(:a, :b)}((1, ""))
(a = 1, b = "")
```

フィールドの型を指定した場合、引数はその型に変換されます。指定しなければ、引数の型がそのまま使われます。

### Parametric Primitive Types

プリミティブ型もパラメトリックに宣言できます。たとえば、ポインタはプリミティブ型として表現され、Juliaでは次のように宣言されます。

```julia
# 32-bit system:
primitive type Ptr{T} 32 end

# 64-bit system:
primitive type Ptr{T} 64 end
```

一般的なパラメトリック複合型と比べて、これらの宣言で少し変わっているのは、型パラメータ`T`が型自体の定義には使われていない点です。これは抽象的なタグにすぎず、実質的には、同じ構造を持ち、型パラメータだけで区別される型の族全体を定義しています。したがって、`Ptr{Float64}`と`Ptr{Int64}`は、表現が同じでも別の型です。そして当然ながら、具体的なポインタ型はすべて、それらを包含する[`Ptr`](@ref)型のサブタイプです。

```jldoctest
julia> Ptr{Float64} <: Ptr
true

julia> Ptr{Int64} <: Ptr
true
```

## UnionAll Types

`Ptr`のようなパラメトリック型は、パラメータを具体化したすべての型（`Ptr{Int64}`など）のスーパータイプとして機能すると説明しました。これはどのような仕組みなのでしょうか。`Ptr`自体は通常のデータ型ではありえません。参照先のデータの型がわからなければ、その型をメモリ操作に使えないことは明らかだからです。答えは、`Ptr`（あるいは`Array`のようなほかのパラメトリック型）が、[`UnionAll`](@ref)型と呼ばれる別種の型だということです。この型は、あるパラメータのすべての値にわたる型の*反復的な共用体*を表します。

`UnionAll`型は、通常`where`キーワードを使って記述します。たとえば、`Ptr`は、より正確には`Ptr{T} where T`と書けます。これは、何らかの`T`に対して型が`Ptr{T}`となる、すべての値を意味します。この文脈では、パラメータ`T`は、型全体を範囲とする変数のようなものなので、「型変数」ともよく呼ばれます。各`where`は型変数を1つ導入するため、複数のパラメータを持つ型では、たとえば`Array{T,N} where N where T`のように、これらの式が入れ子になります。

型適用構文`A{B,C}`では、`A`が`UnionAll`型である必要があり、まず`A`の最も外側の型変数に`B`を代入します。その結果も別の`UnionAll`型になることが想定されており、そこに`C`を代入します。したがって、`A{B,C}`は`A{B}{C}`と同等です。これにより、`Array{Float64}`のように、型を部分的に具体化できる理由が説明できます。第1パラメータの値は固定されていますが、第2パラメータはまだすべての可能な値を取れます。`where`構文を明示的に使えば、パラメータの任意の部分集合を固定できます。たとえば、すべての1次元配列の型は`Array{T,1} where T`と書けます。

型変数はサブタイプ関係で制限できます。`Array{T} where T<:Integer`は、要素型が何らかの[`Integer`](@ref)であるすべての配列を指します。`Array{<:Integer}`という構文は、`Array{T} where T<:Integer`の便利な短縮形です。型変数には下限と上限の両方を指定できます。`Array{T} where Int<:T<:Number`は、`Int`を格納できる[`Number`](@ref)の配列をすべて指します（`T`は、少なくとも`Int`を包含しなければならないためです）。`where T>:Int`という構文で型変数の下限だけを指定することもでき、`Array{>:Int}`は`Array{T} where T>:Int`と同等です。

`where`式は入れ子になるため、型変数の境界から外側の型変数を参照できます。たとえば`Tuple{T,Array{S}} where S<:AbstractArray{T} where T<:Real`は、第1要素が何らかの[`Real`](@ref)であり、第2要素が、第1要素の型を包含する要素型を持つ任意の配列からなる`Array`である、2要素タプルを指します。

`where`キーワード自体を、より複雑な宣言の中に入れ子にすることもできます。たとえば、次の宣言で作成される2つの型を考えます。

```jldoctest
julia> const T1 = Array{Array{T, 1} where T, 1}
Vector{Vector} (alias for Array{Array{T, 1} where T, 1})

julia> const T2 = Array{Array{T, 1}, 1} where T
Array{Vector{T}, 1} where T
```

`T1`型は、1次元配列を要素とする1次元配列を定義します。各内側配列は同じ型のオブジェクトで構成されますが、その型は内側配列ごとに異なっていてもかまいません。一方、`T2`型も1次元配列を要素とする1次元配列ですが、すべての内側配列が同じ型でなければなりません。`T2`は抽象型であり、たとえば`Array{Array{Int,1},1} <: T2`となるのに対し、`T1`は具象型であることに注意してください。そのため、`T1`は引数なしのコンストラクタ`a=T1()`で構築できますが、`T2`ではできません。

このような型に名前を付けるために、関数定義の短縮形に似た便利な構文があります。

```julia
Vector{T} = Array{T, 1}
```

これは`const Vector = Array{T,1} where T`と同等です。`Vector{Float64}`と書くことは、`Array{Float64,1}`と書くことと同等です。また、包括的な型`Vector`は、要素型に関係なく、第2パラメータ（配列の次元数）が1であるすべての`Array`オブジェクトをインスタンスとして持ちます。パラメトリック型を常に完全に指定しなければならない言語では、これは特に有用ではありません。しかしJuliaでは、任意の要素型を持つすべての1次元密配列を含む抽象型を、単に`Vector`と書けます。

## [Singleton types](@id man-singleton-types)

フィールドを持たない不変複合型を*シングルトン*と呼びます。厳密には、次の条件が成立するとき、

1. `T`が不変複合型である（つまり、`struct`で定義されている）。
2. `a isa T && b isa T`ならば`a === b`である。

`T`はシングルトン型です。[^2] 型がシングルトン型かどうかは、[`Base.issingletontype`](@ref)で確認できます。[Abstract types](@ref man-abstract-types)は、その構成上、シングルトン型にはなれません。

定義から、このような型のインスタンスは1つしか存在できないことがわかります。

```jldoctest
julia> struct NoFields
       end

julia> NoFields() === NoFields()
true

julia> Base.issingletontype(NoFields)
true
```

[`===`](@ref)関数によって、構築した`NoFields`のインスタンスが、実際にはまったく同じ1つのものであることを確認できます。

パラメトリック型も、上の条件を満たせばシングルトン型になれます。たとえば、次のようになります。

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

各関数は固有の型を持ち、その型は`Function`のサブタイプです。

```jldoctest foo41
julia> foo41(x) = x + 1
foo41 (generic function with 1 method)

julia> typeof(foo41)
typeof(foo41) (singleton type of function foo41, subtype of Function)
```

`typeof(foo41)`がそれ自身として表示される点に注目してください。これは単なる表示上の慣例です。関数も第一級オブジェクトなので、ほかの値と同様に使えます。

```jldoctest foo41
julia> T = typeof(foo41)
typeof(foo41) (singleton type of function foo41, subtype of Function)

julia> T <: Function
true
```

トップレベルで定義された関数の型はシングルトン型です。必要に応じて、[`===`](@ref)で比較できます。

[Closures](@ref man-anonymous-functions)も固有の型を持ち、通常は`#<number>`で終わる名前で表示されます。異なる場所で定義された関数の名前と型は別々ですが、セッションが変わっても同じように表示される保証はありません。

```jldoctest; filter = r"[0-9\.]+"
julia> typeof(x -> x + 1)
var"#9#10"
```

クロージャの型は、必ずしもシングルトン型ではありません。

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

各型`T`に対して、`Type{T}`は、オブジェクト`T`だけをインスタンスとして持つ抽象パラメトリック型です。[Parametric Methods](@ref)と[conversions](@ref conversion-and-promotion)を説明するまでは、この仕組みの有用性を説明するのは難しいのですが、簡単に言えば、特定の型を*値*として扱い、それに応じて関数の振る舞いを特化できます。これは、引数のいずれかの型から暗黙に決まる型ではなく、明示的な引数として渡された型に振る舞いが依存するメソッド（特にパラメトリックなメソッド）を書くときに役立ちます。

定義だけでは少しわかりにくいので、例を見てみましょう。

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

つまり、[`isa(A, Type{B})`](@ref)がtrueになるのは、`A`と`B`が同一のオブジェクトであり、かつそのオブジェクトが型である場合に限られます。

特に、パラメトリック型は[invariant](@ref man-parametric-composite-types)なので、次が成立します。

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

パラメータを付けない`Type`は、すべての型オブジェクトをインスタンスとして持つ、単なる抽象型です。

```jldoctest
julia> isa(Type{Float64}, Type)
true

julia> isa(Float64, Type)
true

julia> isa(Real, Type)
true
```

型ではないオブジェクトは、`Type`のインスタンスではありません。

```jldoctest
julia> isa(1, Type)
false

julia> isa("foo", Type)
false
```

`Type`は、ほかの抽象パラメトリック型と同様にJuliaの型階層の一部ですが、いくつかの特別な場合を除けば、メソッドシグネチャ以外ではあまり使われません。`Type`のもう1つの重要な用途は、通常では精度の低い型として捉えられるフィールドの型を、より正確にすることです。たとえば、以下の例では通常[`DataType`](@ref man-declared-types)として捉えられますが、デフォルトコンストラクタを使うと、ラップした型の正確な情報に依存するコードで性能上の問題が生じる可能性があります（[abstract type parameters](@ref man-performance-abstract-container)と同様です）。

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

この`Type{Float64}`の振る舞いは、抽象型が具象型（ここでは`DataType`）のサブタイプになる例です。

## Type Aliases

すでに表現できる型に新しい名前を付けると便利な場合があります。これは単純な代入文で行えます。たとえば、`UInt`は、システムのポインタサイズに応じて、[`UInt32`](@ref)または[`UInt64`](@ref)の別名になります。

```julia-repl
# 32-bit system:
julia> UInt
UInt32

# 64-bit system:
julia> UInt
UInt64
```

これは、`base/boot.jl`内の次のコードによって実現されています。

```julia
if Int === Int64
    const UInt = UInt64
else
    const UInt = UInt32
end
```

もちろん、これは`Int`が何の別名かに依存しますが、それは適切な型、つまり[`Int32`](@ref)または[`Int64`](@ref)になるようにあらかじめ定義されています。

（`Int`とは異なり、`Float`は、特定のサイズの[`AbstractFloat`](@ref)の型エイリアスとしては存在しないことに注意してください。整数レジスタでは`Int`のサイズがそのマシンのネイティブポインタのサイズを反映しますが、それとは異なり、浮動小数点レジスタのサイズはIEEE-754標準で規定されています。）

型エイリアスもパラメータ化できます。

```jldoctest
julia> const Family{T} = Set{T}
Set

julia> Family{Char} === Set{Char}
true
```

## Operations on Types

Juliaでは型自体がオブジェクトなので、通常の関数で型を操作できます。型の操作や調査に特に役立つ関数のいくつかは、すでに紹介しました。たとえば`<:`演算子は、左オペランドが右オペランドのサブタイプかどうかを示します。

[`isa`](@ref)関数は、オブジェクトが指定した型かどうかを検査し、trueまたはfalseを返します。

```jldoctest
julia> isa(1, Int)
true

julia> isa(1, AbstractFloat)
false
```

このマニュアルの例ですでに何度も使っている[`typeof`](@ref)関数は、引数の型を返します。前述のとおり、型もオブジェクトなので型を持っており、その型を調べることができます。

```jldoctest
julia> typeof(Rational{Int})
DataType

julia> typeof(Union{Real,String})
Union
```

この操作を繰り返すとどうなるでしょうか。型の型の型は何でしょうか。実は、型はすべて複合値なので、その型はすべて`DataType`です。

```jldoctest
julia> typeof(DataType)
DataType

julia> typeof(Union)
DataType
```

`DataType`は、それ自身の型です。

一部の型に適用できる別の操作として、型のスーパータイプを調べる[`supertype`](@ref)があります。スーパータイプが一意に定まるのは、宣言された型（`DataType`）だけです。

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

それ以外の型オブジェクト（または型ではないオブジェクト）に[`supertype`](@ref)を適用すると、[`MethodError`](@ref)が発生します。

```jldoctest; filter = r"Closest candidates.*"s
julia> supertype(Union{Float64,Int64})
ERROR: MethodError: no method matching supertype(::Type{Union{Float64, Int64}})
The function `supertype` exists, but no method is defined for this combination of argument types.

Closest candidates are:
[...]
```

## [Custom pretty-printing](@id man-custom-pretty-printing)

型のインスタンスの表示方法をカスタマイズしたいことはよくあります。これは[`show`](@ref)関数をオーバーロードすることで実現します。たとえば、複素数を極形式で表す型を定義するとします。

```jldoctest polartype
julia> struct Polar{T<:Real} <: Number
           r::T
           Θ::T
       end

julia> Polar(r::Real,Θ::Real) = Polar(promote(r,Θ)...)
Polar
```

ここでは、異なる[`Real`](@ref)型の引数を受け取り、共通の型に昇格できるよう、独自のコンストラクタ関数を追加しました（[Constructors](@ref man-constructors)と[Conversion and Promotion](@ref conversion-and-promotion)を参照）。（もちろん、[`Number`](@ref)として動作させるには、`+`、`*`、`one`、`zero`、昇格規則など、ほかにも多くのメソッドを定義する必要があります。）デフォルトでは、この型のインスタンスは、たとえば`Polar{Float64}(3.0,4.0)`のように、型名とフィールド値を含む簡素な形式で表示されます。

代わりに`3.0 * exp(4.0im)`のように表示したければ、指定された出力オブジェクト`io`にオブジェクトを出力する、次のメソッドを定義します（出力オブジェクトはファイル、端末、バッファなどを表します。[Networking and Streams](@ref)を参照）。

```jldoctest polartype
julia> Base.show(io::IO, z::Polar) = print(io, z.r, " * exp(", z.Θ, "im)")
```

`Polar`オブジェクトの表示は、さらに細かく制御できます。特に、REPLなどの対話環境で単一のオブジェクトを表示するための詳しい複数行形式と、[`print`](@ref)や、別のオブジェクトの一部（配列の要素など）として表示するためのコンパクトな1行形式の、両方が必要になることがあります。デフォルトではどちらの場合も`show(io, z)`関数が呼び出されますが、第2引数にMIME型`text/plain`を取る、3引数形式の`show`をオーバーロードすれば、オブジェクトを表示するための*別の*複数行形式を定義できます（[Multimedia I/O](@ref Multimedia-I/O)を参照）。たとえば、次のようにします。

```jldoctest polartype
julia> Base.show(io::IO, ::MIME"text/plain", z::Polar{T}) where{T} =
           print(io, "Polar{$T} complex number:\n   ", z)
```

（ここで`print(..., z)`は、2引数の`show(io, z)`メソッドを呼び出すことに注意してください。）結果は次のようになります。

```jldoctest polartype
julia> Polar(3, 4.0)
Polar{Float64} complex number:
   3.0 * exp(4.0im)

julia> [Polar(3, 4.0), Polar(4.0,5.3)]
2-element Vector{Polar{Float64}}:
 3.0 * exp(4.0im)
 4.0 * exp(5.3im)
```

`Polar`値の配列には、引き続き1行の`show(io, z)`形式が使われます。厳密には、REPLは1行を実行した結果`z`を表示するために`display(z)`を呼び出します。これはデフォルトで`show(io, MIME("text/plain"), z)`を呼び出し（`io`は[`stdout`](@ref)を包む[`IOContext`](@ref)ラッパーです）、さらにデフォルトで`show(io, z)`を呼び出します。ただし、新しいマルチメディア表示ハンドラを定義するのでない限り、新しい[`display`](@ref)メソッドを定義しては*いけません*（[Multimedia I/O](@ref Multimedia-I/O)を参照）。

さらに、ほかのMIME型に対する`show`メソッドを定義すると、対応する環境（IJuliaなど）で、HTMLや画像などを使った豊かなオブジェクト表示を実現できます。たとえば、上付き文字とイタリック体を使って`Polar`オブジェクトをHTML表示するには、次のように定義します。

```jldoctest polartype
julia> Base.show(io::IO, ::MIME"text/html", z::Polar{T}) where {T} =
           println(io, "<code>Polar{$T}</code> complex number: ",
                   z.r, " <i>e</i><sup>", z.Θ, " <i>i</i></sup>")
```

これにより、HTML表示をサポートする環境では、`Polar`オブジェクトが自動的にHTMLで表示されます。必要であれば、`show`を手動で呼び出してHTML出力を得ることもできます。

```jldoctest polartype
julia> show(stdout, "text/html", Polar(3.0,4.0))
<code>Polar{Float64}</code> complex number: 3.0 <i>e</i><sup>4.0 <i>i</i></sup>
```

```@raw html
<p>An HTML renderer would display this as: <code>Polar{Float64}</code> complex number: 3.0 <i>e</i><sup>4.0 <i>i</i></sup></p>
```

原則として、1行形式の`show`メソッドは、表示対象のオブジェクトを作成する有効なJulia式を出力すべきです。この`show`メソッドの出力に中置演算子が含まれる場合、別のオブジェクトの一部として出力すると正しく構文解析されないことがあります。たとえば、上で定義した`Polar`用の1行形式の`show`メソッドには、乗算演算子（`*`）が含まれます。この問題を確認するため、`Polar`型の特定のインスタンスを2乗する式オブジェクト（[Program representation](@ref)を参照）を考えます。

```jldoctest polartype
julia> a = Polar(3, 4.0)
Polar{Float64} complex number:
   3.0 * exp(4.0im)

julia> print(:($a^2))
3.0 * exp(4.0im) ^ 2
```

演算子`^`は`*`より優先順位が高いので（[Operator Precedence and Associativity](@ref)を参照）、この出力は式`a ^ 2`を忠実に表していません。この式は本来、`(3.0 * exp(4.0im)) ^ 2`と等しくなるはずです。この問題を解決するには、式オブジェクトが表示時に内部で呼び出す`Base.show_unquoted(io::IO, z::Polar, indent::Int, precedence::Int)`に対して、独自のメソッドを作る必要があります。

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

上で定義したメソッドは、呼び出し側の演算子の優先順位が乗算以上の場合に、`show`の呼び出し結果を丸括弧で囲みます。この検査により、`:($a + 2)`や`:($a == 2)`のように、丸括弧がなくても正しく構文解析される式では、出力時に丸括弧を省略できます。

```jldoctest polartype
julia> :($a + 2)
:(3.0 * exp(4.0im) + 2)

julia> :($a == 2)
:(3.0 * exp(4.0im) == 2)
```

場合によっては、文脈に応じて`show`メソッドの振る舞いを調整すると便利です。これは、ラップしたIOストリームとともに文脈に関するプロパティを渡せる[`IOContext`](@ref)型によって実現できます。たとえば、`:compact`プロパティが`true`に設定されているときは、`show`メソッドで短い表現を生成し、プロパティが`false`か存在しない場合は長い表現を使うようにできます。

```jldoctest polartype
julia> function Base.show(io::IO, z::Polar)
           if get(io, :compact, false)::Bool
               print(io, z.r, "ℯ", z.Θ, "im")
           else
               print(io, z.r, " * exp(", z.Θ, "im)")
           end
       end
```

渡されたIOストリームが、`:compact`プロパティを設定した`IOContext`オブジェクトである場合、この新しいコンパクトな表現が使われます。特に、横方向の空間が限られる複数列の配列を出力する場合がこれにあたります。

```jldoctest polartype
julia> show(IOContext(stdout, :compact=>true), Polar(3, 4.0))
3.0ℯ4.0im

julia> [Polar(3, 4.0) Polar(4.0,5.3)]
1×2 Matrix{Polar{Float64}}:
 3.0ℯ4.0im  4.0ℯ5.3im
```

出力の調整に使える一般的なプロパティの一覧は、[`IOContext`](@ref)のドキュメントを参照してください。

### Output-function summary

Juliaのさまざまな出力関数と、それらの関係を簡単にまとめます。ほとんどの新しい型では、必要だとしても`show`メソッドを定義するだけで十分なはずです。

  * [`display(x)`](@ref)は、現在の環境に対して、その環境が最適と考える方法で`x`を表示するよう指示します。（JupyterやPlutoのノートブックなどでは、グラフィカルな表示になることもあります。）デフォルトでは（スクリプトやテキストREPLなど）、適切な`io`ストリームに対して`show(io, "text/plain", x)`、または同等の`show(io, MIME"text/plain"(), x)`を呼び出します。（REPLでは、`io`は[`stdout`](@ref)を包む[`IOContext`](@ref)ラッパーです。）REPLは、評価した式の結果を出力するために`display`を使います。
  * 3引数の[`show(io, ::MIME"text/plain", x)`](@ref)メソッドは、`x`を詳しい整形済み形式で出力します。デフォルトでは（`typeof(x)`用の3引数メソッドが定義されていなければ）、2引数の`show(io, x)`を呼び出します。このメソッドは、2引数の`repr("text/plain", x)`から呼び出されます。前述のとおり、ほかのMIME型に対する3引数の`show`メソッドを定義すると、一部の対話環境で`x`をより豊かな形式で表示できます。
  * 2引数の[`show(io, x)`](@ref)は、`x`のデフォルトの簡素なテキスト表現です。1引数の[`repr(x)`](@ref)から呼び出され、通常は`x`をJuliaに入力するときにも使える形式です。1引数の`show(x)`は、`show(stdout, x)`を呼び出します。
  * [`print(io, x)`](@ref)はデフォルトで`show(io, x)`を呼び出しますが、一部の型には独自の`print`形式があります。特に、`x`が文字列の場合、`print`は生のテキストを出力するのに対し、`show`は引用符で囲んだエスケープ済み文字列を出力します。1引数の`print(x)`は、`print(stdout, x)`を呼び出します。`print`は、[`string(x)`](@ref)からも呼び出されます。改行を追加する[`println`](@ref)と、色などを追加する[`printstyled`](@ref)も参照してください。これらはどちらも`print`を呼び出します。
  * [`write(io, x)`](@ref)が定義されている場合（新しい型には通常、デフォルト定義は*ありません*）、`x`の「生の」バイナリ表現を`io`に書き込みます。たとえば、`x::Int32`は4バイトとして書き込まれます。

[`IOContext`](@ref)ラッパーによって`io`ストリームに付加できるメタデータについて知っておくことも役立ちます。たとえば、REPLは評価した式に対して`display`から`:limit => true`フラグを設定し、出力が端末内に収まるように制限します。このフラグは`get(io, :limit, false)`で調べられます。また、複数列の行列などに含まれるオブジェクトを表示するときは、`:compact => true`フラグが設定されることがあり、`get(io, :compact, false)`で調べられます。

## "Value types"

Juliaでは、`true`や`false`のような*値*に基づいてディスパッチすることはできません。ただし、パラメトリック型に基づくディスパッチは可能であり、Juliaでは「単純なビット」の値（型、シンボル、整数、浮動小数点数、タプルなど）を型パラメータに含められます。よくある例は、`Array{T,N}`の次元数パラメータです。ここでは`T`は型（たとえば[`Float64`](@ref)）ですが、`N`は単なる`Int`です。

値をパラメータとして受け取る独自の型を作り、それを使って独自の型のディスパッチを制御できます。この考え方を説明するため、パラメトリック型`Val{x}`と、そのコンストラクタ`Val(x) = Val{x}()`を紹介します。これは、より複雑な階層が必要ない場合に、この手法を活用するための慣例的な方法です。

[`Val`](@ref)は次のように定義されています。

```jldoctest valtype
julia> struct Val{x}
       end

julia> Val(x) = Val{x}()
Val
```

`Val`の実装はこれだけです。Juliaの標準ライブラリには、`Val`のインスタンスを引数として受け取る関数がいくつかあります。また、これを使って独自の関数を書くこともできます。たとえば、次のようにします。

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

Julia全体での一貫性を保つため、呼び出し側では常に、*型*ではなく`Val`の*インスタンス*を渡すべきです。つまり、`foo(Val{:bar})`ではなく`foo(Val(:bar))`を使ってください。

`Val`を含む、パラメトリックな「値」型は、非常に誤用しやすい点に注意してください。条件が悪い場合、コードの性能を大幅に*悪化*させてしまうことも容易にあります。特に、上の例のような書き方を実際のコードで使うべきではありません。`Val`の適切な使い方と不適切な使い方については、[the more extensive discussion in the performance tips](@ref man-performance-value-type)を参照してください。

[^1]: 「少数」の範囲は`max_union_splitting`設定で定義され、現在のデフォルト値は4です。

[^2]: Haskell、Scala、Rubyなど、広く使われている言語の中にもシングルトン型を持つものがあります。
