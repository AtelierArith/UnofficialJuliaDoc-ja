# Julia ASTs

Juliaにはコードの2つの表現があります。まず、パーサーによって返される表面構文ASTがあります（例えば、[`Meta.parse`](@ref)関数）で、マクロによって操作されます。これは、文字ストリームから`julia-parser.scm`によって構築された、書かれたままのコードの構造化された表現です。次に、低下した形式、またはIR（中間表現）があります。これは型推論とコード生成に使用されます。低下した形式では、ノードの種類が少なく、すべてのマクロが展開され、すべての制御フローが明示的な分岐と文のシーケンスに変換されます。低下した形式は`julia-syntax.scm`によって構築されます。

最初にASTに焦点を当てます。なぜなら、マクロを書くために必要だからです。

## Surface syntax AST

フロントエンドのASTはほぼ完全に [`Expr`](@ref) と原子（例：シンボル、数値）で構成されています。一般的に、視覚的に異なる構文形式ごとに異なる式のヘッドがあります。例はs式構文で示されます。各括弧付きリストはExprに対応し、最初の要素がヘッドです。例えば、`(call f x)` はJuliaの `Expr(:call, :f, :x)` に対応します。

### Calls

| Input            | AST                                |
|:---------------- |:---------------------------------- |
| `f(x)`           | `(call f x)`                       |
| `f(x, y=1, z=2)` | `(call f x (kw y 1) (kw z 2))`     |
| `f(x; y=1)`      | `(call f (parameters (kw y 1)) x)` |
| `f(x...)`        | `(call f (... x))`                 |

`do` 構文:

```julia
f(x) do a,b
    body
end
```

`(do (call f x) (-> (tuple a b) (block body)))`として解析されます。

### Operators

ほとんどの演算子の使用は単なる関数呼び出しであるため、ヘッド `call` で解析されます。しかし、一部の演算子は特別な形式（必ずしも関数呼び出しではない）であり、その場合、演算子自体が式のヘッドとなります。julia-parser.scm では、これらは「構文演算子」と呼ばれています。一部の演算子（`+` と `*`）は N-ary 解析を使用し、連鎖した呼び出しは単一の N 引数呼び出しとして解析されます。最後に、比較の連鎖には独自の特別な式構造があります。

| Input       | AST                       |
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

| Input                    | AST                                             |
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

| Input         | AST                                          |
|:------------- |:-------------------------------------------- |
| `@m x y`      | `(macrocall @m (line) x y)`                  |
| `Base.@m x y` | `(macrocall (. Base (quote @m)) (line) x y)` |
| `@Base.m x y` | `(macrocall (. Base (quote @m)) (line) x y)` |

### Strings

| Input           | AST                                 |
|:--------------- |:----------------------------------- |
| `"a"`           | `"a"`                               |
| `x"y"`          | `(macrocall @x_str (line) "y")`     |
| `x"y"z`         | `(macrocall @x_str (line) "y" "z")` |
| `"x = $x"`      | `(string "x = " x)`                 |
| ``` `a b c` ``` | `(macrocall @cmd (line) "a b c")`   |

ドキュメント文字列の構文:

```julia
"some docs"
f(x) = x
```

`(macrocall (|.| Core '@doc) (line) "some docs" (= (call f x) (block x)))` として解析されます。

### Imports and such

| Input               | AST                                 |
|:------------------- |:----------------------------------- |
| `import a`          | `(import (. a))`                    |
| `import a.b.c`      | `(import (. a b c))`                |
| `import ...a`       | `(import (. . . . a))`              |
| `import a.b, c.d`   | `(import (. a b) (. c d))`          |
| `import Base: x`    | `(import (: (. Base) (. x)))`       |
| `import Base: x, y` | `(import (: (. Base) (. x) (. y)))` |
| `export a, b`       | `(export a b)`                      |

`using` は `import` と同じ表現を持ちますが、式の先頭が `:using` である代わりに `:import` です。

### Numbers

Juliaは多くのスキーム実装よりも多くの数値型をサポートしているため、すべての数値がAST内でスキーム数として直接表現されるわけではありません。

| Input                   | AST                                                      |
|:----------------------- |:-------------------------------------------------------- |
| `11111111111111111111`  | `(macrocall @int128_str nothing "11111111111111111111")` |
| `0xfffffffffffffffff`   | `(macrocall @uint128_str nothing "0xfffffffffffffffff")` |
| `1111...many digits...` | `(macrocall @big_str nothing "1111....")`                |

### Block forms

ブロックのステートメントは `(block stmt1 stmt2 ...)` として解析されます。

If 文:

```julia
if a
    b
elseif c
    d
else
    e
end
```

解析として：

```
(if a (block (line 2) b)
    (elseif (block (line 3) c) (block (line 4) d)
            (block (line 6 e))))
```

`while` ループは `(while condition body)` として解析されます。

`for` ループは `(for (= var iter) body)` として解析されます。イテレーション仕様が複数ある場合、それらはブロックとして解析されます: `(for (block (= v1 iter1) (= v2 iter2)) body)`。

`break` と `continue` は0引数の式として解析されます `(break)` と `(continue)`。

`let` は `(let (= var val) body)` または `(let (block (= var1 val1) (= var2 val2) ...) body)` として解析されます。これは `for` ループのようなものです。

基本的な関数定義は `(function (call f x) body)` として解析されます。より複雑な例:

```julia
function f(x::T; k = 1) where T
    return x+1
end
```

解析として：

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

解析として：

```
(struct true (curly Foo (<: T S))
        (block (line 2) (:: x T)))
```

最初の引数は、その型がミュータブルかどうかを示すブール値です。

`try` ブロックは `(try try_block var catch_block finally_block)` として解析されます。`catch` の後に変数がない場合、`var` は `#f` です。`finally` 節がない場合、最後の引数は存在しません。

### Quote expressions

Juliaのソース構文形式は、コード引用（`quote`および`:( )`）に対して`$`を使った補間をサポートしています。Lispの用語で言うと、これは実際には「バッククォート」または「クォジクォート」形式です。内部的には、補間なしのコード引用の必要性もあります。Juliaのスキームコードでは、補間しない引用は式のヘッド`inert`で表されます。

`inert` 表現は Julia の `QuoteNode` オブジェクトに変換されます。これらのオブジェクトは任意の型の単一の値をラップし、評価されると単にその値を返します。

引数が原子である `quote` 式も `QuoteNode` に変換されます。

### Line numbers

ソース位置情報は `(line line_num file_name)` の形式で表され、第三のコンポーネントはオプションです（現在の行番号が変わる場合にのみ省略され、ファイル名は省略されません）。

これらの表現は、Juliaの`LineNumberNode`として表されます。

### Macros

マクロの衛生状態は、`escape` と `hygienic-scope` という表現を通じて表されます。マクロ展開の結果は自動的に `(hygienic-scope block module)` でラップされ、新しいスコープの結果を表します。ユーザーは、呼び出し元からコードを補間するために、内部に `(escape block)` を挿入することができます。

## Lowered form

低い形式 (IR) はコンパイラにとってより重要です。なぜなら、型推論、インライン化のような最適化、コード生成に使用されるからです。また、入力構文の大幅な再配置から生じるため、人間にとってはあまり明白ではありません。

`Symbol`やいくつかの数値型に加えて、以下のデータ型が低下した形式で存在します：

  * `Expr`

    `head`フィールドによって示されるノードタイプを持ち、`args`フィールドはサブ式の`Vector{Any}`です。表面ASTのほぼすべての部分は`Expr`で表されますが、IRは主に呼び出しと一部のトップレベル専用の形式のために限られた数の`Expr`のみを使用します。
  * `スロット番号`

    引数とローカル変数を連続番号で識別します。スロットインデックスを示す整数値の `id` フィールドがあります。これらのスロットの型は、それらの `CodeInfo` オブジェクトの `slottypes` フィールドで見つけることができます。
  * `引数`

    `SlotNumber`と同じですが、最適化後のみ表示されます。参照されているスロットが囲んでいる関数の引数であることを示します。
  * `CodeInfo`

    一連のステートメントのIRをラップします。その`code`フィールドは実行する式の配列です。
  * `GotoNode`

    無条件分岐。引数は分岐先であり、ジャンプするコード配列内のインデックスとして表されます。
  * `GotoIfNot`

    条件分岐。`cond` フィールドが false に評価される場合、`dest` フィールドによって識別されるインデックスに移動します。
  * `ReturnNode`

    引数（`val`フィールド）を囲む関数の値として返します。`val`フィールドが未定義の場合、これは到達不可能なステートメントを表します。
  * `QuoteNode`

    任意の値をデータとして参照するためにラップします。例えば、関数 `f() = :a` は、`value` フィールドがシンボル `a` である `QuoteNode` を含んでおり、それによってシンボル自体を評価するのではなく返します。
  * `GlobalRef`

    モジュール `mod` のグローバル変数 `name` を参照します。
  * `SSAValue`

    コンパイラによって挿入された、連続番号（1から始まる）の静的単一代入（SSA）変数を指します。`SSAValue`の番号（`id`）は、それが表す式の値のコード配列インデックスです。
  * `NewvarNode`

    変数（スロット）が作成されるポイントを示します。これにより、変数が未定義にリセットされる効果があります。

### `Expr` types

これらの記号は、[`Expr`](@ref)の`head`フィールドに小文字で表示されます。

  * `call`

    関数呼び出し（動的ディスパッチ）。 `args[1]` は呼び出す関数で、 `args[2:end]` は引数です。
  * `invoke`

    関数呼び出し（静的ディスパッチ）。 `args[1]` は呼び出す MethodInstance で、 `args[2:end]` は引数です（呼び出される関数は `args[2]` にあります）。
  * `static_parameter`

    インデックスで静的パラメータを参照します。
  * `=`

    課題。IRでは、最初の引数は常に`SlotNumber`または`GlobalRef`です。
  * `メソッド`

    汎用関数にメソッドを追加し、必要に応じて結果を割り当てます。

    1引数形式と3引数形式があります。1引数形式は、構文 `function foo end` から生じます。1引数形式では、引数はシンボルです。このシンボルが現在のスコープ内で既に関数の名前として使われている場合、何も起こりません。シンボルが未定義の場合、新しい関数が作成され、そのシンボルで指定された識別子に割り当てられます。シンボルが定義されているが非関数の名前を持っている場合、エラーが発生します。「関数の名前を持つ」という定義は、バインディングが定数であり、シングルトン型のオブジェクトを参照することを意味します。これは、シングルトン型のインスタンスがメソッドを追加する型を一意に識別するためです。型にフィールドがある場合、メソッドがインスタンスに追加されるのか、その型に追加されるのかは明確ではありません。

    3つの引数形式には、以下の引数があります：

      * `args[1]`

        関数名、または不明または不要な場合は`nothing`。シンボルの場合、式は最初に上記の1引数形式のように振る舞います。この引数はその後無視されます。型によって厳密にメソッドが追加される場合は`nothing`であることができます、`(::T)(x) = x`、または既存の関数にメソッドが追加される場合、`MyModule.f(x) = x`。
      * `args[2]`

        `data`型の`SimpleVector`。`args[2][1]`は引数の型の`SimpleVector`であり、`args[2][2]`はメソッドの静的パラメータに対応する型変数の`SimpleVector`です。
      * `args[3]`

        メソッド自体の `CodeInfo`。スコープ外のメソッド定義（異なるスコープで定義されたメソッドを持つ関数にメソッドを追加する）に対して、これは `:lambda` 式に評価される式です。
  * `struct_type`

    7つの引数を持つ新しい `struct` を定義する式：

      * `args[1]`

        `struct`の名前
      * `args[2]`

        `SimpleVector`のパラメータを指定する`call`式
      * `args[3]`

        `call` 式は、フィールド名を指定して `SimpleVector` を作成します。
      * `args[4]`

        `Symbol`、`GlobalRef`、または`Expr`で、スーパタイプを指定します（例：`:Integer`、`GlobalRef(Core, :Any)`、または`:(Core.apply_type(AbstractArray, T, N))`）
      * `args[5]`

        `call` 式は、そのフィールドタイプを指定して `SimpleVector` を作成します。
      * `args[6]`

        `mutable`の場合はtrueのBool
      * `args[7]`

        初期化に必要な引数の数。これはフィールドの数、または内部コンストラクタの `new` ステートメントによって呼び出される最小限のフィールドの数になります。
  * `abstract_type`

    3つの引数を持つ式は、新しい抽象型を定義します。引数は `struct_type` 式の引数1、2、および4と同じです。
  * `primitive_type`

    4つの引数を持つ式は、新しいプリミティブ型を定義します。引数1、2、および4は`struct_type`と同じです。引数3はビット数です。

    !!! compat "Julia 1.5"
        `struct_type`、`abstract_type`、および `primitive_type` はJulia 1.5で削除され、新しいビルトイン関数への呼び出しに置き換えられました。
  * `グローバル`

    グローバルバインディングを宣言します。
  * `const`

    定数として（グローバル）変数を宣言します。
  * `new`

    新しい構造体のようなオブジェクトを割り当てます。最初の引数は型です。[`new`](@ref) 擬似関数はこれに変換され、型は常にコンパイラによって挿入されます。これは非常に内部専用の機能であり、チェックは行われません。任意の `new` 式を評価すると、簡単にセグメンテーションフォルトが発生する可能性があります。
  * `splatnew`

    `new`と似ていますが、フィールド値は単一のタプルとして渡されます。`new`がファーストクラスの関数であった場合の`splat(new)`と同様に動作します。したがって、この名前が付けられています。
  * `isdefined`

    `Expr(:isdefined, :x)` は、`x` が現在のスコープで既に定義されているかどうかを示す Bool を返します。
  * `the_exception`

    `catch` ブロック内で捕捉された例外を返します。これは `jl_current_exception(ct)` によって返されます。
  * `enter`

    例外ハンドラ（`setjmp`）に入ります。`args[1]`はエラー時にジャンプするキャッチブロックのラベルです。`pop_exception`によって消費されるトークンを生成します。
  * `leave`

    ポップ例外ハンドラー。 `args[1]` はポップするハンドラーの数です。
  * `pop_exception`

    キャッチブロックを出るときに、現在の例外のスタックを関連する `enter` の状態に戻します。 `args[1]` には関連する `enter` からのトークンが含まれています。

    !!! compat "Julia 1.1"
        `pop_exception`はJulia 1.1で新しく追加されました。
  * `inbounds`

    境界チェックをオンまたはオフにするコントロール。スタックが維持されます。この式の最初の引数が真または偽である場合（`true`は境界チェックが無効であることを意味します）、それはスタックにプッシュされます。最初の引数が`:pop`の場合、スタックがポップされます。
  * `boundscheck`

    `@inbounds`でマークされたコードのセクションにインライン化された場合は`false`の値を持ち、それ以外の場合は`true`の値を持ちます。
  * `loopinfo`

    ループの終了を示します。`LowerSimdLoop`に渡されるメタデータを含み、`@simd`式の内部ループをマークするか、LLVMループパスに情報を伝播させるために使用されます。
  * `copyast`

    クォジクォートの実装の一部です。引数は表面構文ASTであり、単純に再帰的にコピーされ、実行時に返されます。
  * `メタ`

    メタデータ。 `args[1]` は通常、メタデータの種類を指定するシンボルであり、残りの引数は自由形式です。一般的に使用されるメタデータの種類は次のとおりです：

      * `:inline` と `:noinline`: インラインヒント。
  * `foreigncall`

    `ccall` 情報のための静的に計算されたコンテナです。フィールドは次のとおりです：

      * `args[1]` : 名前

        外国関数のために解析される式。
      * `args[2]::Type` : RT

        含まれているメソッドが定義されたときに静的に計算される（リテラル）戻り値の型。
      * `args[3]::SimpleVector` (の型) : AT

        含まれているメソッドが定義されたときに静的に計算された引数タイプの（リテラル）ベクター。
      * `args[4]::Int` : nreq

        可変引数関数定義に必要な引数の数。
      * `args[5]::QuoteNode{<:Union{Symbol,Tuple{Symbol,UInt16}, Tuple{Symbol,UInt16,Bool}}`: 呼び出し規約

        呼び出し規約は、呼び出しのためのもので、オプションで効果を持ち、`gc_safe`（GCと同時に実行しても安全）です。
      * `args[6:5+length(args[3])]` : 引数

        すべての引数の値（各引数の型はargs[3]に示されています）。
      * `args[6+length(args[3])+1:end]` : gc-ルーツ

        呼び出しの期間中にgc-rootedされる必要がある追加のオブジェクト。これらがどこから派生し、どのように処理されるかについては、[Working with LLVM](@ref Working-with-LLVM)を参照してください。
  * `new_opaque_closure`

    新しい不透明なクロージャを構築します。フィールドは次のとおりです：

      * `args[1]` : シグネチャ

        不透明クロージャの関数シグネチャ。不透明クロージャはディスパッチに参加しませんが、入力タイプは制限できます。
      * `args[2]` : lb

        出力タイプの下限。（デフォルトは `Union{}`）
      * `args[3]` : ub

        出力タイプの上限。（デフォルトは `Any`）
      * `args[4]` : constprop

        不透明クロージャの識別子が定数伝播に使用できるかどうかを示します。`@opaque`マクロはデフォルトでこれを有効にしますが、これにより追加の推論が発生し、望ましくない場合があり、プリコンパイル中にコードが実行されるのを妨げます。`args[4]`がメソッドである場合、引数はスキップされたと見なされます。
      * `args[5]` : メソッド

        `opaque_closure_method` 表現としての実際のメソッド。
      * `args[6:end]` : キャプチャ

        不透明クロージャによってキャプチャされた値。

    !!! compat "Julia 1.7"
        ジュリア1.7で不透明クロージャが追加されました。

### [Method](@id ast-lowered-method)

単一のメソッドに対する共有メタデータを説明するユニークなコンテナ。

  * `名前`, `モジュール`, `ファイル`, `行`, `シグ`

    コンピュータと人間のためにメソッドを一意に識別するメタデータ。
  * `ambig`

    このメソッドと曖昧な可能性のある他のメソッドのキャッシュ。
  * `専門分野`

    このメソッドのために作成されたすべてのMethodInstanceのキャッシュで、ユニーク性を確保するために使用されます。ユニーク性は効率のために必要であり、特にインクリメンタルプリコンパイルやメソッドの無効化の追跡において重要です。
  * `source`

    元のソースコード（利用可能な場合、通常は圧縮されています）。
  * `generator`

    特定のメソッドシグネチャに対して特化したソースを取得するために実行可能な呼び出し可能オブジェクト。
  * `ルーツ`

    ASTに補間された非ASTのものへのポインタで、ASTの圧縮、型推論、またはネイティブコードの生成に必要です。
  * `nargs`、`isva`、`called`、`is_for_opaque_closure`、

    このメソッドのソースコードに対する説明的ビットフィールド。
  * `primary_world`

    このメソッドを「所有する」世界の年齢。

### MethodInstance

ユニークなコンテナで、メソッドの単一の呼び出し可能なシグネチャを説明します。特に [Proper maintenance and care of multi-threading locks](@ref Proper-maintenance-and-care-of-multi-threading-locks) を参照して、これらのフィールドを安全に変更する方法に関する重要な詳細を確認してください。

  * `specTypes`

    このMethodInstanceの主キー。ユニーク性は`def.specializations`のルックアップを通じて保証されます。
  * `def`

    この関数が記述する`Method`の特殊化。あるいは、これはモジュール内で展開されたトップレベルのラムダであり、メソッドの一部ではない場合の`Module`。
  * `sparam_vals`

    `specTypes`の静的パラメータの値。`Method.unspecialized`の`MethodInstance`では、これは空の`SimpleVector`です。しかし、`MethodTable`キャッシュからのランタイム`MethodInstance`の場合、これは常に定義されており、インデックス可能です。
  * `バックエッジ`

    キャッシュ依存関係の逆リストを保存して、新しいメソッド定義の後に必要になる可能性のあるインクリメンタルな再解析/再コンパイル作業を効率的に追跡します。これは、他の `MethodInstance` のリストを保持することによって機能し、これらはこの `MethodInstance` への呼び出しを含む可能性があると推測または最適化されています。これらの最適化結果は、`cache` のどこかに保存されているか、定数伝播のようにキャッシュしたくない何かの結果である可能性があります。したがって、ここでさまざまなキャッシュエントリへのすべてのバックエッジをマージします（適用可能なキャッシュエントリはほぼ常に1つだけで、max_worldのためのセンチネル値があります）。
  * `キャッシュ`

    このテンプレートインスタンスを共有する `CodeInstance` オブジェクトのキャッシュ。

### CodeInstance

  * `def`

    このキャッシュエントリが派生した`MethodInstance`。
  * `オーナー`

    この `CodeInstance` の所有者を表すトークンです。`jl_egal` を使用して一致させます。

  * `rettype`/`rettype_const`

    `specFunctionObject` フィールドの推測される戻り値の型は、一般的に関数の計算された戻り値の型でもあります。
  * `推測された`

    この関数の推測されたソースのキャッシュを含む場合があります。または、`rettype` が推測されていることを示すために `nothing` に設定されることもあります。
  * `ftpr`

    汎用のjlcallエントリーポイント。
  * `jlcall_api`

    `fptr`を呼び出す際に使用するABI。重要なものには以下が含まれます：

      * 0 - まだコンパイルされていません
      * 1 - `JL_CALLABLE` `jl_value_t *(*)(jl_function_t *f, jl_value_t *args[nargs], uint32_t nargs)`
      * 2 - 定数（`rettype_const`に格納された値）
      * 3 - 静的パラメータを転送した `jl_value_t *(*)(jl_svec_t *sparams, jl_function_t *f, jl_value_t *args[nargs], uint32_t nargs)`
      * 4 - インタープリタで実行 `jl_value_t *(*)(jl_method_instance_t *meth, jl_function_t *f, jl_value_t *args[nargs], uint32_t nargs)`
  * `min_world` / `max_world`

    このメソッドインスタンスが呼び出されるのに有効な世界の年齢の範囲。もし `max_world` が特別なトークン値 `-1` であれば、その値はまだ知られていません。再考を必要とするバックエッジに遭遇するまで、引き続き使用される可能性があります。
  * タイミングフィールド

      * `time_infer_total`: 推論の合計コストで、開始から終了までの実時間として元々計算されます。
      * `time_infer_cache_saved`: キャッシングによって `time_infer_total` から節約されたコスト。これを `time_infer_total` に加えることで、2つの実装のコストや1つの実装の時間経過によるコストを比較するための安定した推定値が得られます。これは一般的に、何かを推論するための時間の過大評価となります。なぜなら、キャッシュは繰り返しの作業を処理するのに頻繁に効果的だからです。
      * `time_infer_self`: `inferred` のための Julia 推論の自己コスト（`time_infer_total` の一部）。これは、すべての呼び出しターゲットの完全に埋められたキャッシュが与えられた場合、この1つのメソッドをコンパイルするための増分コストに過ぎません。これには、一般的にキャッシュには含まれない定数推論結果や LimitedAccuracy 結果も含まれます。
      * `time_compile`: llvm JIT コンパイルの自己コスト（例：`inferred` から `invoke` を計算すること）。総コストの推定は、すべての `edges` コンテンツを歩き回り、それらを合計し、サイクルや重複を考慮することで計算できます。（このフィールドには現在、測定された AOT コンパイル時間は含まれていません。）

### CodeInfo

ソースコードを保持するための（通常は一時的な）コンテナで、低下した（おそらく推測された）コードを含むことがあります。

  * `コード`

    `Any` ステートメントの配列
  * `スロット名`

    スロット（引数またはローカル変数）ごとの名前を付けるシンボルの配列。
  * `slotflags`

    スロットプロパティの `UInt8` 配列、ビットフラグとして表現されます：

      * 0x02 - 割り当て済み（この変数が左側にある割り当て文が*ない*場合のみ偽）
      * 0x08 - 使用済み（スロットの読み取りまたは書き込みがある場合）
      * 0x10 - 一度静的に割り当てられた
      * 0x20 - 割り当てられる前に使用される可能性があります。このフラグは型推論の後にのみ有効です。
  * `ssavaluetypes`

    配列または`Int`。

    `Int`の場合、関数内のコンパイラによって挿入された一時的な場所の数（`code`配列の長さ）を示します。配列の場合、各場所の型を指定します。
  * `ssaflags`

    関数内の各式に対するステートメントレベルの32ビットフラグ。詳細については、julia.hの`jl_code_info_t`の定義を参照してください。

これらは推論後（または場合によっては生成された関数によって）のみ populated されます：

  * `debuginfo`

    オブジェクトは、各ステートメントのソース情報を取得するためのもので、[How to interpret line numbers in a `CodeInfo` object](@ref)を参照してください。
  * `rettype`

    低下された形式（IR）の推測された戻り値の型。デフォルト値は `Any` です。これは主に便利さのために存在します。なぜなら（OpaqueClosures の動作のために）必ずしもコード生成で使用される戻り値の型ではないからです。
  * `親`

    このオブジェクトを「所有する」`MethodInstance`（該当する場合）。
  * `edges`

    メソッドインスタンスを無効にする必要があるフォワードエッジ。
  * `min_world`/`max_world`

    このコードが推測された時点で有効だった世界の年齢の範囲。

オプションフィールド:

  * `スロットタイプ`

    スロットのための型の配列。
  * `method_for_inference_limit_heuristics`

    `method_for_inference_heuristics` は、推論中に必要に応じて指定されたメソッドのジェネレーターを拡張します。

ブールプロパティ:

  * `propagate_inbounds`

    この内容が、`@boundscheck` ブロックを省略する目的でインライン化されたときに `@inbounds` を伝播させるべきかどうか。

`UInt8` 設定:

  * `constprop`、`inlineable`

      * 0 = ヒューリスティックを使用する
      * 1 = 攻撃的
      * 2 = なし
  * `purity` は5つのビットフラグから構成されています:

      * 0x01 << 0 = このメソッドは一貫して返すか、または終了することが保証されています (`:consistent`)
      * 0x01 << 1 = このメソッドは外部から意味的に見える副作用がない (`:effect_free`)
      * 0x01 << 2 = このメソッドは例外をスローしないことが保証されています (`:nothrow`)
      * 0x01 << 3 = このメソッドは終了することが保証されています (`:terminates_globally`)
      * 0x01 << 4 = このメソッド内の構文制御フローは終了することが保証されています (`:terminates_locally`)

    `Base.@assume_effects`の詳細については、ドキュメントを参照してください。

#### How to interpret line numbers in a `CodeInfo` object

このデータには2つの一般的な形式があります：内部で使用される形式はデータを多少圧縮し、コンパイラで使用される形式です。両者は基本的な情報は同じですが、コンパイラ版はすべて可変であり、内部で使用される版はそうではありません。

多くの消費者は、`Base.IRShow.buildLineInfoNode`、`Base.IRShow.append_scopes!`、または`Stacktraces.lookup(::InterpreterIP)`を呼び出すことで、これらの詳細を特に（再）実装する必要がなくなるかもしれません。

これらのそれぞれの定義は次のとおりです：

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

  * `def` : この `DebugInfo` が定義された場所（例えば、ファイルスコープの `Method`、`MethodInstance`、または `Symbol`）
  * `linetable`

    別の `DebugInfo` から派生したもので、実際の行番号を含んでおり、この `DebugInfo` にはそれへのインデックスのみが含まれています。これによりコピーを作成することを避けるとともに、各個別のステートメントがソースから最適化されたものにどのように変換されたかを追跡することが可能になります。`def` がシンボルでない場合、そのオブジェクトは現在の関数オブジェクトを置き換え、概念的に実行されている関数に関するメタデータを提供します（例：ここでの Cassette 変換を考えてください）。以下に説明する `codelocs` の値も、このオブジェクト内の `codelocs` へのインデックスとして解釈され、行番号そのものではありません。
  * `edges` : この関数にインライン化されたすべての関数のユニークな DebugInfo のベクター（それらにインライン化されたすべてのもののエッジを再帰的に持つ）。
  * `firstline` (デバッグ情報ストリームに展開されたとき)

    このコード定義が「開始」する場所を示す `begin` ステートメント（または `function` や `quote` などの他のキーワード）に関連付けられた行番号。
  * `codelocs`（`DebugInfoStream`に展開された場合）

    スタックトレースをそのポイントから説明するためのブロックの開始点に対して、IR内の各ステートメントに対して3つの値を持つインデックスのベクター：

    1. `linetable.codelocs` フィールドへの整数インデックスで、各ステートメントに関連付けられた元の位置を示します（その構文的エッジを含む）。また、前に実行されたステートメントから行番号に変更がないことを示すゼロ、または `linetable` フィールドが `nothing` の場合は行番号自体を示します。
    2. `edges`への整数インデックスで、そこにインラインされた`DebugInfo`を示します。エッジがない場合はゼロです。
    3. （エントリ2がゼロでない場合）`edges[].codelocs`への整数インデックスで、インラインスタック内の各関数について再帰的に解釈するためのもので、ゼロは`edges[].firstline`を行番号として使用することを示します。

    特別なコードには次のものが含まれます：

      * `(zero, zero, *)`: 前のステートメントから行番号やエッジに変更はありません（これは文法的または語彙的に解釈することができます）。インラインの深さも変わっている可能性がありますが、ほとんどの呼び出し元はそれを無視するべきです。
      * `(ゼロ, 非ゼロ, *)` : 行番号なし、エッジのみ（通常はトップレベルコードへのマクロ展開のため）。
