# Julia ASTs

Julia にはコードを表す形式が 2 種類あります。まず、パーサーが返し（たとえば [`Meta.parse`](@ref) 関数）、マクロが操作する表層構文 AST があります。これは、文字ストリームから `julia-parser.scm` によって構築される、記述されたコードの構造化表現です。次に、型推論とコード生成で使われる低レベル形式、すなわち IR（中間表現）があります。低レベル形式ではノードの種類が少なく、すべてのマクロが展開され、制御フローは明示的な分岐と文の列に変換されます。低レベル形式は `julia-syntax.scm` によって構築されます。

まず、マクロを書く際に必要となる AST から見ていきます。

## Surface syntax AST

フロントエンドの AST は、ほぼすべてが [`Expr`](@ref) とアトム（シンボルや数値など）で構成されます。通常、見た目の異なる構文形式ごとに、異なる式ヘッドがあります。以下では、例を S 式構文で示します。括弧で囲まれたリストはそれぞれ Expr に対応し、最初の要素がヘッドです。たとえば、`(call f x)` は Julia では `Expr(:call, :f, :x)` に対応します。

### Calls

| 入力               | AST                                |
|:---------------- |:---------------------------------- |
| `f(x)`           | `(call f x)`                       |
| `f(x, y=1, z=2)` | `(call f x (kw y 1) (kw z 2))`     |
| `f(x; y=1)`      | `(call f (parameters (kw y 1)) x)` |
| `f(x...)`        | `(call f (... x))`                 |

`do` 構文は、

```julia
f(x) do a,b
    body
end
```

`(do (call f x) (-> (tuple a b) (block body)))` として解析されます。

### Operators

演算子の多くは単なる関数呼び出しなので、ヘッド `call` を使って解析されます。ただし、一部の演算子は特殊形式（必ずしも関数呼び出しではない）であり、その場合は演算子自体が式ヘッドになります。jul ia-parser.scm では、これらを「構文演算子」と呼んでいます。一部の演算子（`+` と `*`）は N 項解析を使い、連鎖した呼び出しは N 個の引数を持つ単一の呼び出しとして解析されます。比較の連鎖には、さらに独自の特殊な式構造があります。

| 入力          | AST                       |
|:----------- |:------------------------- |
| `x+y`       | `(call + x y)`            |
| `a+b+c+d`   | `(call + a b c d)`        |
| `2x`        | `(call * 2 x)`            |
| `a&&b`      | `(&& a b)`                |
| `x += 1`    | `(+= x 1)`                |
| `a ? 1 : 2` | `(if a 1 2)`              |
| `a,b`       | `(tuple a b)`             |
| `a==b`      | `(call == a b)`           |
| `1<i<=n`    | `(comparison 1 < i <= n)` |
| `a.b`       | `(. a (quote b))`         |
| `a.(b)`     | `(. a (tuple b))`         |

### Bracketed forms

| 入力                       | AST                                             |
|:------------------------ |:----------------------------------------------- |
| `a[i]`                   | `(ref a i)`                                     |
| `t[i;j]`                 | `(typed_vcat t i j)`                            |
| `t[i j]`                 | `(typed_hcat t i j)`                            |
| `t[a b; c d]`            | `(typed_vcat t (row a b) (row c d))`            |
| `t[a b;;; c d]`          | `(typed_ncat t 3 (row a b) (row c d))`          |
| `a{b}`                   | `(curly a b)`                                   |
| `a{b;c}`                 | `(curly a (parameters c) b)`                    |
| `[x]`                    | `(vect x)`                                      |
| `[x,y]`                  | `(vect x y)`                                    |
| `[x;y]`                  | `(vcat x y)`                                    |
| `[x y]`                  | `(hcat x y)`                                    |
| `[x y; z t]`             | `(vcat (row x y) (row z t))`                    |
| `[x;y;; z;t;;;]`         | `(ncat 3 (nrow 2 (nrow 1 x y) (nrow 1 z t)))`   |
| `[x for y in z, a in b]` | `(comprehension (generator x (= y z) (= a b)))` |
| `T[x for y in z]`        | `(typed_comprehension T (generator x (= y z)))` |
| `(a, b, c)`              | `(tuple a b c)`                                 |
| `(a; b; c)`              | `(block a b c)`                                 |

### Macros

| 入力            | AST                                          |
|:------------- |:-------------------------------------------- |
| `@m x y`      | `(macrocall @m (line) x y)`                  |
| `Base.@m x y` | `(macrocall (. Base (quote @m)) (line) x y)` |
| `@Base.m x y` | `(macrocall (. Base (quote @m)) (line) x y)` |

### Strings

| 入力              | AST                                 |
|:--------------- |:----------------------------------- |
| `"a"`           | `"a"`                               |
| `x"y"`          | `(macrocall @x_str (line) "y")`     |
| `x"y"z`         | `(macrocall @x_str (line) "y" "z")` |
| `"x = $x"`      | `(string "x = " x)`                 |
| ``` `a b c` ``` | `(macrocall @cmd (line) "a b c")`   |

ドキュメント文字列の構文は、

```julia
"some docs"
f(x) = x
```

`(macrocall (|.| Core '@doc) (line) "some docs" (= (call f x) (block x)))` として解析されます。

### Imports and such

| 入力                  | AST                                 |
|:------------------- |:----------------------------------- |
| `import a`          | `(import (. a))`                    |
| `import a.b.c`      | `(import (. a b c))`                |
| `import ...a`       | `(import (. . . . a))`              |
| `import a.b, c.d`   | `(import (. a b) (. c d))`          |
| `import Base: x`    | `(import (: (. Base) (. x)))`       |
| `import Base: x, y` | `(import (: (. Base) (. x) (. y)))` |
| `export a, b`       | `(export a b)`                      |
| `public a, b`       | `(public a b)`                      |

`using` は `import` と同じ表現になりますが、式ヘッドは `:import` ではなく `:using` です。

プログラムから `public` 文を作成するには、`Expr(:public, :a, :b)` を使うか、通常のコードに近い方法として `Meta.parse("public a, b")` を使います。これは [current limitations on `public`](@ref Export-lists) のために必要です。`public` キーワードが認識されるのは、ファイル内の構文上の最上位（`parse_stmts`）またはモジュール内に限られます。この制限は、Julia 1.11 で導入された際に、識別子として `public` を使っていた既存コードが壊れるのを防ぐために設けられました。

### Numbers

Julia は多くの Scheme 実装よりも多くの数値型をサポートしているため、AST 内のすべての数値が Scheme の数値として直接表現されるわけではありません。

| 入力                      | AST                                                      |
|:----------------------- |:-------------------------------------------------------- |
| `11111111111111111111`  | `(macrocall @int128_str nothing "11111111111111111111")` |
| `0xfffffffffffffffff`   | `(macrocall @uint128_str nothing "0xfffffffffffffffff")` |
| `1111...many digits...` | `(macrocall @big_str nothing "1111....")`                |

### Block forms

文のブロックは `(block stmt1 stmt2 ...)` として解析されます。

if 文:

```julia
if a
    b
elseif c
    d
else
    e
end
```

は次のように解析されます。

```
(if a (block (line 2) b)
    (elseif (block (line 3) c) (block (line 4) d)
            (block (line 6) e)))
```

`while` ループは `(while condition body)` として解析されます。

`for` ループは `(for (= var iter) body)` として解析されます。反復指定が複数ある場合は、ブロックとして解析されます: `(for (block (= v1 iter1) (= v2 iter2)) body)`。

`break` と `continue` は、引数 0 個の式 `(break)` と `(continue)` として解析されます。

`let` は、`for` ループと同様に、`(let (= var val) body)` または `(let (block (= var1 val1) (= var2 val2) ...) body)` として解析されます。

基本的な関数定義は `(function (call f x) body)` として解析されます。より複雑な例を示します。

```julia
function f(x::T; k = 1) where T
    return x+1
end
```

これは次のように解析されます。

```
(function (where (call f (parameters (kw k 1))
                       (:: x T))
                 T)
          (block (line 2) (return (call + x 1))))
```

型定義:

```julia
mutable struct Foo{T<:S}
    x::T
end
```

は次のように解析されます。

```
(struct true (curly Foo (<: T S))
        (block (line 2) (:: x T)))
```

最初の引数は、その型が可変かどうかを示すブール値です。

`try` ブロックは `(try try_block var catch_block finally_block)` として解析されます。`catch` の後に変数がない場合、`var` は `#f` になります。`finally` 節がない場合、最後の引数は存在しません。

### Quote expressions

コード引用のための Julia のソース構文（`quote` と `:( )`）は、`$` による補間をサポートします。Lisp の用語では、これらは実際には「バッククォート」または「準引用」形式です。内部処理では、補間を行わないコード引用も必要です。Julia の Scheme コードでは、補間なしの引用は式ヘッド `inert` で表されます。

`inert` 式は Julia の `QuoteNode` オブジェクトに変換されます。これらのオブジェクトは任意の型の値を 1 つ包み、評価されるとその値をそのまま返します。

引数がアトムである `quote` 式も、`QuoteNode` に変換されます。

### Line numbers

ソース位置情報は `(line line_num file_name)` として表されます。3 番目の要素は省略可能で、ファイル名は変わらず現在の行番号だけが変わる場合には省略されます。

これらの式は Julia では `LineNumberNode` として表されます。

### Macros

マクロの衛生性は、式ヘッド `escape` と `hygienic-scope` の組で表されます。マクロ展開の結果は、新しいスコープの結果を表すため、自動的に `(hygienic-scope block module [lno])` で包まれます。呼び出し元のコードを補間するには、その内側に `(escape block)` を挿入できます。lno は、指定されている場合、マクロの `__source__` 引数です。

## Lowered form

低レベル形式（IR）は、型推論、インライン化などの最適化、コード生成に使われるため、コンパイラーにとってより重要です。一方、入力構文が大幅に組み替えられた結果であるため、人間には理解しにくい形式でもあります。

`Symbol` といくつかの数値型に加えて、低レベル形式には次のデータ型があります。

  * `Expr`

    ノード型は `head` フィールドで示され、`args` フィールドには部分式の `Vector{Any}` が格納されます。表層 AST のほぼすべての部分は `Expr` で表されますが、IR で使われる `Expr` は限られており、主に呼び出しと一部の最上位専用形式に使われます。
  * `SlotNumber`

    引数とローカル変数を連番で識別します。整数値の `id` フィールドにスロットのインデックスが格納されます。各スロットの型は、その `CodeInfo` オブジェクトの `slottypes` フィールドで確認できます。
  * `Argument`

    `SlotNumber` と同じですが、最適化後にのみ現れます。参照先のスロットが、外側の関数の引数であることを示します。
  * `CodeInfo`

    文のグループの IR を包みます。`code` フィールドは、実行する式の配列です。
  * `GotoNode`

    無条件分岐です。引数は分岐先であり、ジャンプ先となるコード配列内のインデックスで表されます。
  * `GotoIfNot`

    条件分岐です。`cond` フィールドが false と評価されると、`dest` フィールドで指定されたインデックスに移動します。
  * `ReturnNode`

    引数（`val` フィールド）を、外側の関数の戻り値として返します。`val` フィールドが未定義の場合、到達不能な文を表します。
  * `QuoteNode`

    任意の値をデータとして参照できるように包みます。たとえば、関数 `f() = :a` には `QuoteNode` が含まれ、その `value` フィールドはシンボル `a` です。これにより、シンボルを評価するのではなく、シンボル自体を返します。
  * `GlobalRef`

    モジュール `mod` 内のグローバル変数 `name` を参照します。
  * `SSAValue`

    コンパイラーが挿入する、1 から始まる連番の静的単一代入（SSA）変数を参照します。`SSAValue` の番号（`id`）は、その値を表す式のコード配列内インデックスです。
  * `NewvarNode`

    変数（スロット）が作成される位置を示します。これにより、変数は未定義の状態にリセットされます。

### `Expr` types

これらのシンボルは、低レベル形式の [`Expr`](@ref) の `head` フィールドに現れます。

  * `call`

    関数呼び出し（動的ディスパッチ）です。`args[1]` は呼び出す関数、`args[2:end]` は引数です。
  * `invoke`

    関数呼び出し（静的ディスパッチ）です。`args[1]` は呼び出す MethodInstance、`args[2:end]` は引数です（`args[2]` にある呼び出し対象の関数も含みます）。
  * `static_parameter`

    静的パラメーターをインデックスで参照します。
  * `=`

    代入です。IR では、最初の引数は常に `SlotNumber` または `GlobalRef` です。
  * `method`

    ジェネリック関数にメソッドを追加し、必要に応じてその結果を割り当てます。

    引数 1 個の形式と引数 3 個の形式があります。引数 1 個の形式は、構文 `function foo end` から生成されます。この形式の引数はシンボルです。そのシンボルが現在のスコープですでに関数を指している場合は何も起こりません。シンボルが未定義なら、新しい関数が作成され、そのシンボルで指定された識別子に割り当てられます。シンボルが定義済みでも関数以外を指している場合は、エラーが発生します。「関数を指す」とは、束縛が定数であり、シングルトン型のオブジェクトを参照していることを意味します。シングルトン型のインスタンスは、メソッドを追加する型を一意に識別するため、このような定義になっています。型にフィールドがある場合、メソッドをインスタンスに追加するのか、その型に追加するのかが明確でなくなるためです。

    引数 3 個の形式は、次の引数を取ります。

      * `args[1]`

        関数名。未知または不要の場合は `nothing` です。シンボルの場合、式はまず上記の引数 1 個の形式と同じ動作をします。その後、この引数は無視されます。型だけを基準にメソッドを追加する場合は `nothing` にできます（`(::T)(x) = x`）。既存の関数にメソッドを追加する場合は `MyModule.f(x) = x` にできます。
      * `args[2]`

        引数型データの `SimpleVector` です。`args[2][1]` は引数型の `SimpleVector`、`args[2][2]` はメソッドの静的パラメーターに対応する型変数の `SimpleVector` です。
      * `args[3]`

        メソッド自体の `CodeInfo` です。「スコープ外」のメソッド定義（異なるスコープで定義されたメソッドも持つ関数にメソッドを追加する場合）では、`:lambda` 式に評価される式です。
  * `struct_type`

    新しい `struct` を定義する、引数 7 個の式です。

      * `args[1]`

        `struct` の名前
      * `args[2]`

        パラメーターを指定する `SimpleVector` を作成する `call` 式
      * `args[3]`

        フィールド名を指定する `SimpleVector` を作成する `call` 式
      * `args[4]`

        上位型を指定する `Symbol`、`GlobalRef`、または `Expr`（例: `:Integer`、`GlobalRef(Core, :Any)`、`:(Core.apply_type(AbstractArray, T, N))`）
      * `args[5]`

        フィールド型を指定する `SimpleVector` を作成する `call` 式
      * `args[6]`

        Bool。`mutable` の場合は true
      * `args[7]`

        初期化する引数の数。これはフィールド数、または内部コンストラクターの `new` 文で呼び出されるフィールドの最小数です。
  * `abstract_type`

    新しい抽象型を定義する、引数 3 個の式です。引数は `struct_type` 式の第 1、第 2、第 4 引数と同じです。
  * `primitive_type`

    新しいプリミティブ型を定義する、引数 4 個の式です。第 1、第 2、第 4 引数は `struct_type` と同じです。第 3 引数はビット数です。

    !!! compat "Julia 1.5"
        `struct_type`、`abstract_type`、`primitive_type` は Julia 1.5 で削除され、新しい組み込み関数の呼び出しに置き換えられました。
  * `global`

    グローバル束縛を宣言します。
  * `const`

    （グローバル）変数を定数として宣言します。
  * `new`

    struct に似た新しいオブジェクトを割り当てます。最初の引数は型です。[`new`](@ref) 疑似関数はこれに低レベル化され、型は常にコンパイラーによって挿入されます。これは完全に内部向けの機能であり、検査は行いません。任意の `new` 式を評価すると、簡単にセグメンテーション違反が発生する可能性があります。
  * `splatnew`

    `new` と似ていますが、フィールド値を単一のタプルとして渡します。`new` が第一級関数であった場合の `splat(new)` と同様に動作するため、この名前が付いています。
  * `isdefined`

    `Expr(:isdefined, :x)` は、現在のスコープで `x` がすでに定義されているかどうかを示す Bool を返します。
  * `the_exception`

    `catch` ブロック内で捕捉された例外を、`jl_current_exception(ct)` が返す値として取り出します。
  * `enter`

    例外ハンドラー（`setjmp`）に入ります。`args[1]` は、エラー発生時にジャンプする catch ブロックのラベルです。`pop_exception` が消費するトークンを返します。
  * `leave`

    例外ハンドラーを取り除きます。`args[1]` は取り除くハンドラーの数です。
  * `pop_exception`

    catch ブロックを抜ける際に、現在の例外スタックを、対応する `enter` 時点の状態に戻します。`args[1]` には、対応する `enter` のトークンが格納されます。

    !!! compat "Julia 1.1"
        `pop_exception` は Julia 1.1 で追加されました。
  * `inbounds`

    境界チェックの有効・無効を制御します。スタックが維持され、この式の最初の引数が true または false（`true` は境界チェック無効を意味します）の場合、その値がスタックに積まれます。最初の引数が `:pop` の場合は、スタックから値を取り除きます。
  * `boundscheck`

    `@inbounds` でマークされたコード領域にインライン化された場合は `false` の値を持ち、それ以外の場合は `true` の値を持ちます。
  * `loopinfo`

    ループの終端を示します。メタデータを含み、`LowerSimdLoop` に渡されます。これにより、`@simd` 式の内側のループを示すか、LLVM のループパスに情報を伝えます。
  * `copyast`

    準引用の実装の一部です。引数は表層構文 AST で、再帰的にそのままコピーされ、実行時に返されます。
  * `meta`

    メタデータです。`args[1]` は通常、メタデータの種類を示すシンボルで、残りの引数は任意の形式です。よく使われるメタデータの種類は次のとおりです。

      * `:inline` と `:noinline`: インライン化のヒント。
  * `foreigncall`

    `ccall` 情報を格納する、静的に計算されたコンテナーです。フィールドは次のとおりです。

      * `args[1]` : name

        外部関数用に解析される式。
      * `args[2]::Type` : RT

        リテラルの戻り値型。これを含むメソッドの定義時に静的に計算されます。
      * `args[3]::SimpleVector` (of Types) : AT

        リテラルの引数型ベクトル。これを含むメソッドの定義時に静的に計算されます。
      * `args[4]::Int` : nreq

        可変長引数関数定義における必須引数の数。
      * `args[5]::QuoteNode{<:Union{Symbol,Tuple{Symbol,UInt16}, Tuple{Symbol,UInt16,Bool}}`: calling convention

        呼び出し規約。必要に応じて効果情報を含み、`gc_safe`（GC と並行して安全に実行可能）を指定できます。
      * `args[6:5+length(args[3])]` : arguments

        すべての引数の値（各引数の型は args[3] に指定）。
      * `args[6+length(args[3])+1:end]` : gc-roots

        呼び出し中に GC ルートとして保持する必要がある追加オブジェクト。これらの導出元と処理方法については [Working with LLVM](@ref Working-with-LLVM) を参照してください。
  * `new_opaque_closure`

    新しい不透明クロージャを構築します。フィールドは次のとおりです。

      * `args[1]` : signature

        不透明クロージャの関数シグネチャ。不透明クロージャはディスパッチには参加しませんが、入力型を制限できます。
      * `args[2]` : lb

        出力型の下限（既定値は `Union{}`）。
      * `args[3]` : ub

        出力型の上限（既定値は `Any`）。
      * `args[4]` : constprop

        不透明クロージャの同一性を定数伝播に利用できるかどうかを示します。`@opaque` マクロは既定でこれを有効にしますが、追加の推論が発生するため望ましくない場合があり、プリコンパイル中のコード実行もできなくなります。`args[4]` がメソッドの場合、この引数はスキップされたものとして扱われます。
      * `args[5]` : method

        `opaque_closure_method` 式として表される実際のメソッド。
      * `args[6:end]` : captures

        不透明クロージャが捕捉した値。

    !!! compat "Julia 1.7"
        不透明クロージャは Julia 1.7 で追加されました。

### [Method](@id ast-lowered-method)

単一のメソッドに共有されるメタデータを記述する、一意化されたコンテナーです。

  * `name`、`module`、`file`、`line`、`sig`

    コンピューターと人間の双方にとって、メソッドを一意に識別するメタデータです。
  * `ambig`

    このメソッドと曖昧になり得る他のメソッドのキャッシュ。
  * `specializations`

    この Method に対して作成されたすべての MethodInstance のキャッシュ。一意性を保証するために使われます。一意性は、特にインクリメンタルなプリコンパイルやメソッド無効化の追跡において、効率上必要です。
  * `source`

    元のソースコード（利用可能な場合。通常は圧縮されています）。
  * `generator`

    特定のメソッドシグネチャに特化したソースを取得するために実行できる呼び出し可能オブジェクト。
  * `roots`

    AST に補間された、AST の圧縮、型推論、またはネイティブコード生成に必要な、AST 以外の要素へのポインター。
  * `nargs`、`isva`、`called`、`is_for_opaque_closure`

    この Method のソースコードに関する説明的なビットフィールド。
  * `primary_world`

    この Method を「所有する」ワールドエイジ。

### MethodInstance

Method の単一の呼び出し可能シグネチャを記述する、一意化されたコンテナーです。これらのフィールドを安全に変更する方法については、特に [Proper maintenance and care of multi-threading locks](@ref Proper-maintenance-and-care-of-multi-threading-locks) を参照してください。

  * `specTypes`

    この MethodInstance の主キー。一意性は `def.specializations` による検索で保証されます。
  * `def`

    この関数が特殊化された元の `Method`。トップレベルの Lambda が Module 内で展開され、Method の一部ではない場合は、`Module` になります。
  * `sparam_vals`

    `specTypes` にある静的パラメーターの値。`Method.unspecialized` にある `MethodInstance` では、これは空の `SimpleVector` です。一方、`MethodTable` キャッシュから得られる実行時の `MethodInstance` では、常に定義済みで、インデックス参照が可能です。
  * `backedges`

    新しいメソッド定義の後に必要となるインクリメンタルな再解析・再コンパイル作業を効率よく追跡するため、キャッシュ依存関係の逆リストを保持します。これは、この `MethodInstance` を呼び出す可能性があると推論または最適化された、他の `MethodInstance` のリストを保持することで実現します。最適化結果は `cache` のどこかに保存されている場合もあれば、定数伝播のようにキャッシュしたくない処理の結果である場合もあります。そのため、さまざまなキャッシュエントリーへのバックエッジをここにまとめます（通常は max_world の番兵値を持つ、該当するキャッシュエントリーが 1 つだけです）。
  * `cache`

    このテンプレートのインスタンス化を共有する `CodeInstance` オブジェクトのキャッシュ。

### CodeInstance

  * `def`

    このキャッシュエントリーの元となった `MethodInstance`。
  * `owner`

    この `CodeInstance` の所有者を表すトークン。照合には `jl_egal` を使います。
  * `rettype`/`rettype_const`

    `specFunctionObject` フィールドの推論された戻り値型。多くの場合、関数全体について計算された戻り値型でもあります。
  * `inferred`

    この関数の推論済みソースのキャッシュを含む場合があります。あるいは、`rettype` が推論済みであることだけを示すために `nothing` に設定される場合もあります。
  * `ftpr`

    汎用 jlcall エントリーポイント。
  * `jlcall_api`

    `fptr` の呼び出しに使う ABI。主な値は次のとおりです。

      * 0 - まだコンパイルされていない
      * 1 - `JL_CALLABLE` `jl_value_t *(*)(jl_value_t *f, jl_value_t *args[nargs], uint32_t nargs)`
      * 2 - 定数（値は `rettype_const` に格納）
      * 3 - 静的パラメーターを転送して実行 `jl_value_t *(*)(jl_svec_t *sparams, jl_value_t *f, jl_value_t *args[nargs], uint32_t nargs)`
      * 4 - インタープリターで実行 `jl_value_t *(*)(jl_method_instance_t *meth, jl_value_t *f, jl_value_t *args[nargs], uint32_t nargs)`
  * `min_world` / `max_world`

    このメソッドインスタンスを呼び出せるワールドエイジの範囲。max_world が特殊なトークン値 `-1` の場合、値はまだ不明です。再検討が必要となるバックエッジに遭遇するまでは、引き続き使用できます。
  * タイミングフィールド

      * `time_infer_total`: `inferred` の計算にかかった合計時間。開始から終了までの実時間です。
      * `time_infer_cache_saved`: キャッシュによって `time_infer_total` から節約された時間。これを `time_infer_total` に加えると、2 つの実装間、または同じ実装の経時的なコストを比較するための安定した推定値になります。キャッシュは繰り返し処理を頻繁に効率化するため、通常、何かを推論する時間を過大評価します。
      * `time_infer_self`: `inferred` に対する Julia 推論の自己コスト（`time_infer_total` の一部）。これは、定数推論結果や LimitedAccuracy の結果（通常はキャッシュされないもの）も含め、すべての呼び出し先がキャッシュに揃っていると仮定した場合に、この 1 つのメソッドをコンパイルする増分コストです。
      * `time_compile`: LLVM JIT コンパイルの自己コスト（例: `inferred` から `invoke` を計算するコスト）。`edges` の内容をすべてたどり、循環と重複を考慮して合計すれば、総コストを推定できます（このフィールドには現在、測定済みの AOT コンパイル時間は含まれません）。

### CodeInfo

低レベル化された（場合によっては推論済みの）ソースコードを保持するための、通常は一時的なコンテナーです。

  * `code`

    文の `Any` 配列。
  * `slotnames`

    各スロット（引数またはローカル変数）の名前を格納するシンボル配列。
  * `slotflags`

    スロットのプロパティをビットフラグで表した `UInt8` 配列。

      * 0x02 - 代入済み（この変数を左辺とする代入文が*一つもない*場合に限り false）
      * 0x08 - 使用済み（スロットの読み取りまたは書き込みがある場合）
      * 0x10 - 静的に一度だけ代入される
      * 0x20 - 代入前に使用される可能性がある。このフラグが有効なのは型推論後のみです。
  * `ssavaluetypes`

    配列または `Int` のいずれかです。

    `Int` の場合、関数内のコンパイラー挿入一時領域の数（`code` 配列の長さ）を示します。配列の場合は、各領域の型を指定します。
  * `ssaflags`

    関数内の各式に対応する、文レベルの 32 ビットフラグです。詳細は julia.h の `jl_code_info_t` の定義を参照してください。

次のフィールドは、推論後（または一部のケースでは生成関数によって）にのみ設定されます。

  * `debuginfo`

    各文のソース情報を取得するためのオブジェクトです。[How to interpret line numbers in a `CodeInfo` object](@ref) を参照してください。
  * `rettype`

    低レベル形式（IR）の推論された戻り値型。既定値は `Any` です。主に利便性のために用意されています。OpaqueClosure の動作上、コード生成で使われる戻り値型と必ずしも一致しないためです。
  * `parent`

    このオブジェクトを「所有する」`MethodInstance`（該当する場合）。
  * `edges`

    無効化が必要なメソッドインスタンスへのフォワードエッジ。
  * `min_world`/`max_world`

    推論時点でこのコードが有効だったワールドエイジの範囲。

任意フィールド:

  * `slottypes`

    スロットの型の配列。
  * `method_for_inference_limit_heuristics`

    推論中に必要に応じて、`method_for_inference_heuristics` が指定されたメソッドのジェネレーターを展開します。

ブール型プロパティ:

  * `propagate_inbounds`

    インライン化時に `@inbounds` を伝播し、`@boundscheck` ブロックを省略するかどうかを示します。

`UInt8` の設定:

  * `constprop`、`inlineable`

      * 0 = ヒューリスティックを使用
      * 1 = 積極的
      * 2 = なし
  * `purity` は 5 つのビットフラグから構成されます。

      * 0x01 << 0 = このメソッドは一貫して戻るか終了することが保証される（`:consistent`）
      * 0x01 << 1 = 外部から意味的に観測可能な副作用がないことが保証される（`:effect_free`）
      * 0x01 << 2 = 例外をスローしないことが保証される（`:nothrow`）
      * 0x01 << 3 = 終了することが保証される（`:terminates_globally`）
      * 0x01 << 4 = このメソッド内の構文上の制御フローが終了することが保証される（`:terminates_locally`）

    詳細は `Base.@assume_effects` のドキュメントを参照してください。

#### How to interpret line numbers in a `CodeInfo` object

このデータには、一般的に 2 つの形式があります。内部で使われる、データをある程度圧縮した形式と、コンパイラーで使われる形式です。基本情報は同じですが、コンパイラー版はすべて可変である一方、内部版は可変ではありません。

多くの利用側では、これらの詳細を個別に再実装する必要を避けるため、`Base.IRShow.buildLineInfoNode`、`Base.IRShow.append_scopes!`、または `Stacktraces.lookup(::InterpreterIP)` を呼び出せます。

それぞれの定義は次のとおりです。

```julia
struct Core.DebugInfo
    @noinline
    def::Union{Method,MethodInstance,Symbol}
    linetable::Union{Nothing,DebugInfo}
    edges::SimpleVector{DebugInfo}
    codelocs::String # compressed data
end
mutable struct Core.Compiler.DebugInfoStream
    def::Union{Method,MethodInstance,Symbol}
    linetable::Union{Nothing,DebugInfo}
    edges::Vector{DebugInfo}
    firstline::Int32 # the starting line for this block (specified by an index of 0)
    codelocs::Vector{Int32} # for each statement:
        # index into linetable (if defined), else a line number (in the file represented by def)
        # then index into edges
        # then index into edges[linetable]
end
```

  * `def` : この `DebugInfo` が定義された場所（たとえば、ファイルスコープの `Method`、`MethodInstance`、または `Symbol`）
  * `linetable`

    これの派生元となった別の `DebugInfo`。実際の行番号を含み、この DebugInfo にはそのインデックスだけが格納されます。これによりコピーを避けられるだけでなく、行番号だけでなく、個々の文がソースから最適化後の形式へどのように変換されたかも追跡できます。`def` が Symbol でない場合、そのオブジェクトが、実行中と概念上みなされる関数に関するメタデータの現在の関数オブジェクトに置き換わります（たとえば Cassette の変換を考えてください）。以下で説明する `codelocs` の値も、行番号そのものではなく、このオブジェクト内の `codelocs` へのインデックスとして解釈されます。
  * `edges` : この関数にインライン化された各関数の一意な DebugInfo のベクトル（それぞれの DebugInfo には、その関数にインライン化されたすべての関数へのエッジも再帰的に含まれます）。
  * `firstline`（DebugInfoStream に展開した場合）

    このコード定義の「開始」位置を示す `begin` 文（または `function` や `quote` などのキーワード）に対応する行番号。
  * `codelocs`（`DebugInfoStream` に展開した場合）

    インデックスのベクトルです。IR 内の各文に 3 つの値があり、さらにブロックの開始位置に 1 つの値が追加されます。各位置のスタックトレースを次のように記述します。

    1. `linetable.codelocs` フィールドへの整数インデックス。各文に対応する元の位置（構文上のエッジを含む）を示します。0 は、直前に実行された文（必ずしも構文上または字句上で直前とは限りません）から行番号が変わらないことを示します。また、`linetable` フィールドが `nothing` の場合は、行番号そのものを示します。
    2. `edges` への整数インデックス。そこでインライン化された `DebugInfo` を示します。エッジがない場合は 0 です。
    3. （項目 2 が 0 でない場合）`edges[].codelocs` への整数インデックス。インライン化スタック内の各関数について再帰的に解釈します。0 の場合は、行番号として `edges[].firstline` を使います。

    特殊コードは次のとおりです。

      * `(zero, zero, *)`: 直前の文から行番号もエッジも変わらないことを示します（構文上または字句上のどちらとして解釈してもかまいません）。インライン化の深さは変わっている場合がありますが、ほとんどの呼び出し側では無視できます。
      * `(zero, non-zero, *)` : 行番号はなく、エッジだけがあります（通常はマクロ展開によって最上位コードに展開された場合）。
