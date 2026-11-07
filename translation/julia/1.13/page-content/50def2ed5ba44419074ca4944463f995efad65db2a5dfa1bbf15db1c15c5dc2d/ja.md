# Julia ASTs

Juliaには、コードを表す形式が2種類あります。まず、パーサーが返す表層構文AST（たとえば[`Meta.parse`](@ref)関数）があり、マクロはこれを操作します。これは、文字ストリームから`julia-parser.scm`によって構築される、記述されたコードの構造化表現です。次に、型推論とコード生成で使われる低レベル形式、すなわちIR（中間表現）があります。低レベル形式ではノードの種類が少なく、すべてのマクロが展開され、制御フローは明示的な分岐と文の列に変換されます。低レベル形式は`julia-syntax.scm`によって構築されます。

まず、マクロを書く際に必要となるASTに注目します。

## Surface syntax AST

フロントエンドのASTは、ほぼすべてが[`Expr`](@ref)とアトム（シンボルや数値など）で構成されています。通常、見た目の異なる構文形式ごとに、異なる式ヘッドがあります。以下では、例をS式構文で示します。括弧で囲まれたリストはそれぞれExprに対応し、最初の要素がヘッドです。たとえば、`(call f x)`はJuliaでは`Expr(:call, :f, :x)`に対応します。

### Calls

| 入力               | AST                                |
|:---------------- |:---------------------------------- |
| `f(x)`           | `(call f x)`                       |
| `f(x, y=1, z=2)` | `(call f x (kw y 1) (kw z 2))`     |
| `f(x; y=1)`      | `(call f (parameters (kw y 1)) x)` |
| `f(x...)`        | `(call f (... x))`                 |

`do`構文は、

```julia
f(x) do a,b
    body
end
```

`(do (call f x) (-> (tuple a b) (block body)))`としてパースされます。

### Operators

演算子の多くは単なる関数呼び出しなので、ヘッド`call`でパースされます。ただし、一部の演算子は特殊形式（必ずしも関数呼び出しではありません）であり、その場合は演算子自体が式ヘッドになります。julia-parser.scmでは、これらを「構文演算子」と呼んでいます。一部の演算子（`+`と`*`）はN項パースを使い、連鎖した呼び出しはN個の引数を持つ単一の呼び出しとしてパースされます。比較の連鎖には、専用の式構造があります。

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

`(macrocall (|.| Core '@doc) (line) "some docs" (= (call f x) (block x)))`としてパースされます。

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

`using`は`import`と同じ表現ですが、式ヘッドは`:import`ではなく`:using`です。

`public`文をプログラムから作成するには、`Expr(:public, :a, :b)`を使うか、通常のコードに近い書き方として`Meta.parse("public a, b")`を使います。これは[current limitations on `public`](@ref Export-lists)のために必要です。`public`キーワードが認識されるのは、ファイル内の構文上の最上位（`parse_stmts`）またはモジュール内に限られます。この制限は、Julia 1.11で導入された際に、識別子として`public`を使っていた既存コードが壊れるのを防ぐために設けられました。

### Numbers

Juliaは多くのScheme実装よりも多様な数値型をサポートしているため、AST内ですべての数値がSchemeの数値として直接表現されるわけではありません。

| 入力                      | AST                                                      |
|:----------------------- |:-------------------------------------------------------- |
| `11111111111111111111`  | `(macrocall @int128_str nothing "11111111111111111111")` |
| `0xfffffffffffffffff`   | `(macrocall @uint128_str nothing "0xfffffffffffffffff")` |
| `1111...many digits...` | `(macrocall @big_str nothing "1111....")`                |

### Block forms

文のブロックは`(block stmt1 stmt2 ...)`としてパースされます。

if文は、

```julia
if a
    b
elseif c
    d
else
    e
end
```

次のようにパースされます。

```
(if a (block (line 2) b)
    (elseif (block (line 3) c) (block (line 4) d)
            (block (line 6) e)))
```

`while`ループは`(while condition body)`としてパースされます。

`for`ループは`(for (= var iter) body)`としてパースされます。反復指定が複数ある場合は、ブロックとしてパースされます。`(for (block (= v1 iter1) (= v2 iter2)) body)`

`break`と`continue`は、引数0個の式`(break)`と`(continue)`としてパースされます。

`let`は、`for`ループと同様に、`(let (= var val) body)`または`(let (block (= var1 val1) (= var2 val2) ...) body)`としてパースされます。

基本的な関数定義は`(function (call f x) body)`としてパースされます。より複雑な例を示します。

```julia
function f(x::T; k = 1) where T
    return x+1
end
```

これは次のようにパースされます。

```
(function (where (call f (parameters (kw k 1))
                       (:: x T))
                 T)
          (block (line 2) (return (call + x 1))))
```

型定義は、

```julia
mutable struct Foo{T<:S}
    x::T
end
```

次のようにパースされます。

```
(struct true (curly Foo (<: T S))
        (block (line 2) (:: x T)))
```

最初の引数は、その型が可変かどうかを示すブール値です。

`try`ブロックは`(try try_block var catch_block finally_block)`としてパースされます。`catch`の後に変数がない場合、`var`は`#f`になります。`finally`節がない場合、最後の引数は存在しません。

### Quote expressions

コード引用のためのJuliaのソース構文（`quote`と`:( )`）は、`$`による補間をサポートします。Lispの用語では、これらは実際には「バッククォート」または「準引用」形式です。内部的には、補間を行わないコード引用も必要です。JuliaのSchemeコードでは、補間なしの引用は式ヘッド`inert`で表されます。

`inert`式はJuliaの`QuoteNode`オブジェクトに変換されます。このオブジェクトは任意の型の値を1つ包み、評価されるとその値をそのまま返します。

引数がアトムである`quote`式も、`QuoteNode`に変換されます。

### Line numbers

ソース位置情報は`(line line_num file_name)`として表されます。3番目の要素は省略可能で、ファイル名は変わらず現在の行番号だけが変わる場合には省略されます。

Juliaでは、これらの式は`LineNumberNode`として表されます。

### Macros

マクロの衛生性は、式ヘッド`escape`と`hygienic-scope`の組み合わせで表されます。マクロ展開の結果は、新しいスコープの結果を表すため、自動的に`(hygienic-scope block module [lno])`で包まれます。呼び出し元のコードを補間するには、ユーザーがその内側に`(escape block)`を挿入できます。lnoは、指定されている場合、マクロの`__source__`引数です。

## Lowered form

低レベル形式（IR）は、型推論、インライン化などの最適化、コード生成に使われるため、コンパイラーにとってより重要です。一方、入力構文が大幅に組み替えられた結果であるため、人間には理解しにくい形式でもあります。

`Symbol`や一部の数値型に加えて、低レベル形式には次のデータ型があります。

  * `Expr`

    ノード型は`head`フィールドで示され、`args`フィールドには部分式の`Vector{Any}`が格納されます。表層ASTのほぼすべての要素は`Expr`で表されますが、IRで使われる`Expr`は限られており、主に呼び出しと一部の最上位専用形式に使われます。
  * `SlotNumber`

    引数とローカル変数を連番で識別します。整数値の`id`フィールドにスロットのインデックスが格納されます。各スロットの型は、その`CodeInfo`オブジェクトの`slottypes`フィールドで確認できます。
  * `Argument`

    `SlotNumber`と同じですが、最適化後にのみ現れます。参照先のスロットが、包含する関数の引数であることを示します。
  * `CodeInfo`

    文のグループのIRを包みます。`code`フィールドには、実行する式の配列が格納されます。
  * `GotoNode`

    無条件分岐です。引数は分岐先で、ジャンプ先となるコード配列内のインデックスで表されます。
  * `GotoIfNot`

    条件付き分岐です。`cond`フィールドがfalseと評価されると、`dest`フィールドで指定されたインデックスに移動します。
  * `ReturnNode`

    引数（`val`フィールド）を、包含する関数の戻り値として返します。`val`フィールドが未定義の場合、到達不能な文を表します。
  * `QuoteNode`

    任意の値をデータとして参照できるように包みます。たとえば、関数`f() = :a`には、`value`フィールドがシンボル`a`である`QuoteNode`が含まれています。これにより、シンボルを評価せずにそのまま返せます。
  * `GlobalRef`

    モジュール`mod`内のグローバル変数`name`を参照します。
  * `SSAValue`

    コンパイラーが挿入する、1から始まる連番の静的単一代入（SSA）変数を参照します。`SSAValue`の番号（`id`）は、その値を表す式のコード配列内のインデックスです。
  * `NewvarNode`

    変数（スロット）が作成される位置を示します。これにより、変数は未定義の状態にリセットされます。

### `Expr` types

これらのシンボルは、低レベル形式の[`Expr`](@ref)の`head`フィールドに現れます。

  * `call`

    関数呼び出し（動的ディスパッチ）です。呼び出す関数は`args[1]`、引数は`args[2:end]`です。
  * `invoke`

    関数呼び出し（静的ディスパッチ）です。呼び出すMethodInstanceは`args[1]`、引数は`args[2:end]`です。引数には、`args[2]`にある呼び出し対象の関数も含まれます。
  * `static_parameter`

    静的パラメーターをインデックスで参照します。
  * `=`

    代入です。IRでは、最初の引数は必ず`SlotNumber`または`GlobalRef`です。
  * `method`

    ジェネリック関数にメソッドを追加し、必要に応じて結果を割り当てます。

    引数1個の形式と引数3個の形式があります。引数1個の形式は、構文`function foo end`から生成されます。この形式の引数はシンボルです。そのシンボルが現在のスコープですでに関数を指している場合は何も起こりません。シンボルが未定義なら、新しい関数が作成され、そのシンボルで指定された識別子に割り当てられます。シンボルが定義済みでも関数以外を指している場合は、エラーになります。「関数を指す」とは、その束縛が定数であり、シングルトン型のオブジェクトを参照していることを意味します。シングルトン型のインスタンスは、メソッドを追加する型を一意に識別するため、このような仕様になっています。型にフィールドがある場合、メソッドをインスタンスに追加するのか、その型に追加するのかが明確でなくなるためです。

    引数3個の形式では、次の引数を取ります。

      * `args[1]`

        関数名。不明または不要な場合は`nothing`です。シンボルの場合、式はまず上記の引数1個の形式と同じ動作をします。その後、この引数は無視されます。型だけを基準にメソッドを追加する場合は`nothing`、`(::T)(x) = x`にできます。また、既存の関数にメソッドを追加する場合は`MyModule.f(x) = x`にできます。
      * `args[2]`

        引数型データの`SimpleVector`です。`args[2][1]`は引数型の`SimpleVector`、`args[2][2]`はメソッドの静的パラメーターに対応する型変数の`SimpleVector`です。
      * `args[3]`

        メソッド本体の`CodeInfo`です。「スコープ外」のメソッド定義（異なるスコープで定義されたメソッドも持つ関数へのメソッド追加）の場合、これは`:lambda`式を評価する式です。
  * `struct_type`

    新しい`struct`を定義する、引数7個の式です。

      * `args[1]`

        `struct`の名前
      * `args[2]`

        パラメーターを指定する`SimpleVector`を作成する`call`式
      * `args[3]`

        フィールド名を指定する`SimpleVector`を作成する`call`式
      * `args[4]`

        上位型を指定する`Symbol`、`GlobalRef`、または`Expr`（例：`:Integer`、`GlobalRef(Core, :Any)`、`:(Core.apply_type(AbstractArray, T, N))`）
      * `args[5]`

        フィールド型を指定する`SimpleVector`を作成する`call`式
      * `args[6]`

        Bool。`mutable`の場合はtrueです。
      * `args[7]`

        初期化する引数の数です。フィールド数、または内部コンストラクターの`new`文で呼び出されるフィールドの最小数になります。
  * `abstract_type`

    新しい抽象型を定義する、引数3個の式です。引数は`struct_type`式の第1、第2、第4引数と同じです。
  * `primitive_type`

    新しいプリミティブ型を定義する、引数4個の式です。第1、第2、第4引数は`struct_type`と同じです。第3引数はビット数です。

    !!! compat "Julia 1.5"
        `struct_type`、`abstract_type`、`primitive_type`はJulia 1.5で削除され、新しい組み込み関数の呼び出しに置き換えられました。
  * `global`

    グローバル束縛を宣言します。
  * `const`

    （グローバル）変数を定数として宣言します。
  * `new`

    新しい構造体風オブジェクトを割り当てます。最初の引数は型です。[`new`](@ref)疑似関数はこれに低レベル化され、型は常にコンパイラーによって挿入されます。これは完全に内部向けの機能であり、検査は行いません。任意の`new`式を評価すると、簡単にセグメンテーション違反が発生する可能性があります。
  * `splatnew`

    `new`と似ていますが、フィールド値を単一のタプルとして渡します。`new`が第一級関数だった場合の`splat(new)`と同様に動作するため、この名前が付いています。
  * `isdefined`

    `Expr(:isdefined, :x)`は、`x`が現在のスコープですでに定義されているかどうかを示すBoolを返します。
  * `the_exception`

    `jl_current_exception(ct)`が返す、`catch`ブロック内で捕捉された例外を取り出します。
  * `enter`

    例外ハンドラー（`setjmp`）に入ります。`args[1]`は、エラー発生時にジャンプするcatchブロックのラベルです。`pop_exception`が消費するトークンを返します。
  * `leave`

    例外ハンドラーを取り除きます。`args[1]`は、取り除くハンドラーの数です。
  * `pop_exception`

    catchブロックを抜ける際に、現在の例外スタックを、対応する`enter`時点の状態に戻します。`args[1]`には、対応する`enter`のトークンが格納されます。

    !!! compat "Julia 1.1"
        `pop_exception`はJulia 1.1で追加されました。
  * `inbounds`

    境界チェックの有効・無効を制御します。スタックが維持され、式の最初の引数がtrueまたはfalseの場合はその値がスタックに積まれます（`true`は境界チェックを無効にします）。最初の引数が`:pop`の場合は、スタックから値を取り除きます。
  * `boundscheck`

    `@inbounds`でマークされたコード領域にインライン化された場合は`false`、それ以外の場合は`true`の値になります。
  * `loopinfo`

    ループの終端を示します。メタデータを含み、`LowerSimdLoop`に渡されます。これにより、`@simd`式の内側のループを示すか、LLVMのループパスに情報を伝えます。
  * `copyast`

    準引用の実装の一部です。引数は表層構文ASTで、再帰的にそのままコピーされ、実行時に返されます。
  * `meta`

    メタデータです。`args[1]`は通常、メタデータの種類を示すシンボルで、残りの引数は任意です。よく使われるメタデータの種類は次のとおりです。

      * `:inline`と`:noinline`：インライン化のヒント。
  * `foreigncall`

    `ccall`情報を格納する、静的に計算されたコンテナーです。フィールドは次のとおりです。

      * `args[1]`：name

        外部関数用にパースされる式です。
      * `args[2]::Type`：RT

        リテラルの戻り値型です。包含するメソッドの定義時に静的に計算されます。
      * `args[3]::SimpleVector`（Types型）：AT

        リテラルの引数型ベクトルです。包含するメソッドの定義時に静的に計算されます。
      * `args[4]::Int`：nreq

        可変長引数関数の定義における必須引数の数です。
      * `args[5]::QuoteNode{<:Union{Symbol,Tuple{Symbol,UInt16}, Tuple{Symbol,UInt16,Bool}}`：呼び出し規約

        呼び出し規約と、必要に応じて効果を指定します。また、`gc_safe`（GCと並行して安全に実行可能）も指定できます。
      * `args[6:5+length(args[3])]`：arguments

        すべての引数の値です（各引数の型はargs[3]で指定されます）。
      * `args[6+length(args[3])+1:end]`：gc-roots

        呼び出し中にGCルートとして保持する必要がある追加オブジェクトです。これらがどこから導出され、どのように処理されるかについては[Working with LLVM](@ref Working-with-LLVM)を参照してください。
  * `new_opaque_closure`

    新しい不透明クロージャを構築します。フィールドは次のとおりです。

      * `args[1]`：signature

        不透明クロージャの関数シグネチャです。不透明クロージャはディスパッチには参加しませんが、入力型を制限できます。
      * `args[2]`：lb

        出力型の下限です（既定値は`Union{}`）。
      * `args[3]`：ub

        出力型の上限です（既定値は`Any`）。
      * `args[4]`：constprop

        不透明クロージャの同一性を定数伝播に利用できるかどうかを示します。`@opaque`マクロは既定でこれを有効にしますが、その場合、追加の推論が発生するため望ましくないことがあり、プリコンパイル中にコードを実行できなくなります。`args[4]`がメソッドの場合、この引数はスキップされたものと見なされます。
      * `args[5]`：method

        `opaque_closure_method`式として表される実際のメソッドです。
      * `args[6:end]`：captures

        不透明クロージャがキャプチャした値です。

    !!! compat "Julia 1.7"
        不透明クロージャはJulia 1.7で追加されました。

### [Method](@id ast-lowered-method)

単一のメソッドに共通するメタデータを記述する、一意化されたコンテナーです。

  * `name`、`module`、`file`、`line`、`sig`

    コンピューターと人間の双方がメソッドを一意に識別するためのメタデータです。
  * `ambig`

    このメソッドと曖昧になり得る他のメソッドのキャッシュです。
  * `specializations`

    このMethodに対して作成されたすべてのMethodInstanceのキャッシュです。一意性を保証するために使われます。一意性は、特にインクリメンタルなプリコンパイルやメソッド無効化の追跡において、効率上必要です。
  * `source`

    元のソースコード（利用可能な場合。通常は圧縮されています）。
  * `generator`

    特定のメソッドシグネチャに特化したソースを取得するために実行できる呼び出し可能オブジェクトです。
  * `roots`

    ASTに補間された、ASTの圧縮、型推論、またはネイティブコード生成に必要な、AST以外の要素へのポインターです。
  * `nargs`、`isva`、`called`、`is_for_opaque_closure`、

    このMethodのソースコードを説明するビットフィールドです。
  * `primary_world`

    このMethodを「所有する」ワールドエイジです。

### MethodInstance

Methodの単一の呼び出し可能シグネチャを記述する、一意化されたコンテナーです。これらのフィールドを安全に変更する方法については、特に[Proper maintenance and care of multi-threading locks](@ref Proper-maintenance-and-care-of-multi-threading-locks)を参照してください。

  * `specTypes`

    このMethodInstanceの主キーです。一意性は`def.specializations`による検索で保証されます。
  * `def`

    この関数が特殊化された元の`Method`です。トップレベルのLambdaがModule内で展開され、Methodの一部ではない場合は、`Module`になります。
  * `sparam_vals`

    `specTypes`内の静的パラメーターの値です。`Method.unspecialized`にある`MethodInstance`の場合、これは空の`SimpleVector`です。一方、`MethodTable`キャッシュから得られる実行時の`MethodInstance`では、常に定義済みで、インデックス参照が可能です。
  * `backedges`

    新しいメソッド定義の後に必要となるインクリメンタルな再解析・再コンパイル作業を効率よく追跡するため、キャッシュ依存関係の逆リストを保持します。これは、この`MethodInstance`への呼び出しの可能性を含むと推論または最適化された、他の`MethodInstance`のリストを保持することで実現します。最適化結果は`cache`内に保存されている場合もあれば、定数伝播のようにキャッシュしないことにした処理の結果である場合もあります。そのため、さまざまなキャッシュエントリーへのバックエッジをここにまとめます（通常、max_worldのセンチネル値を持つ該当キャッシュエントリーは1つだけです）。
  * `cache`

    このテンプレートのインスタンス化を共有する`CodeInstance`オブジェクトのキャッシュです。

### CodeInstance

  * `def`

    このキャッシュエントリーの元となった`MethodInstance`です。
  * `owner`

    この`CodeInstance`の所有者を表すトークンです。一致判定には`jl_egal`を使います。
  * `rettype`/`rettype_const`

    `specFunctionObject`フィールドの推論済み戻り値型です。多くの場合、関数全体の計算済み戻り値型でもあります。
  * `inferred`

    この関数の推論済みソースのキャッシュを含む場合があります。または、`rettype`が推論済みであることだけを示すために、`nothing`に設定される場合もあります。
  * `ftpr`

    汎用のjlcallエントリーポイントです。
  * `jlcall_api`

    `fptr`の呼び出しに使うABIです。主な値は次のとおりです。

      * 0 - まだコンパイルされていない
      * 1 - `JL_CALLABLE` `jl_value_t *(*)(jl_value_t *f, jl_value_t *args[nargs], uint32_t nargs)`
      * 2 - 定数（値は`rettype_const`に格納）
      * 3 - 静的パラメーターを転送する`jl_value_t *(*)(jl_svec_t *sparams, jl_value_t *f, jl_value_t *args[nargs], uint32_t nargs)`
      * 4 - インタープリターで実行する`jl_value_t *(*)(jl_method_instance_t *meth, jl_value_t *f, jl_value_t *args[nargs], uint32_t nargs)`
  * `min_world` / `max_world`

    このメソッドインスタンスを呼び出せるワールドエイジの範囲です。max_worldが特殊なトークン値`-1`の場合、値はまだ不明です。再検討が必要となるバックエッジに遭遇するまでは、引き続き使用できます。
  * 計時フィールド

      * `time_infer_total`：`inferred`を最初に計算した際の、開始から終了までの実時間コストです。
      * `time_infer_cache_saved`：キャッシュによって`time_infer_total`から節約されたコストです。これを`time_infer_total`に加えると、2つの実装間、または同一実装の時点間でコストを比較するための安定した推定値になります。キャッシュは繰り返し処理を効率よく扱うことが多いため、何かを推論する時間を過大評価する傾向があります。
      * `time_infer_self`：`inferred`に対するJulia推論の自己コスト（`time_infer_total`の一部）です。呼び出し先のキャッシュがすべて埋まっている場合に、このメソッド1つのコンパイルにかかる増分コストを表します。定数推論結果やLimitedAccuracyの結果も含みますが、これらは通常キャッシュされません。
      * `time_compile`：LLVM JITコンパイルの自己コストです（例：`inferred`から`invoke`を計算するコスト）。`edges`の内容をすべてたどり、循環参照と重複を考慮して合計すれば、総コストを推定できます（このフィールドには現在、測定済みのAOTコンパイル時間は含まれません）。

### CodeInfo

低レベル化済み（場合によっては推論済み）のソースコードを保持するための、通常は一時的なコンテナーです。

  * `code`

    文の`Any`配列です。
  * `slotnames`

    各スロット（引数またはローカル変数）の名前を示すシンボルの配列です。
  * `slotflags`

    スロットのプロパティをビットフラグで表した`UInt8`配列です。

      * 0x02 - 代入済み（この変数を左辺とする代入文が一切ない場合にのみfalse）
      * 0x08 - 使用済み（スロットの読み取りまたは書き込みがある場合）
      * 0x10 - 静的に一度だけ代入される
      * 0x20 - 代入前に使用される可能性がある。このフラグが有効なのは型推論後のみです。
  * `ssavaluetypes`

    配列または`Int`です。

    `Int`の場合、関数内でコンパイラーが挿入した一時領域の数（`code`配列の長さ）を示します。配列の場合は、各領域の型を指定します。
  * `ssaflags`

    関数内の各式に対応する、文レベルの32ビットフラグです。詳細はjulia.hの`jl_code_info_t`の定義を参照してください。

次のフィールドは、推論後（または一部の場合は生成関数によって）にのみ設定されます。

  * `debuginfo`

    各文のソース情報を取得するためのオブジェクトです。[How to interpret line numbers in a `CodeInfo` object](@ref)を参照してください。
  * `rettype`

    低レベル形式（IR）の推論済み戻り値型です。既定値は`Any`です。主に利便性のために存在します。OpaqueClosureの動作上、コード生成で使われる戻り値型とは限りません。
  * `parent`

    このオブジェクトを「所有する」`MethodInstance`です（該当する場合）。
  * `edges`

    無効化が必要なメソッドインスタンスへのフォワードエッジです。
  * `min_world`/`max_world`

    このコードが推論された時点で有効だったワールドエイジの範囲です。

オプションのフィールド：

  * `slottypes`

    スロットの型の配列です。
  * `method_for_inference_limit_heuristics`

    推論中に必要に応じて、`method_for_inference_heuristics`が指定されたメソッドのジェネレーターを展開します。

ブール型プロパティ：

  * `propagate_inbounds`

    インライン化時に`@inbounds`を伝播し、`@boundscheck`ブロックを省略するかどうかを示します。

`UInt8`の設定：

  * `constprop`、`inlineable`

      * 0 = ヒューリスティックを使用
      * 1 = 積極的
      * 2 = なし
  * `purity`：5つのビットフラグから構成されます。

      * 0x01 << 0 = このメソッドは一貫して戻るか終了することが保証される（`:consistent`）
      * 0x01 << 1 = このメソッドには、外部から意味的に観測可能な副作用がない（`:effect_free`）
      * 0x01 << 2 = このメソッドは例外を投げないことが保証される（`:nothrow`）
      * 0x01 << 3 = このメソッドは終了することが保証される（`:terminates_globally`）
      * 0x01 << 4 = このメソッド内の構文上の制御フローは終了することが保証される（`:terminates_locally`）

    詳細は`Base.@assume_effects`のドキュメントを参照してください。

#### How to interpret line numbers in a `CodeInfo` object

このデータには、一般的に2つの形式があります。1つは内部で使われ、データをある程度圧縮した形式、もう1つはコンパイラーで使われる形式です。基本情報は同じですが、コンパイラー版はすべて可変である一方、内部版は可変ではありません。

多くの利用側では、これらの詳細を個別に再実装する必要を避けるため、`Base.IRShow.buildLineInfoNode`、`Base.IRShow.append_scopes!`、または`Stacktraces.lookup(::InterpreterIP)`を呼び出せます。

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

  * `def`：この`DebugInfo`が定義された場所（たとえば、ファイルスコープの`Method`、`MethodInstance`、または`Symbol`）
  * `linetable`

    これを元に派生した別の`DebugInfo`です。実際の行番号はそこに格納され、このDebugInfoにはそのインデックスだけが含まれます。これによりコピーを避けられるだけでなく、行番号だけでなく、個々の文がソースから最適化後の形へどのように変換されたかも追跡できます。`def`がSymbolでない場合、そのオブジェクトが、概念上実行されている関数に関するメタデータの現在の関数オブジェクトに置き換わります（たとえば、Cassetteによる変換を考えてください）。以下で説明する`codelocs`の値も、行番号そのものではなく、このオブジェクト内の`codelocs`へのインデックスとして解釈されます。
  * `edges`：この関数にインライン化されたすべての関数について、一意なDebugInfoを格納するベクトルです（各DebugInfoには、その関数にインライン化されたすべての関数へのエッジも再帰的に含まれます）。
  * `firstline`（DebugInfoStreamに展開した場合）

    このコード定義の「開始」位置を示す`begin`文（または`function`や`quote`などのキーワード）に対応する行番号です。
  * `codelocs`（`DebugInfoStream`に展開した場合）

    IR内の各文に3つの値、ブロックの開始位置に1つの値を持つインデックスのベクトルです。各位置のスタックトレースを表します。

    1. `linetable.codelocs`フィールドへの整数インデックスです。各文（構文上のエッジを含む）に対応する元の位置を示します。0の場合は、直前に実行された文（必ずしも構文上または字句上で直前とは限りません）から行番号が変わっていないことを示します。`linetable`フィールドが`nothing`の場合は、行番号そのものを示します。
    2. `edges`への整数インデックスです。そこでインライン化された`DebugInfo`を示し、エッジがない場合は0です。
    3. （項目2が0以外の場合）`edges[].codelocs`への整数インデックスです。インライン化スタック内の各関数について再帰的に解釈します。0の場合は、行番号として`edges[].firstline`を使います。

    特殊コードは次のとおりです。

      * `(zero, zero, *)`：直前の文から行番号もエッジも変わっていません（構文上または字句上のどちらとして解釈してもかまいません）。インライン化の深さは変わっている場合がありますが、ほとんどの呼び出し側では無視できます。
      * `(zero, non-zero, *)`：行番号はなく、エッジのみです（通常、マクロ展開によってトップレベルコードになった場合）。
