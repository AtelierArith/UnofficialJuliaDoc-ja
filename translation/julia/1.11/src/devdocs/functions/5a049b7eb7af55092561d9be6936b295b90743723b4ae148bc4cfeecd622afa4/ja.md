# Julia Functions

この文書では、関数、メソッド定義、およびメソッドテーブルの仕組みについて説明します。

## Method Tables

Juliaのすべての関数はジェネリック関数です。ジェネリック関数は概念的には単一の関数ですが、多くの定義、またはメソッドで構成されています。ジェネリック関数のメソッドはメソッドテーブルに格納されます。メソッドテーブル（型 `MethodTable`）は `TypeName` に関連付けられています。`TypeName` はパラメータ化された型のファミリーを説明します。例えば、`Complex{Float32}` と `Complex{Float64}` は同じ `Complex` 型名オブジェクトを共有しています。

すべてのオブジェクトは呼び出し可能であり、なぜならすべてのオブジェクトには型があり、その型には `TypeName` があるからです。

## [Function calls](@id Function-calls)

与えられた呼び出し `f(x, y)` に対して、次のステップが実行されます。まず、使用するメソッドテーブルにアクセスします：`typeof(f).name.mt`。次に、引数タプル型が形成されます：`Tuple{typeof(f), typeof(x), typeof(y)}`。関数自体の型が最初の要素であることに注意してください。これは、型がパラメータを持つ可能性があるため、ディスパッチに参加する必要があるからです。このタプル型はメソッドテーブルで検索されます。

このディスパッチプロセスは `jl_apply_generic` によって実行され、2つの引数を取ります：値 `f`、`x`、および `y` の配列へのポインタと、値の数（この場合は3）です。

システム全体には、関数と引数リストを処理する2種類のAPIがあります。1つは関数と引数を別々に受け取るAPI、もう1つは単一の引数構造を受け取るAPIです。最初の種類のAPIでは、「引数」部分には関数に関する情報は含まれておらず、それは別途渡されます。2番目の種類のAPIでは、関数が引数構造の最初の要素です。

例えば、次の呼び出しを行う関数は `args` ポインタのみを受け取りますので、args 配列の最初の要素が呼び出す関数になります：

```c
jl_value_t *jl_apply(jl_value_t **args, uint32_t nargs)
```

このエントリーポイントは同じ機能のために、関数を別々に受け取るため、`args` 配列には関数が含まれていません：

```c
jl_value_t *jl_call(jl_function_t *f, jl_value_t **args, int32_t nargs);
```

## Adding methods

上記のディスパッチプロセスに基づいて、新しいメソッドを追加するために必要なのは、(1) タプル型と (2) メソッドの本体のコードだけです。`jl_method_def` はこの操作を実装しています。`jl_method_table_for` は、最初の引数の型から関連するメソッドテーブルを抽出するために呼び出されます。これは、引数のタプル型が抽象的である可能性があるため、ディスパッチ中の対応する手続きよりもはるかに複雑です。たとえば、次のように定義できます：

```julia
(::Union{Foo{Int},Foo{Int8}})(x) = 0
```

すべての可能なマッチングメソッドが同じメソッドテーブルに属するため、機能します。

## Creating generic functions

すべてのオブジェクトは呼び出し可能であるため、汎用関数を作成するために特別なことは必要ありません。したがって、`jl_new_generic_function`は単に新しいシングルトン（サイズ0）の`Function`のサブタイプを作成し、そのインスタンスを返します。関数には、デバッグ情報やオブジェクトを印刷する際に使用されるニーモニック「表示名」があります。たとえば、`Base.sin`の名前は`sin`です。慣例として、作成された*型*の名前は関数名と同じで、`#`が前に付けられます。したがって、`typeof(sin)`は`Base.#sin`です。

## Closures

クロージャは、キャプチャされた変数に対応するフィールド名を持つ呼び出し可能なオブジェクトです。例えば、次のコード：

```julia
function adder(x)
    return y->x+y
end
```

は（おおよそ）に下げられます：

```julia
struct ##1{T}
    x::T
end

(_::##1)(y) = _.x + y

function adder(x)
    return ##1(x)
end
```

## Constructors

コンストラクタ呼び出しは、単に型への呼び出しです。`Type`のメソッドテーブルには、すべてのコンストラクタ定義が含まれています。`Type`のすべてのサブタイプ（`Type`、`UnionAll`、`Union`、および`DataType`）は、特別な取り決めにより、現在メソッドテーブルを共有しています。

## Builtins

`Core`モジュールで定義されている「ビルトイン」関数は次のとおりです：

```@eval
function lines(words)
    io = IOBuffer()
    n = 0
    for w in words
        if n+length(w) > 80
            print(io, '\n', w)
            n = length(w)
        elseif n == 0
            print(io, w);
            n += length(w)
        else
            print(io, ' ', w);
            n += length(w)+1
        end
    end
    String(take!(io))
end
import Markdown
[string(n) for n in names(Core;all=true)
    if getfield(Core,n) isa Core.Builtin && nameof(getfield(Core,n)) === n] |>
    lines |>
    s ->  "```\n$s\n```" |>
    Markdown.parse
```

これらはすべて、`Builtin` のサブタイプであるシングルトンオブジェクトであり、`Function` のサブタイプです。これらの目的は、「jlcall」呼び出し規約を使用するランタイムのエントリポイントを公開することです：

```c
jl_value_t *(jl_value_t*, jl_value_t**, uint32_t)
```

ビルトインのメソッドテーブルは空です。代わりに、正しい関数を指すjlcall fptrを持つ単一のキャッチオールメソッドキャッシュエントリ（`Tuple{Vararg{Any}}`）があります。これは一種のハックですが、かなりうまく機能します。

## Keyword arguments

キーワード引数は、kwcall関数にメソッドを追加することで機能します。この関数は通常、「キーワード引数ソーター」または「キーワードソーター」と呼ばれ、次に関数の内部本体（匿名で定義された）を呼び出します。kwsorter関数内のすべての定義は、通常のメソッドテーブルのいくつかの定義と同じ引数を持っていますが、渡されたキーワード引数の名前と値を提供する単一の`NamedTuple`引数が前に追加されています。kwsorterの仕事は、名前に基づいてキーワード引数をその標準的な位置に移動し、必要なデフォルト値の式を評価して置き換えることです。その結果は通常の位置引数リストとなり、さらに別のコンパイラ生成関数に渡されます。

キーワード引数メソッド定義がどのように低下されるかを見ることが、プロセスを理解する最も簡単な方法です。コード：

```julia
function circle(center, radius; color = black, fill::Bool = true, options...)
    # draw
end
```

実際には *3* つのメソッド定義が生成されます。最初は、すべての引数（キーワード引数を含む）を位置引数として受け取り、メソッド本体のコードを含む関数です。自動生成された名前を持っています：

```julia
function #circle#1(color, fill::Bool, options, circle, center, radius)
    # draw
end
```

2番目の方法は、キーワード引数が渡されない場合の処理を行う元の `circle` 関数の通常の定義です：

```julia
function circle(center, radius)
    #circle#1(black, true, pairs(NamedTuple()), circle, center, radius)
end
```

これは単に最初のメソッドにディスパッチし、デフォルト値を渡します。`pairs`は、キーワード引数の名前付きタプルに適用され、キーと値のペアの反復を提供します。メソッドが可変キーワード引数を受け入れない場合、この引数は存在しないことに注意してください。

最後に、kwsorterの定義があります：

```
function (::Core.kwftype(typeof(circle)))(kws, circle, center, radius)
    if haskey(kws, :color)
        color = kws.color
    else
        color = black
    end
    # etc.

    # put remaining kwargs in `options`
    options = structdiff(kws, NamedTuple{(:color, :fill)})

    # if the method doesn't accept rest keywords, throw an error
    # unless `options` is empty

    #circle#1(color, fill, pairs(options), circle, center, radius)
end
```

関数 `Core.kwftype(t)` は、フィールド `t.name.mt.kwsorter` を作成し（まだ作成されていない場合）、その関数の型を返します。

このデザインの特徴は、キーワード引数を使用しない呼び出しサイトは特別な処理を必要とせず、すべてがまるでそれらが言語の一部でないかのように機能することです。キーワード引数を使用する呼び出しサイトは、呼び出された関数のkwsorterに直接ディスパッチされます。例えば、次の呼び出し：

```julia
circle((0, 0), 1.0, color = red; other...)
```

は次のように引き下げられます：

```julia
kwcall(merge((color = red,), other), circle, (0, 0), 1.0)
```

`kwcall`（`Core`にもあります）は、kwcallシグネチャとディスパッチを示します。キーワードスプラッティング操作（`other...`として書かれます）は、名前付きタプル`merge`関数を呼び出します。この関数は、`other`の各*要素*をさらに展開し、各要素がシンボルと値の2つの値を含むことを期待します。もちろん、すべてのスプラット引数が名前付きタプルである場合、より効率的な実装が可能です。元の`circle`関数は、クロージャを処理するために通過されることに注意してください。

## [Compiler efficiency issues](@id compiler-efficiency-issues)

新しい型をすべての関数に対して生成することは、Juliaの「デフォルトで全引数に特化する」という設計と組み合わせると、コンパイラのリソース使用に潜在的に深刻な影響を与える可能性があります。実際、この設計の初期実装は、ビルドとテストの時間が大幅に長くなり、メモリ使用量が増加し、システムイメージがベースラインのほぼ2倍になるという問題に直面しました。ナイーブな実装では、この問題はシステムをほぼ使用不可能にするほど深刻です。この設計を実用的にするためには、いくつかの重要な最適化が必要でした。

最初の問題は、関数値引数の異なる値に対する関数の過度な特殊化です。多くの関数は、引数を他の場所、例えば別の関数やストレージ位置に「パススルー」するだけです。このような関数は、渡される可能性のあるすべてのクロージャに対して特殊化する必要はありません。幸いなことに、このケースは、関数がその引数のいずれかを*呼び出す*かどうかを考慮することで簡単に区別できます（つまり、引数が「ヘッドポジション」に現れる場合）。`map`のようなパフォーマンスクリティカルな高階関数は、確実にその引数関数を呼び出し、したがって期待通りに特殊化されます。この最適化は、フロントエンドの`analyze-variables`パス中に呼び出される引数を記録することによって実装されています。`cache_method`が`Any`または`Function`として宣言されたスロットに渡される`Function`型階層の引数を見たとき、それは`@nospecialize`アノテーションが適用されたかのように振る舞います。このヒューリスティックは、実際には非常に効果的であるようです。

次の問題は、メソッドキャッシュハッシュテーブルの構造に関するものです。実証研究によると、動的にディスパッチされた呼び出しの大多数は1つまたは2つの引数を含みます。これにより、これらのケースの多くは最初の引数のみを考慮することで解決できます。（余談ですが、シングルディスパッチの支持者はこれに全く驚かないでしょう。しかし、この議論は「マルチディスパッチは実際に最適化が容易である」という意味であり、したがってそれを使用すべきであるということを示しています。*シングルディスパッチを使用すべきだ*ということではありません！）したがって、メソッドキャッシュは最初の引数の型を主キーとして使用します。ただし、これは関数呼び出しのタプル型の*2番目*の要素に対応します（最初の要素は関数自体の型です）。通常、ヘッドポジションでの型の変動は非常に低く、実際、ほとんどの関数はパラメータを持たないシングルトン型に属します。しかし、これはコンストラクタには当てはまらず、単一のメソッドテーブルがすべての型のコンストラクタを保持します。したがって、`Type`メソッドテーブルは、2番目の代わりに*最初*のタプル型要素を使用するように特別に処理されています。

フロントエンドはすべてのクロージャの型宣言を生成します。最初は、通常の型宣言を生成することで実装されていました。しかし、これにより非常に多くのコンストラクタが生成され、すべてがトリビアル（単にすべての引数を [`new`](@ref) に渡すだけ）でした。メソッドは部分的に順序付けられているため、これらすべてのメソッドを挿入するのは O(n²) であり、保持しておくにはあまりにも多すぎます。これを最適化するために、`struct_type` 表現を直接生成し（デフォルトコンストラクタ生成をバイパス）、`new` を直接使用してクロージャインスタンスを作成するようにしました。決して美しいものではありませんが、やるべきことをやるのです。

次の問題は、各テストケースのために0引数のクロージャを生成する`@test`マクロでした。これは実際には必要ありません。なぜなら、各テストケースは単にその場で一度実行されるからです。したがって、`@test`はテスト結果（真、偽、または例外が発生した）を記録し、それに対してテストスイートハンドラーを呼び出すtry-catchブロックに展開されるように修正されました。
