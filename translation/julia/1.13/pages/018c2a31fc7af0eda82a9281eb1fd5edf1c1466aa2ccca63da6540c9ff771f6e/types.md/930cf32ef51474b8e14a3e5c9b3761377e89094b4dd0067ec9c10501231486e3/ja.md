# [Types](@id man-types)

型システムは従来、大きく異なる2つの陣営に分かれてきました。静的型システムでは、プログラム内のすべての式について、プログラムの実行前に型を計算できなければなりません。一方、動的型システムでは、プログラムが操作する実際の値が得られる実行時まで、型については何もわかりません。オブジェクト指向は、コンパイル時に値の正確な型がわからなくてもコードを記述できるようにすることで、静的型付け言語にある程度の柔軟性をもたらします。異なる型に対して動作するコードを記述できる性質を、多相性と呼びます。従来の動的型付け言語では、すべてのコードが多相的です。値の型が制限されるのは、型を明示的に検査した場合か、実行時にオブジェクトがある操作をサポートしていないことが判明した場合だけです。

Juliaの型システムは動的ですが、特定の値が特定の型であることを指定できるようにすることで、静的型システムの利点の一部を取り入れています。これは効率的なコードを生成するうえで大いに役立ちますが、さらに重要なのは、関数の引数の型に基づくメソッドディスパッチを言語に深く統合できることです。メソッドディスパッチについては[Methods](@ref)で詳しく説明しますが、その基盤はここで紹介する型システムにあります。

Juliaでは、型を省略すると、デフォルトで任意の型の値を使用できます。そのため、型を明示的に使わなくても、多くの有用なJulia関数を記述できます。一方、より高い表現力が必要になった場合は、それまで「型なし」だったコードに明示的な型注釈を段階的に導入することも簡単です。型注釈を追加する主な目的は、Juliaの強力な多重ディスパッチ機構を活用すること、人間にとっての読みやすさを向上させること、そしてプログラマーの誤りを検出することの3つです。

[type systems](https://en.wikipedia.org/wiki/Type_system)の用語でJuliaを説明すると、動的、名前的、パラメトリックな型システムを持つ言語です。ジェネリック型はパラメーター化でき、型間の階層関係は[implied by compatible structure](https://en.wikipedia.org/wiki/Structural_type_system)ではなく、[explicitly declared](https://en.wikipedia.org/wiki/Nominal_type_system)です。Juliaの型システムで特に際立つ特徴の1つは、具象型同士をサブタイプ関係にできないことです。すべての具象型はfinalであり、そのスーパータイプになれるのは抽象型だけです。一見すると過度な制約に思えるかもしれませんが、これには多くの利点があり、欠点は驚くほど少なくなっています。構造を継承できることよりも振る舞いを継承できることのほうがはるかに重要であり、両方を継承すると従来のオブジェクト指向言語では大きな困難が生じることがわかっています。具象型にも抽象型のサブタイプはありますが、その例は2つだけです（[`Union{}`](@ref man-abstract-types)と[`Type{T}`](@ref man-typet-type)）。また、具象型のサブタイプを追加で宣言することはできません。

Juliaの型システムの全体的な特徴として、最初に触れておくべき点はほかにもあります。

  * オブジェクトの値と非オブジェクトの値という区別はありません。Juliaのすべての値は真のオブジェクトであり、単一の完全に連結された型グラフに属する型を持ちます。このグラフのすべてのノードは、型として等しく第一級の存在です。
  * 「コンパイル時の型」という概念には実質的な意味がありません。値が持つ型は、プログラムの実行中にその値が実際に持つ型だけです。静的コンパイルと多相性の組み合わせによってこの区別が重要になるオブジェクト指向言語では、これを「実行時の型」と呼びます。
  * 型を持つのは値だけであり、変数ではありません。変数は値に束縛された名前にすぎません。ただし、簡潔にするため、「変数が参照する値の型」を略して「変数の型」と呼ぶことがあります。
  * 抽象型も具象型も、ほかの型でパラメーター化できます。また、シンボルや、[`isbits`](@ref)がtrueを返す任意の型の値（基本的には、数値や真偽値など、Cの型や、ほかのオブジェクトへのポインターを持たない`struct`のように格納されるもの）、さらにそれらのタプルでもパラメーター化できます。型パラメーターを参照したり制限したりする必要がない場合は、省略できます。

Juliaの型システムは、強力で表現力が高く、それでいて明快で直感的であり、邪魔にならないように設計されています。多くのJuliaプログラマーは、型を明示的に使うコードを書く必要を一度も感じないかもしれません。しかし、プログラミングの種類によっては、型を宣言することで、コードがより明快、簡潔、高速かつ堅牢になります。

## Type Declarations

`::`演算子を使うと、プログラム内の式や変数に型注釈を付けられます。これには主に2つの理由があります。

1. プログラムが意図どおりに動作することを確認するためのアサーションとして使うこと。
2. コンパイラーに追加の型情報を与え、場合によっては性能を向上させること。

値を計算する式の後に付けた場合、`::`演算子は「〜のインスタンスである」と読みます。これはどこでも使用でき、左側の式の値が右側の型のインスタンスであることを表明します。右側が具象型の場合、左側の値はその型そのもので実装されていなければなりません。すべての具象型はfinalなので、ある実装が別の実装のサブタイプになることはない点を思い出してください。右側が抽象型の場合は、その抽象型のサブタイプである具象型によって値が実装されていれば十分です。型アサーションが成立しなければ例外がスローされ、成立すれば左側の値が返されます。

```jldoctest
julia> (1+2)::AbstractFloat
ERROR: TypeError: in typeassert, expected AbstractFloat, got a value of type Int64

julia> (1+2)::Int
3
```

これにより、任意の式にその場で型アサーションを付けられます。

代入の左辺にある変数に付けた場合や、`local`宣言の一部として使った場合、`::`演算子の意味は少し異なります。Cなどの静的型付け言語の型宣言と同様に、その変数が常に指定した型を持つことを宣言します。その変数に代入されるすべての値は、[`convert`](@ref)を使って宣言された型に変換されます。

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

この機能は、変数への代入のいずれかで型が意図せず変わることによる、性能上の「落とし穴」を避けるのに役立ちます。

この「宣言」としての振る舞いは、特定の文脈でのみ生じます。

```julia
local x::Int8  # in a local declaration
x::Int8 = 10   # as the left-hand side of an assignment
```

また、宣言より前の部分も含め、現在のスコープ全体に適用されます。

Julia 1.8以降では、グローバルスコープでも型宣言を使えるようになりました。つまり、グローバル変数に型注釈を追加することで、その変数へのアクセスを型安定にできます。

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

関数定義にも宣言を付けられます。

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

抽象型はインスタンス化できず、型グラフのノードとしてのみ機能します。これにより、関連する具象型、すなわちその抽象型の子孫である具象型の集合を表します。インスタンスを持たないにもかかわらず抽象型から説明を始めるのは、それが型システムの骨格だからです。抽象型は概念的な階層を形成し、Juliaの型システムを単なるオブジェクト実装の集合以上のものにしています。

[Integers and Floating-Point Numbers](@ref)では、数値のさまざまな具象型として、[`Int8`](@ref)、[`UInt8`](@ref)、[`Int16`](@ref)、[`UInt16`](@ref)、[`Int32`](@ref)、[`UInt32`](@ref)、[`Int64`](@ref)、[`UInt64`](@ref)、[`Int128`](@ref)、[`UInt128`](@ref)、[`Float16`](@ref)、[`Float32`](@ref)、[`Float64`](@ref)を紹介しました。`Int8`、`Int16`、`Int32`、`Int64`、`Int128`は、表現に使うサイズこそ異なりますが、いずれも符号付き整数型であるという共通点があります。同様に、`UInt8`、`UInt16`、`UInt32`、`UInt64`、`UInt128`はすべて符号なし整数型です。一方、`Float16`、`Float32`、`Float64`は、整数型ではなく浮動小数点型である点で異なります。あるコードが、たとえば引数が何らかの整数である場合にだけ意味を持ち、整数の*種類*そのものには依存しないことはよくあります。たとえば、最大公約数のアルゴリズムはあらゆる種類の整数に対して動作しますが、浮動小数点数には使えません。抽象型を使うと型の階層を構築でき、具象型を位置付けるための枠組みが得られます。これにより、たとえばアルゴリズムを特定の整数型に限定せず、任意の整数型を対象とするプログラムを簡単に記述できます。

抽象型は[`abstract type`](@ref)キーワードを使って宣言します。抽象型を宣言する一般的な構文は次のとおりです。

```
abstract type «name» end
abstract type «name» <: «supertype» end
```

`abstract type`キーワードは、`«name»`で指定された名前の新しい抽象型を導入します。この名前の後には、任意で[`<:`](@ref)と既存の型を続けられます。これは、新しく宣言する抽象型が、その「親」型のサブタイプであることを示します。

スーパータイプを指定しない場合、デフォルトのスーパータイプは`Any`です。これは定義済みの抽象型であり、すべてのオブジェクトはそのインスタンス、すべての型はそのサブタイプです。型理論では、`Any`は型グラフの頂点にあることから、一般に「トップ型」と呼ばれます。Juliaには、型グラフの最下部に位置する定義済みの抽象型「ボトム型」もあり、`Union{}`と表記します。これは`Any`と正反対です。`Union{}`のインスタンスであるオブジェクトは存在せず、すべての型（具象型を含む）は`Union{}`のスーパータイプです。

Juliaの数値型の階層を構成する抽象型のいくつかを見てみましょう。

```julia
abstract type Number end
abstract type Real          <: Number end
abstract type AbstractFloat <: Real end
abstract type Integer       <: Real end
abstract type Signed        <: Integer end
abstract type Unsigned      <: Integer end
```

[`Number`](@ref)型は`Any`の直接の子型であり、[`Real`](@ref)はその子型です。さらに、`Real`には[`Integer`](@ref)と[`AbstractFloat`](@ref)という2つの子型があり、整数の表現と実数の表現に分かれます（実際には子型はほかにもありますが、ここでは2つだけを示しています。残りは後で説明します）。実数の表現には浮動小数点型だけでなく、有理数などの型も含まれます。`AbstractFloat`には、実数の浮動小数点表現だけが含まれます。整数はさらに[`Signed`](@ref)と[`Unsigned`](@ref)に分かれます。

`<:`演算子は一般に「〜のサブタイプである」を意味し、上記のような宣言で使うと、右側の型が新しく宣言する型の直接のスーパータイプであることを宣言します。また、式の中でサブタイプ演算子として使うこともでき、左オペランドが右オペランドのサブタイプであれば`true`を返します。

```jldoctest
julia> Integer <: Number
true

julia> Integer <: AbstractFloat
false
```

抽象型の重要な用途の1つは、具象型にデフォルトの実装を提供することです。簡単な例として、次を考えてみましょう。

```julia
function myplus(x,y)
    x+y
end
```

まず、上記の引数宣言は`x::Any`および`y::Any`と等価であることに注意してください。この関数を、たとえば`myplus(2,5)`として呼び出すと、ディスパッチャーは、与えられた引数に一致する`myplus`という名前のメソッドのうち、最も具体的なものを選びます。（多重ディスパッチの詳細は[Methods](@ref)を参照してください。）

上記よりも具体的なメソッドが見つからなかったとすると、Juliaは次に、上記のジェネリック関数に基づいて、2つの`Int`引数に特化した`myplus`というメソッドを内部で定義し、コンパイルします。つまり、次の定義とコンパイルを暗黙的に行います。

```julia
function myplus(x::Int,y::Int)
    x+y
end
```

そして最後に、この特化されたメソッドを呼び出します。

このように、抽象型を使うと、具象型のさまざまな組み合わせに対するデフォルトのメソッドとして利用できるジェネリック関数を記述できます。多重ディスパッチにより、デフォルトのメソッドを使うか、より具体的なメソッドを使うかを、プログラマーが完全に制御できます。

重要なのは、引数を抽象型として宣言した関数を使っても、性能は低下しないという点です。関数は、呼び出しに使われる具象引数型のタプルごとに再コンパイルされるためです。（ただし、関数の引数が抽象型のコンテナーである場合は、性能上の問題が生じることがあります。[Performance Tips](@ref man-performance-abstract-container)を参照してください。）

## Primitive Types

!!! warning
    独自のプリミティブ型を定義するよりも、既存のプリミティブ型を新しい複合型で包むほうが、ほとんどの場合に適切です。

    この機能は、LLVMがサポートする標準のプリミティブ型をJulia自身で構築できるようにするために存在します。それらが定義された後に、さらにプリミティブ型を定義する理由はほとんどありません。


プリミティブ型とは、そのデータが単なるビット列からなる具象型です。代表的な例は整数と浮動小数点値です。多くの言語とは異なり、Juliaは固定された組み込み型だけを提供するのではなく、独自のプリミティブ型を宣言できます。実際、標準のプリミティブ型はすべて、言語そのものを使って定義されています。

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

ビット数はその型に必要な記憶領域の量を示し、名前は新しい型の名前を指定します。プリミティブ型は、任意で何らかのスーパータイプのサブタイプとして宣言できます。スーパータイプを省略すると、デフォルトで`Any`が直接のスーパータイプになります。したがって、上記の[`Bool`](@ref)の宣言は、真偽値の格納に8ビットを使い、直接のスーパータイプが[`Integer`](@ref)であることを意味します。現在サポートされているサイズは8ビットの倍数だけであり、上記で使われているもの以外のサイズでは、バグに遭遇する可能性が高くなります。そのため、真偽値は実際には1ビットしか必要としませんが、8ビット未満のサイズでは宣言できません。

[`Bool`](@ref)、[`Int8`](@ref)、[`UInt8`](@ref)の表現はすべて同一で、8ビットのメモリー領域です。しかし、Juliaの型システムは名前的なので、構造が同じでも互換ではありません。これらの根本的な違いの1つは、スーパータイプが異なることです。[`Bool`](@ref)の直接のスーパータイプは[`Integer`](@ref)、[`Int8`](@ref)では[`Signed`](@ref)、[`UInt8`](@ref)では[`Unsigned`](@ref)です。[`Bool`](@ref)、[`Int8`](@ref)、[`UInt8`](@ref)のその他の違いはすべて、振る舞いの違いです。つまり、これらの型のオブジェクトを引数として受け取ったときに、関数がどのように動作するよう定義されているかという違いです。これが、名前的な型システムが必要な理由です。構造によって型が決まり、さらに型によって振る舞いが決まるのであれば、[`Bool`](@ref)を[`Int8`](@ref)や[`UInt8`](@ref)と異なるように動作させることはできません。

## Composite Types

[Composite types](https://en.wikipedia.org/wiki/Composite_data_type)は、言語によってレコード、構造体、オブジェクトなどと呼ばれます。複合型は名前付きフィールドの集まりであり、そのインスタンスを1つの値として扱えます。多くの言語では、ユーザーが定義できる型は複合型だけです。Juliaでも、複合型は最もよく使われるユーザー定義型です。

C++、Java、Python、Rubyなどの主流のオブジェクト指向言語では、複合型には名前付きの関数も関連付けられており、その組み合わせを「オブジェクト」と呼びます。RubyやSmalltalkのような、より純粋なオブジェクト指向言語では、複合型であるかどうかにかかわらず、すべての値がオブジェクトです。C++やJavaなど、純粋さの低いオブジェクト指向言語では、整数や浮動小数点値など、一部の値はオブジェクトではありません。一方、ユーザー定義の複合型のインスタンスは、メソッドが関連付けられた真のオブジェクトです。Juliaではすべての値がオブジェクトですが、関数は操作対象のオブジェクトにまとめられていません。これは、Juliaが多重ディスパッチによって関数のどのメソッドを使うかを選ぶために必要です。つまり、メソッドの選択では、最初の引数だけでなく、関数の*すべての*引数の型を考慮します（メソッドとディスパッチの詳細は[Methods](@ref)を参照してください）。したがって、関数が最初の引数だけに「属する」のは適切ではありません。各オブジェクトの「内部」に名前付きのメソッドの集まりを置くのではなく、メソッドを関数オブジェクトにまとめる設計は、この言語に大きな利点をもたらしています。

複合型は、[`struct`](@ref)キーワードに続けてフィールド名のブロックを記述することで導入します。フィールドには、任意で`::`演算子を使って型注釈を付けられます。

```jldoctest footype
julia> struct Foo
           bar
           baz::Int
           qux::Float64
       end
```

型注釈のないフィールドはデフォルトで`Any`となり、任意の型の値を保持できます。

`Foo`型の新しいオブジェクトは、`Foo`型オブジェクトを関数のように使い、各フィールドの値に適用することで作成します。

```jldoctest footype
julia> foo = Foo("Hello, world.", 23, 1.5)
Foo("Hello, world.", 23, 1.5)

julia> typeof(foo)
Foo
```

型を関数のように適用するとき、それを*コンストラクター*と呼びます。コンストラクターは自動的に2つ生成されます（これらを*デフォルトコンストラクター*と呼びます）。一方は任意の引数を受け取り、[`convert`](@ref)を呼び出してフィールドの型に変換します。もう一方は、フィールドの型と正確に一致する引数を受け取ります。両方が生成されるのは、デフォルトコンストラクターを意図せず置き換えることなく、新しい定義を追加しやすくするためです。

`bar`フィールドには型の制約がないため、どのような値でも使えます。ただし、`baz`の値は`Int`に変換できなければなりません。

```jldoctest footype
julia> Foo((), 23.5, 1)
ERROR: InexactError: Int64(23.5)
Stacktrace:
[...]
```

フィールド名の一覧は[`fieldnames`](@ref)関数で取得できます。

```jldoctest footype
julia> fieldnames(Foo)
(:bar, :baz, :qux)
```

複合オブジェクトのフィールド値には、従来どおり`foo.bar`記法でアクセスできます。

```jldoctest footype
julia> foo.bar
"Hello, world."

julia> foo.baz
23

julia> foo.qux
1.5
```

`struct`で宣言した複合オブジェクトは*不変*であり、構築後に変更できません。最初は奇妙に思えるかもしれませんが、これにはいくつかの利点があります。

  * 効率がよくなる場合があります。一部の構造体は配列内に効率よく詰めて格納でき、場合によってはコンパイラーが不変オブジェクトの割り当て自体を完全に省略できます。
  * 型のコンストラクターが保証する不変条件を破ることができません。
  * 不変オブジェクトを使うコードは、動作を推論しやすくなる場合があります。

不変オブジェクトのフィールドに、配列などの可変オブジェクトが含まれることはあります。含まれるオブジェクトは可変のままです。変更できないのは、不変オブジェクト自体のフィールドを、別のオブジェクトを指すようにすることだけです。

必要であれば、次の節で説明する[`mutable struct`](@ref)キーワードを使って、可変の複合オブジェクトを宣言できます。

不変構造体のすべてのフィールドが区別不能（`===`）なら、それらのフィールドを含む2つの不変値も区別不能です。

```jldoctest
julia> struct X
           a::Int
           b::Float64
       end

julia> X(1, 2) === X(1, 2)
true
```

複合型のインスタンスの作成方法には、まだ多くの説明が必要です。ただし、その説明には[Parametric Types](@ref)と[Methods](@ref)の両方が関わり、また十分に重要な話題であるため、独立した節である[Constructors](@ref man-constructors)で扱います。

多くのユーザー定義型`X`では、[broadcasting](@ref Broadcasting)において、その型のインスタンスを0次元の「スカラー」として動作させるために、メソッド[`Base.broadcastable(x::X) = Ref(x)`](@ref man-interfaces-broadcasting)を定義するとよいでしょう。

## Mutable Composite Types

複合型を`struct`ではなく`mutable struct`で宣言すると、そのインスタンスを変更できます。

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

[Instance Properties](@ref man-instance-properties)を通じて、フィールドとユーザーの間に追加のインターフェースを設けることもできます。これにより、`bar.baz`記法で何にアクセスし、何を変更できるかを、より細かく制御できます。

変更をサポートするため、このようなオブジェクトは通常ヒープ上に割り当てられ、安定したメモリーアドレスを持ちます。可変オブジェクトは、時間とともに異なる値を保持し得る小さな容器のようなものなので、確実に識別するにはアドレスを使うしかありません。これに対して、不変型のインスタンスは特定のフィールド値と結び付いており、フィールド値だけでオブジェクトについてのすべてがわかります。型を可変にするかどうかを決める際は、同じフィールド値を持つ2つのインスタンスを同一とみなすか、それとも時間とともに独立して変更する必要があり得るかを考えてください。同一とみなすのであれば、その型はおそらく不変にすべきです。

まとめると、Juliaの不変性は次の2つの本質的な性質によって定義されます。

  * 不変型の値を変更することは許されません。

      * ビット型では、一度設定された値のビットパターンは変化せず、その値自体がビット型の値の同一性を定めます。
      * 複合型では、各フィールドの値の同一性が変わらないことを意味します。フィールドがビット型なら、そのビット列は変わりません。フィールドの値が配列などの可変型なら、その可変値の内容自体は変更できても、フィールドは常に同じ可変値を参照し続けます。
  * 不変型のオブジェクトは、コンパイラーが自由にコピーできます。不変であるため、元のオブジェクトとコピーをプログラムから区別できないからです。

      * 特に、整数や浮動小数点数など、十分に小さい不変値は、通常レジスターで関数に渡されます（またはスタックに割り当てられます）。
      * 一方、可変値はヒープに割り当てられ、そのヒープ上の値へのポインターとして関数に渡されます。ただし、実際にそのように処理しなくても、その違いを検出する方法がないとコンパイラーが確信できる場合は例外です。

可変構造体の1つ以上のフィールドが不変であるとわかっている場合は、次に示すように`const`を使って、そのフィールドを不変として宣言できます。これにより、不変構造体に適用される最適化の一部を利用できますが、すべてではありません。また、`const`を付けた特定のフィールドに不変条件を強制するためにも使えます。

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

前の各節で説明した3種類の型（抽象型、プリミティブ型、複合型）は、実際には互いに密接な関係があります。いずれも、次の主要な性質を共有しています。

  * 明示的に宣言されます。
  * 名前を持ちます。
  * 明示的に宣言されたスーパータイプを持ちます。
  * パラメーターを持つことができます。

これらの共通の性質により、これらの型は内部では同じ概念である`DataType`のインスタンスとして表現されます。これは、これらのいずれの型に対しても、その型となるものです。

```jldoctest
julia> typeof(Real)
DataType

julia> typeof(Int)
DataType
```

`DataType`は抽象型にも具象型にもなれます。具象型の場合、サイズ、格納レイアウト、および任意でフィールド名が指定されています。したがって、プリミティブ型は、サイズがゼロではなく、フィールド名を持たない`DataType`です。複合型は、フィールド名を持つか、空（サイズがゼロ）である`DataType`です。

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

多くの言語のコンパイラーは、型について推論するために内部的な共用体の構成要素を持っています。Juliaは、それをプログラマーに公開しているにすぎません。Juliaのコンパイラーは、少数の型からなる`Union`型[^1]が使われていても、候補となる型ごとに別の分岐で特化したコードを生成することで、効率的なコードを生成できます。

`Union`型の特に有用な例が`Union{T, Nothing}`です。ここで、`T`には任意の型を指定でき、[`Nothing`](@ref)は、オブジェクト[`nothing`](@ref)だけをインスタンスに持つシングルトン型です。このパターンは、ほかの言語の[`Nullable`, `Option` or `Maybe`](https://en.wikipedia.org/wiki/Nullable_type)型に相当します。関数の引数やフィールドを`Union{T, Nothing}`として宣言すると、`T`型の値、または値が存在しないことを示す`nothing`のいずれかを設定できます。詳細は[this FAQ entry](@ref faq-nothing)を参照してください。

## Parametric Types

Juliaの型システムの重要で強力な特徴の1つは、パラメトリックであることです。型はパラメーターを取ることができるため、型宣言は実際には、パラメーター値の可能な組み合わせごとに1つずつ、新しい型の族全体を導入します。多くの言語は、何らかの形で[generic programming](https://en.wikipedia.org/wiki/Generic_programming)をサポートしています。そこでは、関係する型を正確に指定しなくても、データ構造とそれを操作するアルゴリズムを指定できます。たとえば、ML、Haskell、Ada、Eiffel、C++、Java、C#、F#、Scalaなどには、何らかの形のジェネリックプログラミングが存在します。これらのうち、一部の言語は真のパラメトリック多相性をサポートし（ML、Haskell、Scalaなど）、別の言語はアドホックでテンプレートベースのジェネリックプログラミングをサポートしています（C++、Javaなど）。言語ごとにジェネリックプログラミングやパラメトリック型には非常に多くの種類があるため、ここではJuliaのパラメトリック型と他言語との比較は行わず、Juliaの仕組みそのものの説明に集中します。ただし、Juliaは動的型付け言語であり、型に関するすべての判断をコンパイル時に行う必要がないため、静的なパラメトリック型システムで従来遭遇してきた多くの困難を、比較的容易に扱えることは指摘しておきます。

宣言されるすべての型（`DataType`の種類）はパラメーター化でき、その構文はどの場合も同じです。ここでは、パラメトリック複合型、パラメトリック抽象型、パラメトリックプリミティブ型の順に説明します。

### [Parametric Composite Types](@id man-parametric-composite-types)

型パラメーターは、型名の直後に波括弧で囲んで導入します。

```jldoctest pointtype
julia> struct Point{T}
           x::T
           y::T
       end
```

この宣言は、`T`型の2つの「座標」を保持する、新しいパラメトリック型`Point{T}`を定義します。では、`T`とは何でしょうか。それこそがパラメトリック型の要点で、どのような型でも指定できます（実際には任意のビット型の値も指定できますが、ここでは明らかに型として使われています）。`Point{Float64}`は、`Point`の定義内の`T`を[`Float64`](@ref)に置き換えて定義した型と等価な具象型です。したがって、この1つの宣言は、実際には`Point{Float64}`、`Point{AbstractString}`、`Point{Int64}`など、無数の型を宣言しています。それぞれが、利用可能な具象型となります。

```jldoctest pointtype
julia> Point{Float64}
Point{Float64}

julia> Point{AbstractString}
Point{AbstractString}
```

`Point{Float64}`型は、座標が64ビット浮動小数点値である点を表します。一方、`Point{AbstractString}`型は、「座標」が文字列オブジェクトである「点」を表します（[Strings](@ref)を参照）。

`Point`自体も有効な型オブジェクトであり、`Point{Float64}`、`Point{AbstractString}`など、すべての具体化された型をサブタイプとして含みます。

```jldoctest pointtype
julia> Point{Float64} <: Point
true

julia> Point{AbstractString} <: Point
true
```

もちろん、ほかの型はそのサブタイプではありません。

```jldoctest pointtype
julia> Float64 <: Point
false

julia> AbstractString <: Point
false
```

`T`の値が異なる具象`Point`型同士が、互いにサブタイプになることはありません。

```jldoctest pointtype
julia> Point{Float64} <: Point{Int64}
false

julia> Point{Float64} <: Point{Real}
false
```

!!! warning
    この最後の点は*非常に*重要です。`Float64 <: Real`であっても、`Point{Float64} <: Point{Real}`は**成立しません**。


言い換えると、型理論の用語では、Juliaの型パラメーターは[covariant (or even contravariant)](https://en.wikipedia.org/wiki/Covariance_and_contravariance_%28computer_science%29)ではなく、*不変*です。これには実用上の理由があります。`Point{Float64}`の任意のインスタンスは、概念的には`Point{Real}`のインスタンスのようにも見なせますが、両者のメモリー上の表現は異なります。

  * `Point{Float64}`のインスタンスは、64ビット値を直接2つ並べることで、コンパクトかつ効率的に表現できます。
  * `Point{Real}`のインスタンスは、[`Real`](@ref)の任意のインスタンスのペアを保持できなければなりません。`Real`のインスタンスであるオブジェクトは、任意のサイズと構造を持ち得るため、実際には`Point{Real}`のインスタンスは、個別に割り当てられた`Real`オブジェクトへのポインターのペアとして表現しなければなりません。

`Point{Float64}`オブジェクトに値を直接格納できることによる効率の向上は、配列の場合には非常に大きくなります。`Array{Float64}`は、64ビット浮動小数点値の連続したメモリーブロックとして格納できます。一方、`Array{Real}`は、個別に割り当てられた[`Real`](@ref)オブジェクトへのポインターの配列でなければなりません。これらのオブジェクトは、[boxed](https://en.wikipedia.org/wiki/Object_type_%28object-oriented_programming%29#Boxing)の64ビット浮動小数点値であることも多いでしょうが、`Real`抽象型の実装として宣言された、任意の大きさの複雑なオブジェクトである可能性もあります。

`Point{Float64}`は`Point{Real}`のサブタイプではないため、次のメソッドは`Point{Float64}`型の引数には適用できません。

```julia
function norm(p::Point{Real})
    sqrt(p.x^2 + p.y^2)
end
```

`T`が[`Real`](@ref)のサブタイプであるような、すべての`Point{T}`型の引数を受け取るメソッドは、次のように定義するのが正しい方法です。

```julia
function norm(p::Point{<:Real})
    sqrt(p.x^2 + p.y^2)
end
```

（同じ意味で、`function norm(p::Point{T} where T<:Real)`または`function norm(p::Point{T}) where T<:Real`と定義することもできます。[UnionAll Types](@ref)を参照してください。）

後の[Methods](@ref)で、さらに多くの例を説明します。

`Point`オブジェクトはどのように構築するのでしょうか。複合型には独自のコンストラクターを定義でき、その詳細は[Constructors](@ref man-constructors)で説明します。ただし、特別なコンストラクター宣言がない場合でも、新しい複合オブジェクトを作成するデフォルトの方法が2つあります。1つは型パラメーターを明示的に指定する方法、もう1つはオブジェクトのコンストラクターへの引数から型パラメーターが暗黙的に決まる方法です。

`Point{Float64}`型は、`Point`の宣言内の`T`を[`Float64`](@ref)に置き換えたものと等価な具象型なので、それに応じてコンストラクターとして適用できます。

```jldoctest pointtype
julia> p = Point{Float64}(1.0, 2.0)
Point{Float64}(1.0, 2.0)

julia> typeof(p)
Point{Float64}
```

デフォルトコンストラクターには、各フィールドに対してちょうど1つずつ引数を渡さなければなりません。

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

パラメトリック型では、デフォルトコンストラクターを上書きできないため、生成されるデフォルトコンストラクターは1つだけです。このコンストラクターは任意の引数を受け取り、フィールドの型に変換します。

多くの場合、作成したい`Point`オブジェクトの型を指定するのは冗長です。コンストラクター呼び出しの引数の型が、すでに型情報を暗黙的に与えているからです。そのため、型パラメーター`T`の値が一意に決まるのであれば、`Point`自体をコンストラクターとして使うこともできます。

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

`Point`の場合、`T`の型が一意に決まるのは、`Point`への2つの引数が同じ型である場合、かつその場合に限られます。そうでなければ、コンストラクターは[`MethodError`](@ref)で失敗します。

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

このように型が混在する場合を適切に処理するコンストラクターメソッドを定義することもできますが、それについては後の[Constructors](@ref man-constructors)で説明します。

### Parametric Abstract Types

パラメトリック抽象型の宣言も、ほぼ同じ方法で抽象型の集合を宣言します。

```jldoctest pointytype
julia> abstract type Pointy{T} end
```

この宣言により、`T`に指定する型または整数値ごとに、`Pointy{T}`はそれぞれ別の抽象型になります。パラメトリック複合型と同様に、これらの具体化された型はそれぞれ`Pointy`のサブタイプです。

```jldoctest pointytype
julia> Pointy{Int64} <: Pointy
true

julia> Pointy{1} <: Pointy
true
```

パラメトリック抽象型も、パラメトリック複合型と同様に不変です。

```jldoctest pointytype
julia> Pointy{Float64} <: Pointy{Real}
false

julia> Pointy{Real} <: Pointy{Float64}
false
```

`Pointy{<:Real}`という記法を使うと、Juliaで*共変*型に相当するものを表せます。同様に、`Pointy{>:Int}`は*反変*型に相当するものを表せます。ただし、厳密にはこれらは型の*集合*を表しています（[UnionAll Types](@ref)を参照）。

```jldoctest pointytype
julia> Pointy{Float64} <: Pointy{<:Real}
true

julia> Pointy{Real} <: Pointy{>:Int}
true
```

通常の抽象型が具象型の上に有用な型階層を作るのと同様に、パラメトリック抽象型は、パラメトリック複合型に対して同じ役割を果たします。たとえば、`Point{T}`を`Pointy{T}`のサブタイプとして、次のように宣言することもできました。

```jldoctest pointytype
julia> struct Point{T} <: Pointy{T}
           x::T
           y::T
       end
```

このように宣言すると、`T`の選択ごとに、`Point{T}`は`Pointy{T}`のサブタイプになります。

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

`Pointy`のようなパラメトリック抽象型には、どのような用途があるのでしょうか。点が対角線*x = y*上にあるため、座標が1つだけで済む、点のような実装を作る場合を考えてみましょう。

```jldoctest pointytype
julia> struct DiagPoint{T} <: Pointy{T}
           x::T
       end
```

これで、`Point{Float64}`と`DiagPoint{Float64}`はどちらも`Pointy{Float64}`という抽象化の実装になります。型`T`にほかの値を選んだ場合も同様です。これにより、`Point`と`DiagPoint`の両方に実装され、すべての`Pointy`オブジェクトが共有する共通インターフェースに対してプログラミングできます。ただし、これを十分に示すには、次の節[Methods](@ref)でメソッドとディスパッチを紹介する必要があります。

型パラメーターがあらゆる型を自由に取れることが、適切でない場合もあります。そのような場合は、次のように`T`の範囲を制約できます。

```jldoctest realpointytype
julia> abstract type Pointy{T<:Real} end
```

このように宣言すると、`T`には[`Real`](@ref)のサブタイプである任意の型を使えますが、`Real`のサブタイプではない型は使えません。

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

パラメトリック複合型の型パラメーターも、同じ方法で制限できます。

```julia
struct Point{T<:Real} <: Pointy{T}
    x::T
    y::T
end
```

こうしたパラメトリック型の仕組みがどのように役立つかを示す実例として、整数の正確な比を表すJuliaの不変型[`Rational`](@ref)の実際の定義を示します（ただし、簡潔にするため、ここではコンストラクターを省略しています）。

```julia
struct Rational{T<:Integer} <: Real
    num::T
    den::T
end
```

比を取る対象として意味があるのは整数値だけなので、型パラメーター`T`は[`Integer`](@ref)のサブタイプに制限されています。また、整数の比は実数直線上の値を表すため、どの[`Rational`](@ref)も、抽象化[`Real`](@ref)のインスタンスです。

### Tuple Types

タプルは、関数そのものを除いて、関数の引数を抽象化したものです。関数の引数で重要なのは、その順序と型です。したがって、タプル型は、各パラメーターが1つのフィールドの型を表す、パラメーター化された不変型に似ています。たとえば、2要素のタプル型は、次の不変型に似ています。

```julia
struct Tuple2{A,B}
    a::A
    b::B
end
```

ただし、重要な違いが3つあります。

  * タプル型は任意の数のパラメーターを持てます。
  * タプル型はパラメーターに関して*共変*です。`Tuple{Int}`は`Tuple{Any}`のサブタイプです。そのため、`Tuple{Any}`は抽象型とみなされ、タプル型が具象型になるのは、そのパラメーターがすべて具象型である場合だけです。
  * タプルにはフィールド名がなく、フィールドへのアクセスにはインデックスだけを使います。

タプルの値は丸括弧とカンマを使って記述します。タプルを構築すると、必要に応じて適切なタプル型が生成されます。

```jldoctest
julia> typeof((1,"foo",2.5))
Tuple{Int64, String, Float64}
```

共変性によって次のようになることに注意してください。

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

タプル型の最後のパラメーターには、末尾に任意の数の要素が続くことを表す特殊な値[`Vararg`](@ref)を指定できます。

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

また、`Vararg{T}`は、`T`型の0個以上の要素に対応します。可変長タプル型は、可変長引数メソッドが受け取る引数を表すために使われます（[Varargs Functions](@ref)を参照）。

特殊な値`Vararg{T,N}`をタプル型の最後のパラメーターとして使うと、`T`型のちょうど`N`個の要素に対応します。`NTuple{N,T}`は`Tuple{Vararg{T,N}}`の便利な別名です。つまり、`T`型の要素をちょうど`N`個含むタプル型です。

### Named Tuple Types

名前付きタプルは[`NamedTuple`](@ref)型のインスタンスです。この型は、フィールド名を表すシンボルのタプルと、フィールドの型を表すタプル型という2つのパラメーターを持ちます。便宜上、`NamedTuple`型は[`@NamedTuple`](@ref)マクロを使って表示されます。このマクロは、`key::Type`宣言によってこれらの型を宣言するための、`struct`に似た便利な構文を提供します。`::Type`を省略した場合は、`::Any`に対応します。

```jldoctest
julia> typeof((a=1,b="hello")) # prints in macro form
@NamedTuple{a::Int64, b::String}

julia> NamedTuple{(:a, :b), Tuple{Int64, String}} # long form of the type
@NamedTuple{a::Int64, b::String}
```

`@NamedTuple`マクロの`begin ... end`形式では、構造体の宣言と同様に、宣言を複数行に分けられます。それ以外の点では等価です。

```jldoctest
julia> @NamedTuple begin
           a::Int
           b::String
       end
@NamedTuple{a::Int64, b::String}
```

`NamedTuple`型は、タプルを1つ引数として受け取るコンストラクターとして使えます。構築に使う`NamedTuple`型には、両方のパラメーターを指定した具象型か、フィールド名だけを指定した型のいずれかを使えます。

```jldoctest
julia> @NamedTuple{a::Float32,b::String}((1, ""))
(a = 1.0f0, b = "")

julia> NamedTuple{(:a, :b)}((1, ""))
(a = 1, b = "")
```

フィールドの型を指定した場合、引数は変換されます。指定しない場合は、引数の型がそのまま使われます。

### Parametric Primitive Types

プリミティブ型もパラメトリックに宣言できます。たとえば、ポインターはプリミティブ型として表現され、Juliaでは次のように宣言されます。

```julia
# 32-bit system:
primitive type Ptr{T} 32 end

# 64-bit system:
primitive type Ptr{T} 64 end
```

通常のパラメトリック複合型と比べて、これらの宣言で少し変わっているのは、型パラメーター`T`が型そのものの定義内では使われていないことです。これは単なる抽象的なタグであり、本質的には、構造が同一で、型パラメーターだけによって区別される型の族全体を定義しています。したがって、`Ptr{Float64}`と`Ptr{Int64}`は、表現が同一でも異なる型です。そしてもちろん、すべての具体的なポインター型は、それらを包括する[`Ptr`](@ref)型のサブタイプです。

```jldoctest
julia> Ptr{Float64} <: Ptr
true

julia> Ptr{Int64} <: Ptr
true
```

## UnionAll Types

`Ptr`のようなパラメトリック型は、それを具体化したすべての型（`Ptr{Int64}`など）のスーパータイプとして機能すると説明しました。これはどのような仕組みなのでしょうか。`Ptr`自体は、通常のデータ型ではありません。参照先のデータの型がわからなければ、メモリー操作に使えないことは明らかだからです。その答えは、`Ptr`（または`Array`などのほかのパラメトリック型）が、[`UnionAll`](@ref)型と呼ばれる、別の種類の型だということです。この型は、あるパラメーターのすべての値にわたる型の*反復的な共用体*を表します。

`UnionAll`型は、通常`where`キーワードを使って記述します。たとえば、`Ptr`は、より正確には`Ptr{T} where T`と書けます。これは、何らかの`T`の値に対して、型が`Ptr{T}`となるすべての値を意味します。この文脈では、パラメーター`T`は、型を値域とする変数のようなものなので、「型変数」と呼ばれることもよくあります。各`where`は型変数を1つだけ導入するため、複数のパラメーターを持つ型では、たとえば`Array{T,N} where N where T`のように、これらの式を入れ子にします。

型適用構文`A{B,C}`では、`A`が`UnionAll`型である必要があります。まず、`A`の最も外側の型変数に`B`を代入します。その結果も`UnionAll`型であることが想定され、そこに`C`を代入します。したがって、`A{B,C}`は`A{B}{C}`と等価です。これが、`Array{Float64}`のように型を部分的に具体化できる理由です。最初のパラメーター値は固定されていますが、2番目のパラメーターは依然としてすべての可能な値を取り得ます。明示的な`where`構文を使うと、パラメーターの任意の部分集合を固定できます。たとえば、すべての1次元配列の型は`Array{T,1} where T`と記述できます。

型変数は、サブタイプ関係によって制限できます。`Array{T} where T<:Integer`は、要素型が何らかの[`Integer`](@ref)である、すべての配列を指します。`Array{<:Integer}`という構文は、`Array{T} where T<:Integer`の便利な短縮形です。型変数には下限と上限の両方を指定できます。`Array{T} where Int<:T<:Number`は、`Int`を格納できる、[`Number`](@ref)のすべての配列を指します（`T`は、少なくとも`Int`を含む広さを持たなければならないためです）。`where T>:Int`という構文で型変数の下限だけを指定することもでき、`Array{>:Int}`は`Array{T} where T>:Int`と等価です。

`where`式は入れ子になるため、型変数の境界から外側の型変数を参照できます。たとえば、`Tuple{T,Array{S}} where S<:AbstractArray{T} where T<:Real`は、最初の要素が何らかの[`Real`](@ref)で、2番目の要素が`Array`である2要素タプルを指します。この2番目の要素には、要素型がタプルの最初の要素の型を含む、任意の種類の配列を使用できます。

`where`キーワード自体を、より複雑な宣言の中に入れ子にすることもできます。たとえば、次の宣言によって作成される2つの型を考えてみましょう。

```jldoctest
julia> const T1 = Array{Array{T, 1} where T, 1}
Vector{Vector} (alias for Array{Array{T, 1} where T, 1})

julia> const T2 = Array{Array{T, 1}, 1} where T
Array{Vector{T}, 1} where T
```

`T1`型は、1次元配列を要素とする1次元配列を定義します。各内側の配列は同じ型のオブジェクトで構成されますが、その型は内側の配列ごとに異なっていてもかまいません。一方、`T2`型も1次元配列を要素とする1次元配列を定義しますが、内側の配列はすべて同じ型でなければなりません。`T2`は抽象型であり、たとえば`Array{Array{Int,1},1} <: T2`が成り立つのに対し、`T1`は具象型であることに注意してください。その結果、`T1`は引数なしのコンストラクター`a=T1()`で構築できますが、`T2`はできません。

このような型に名前を付けるために、関数定義の短い形式に似た便利な構文があります。

```julia
Vector{T} = Array{T, 1}
```

これは`const Vector = Array{T,1} where T`と等価です。`Vector{Float64}`と書くことは、`Array{Float64,1}`と書くことに相当します。また、包括的な型`Vector`は、要素型にかかわらず、2番目のパラメーターである配列の次元数が1であるすべての`Array`オブジェクトをインスタンスとして持ちます。パラメトリック型を常に完全に指定しなければならない言語では、これは特に役立ちません。しかしJuliaでは、任意の要素型を持つすべての1次元密配列を含む抽象型を、単に`Vector`と記述できます。

## [Singleton types](@id man-singleton-types)

フィールドを持たない不変複合型を*シングルトン*と呼びます。形式的には、

1. `T`が不変複合型であり（つまり`struct`で定義されている）、
2. `a isa T && b isa T`から`a === b`が導かれる、

という条件を満たす場合、`T`はシングルトン型です。[^2] 型がシングルトン型かどうかは、[`Base.issingletontype`](@ref)で確認できます。[Abstract types](@ref man-abstract-types)は、その構成上、シングルトン型にはなれません。

定義から、このような型のインスタンスは1つしか存在できないことがわかります。

```jldoctest
julia> struct NoFields
       end

julia> NoFields() === NoFields()
true

julia> Base.issingletontype(NoFields)
true
```

[`===`](@ref)関数により、構築された`NoFields`のインスタンスが、実際にはまったく同じものであると確認できます。

パラメトリック型も、上記の条件を満たす場合はシングルトン型になれます。たとえば、次のとおりです。

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

`typeof(foo41)`がそれ自体として表示されることに注目してください。これは表示上の慣例にすぎません。関数は第一級オブジェクトであり、ほかの値と同じように使えます。

```jldoctest foo41
julia> T = typeof(foo41)
typeof(foo41) (singleton type of function foo41, subtype of Function)

julia> T <: Function
true
```

トップレベルで定義された関数の型はシングルトンです。必要に応じて、[`===`](@ref)で比較できます。

[Closures](@ref man-anonymous-functions)も固有の型を持ち、通常は`#<number>`で終わる名前で表示されます。異なる場所で定義された関数は名前も型も異なりますが、セッションが変わっても同じ表記になるとは限りません。

```jldoctest; filter = r"[0-9\.]+"
julia> typeof(x -> x + 1)
var"#9#10"
```

クロージャーの型は、必ずしもシングルトンではありません。

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

各型`T`に対して、`Type{T}`は、オブジェクト`T`だけをインスタンスに持つ抽象パラメトリック型です。この仕組みの有用性は、[Parametric Methods](@ref)と[conversions](@ref conversion-and-promotion)を説明するまでは伝えにくいのですが、簡単に言えば、*値*として与えられた特定の型に応じて、関数の振る舞いを特化できます。これは、引数のいずれかの型から暗黙的に決まる型ではなく、明示的な引数として与えられる型に振る舞いが依存するメソッド、特にパラメトリックメソッドを書く際に役立ちます。

この定義は少し理解しにくいため、いくつか例を見てみましょう。

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

言い換えると、[`isa(A, Type{B})`](@ref)がtrueになるのは、`A`と`B`が同じオブジェクトであり、かつそのオブジェクトが型である場合、かつその場合に限られます。

特に、パラメトリック型は[invariant](@ref man-parametric-composite-types)なので、次のようになります。

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

パラメーターを付けない`Type`は、単にすべての型オブジェクトをインスタンスに持つ抽象型です。

```jldoctest
julia> isa(Type{Float64}, Type)
true

julia> isa(Float64, Type)
true

julia> isa(Real, Type)
true
```

型ではないオブジェクトは、いずれも`Type`のインスタンスではありません。

```jldoctest
julia> isa(1, Type)
false

julia> isa("foo", Type)
false
```

`Type`は、ほかの抽象パラメトリック型と同様にJuliaの型階層の一部ですが、特別な場合を除き、メソッドのシグネチャ以外ではあまり使われません。`Type`のもう1つの重要な用途は、そうしなければ精度の低い型として扱われるフィールドの型を、より正確にすることです。たとえば、以下の例では、デフォルトコンストラクターを使うと[`DataType`](@ref man-declared-types)として扱われます。この場合、包まれた型の正確さに依存するコードでは、性能上の問題が生じる可能性があります（[abstract type parameters](@ref man-performance-abstract-container)と同様です）。

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

すでに表現できる型に、新しい名前を付けると便利な場合があります。これは単純な代入文で実現できます。たとえば、`UInt`は、システム上のポインターのサイズに応じて、[`UInt32`](@ref)または[`UInt64`](@ref)の別名になります。

```julia-repl
# 32-bit system:
julia> UInt
UInt32

# 64-bit system:
julia> UInt
UInt64
```

これは`base/boot.jl`内の次のコードによって実現されています。

```julia
if Int === Int64
    const UInt = UInt64
else
    const UInt = UInt32
end
```

もちろん、これは`Int`が何の別名であるかに依存します。ただし、それは[`Int32`](@ref)または[`Int64`](@ref)のうち、適切な型になるようにあらかじめ定義されています。

（`Int`とは異なり、`Float`は、特定のサイズの[`AbstractFloat`](@ref)の型エイリアスとしては存在しません。`Int`のサイズがそのマシンのネイティブポインターのサイズを反映する整数レジスターの場合とは異なり、浮動小数点レジスターのサイズはIEEE-754規格によって定められています。）

型エイリアスもパラメーター化できます。

```jldoctest
julia> const Family{T} = Set{T}
Set

julia> Family{Char} === Set{Char}
true
```

## Operations on Types

Juliaでは型自体がオブジェクトなので、通常の関数で型を操作できます。型の操作や調査に特に役立つ関数のいくつかは、すでに紹介しています。たとえば`<:`演算子は、左オペランドが右オペランドのサブタイプかどうかを示します。

[`isa`](@ref)関数は、オブジェクトが指定された型かどうかを検査し、trueまたはfalseを返します。

```jldoctest
julia> isa(1, Int)
true

julia> isa(1, AbstractFloat)
false
```

マニュアル全体の例ですでに使っている[`typeof`](@ref)関数は、引数の型を返します。前述したように型もオブジェクトなので、それ自体も型を持ち、その型を調べられます。

```jldoctest
julia> typeof(Rational{Int})
DataType

julia> typeof(Union{Real,String})
Union
```

この操作を繰り返すとどうなるでしょうか。型の型の型は何でしょうか。実は、型はすべて複合値であり、したがってその型はいずれも`DataType`です。

```jldoctest
julia> typeof(DataType)
DataType

julia> typeof(Union)
DataType
```

`DataType`の型は、それ自身です。

一部の型に適用できる別の操作が[`supertype`](@ref)で、その型のスーパータイプを返します。一意に定まるスーパータイプを持つのは、宣言された型（`DataType`）だけです。

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

[`supertype`](@ref)をそれ以外の型オブジェクト（または型ではないオブジェクト）に適用すると、[`MethodError`](@ref)が発生します。

```jldoctest; filter = r"Closest candidates.*"s
julia> supertype(Union{Float64,Int64})
ERROR: MethodError: no method matching supertype(::Type{Union{Float64, Int64}})
The function `supertype` exists, but no method is defined for this combination of argument types.

Closest candidates are:
[...]
```

## [Custom pretty-printing](@id man-custom-pretty-printing)

型のインスタンスの表示方法をカスタマイズしたいことはよくあります。これは[`show`](@ref)関数をオーバーロードすることで実現できます。たとえば、複素数を極形式で表す型を定義するとします。

```jldoctest polartype
julia> struct Polar{T<:Real} <: Number
           r::T
           Θ::T
       end

julia> Polar(r::Real,Θ::Real) = Polar(promote(r,Θ)...)
Polar
```

ここでは、異なる[`Real`](@ref)型の引数を受け取り、共通の型に昇格できるように、独自のコンストラクター関数を追加しています（[Constructors](@ref man-constructors)と[Conversion and Promotion](@ref conversion-and-promotion)を参照）。（もちろん、[`Number`](@ref)のように動作させるには、`+`、`*`、`one`、`zero`、昇格規則など、多くのメソッドも定義する必要があります。）デフォルトでは、この型のインスタンスは、型名とフィールド値の情報を含む、比較的単純な形式で表示されます。たとえば`Polar{Float64}(3.0,4.0)`のようになります。

代わりに`3.0 * exp(4.0im)`と表示したい場合は、指定された出力オブジェクト`io`にオブジェクトを出力する、次のメソッドを定義します。この出力オブジェクトは、ファイル、端末、バッファーなどを表します（[Networking and Streams](@ref)を参照）。

```jldoctest polartype
julia> Base.show(io::IO, z::Polar) = print(io, z.r, " * exp(", z.Θ, "im)")
```

`Polar`オブジェクトの表示は、さらに細かく制御できます。特に、REPLなどの対話環境で単一のオブジェクトを表示するための詳細な複数行形式と、[`print`](@ref)や、別のオブジェクトの一部として表示する場合（配列内など）に使う、より簡潔な1行形式の両方が必要なことがあります。デフォルトではどちらの場合も`show(io, z)`関数が呼び出されますが、第2引数に`text/plain` MIME型を取る、3引数形式の`show`をオーバーロードすると、オブジェクトの表示に*別の*複数行形式を定義できます（[Multimedia I/O](@ref Multimedia-I/O)を参照）。たとえば、次のようになります。

```jldoctest polartype
julia> Base.show(io::IO, ::MIME"text/plain", z::Polar{T}) where{T} =
           print(io, "Polar{$T} complex number:\n   ", z)
```

（ここでの`print(..., z)`は、2引数の`show(io, z)`メソッドを呼び出すことに注意してください。）結果は次のとおりです。

```jldoctest polartype
julia> Polar(3, 4.0)
Polar{Float64} complex number:
   3.0 * exp(4.0im)

julia> [Polar(3, 4.0), Polar(4.0,5.3)]
2-element Vector{Polar{Float64}}:
 3.0 * exp(4.0im)
 4.0 * exp(5.3im)
```

ここでは、`Polar`値の配列に対しては、引き続き1行形式の`show(io, z)`が使われます。厳密には、REPLは1行を実行した結果`z`を表示するために、`display(z)`を呼び出します。そのデフォルトの動作は`show(io, MIME("text/plain"), z)`です（`io`は[`stdout`](@ref)を包む[`IOContext`](@ref)ラッパーです）。さらに、そのデフォルトの動作は`show(io, z)`です。ただし、新しいマルチメディア表示ハンドラーを定義するのでない限り、新しい[`display`](@ref)メソッドを定義しては*いけません*（[Multimedia I/O](@ref Multimedia-I/O)を参照）。

さらに、ほかのMIME型に対して`show`メソッドを定義すると、それに対応した環境（IJuliaなど）で、オブジェクトをより豊かな形式（HTML、画像など）で表示できます。たとえば、次のようにして、`Polar`オブジェクトを上付き文字や斜体を使ったHTML形式で表示できます。

```jldoctest polartype
julia> Base.show(io::IO, ::MIME"text/html", z::Polar{T}) where {T} =
           println(io, "<code>Polar{$T}</code> complex number: ",
                   z.r, " <i>e</i><sup>", z.Θ, " <i>i</i></sup>")
```

これにより、HTML表示に対応した環境では、`Polar`オブジェクトが自動的にHTMLで表示されます。必要なら、`show`を手動で呼び出してHTML出力を取得することもできます。

```jldoctest polartype
julia> show(stdout, "text/html", Polar(3.0,4.0))
<code>Polar{Float64}</code> complex number: 3.0 <i>e</i><sup>4.0 <i>i</i></sup>
```

```@raw html
<p>An HTML renderer would display this as: <code>Polar{Float64}</code> complex number: 3.0 <i>e</i><sup>4.0 <i>i</i></sup></p>
```

目安として、1行形式の`show`メソッドは、表示対象のオブジェクトを作成するための有効なJulia式を出力するべきです。この`show`メソッドの出力に中置演算子が含まれる場合、別のオブジェクトの一部として出力すると、正しく構文解析されないことがあります。上記の`Polar`に対する1行形式の`show`メソッドに含まれる、乗算演算子（`*`）がその例です。これを確認するため、`Polar`型の特定のインスタンスを2乗する式オブジェクト（[Program representation](@ref)を参照）を考えてみましょう。

```jldoctest polartype
julia> a = Polar(3, 4.0)
Polar{Float64} complex number:
   3.0 * exp(4.0im)

julia> print(:($a^2))
3.0 * exp(4.0im) ^ 2
```

演算子`^`は`*`より優先順位が高いため（[Operator Precedence and Associativity](@ref)を参照）、この出力は式`a ^ 2`を忠実に表していません。本来は`(3.0 * exp(4.0im)) ^ 2`と等価であるべきです。この問題を解決するには、式オブジェクトが出力時に内部で呼び出す`Base.show_unquoted(io::IO, z::Polar, indent::Int, precedence::Int)`に対して、独自のメソッドを作成する必要があります。

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

上記で定義したメソッドは、呼び出し元の演算子の優先順位が乗算以上の場合に、`show`の呼び出しによる出力を丸括弧で囲みます。この検査により、丸括弧がなくても正しく構文解析される式（`:($a + 2)`や`:($a == 2)`など）では、出力時に丸括弧を省略できます。

```jldoctest polartype
julia> :($a + 2)
:(3.0 * exp(4.0im) + 2)

julia> :($a == 2)
:(3.0 * exp(4.0im) == 2)
```

場合によっては、文脈に応じて`show`メソッドの振る舞いを調整すると便利です。これは、ラップしたIOストリームとともに文脈のプロパティを渡せる[`IOContext`](@ref)型を使って実現できます。たとえば、`:compact`プロパティが`true`に設定されている場合、`show`メソッドで短い表現を生成し、プロパティが`false`であるか存在しない場合は、長い表現に戻すことができます。

```jldoctest polartype
julia> function Base.show(io::IO, z::Polar)
           if get(io, :compact, false)::Bool
               print(io, z.r, "ℯ", z.Θ, "im")
           else
               print(io, z.r, " * exp(", z.Θ, "im)")
           end
       end
```

この新しい簡潔な表現は、渡されたIOストリームが、`:compact`プロパティを設定した`IOContext`オブジェクトである場合に使われます。特に、複数列の配列を出力する場合は、横方向のスペースが限られるため、これに該当します。

```jldoctest polartype
julia> show(IOContext(stdout, :compact=>true), Polar(3, 4.0))
3.0ℯ4.0im

julia> [Polar(3, 4.0) Polar(4.0,5.3)]
1×2 Matrix{Polar{Float64}}:
 3.0ℯ4.0im  4.0ℯ5.3im
```

出力の調整に使える一般的なプロパティの一覧については、[`IOContext`](@ref)のドキュメントを参照してください。

### Output-function summary

Juliaの各種出力関数と、その関係を簡単にまとめます。ほとんどの新しい型では、何か定義するとしても、`show`メソッドだけで十分なはずです。

  * [`display(x)`](@ref)は、現在の環境に対して、その環境が最適と考える方法で`x`を表示するよう指示します。（JupyterやPlutoのノートブックなどでは、グラフィカルな表示になることもあります。）デフォルトでは（スクリプトやテキストREPLなど）、適切な`io`ストリームに対して`show(io, "text/plain", x)`、またはそれと等価な`show(io, MIME"text/plain"(), x)`を呼び出します。（REPLでは、`io`は[`stdout`](@ref)を包む[`IOContext`](@ref)ラッパーです。）REPLは、評価した式の結果を出力するために`display`を使います。
  * 3引数の[`show(io, ::MIME"text/plain", x)`](@ref)メソッドは、`x`を詳細かつ読みやすく整形して出力します。デフォルトでは（`typeof(x)`に対する3引数メソッドが定義されていなければ）、2引数の`show(io, x)`を呼び出します。これは2引数の`repr("text/plain", x)`から呼び出されます。前述したように、追加のMIME型に対して別の3引数`show`メソッドを定義すると、一部の対話環境で`x`をより豊かな形式で表示できます。
  * 2引数の[`show(io, x)`](@ref)は、`x`のデフォルトの単純なテキスト表現です。1引数の[`repr(x)`](@ref)から呼び出され、通常は`x`をJuliaに入力する際に使える形式になります。1引数の`show(x)`は、`show(stdout, x)`を呼び出します。
  * [`print(io, x)`](@ref)は、デフォルトでは`show(io, x)`を呼び出しますが、一部の型は独自の`print`形式を持ちます。特に、`x`が文字列の場合、`print`は生のテキストを出力するのに対し、`show`は引用符で囲まれたエスケープ済みの文字列を出力します。1引数の`print(x)`は、`print(stdout, x)`を呼び出します。`print`は[`string(x)`](@ref)からも呼び出されます。また、改行を追加する[`println`](@ref)や、色などを付ける[`printstyled`](@ref)も参照してください。どちらも`print`を呼び出します。
  * [`write(io, x)`](@ref)は、定義されている場合（新しい型に対しては、通常デフォルトの定義は*ありません*）、`x`の「生の」バイナリー表現を`io`に書き込みます。たとえば、`x::Int32`は4バイトとして書き込まれます。

[`IOContext`](@ref)ラッパーによって`io`ストリームに付加できるメタデータについても、理解しておくと役立ちます。たとえばREPLは、評価した式に対する`display`から`:limit => true`フラグを設定し、出力が端末に収まるように制限します。このフラグは`get(io, :limit, false)`で調べられます。また、たとえば複数列の行列に含まれるオブジェクトを表示する際には、`:compact => true`フラグが設定されることがあり、`get(io, :compact, false)`で調べられます。

## "Value types"

Juliaでは、`true`や`false`のような*値*に基づいてディスパッチすることはできません。ただし、パラメトリック型に基づくディスパッチは可能です。またJuliaでは、型パラメーターに「単純なビット列」の値（型、シンボル、整数、浮動小数点数、タプルなど）を含められます。よくある例は、`Array{T,N}`の次元数パラメーターです。ここで、`T`は型（[`Float64`](@ref)など）ですが、`N`は単なる`Int`です。

値をパラメーターとして取る独自の型を作成し、それを使って独自の型のディスパッチを制御できます。この考え方を示すため、パラメトリック型`Val{x}`と、そのコンストラクター`Val(x) = Val{x}()`を紹介します。これは、より複雑な階層を必要としない場合に、この手法を活用するための慣用的な方法です。

[`Val`](@ref)は、次のように定義されています。

```jldoctest valtype
julia> struct Val{x}
       end

julia> Val(x) = Val{x}()
Val
```

`Val`の実装は、これだけです。Juliaの標準ライブラリーの一部の関数は、`Val`のインスタンスを引数として受け取ります。また、これを使って独自の関数を書くこともできます。たとえば、次のようになります。

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

Julia全体で一貫性を保つため、呼び出し側では常に*型*ではなく、`Val`の*インスタンス*を渡すべきです。つまり、`foo(Val{:bar})`ではなく、`foo(Val(:bar))`を使ってください。

`Val`を含め、パラメトリックな「値」型は非常に誤用しやすいことに注意が必要です。条件が悪いと、コードの性能を大幅に*悪化*させてしまうことがあります。特に、上記の例のようなコードを実際のコードで書くべきではありません。`Val`の適切な使い方と不適切な使い方については、[the more extensive discussion in the performance tips](@ref man-performance-value-type)を参照してください。

[^1]: 「少数」の定義は`max_union_splitting`の設定によって決まり、現在のデフォルトは4です。

[^2]: Haskell、Scala、Rubyなど、いくつかの広く使われている言語にはシングルトン型があります。
