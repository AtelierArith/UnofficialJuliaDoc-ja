```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/docs/src/index.md"
```

# The Julia REPL

Juliaには、`julia`実行ファイルに組み込まれた、機能豊富な対話型コマンドラインREPL（read-eval-print loop）が付属しています。Juliaの文をすばやく簡単に評価できるだけでなく、検索可能な履歴、タブ補完、便利なキーバインド、専用のヘルプモードとシェルモードも備えています。引数を指定せずに`julia`を呼び出すか、実行ファイルをダブルクリックするだけでREPLを起動できます。

```@eval
using REPL
io = IOBuffer()
REPL.banner(io)
banner = String(take!(io))
import Markdown
Markdown.parse("```\n\$ julia\n\n$(banner)\njulia>\n```")
```

対話セッションを終了するには、`^D`（空行でControlキーと`d`キーを同時に押す）と入力するか、`exit()`と入力してReturnキーまたはEnterキーを押します。REPLがバナーと`julia>`プロンプトを表示します。

## The different prompt modes

### The Julian mode

REPLには、主に5つの動作モードがあります。最も一般的なのはJuliaプロンプトで、デフォルトのモードです。新しい行は通常、`julia>`で始まります。ここにJuliaの式を入力します。式を入力し終えてReturnキーまたはEnterキーを押すと、その式が評価され、最後の式の結果が表示されます。

```jldoctest
julia> string(1 + 2)
"3"
```

対話的な作業に便利な機能もいくつかあります。REPLは結果を表示するだけでなく、その結果を変数`ans`にも束縛します。行末にセミコロンを付けると、結果の表示を抑制できます。

```jldoctest
julia> string(3 * 4);

julia> ans
"12"
```

Juliaモードでは、「プロンプト貼り付け」と呼ばれる機能が使えます。`julia>`で始まるテキストをREPLに貼り付けると、この機能が有効になります。この場合、`julia>`で始まる式（および他のREPLモードのプロンプトである`shell>`、`help?>`、`pkg>`）だけが解析され、それ以外は削除されます。そのため、プロンプトや出力を取り除かなくても、REPLセッションからコピーしたテキストをまとめて貼り付けられます。この機能はデフォルトで有効ですが、`REPL.enable_promptpaste(::Bool)`でいつでも無効化または有効化できます。有効な場合は、この段落の上にあるコードブロックをそのままREPLに貼り付けて試せます。標準のWindowsコマンドプロンプトでは、貼り付けが行われたことを検出する機能に制限があるため、この機能は動作しません。

式の実行結果が[`nothing`](@ref)でない場合、REPLは特定の[`IOContext`](@ref)を指定して[`show`](@ref)関数を使い、結果を表示します（[`display`](@ref)経由で指定されます。デフォルトでは`show(io, MIME("text/plain"), ans)`を呼び出し、さらにそのデフォルトは`show(io, ans)`です）。特に、`:limit`属性は`true`に設定されます。`show`メソッドによっては、`:compact`のように、まだ設定されていない属性にデフォルト値が設定されることもあります。実験的な機能として、`Base.active_repl.options.iocontext`辞書を使い、REPLで使用する属性とその値を指定できます。たとえば、次のようにします。

```julia-repl
julia> rand(2, 2)
2×2 Matrix{Float64}:
 0.8833    0.329197
 0.719708  0.59114

julia> show(IOContext(stdout, :compact => false), "text/plain", rand(2, 2))
 0.43540323669187075  0.15759787870609387
 0.2540832269192739   0.4597637838786053
julia> Base.active_repl.options.iocontext[:compact] = false;

julia> rand(2, 2)
2×2 Matrix{Float64}:
 0.2083967319174056  0.13330606013126012
 0.6244375177790158  0.9777957560761545
```

起動時にこの辞書の値を自動的に定義するには、たとえば`~/.julia/config/startup.jl`ファイルで[`atreplinit`](@ref)関数を使います。

```julia
atreplinit() do repl
    repl.options.iocontext[:compact] = false
end
```

### Help mode

カーソルが行頭にあるときに`?`と入力すると、プロンプトをヘルプモードに切り替えられます。ヘルプモードで入力した内容について、Juliaはヘルプやドキュメントの表示を試みます。

```julia-repl
julia> ? # upon typing ?, the prompt changes (in place) to: help?>

help?> string
search: string String Cstring Cwstring RevString randstring bytestring SubString

  string(xs...)

  Create a string from any values using the print function.
```

マクロ、型、変数についても問い合わせることができます。

```
help?> @time
  @time

  A macro to execute an expression, printing the time it took to execute, the number of allocations,
  and the total number of bytes its execution caused to be allocated, before returning the value of the
  expression.

  See also @timev, @timed, @elapsed, and @allocated.

help?> Int32
search: Int32 UInt32

  Int32 <: Signed

  32-bit signed integer type.
```

文字列リテラルまたは正規表現リテラルを入力すると、[`apropos`](@ref)を使ってすべてのdocstringを検索できます。

```
help?> "aprop"
REPL.stripmd
Base.Docs.apropos

help?> r"ap..p"
Base.:∘
Base.shell_escape_posixly
Distributed.CachingPool
REPL.stripmd
Base.Docs.apropos
```

ヘルプモードでは、拡張docstringにもアクセスできます。たとえば、`?Print`ではなく`??Print`と入力すると、ソースコードのドキュメントにある`# Extended help`セクションが表示されます。

ヘルプモードを終了するには、行頭でBackspaceキーを押します。

### [Shell mode](@id man-shell-mode)

ヘルプモードでドキュメントをすばやく参照できるのと同様に、システムシェルを使ってシステムコマンドを実行することもよくあります。行頭で`?`を入力するとヘルプモードに切り替わりますが、セミコロン（`;`）を入力するとシェルモードに切り替わります。シェルモードは、行頭でBackspaceキーを押すと終了できます。

```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> echo hello
hello
```

!!! note
    Windowsユーザーの場合、JuliaのシェルモードからWindowsのシェルコマンドを実行することはできません。そのため、次のコマンドは失敗します。


```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> dir
ERROR: IOError: could not spawn `dir`: no such file or directory (ENOENT)
Stacktrace!
.......
```

ただし、次のようにすれば`PowerShell`を利用できます。

```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.
PS C:\Users\elm>
```

また、`dir`コマンドを使えば、次のように`cmd.exe`も利用できます。

```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> cmd
Microsoft Windows [version 10.0.17763.973]
(c) 2018 Microsoft Corporation. All rights reserved.
C:\Users\elm>dir
 Volume in drive C has no label
 Volume Serial Number is 1643-0CD7
  Directory of C:\Users\elm

29/01/2020  22:15    <DIR>          .
29/01/2020  22:15    <DIR>          ..
02/02/2020  08:06    <DIR>          .atom
```

### Pkg mode

パッケージマネージャーモードでは、パッケージの読み込みや更新に特化したコマンドを使えます。Julia REPLのプロンプトで`]`キーを押すとこのモードに入り、CTRL-Cまたは行頭でBackspaceキーを押すと終了します。このモードのプロンプトは`pkg>`です。専用のヘルプモードもあり、`pkg>`プロンプトの行頭で`?`を押すと入れます。パッケージマネージャーモードの詳細は、[https://julialang.github.io/Pkg.jl/v1/](https://julialang.github.io/Pkg.jl/v1/)で参照できるPkgマニュアルに記載されています。

### History searching

上記のすべてのモードで、実行した行は検索可能な履歴ファイルに保存されます。過去の履歴を対話的に検索するには、`^R`（Controlキーと`r`キー）を押します。

対話型の履歴ビューアーが表示されます。検索文字列を入力すると履歴が絞り込まれ、Enterキーを押すと選択した履歴項目がREPLに挿入されます。履歴検索機能の詳しいヘルプは、REPLで特殊なクエリ`?`および`??`を使って参照できます。

Julia REPLで実行したコマンドはすべて`~/.julia/logs/repl_history.jl`に記録されます。記録には実行時のタイムスタンプと、そのときのREPLモードも含まれます。履歴検索機能はこのログファイルを読み込み、以前に実行したコマンドを検索します。複数のREPLから同時にこのファイルへ書き込むことができ、検索を開始するたびに最新の履歴が取得されます。Juliaの起動時に`--history-file=no`フラグを渡すと、このファイルの使用を無効にできます。

## Key bindings

Julia REPLではキーバインドを幅広く活用できます。終了用の`^D`や検索用の`^R`など、いくつかのControlキーのキーバインドをすでに紹介しましたが、ほかにも多数あります。Controlキーに加えて、Metaキーのキーバインドもあります。これらはプラットフォームによる違いが大きいものの、多くの端末ではAltキーまたはOptionキーを押しながら別のキーを押すとMetaキーとして送信されます（そのように設定することもできます）。または、Escキーを押してから別のキーを押します。

| キーバインド             | 説明                                                |
|:------------------ |:------------------------------------------------- |
| **プログラム制御**        |                                                   |
| `^D`               | 終了（バッファーが空の場合）                                    |
| `^C`               | 割り込みまたはキャンセル                                      |
| `^L`               | コンソール画面を消去                                        |
| Return/Enter、`^J`  | 改行。入力が完了していれば実行                                   |
| meta-Return/Enter  | 実行せずに改行を挿入                                        |
| `?`または`;`          | ヘルプモードまたはシェルモードに切り替え（行頭の場合）                       |
| `^R`、`^S`          | 上記の対話型履歴検索                                        |
| **カーソル移動**         |                                                   |
| 右矢印、`^F`           | 右へ1文字移動                                           |
| 左矢印、`^B`           | 左へ1文字移動                                           |
| ctrl-右、`meta-F`    | 右へ1単語移動                                           |
| ctrl-左、`meta-B`    | 左へ1単語移動                                           |
| Home、`^A`          | 行頭へ移動                                             |
| End、`^E`           | 行末へ移動                                             |
| 上矢印、`^P`           | 1行上へ移動（またはカーソルより前のテキストに一致する直前の履歴項目へ移動）            |
| 下矢印、`^N`           | 1行下へ移動（またはカーソルより前のテキストに一致する次の履歴項目へ移動）             |
| Shift-矢印キー         | 矢印キーの方向にカーソルを移動し、領域を有効化（「Shift選択」）                |
| Page-up、`meta-P`   | 直前の履歴項目へ移動                                        |
| Page-down、`meta-N` | 次の履歴項目へ移動                                         |
| `meta-<`           | 最初の履歴項目へ移動（現在の履歴位置より前にある場合は、現在のセッションの最初の項目）       |
| `meta->`           | 最後の履歴項目へ移動                                        |
| `^-Space`          | 編集領域に「マーク」を設定（領域が有効な場合は無効化）                       |
| `^-Space ^-Space`  | 編集領域に「マーク」を設定し、領域を有効化（ハイライト表示）                    |
| `^G`               | 領域を無効化（ハイライト表示を解除）                                |
| `^X^X`             | 現在位置とマークを入れ替え                                     |
| **編集**             |                                                   |
| Backspace、`^H`     | 直前の文字を削除。領域が有効な場合は領域全体を削除                         |
| Delete、`^D`        | 1文字を前方削除（バッファーにテキストがある場合）                         |
| meta-Backspace     | 直前の単語を削除                                          |
| `meta-d`           | 次の単語を前方削除                                         |
| `^W`               | 最も近い空白文字までの直前のテキストを削除                             |
| `meta-w`           | 現在の領域をキルリングにコピー                                   |
| `meta-W`           | 現在の領域を「キル」し、テキストをキルリングに格納                         |
| `^U`               | 行頭までを「キル」し、テキストをキルリングに格納                          |
| `^K`               | 行末までを「キル」し、テキストをキルリングに格納                          |
| `^Y`               | キルリングのテキストを「ヤンク」して挿入                              |
| `meta-y`           | 直前にヤンクしたテキストを、キルリング内の古い項目で置換                      |
| `^T`               | カーソル付近の文字を入れ替え                                    |
| `meta-Up arrow`    | 現在の行と1行上の行を入れ替え                                   |
| `meta-Down arrow`  | 現在の行と1行下の行を入れ替え                                   |
| `meta-u`           | 次の単語を大文字に変換                                       |
| `meta-c`           | 次の単語をタイトルケースに変換                                   |
| `meta-l`           | 次の単語を小文字に変換                                       |
| `^/`、`^_`          | 直前の編集操作を元に戻す                                      |
| `^Q`               | REPLに数値を入力して`^Q`を押すと、対応するスタックフレームまたはメソッドをエディターで開く |
| `meta-Left Arrow`  | 現在の行を左にインデント                                      |
| `meta-Right Arrow` | 現在の行を右にインデント                                      |
| `meta-.`           | 直前の履歴項目の最後の単語を挿入                                  |
| `meta-e`           | 現在の入力をエディターで編集                                    |
| **履歴検索**           |                                                   |
| 上矢印、`^P`、`^K`      | フォーカスを1項目上へ移動                                     |
| 下矢印、`^P`、`^N`      | フォーカスを1項目下へ移動                                     |
| Page up、`^B`       | フォーカスを1ページ上へ移動                                    |
| Page down、`^F`     | フォーカスを1ページ下へ移動                                    |
| `meta-<`           | 最初（最も古い）の履歴項目にフォーカス                               |
| `meta->`           | 最後（最も新しい）の履歴項目にフォーカス                              |
| Tab                | 現在フォーカスされている項目の選択を切り替え                            |
| Enter              | 現在フォーカスされている項目または選択済みの項目を確定                       |
| `^S`               | フォーカスされている項目または選択済みの項目をクリップボードまたはファイルに保存          |
| `^C`、`^D`、`^G`     | 履歴検索を中止                                           |

### Customizing keybindings

`REPL.setup_interface`に辞書を渡すと、Julia REPLのキーバインドをユーザーの好みに合わせて自由にカスタマイズできます。この辞書のキーには文字または文字列を指定できます。キー`'*'`はデフォルトのアクションを表します。Controlキーと文字`x`の組み合わせは、`"^x"`で表します。Metaキーと`x`の組み合わせは`"\\M-x"`または`"\ex"`、Controlキーと`x`の組み合わせは`"\\C-x"`または`"^x"`と記述できます。カスタムキーマップの値には、入力を無視することを示す`nothing`、またはシグネチャ`(PromptState, AbstractREPL, Char)`を受け取る関数を指定します。`REPL.setup_interface`関数はREPLの初期化前に呼び出す必要があるため、[`atreplinit`](@ref)に処理を登録します。たとえば、上矢印キーと下矢印キーで、前方一致検索を使わずに履歴を移動できるようにするには、次のコードを`~/.julia/config/startup.jl`に記述します。

```julia
import REPL
import REPL.LineEdit

const mykeys = Dict{Any,Any}(
    # Up Arrow
    "\e[A" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.history_prev(s, LineEdit.mode(s).hist)),
    # Down Arrow
    "\e[B" => (s,o...)->(LineEdit.edit_move_down(s) || LineEdit.history_next(s, LineEdit.mode(s).hist))
)

function customize_keys(repl)
    repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
end

atreplinit(customize_keys)
```

キー入力に対して利用できるアクションを確認するには、`LineEdit.jl`を参照してください。

### Automatic bracket insertion

Julia REPLでは、開き括弧、丸括弧、中括弧、引用符を入力すると、対応する閉じ記号を自動挿入できます。

この機能が有効な場合、開き括弧`(`、`{`、または`[`を入力すると、対応する閉じ括弧`)`、`}`、または`]`が自動挿入され、カーソルはその間に置かれます。引用符（`"`、`'`、`` ` ``）も同様です。その後、閉じ記号を入力すると、REPLは重複して挿入する代わりに、自動挿入された記号を飛び越えます。また、自動挿入の直後にBackspaceキーを押すと、開き記号と閉じ記号の両方が削除されます。

この機能を無効にするには、`~/.julia/config/startup.jl`ファイルに次の設定を追加します。

```julia
atreplinit() do repl
    # Robust against older julia versions
    if hasfield(typeof(repl.options), :auto_insert_closing_bracket)
        repl.options.auto_insert_closing_bracket = false
    end
end
```

## Tab completion

REPLのJuliaモード、pkgモード、ヘルプモードでは、関数名や型名の先頭数文字を入力してTabキーを押すと、一致する候補の一覧が表示されます。

```julia-repl
julia> x[TAB]
julia> xor
```

場合によっては、曖昧さが生じる直前までしか補完されないことがあります。

```julia-repl
julia> mapf[TAB]
julia> mapfold
```

その状態でもう一度Tabキーを押すと、補完候補の一覧が表示されます。

```julia-repl
julia> mapfold[TAB]
mapfoldl mapfoldr
```

入力行の末尾でタブ補完の候補が1つに絞られ、2文字以上入力されている場合は、補完候補が薄い色でヒント表示されます。この機能は`Base.active_repl.options.hint_tab_completes = false`で無効にするか、次の設定を

```
atreplinit() do repl
    if VERSION >= v"1.11.0-0"
        repl.options.hint_tab_completes = false
    end
end
```

`~/.julia/config/startup.jl`に追加して無効にできます。

!!! compat "Julia 1.11"
    タブ補完のヒント表示はJulia 1.11で追加されました。


REPLのほかの機能と同様、検索では大文字と小文字が区別されます。

```julia-repl
julia> stri[TAB]
stride     strides     string      strip

julia> Stri[TAB]
StridedArray    StridedMatrix    StridedVecOrMat  StridedVector    String
```

Tabキーを使うと、LaTeXの数式記号を対応するUnicode文字に置き換えたり、LaTeXの候補一覧を表示したりすることもできます。

```julia-repl
julia> \pi[TAB]
julia> π
π = 3.1415926535897...

julia> e\_1[TAB] = [1,0]
julia> e₁ = [1,0]
2-element Vector{Int64}:
 1
 0

julia> e\^1[TAB] = [1 0]
julia> e¹ = [1 0]
1×2 Matrix{Int64}:
 1  0

julia> \sqrt[TAB]2     # √ is equivalent to the sqrt function
julia> √2
1.4142135623730951

julia> \hbar[TAB](h) = h / 2\pi[TAB]
julia> ħ(h) = h / 2π
ħ (generic function with 1 method)

julia> \h[TAB]
\hat              \hermitconjmatrix  \hkswarow          \hrectangle
\hatapprox        \hexagon           \hookleftarrow     \hrectangleblack
\hbar             \hexagonblack      \hookrightarrow    \hslash
\heartsuit        \hksearow          \house             \hspace

julia> α="\alpha[TAB]"   # LaTeX completion also works in strings
julia> α="α"
```

タブ補完の一覧は、マニュアルの[Unicode Input](@ref)セクションにあります。

パスの補完は、文字列とJuliaのシェルモードで利用できます。

```julia-repl
julia> path="/[TAB]"
.dockerenv  .juliabox/   boot/        etc/         lib/         media/       opt/         root/        sbin/        sys/         usr/
.dockerinit bin/         dev/         home/        lib64/       mnt/         proc/        run/         srv/         tmp/         var/
shell> /[TAB]
.dockerenv  .juliabox/   boot/        etc/         lib/         media/       opt/         root/        sbin/        sys/         usr/
.dockerinit bin/         dev/         home/        lib64/       mnt/         proc/        run/         srv/         tmp/         var/
```

辞書のキーもタブ補完できます。

```julia-repl
julia> foo = Dict("qwer1"=>1, "qwer2"=>2, "asdf"=>3)
Dict{String,Int64} with 3 entries:
  "qwer2" => 2
  "asdf"  => 3
  "qwer1" => 1

julia> foo["q[TAB]

"qwer1" "qwer2"
julia> foo["qwer
```

フィールドの補完にもタブ補完を利用できます。

```julia-repl
julia> x = 3 + 4im;

julia> x.[TAB][TAB]
im re

julia> import UUIDs

julia> UUIDs.uuid[TAB][TAB]
uuid1        uuid4         uuid5        uuid_version
```

関数の出力に含まれるフィールドも補完できます。

```julia-repl
julia> split("","")[1].[TAB]
lastindex  offset  string
```

関数の出力に含まれるフィールドの補完には型推論が使われます。そのため、関数が型安定である場合に限り、フィールド候補が提示されます。

入力した引数に一致する利用可能なメソッドを調べる際にも、タブ補完が役立ちます。

```julia-repl
julia> max([TAB] # All methods are displayed, not shown here due to size of the list

julia> max([1, 2], [TAB] # All methods where `Vector{Int}` matches as first argument
max(x, y) in Base at operators.jl:215
max(a, b, c, xs...) in Base at operators.jl:281

julia> max([1, 2], max(1, 2), [TAB] # All methods matching the arguments.
max(x, y) in Base at operators.jl:215
max(a, b, c, xs...) in Base at operators.jl:281
```

`;`の後には、キーワード引数も候補メソッドに表示されます。以下の例では、`limit`と`keepempty`がキーワード引数です。

```julia-repl
julia> split("1 1 1", [TAB]
split(str::AbstractString; limit, keepempty) in Base at strings/util.jl:302
split(str::T, splitter; limit, keepempty) where T<:AbstractString in Base at strings/util.jl:277
```

メソッドの補完には型推論が使われるため、引数が関数の出力であっても、その型が一致するかどうかを判定できます。ただし、一致しないメソッドを候補から除外するには、関数が型安定である必要があります。

特定の引数型で使えるメソッドを調べるには、関数名として`?`を使います。次の例では、InteractiveUtils内で、文字列を1つ受け取る関数を検索しています。

```julia-repl
julia> InteractiveUtils.?("somefile")[TAB]
edit(path::AbstractString) in InteractiveUtils at InteractiveUtils/src/editless.jl:197
less(file::AbstractString) in InteractiveUtils at InteractiveUtils/src/editless.jl:266
```

この例では、文字列に対して呼び出せる`InteractiveUtils`モジュール内のメソッドが一覧表示されました。デフォルトでは、すべての引数が`Any`型として指定されているメソッドは除外されます。TABの代わりにSHIFT-TABを押すと、それらも表示できます。

```julia-repl
julia> InteractiveUtils.?("somefile")[SHIFT-TAB]
apropos(string) in REPL at REPL/src/docview.jl:796
clipboard(x) in InteractiveUtils at InteractiveUtils/src/clipboard.jl:64
code_llvm(f) in InteractiveUtils at InteractiveUtils/src/codeview.jl:221
code_native(f) in InteractiveUtils at InteractiveUtils/src/codeview.jl:243
edit(path::AbstractString) in InteractiveUtils at InteractiveUtils/src/editless.jl:197
edit(f) in InteractiveUtils at InteractiveUtils/src/editless.jl:225
eval(x) in InteractiveUtils at InteractiveUtils/src/InteractiveUtils.jl:3
include(x) in InteractiveUtils at InteractiveUtils/src/InteractiveUtils.jl:3
less(file::AbstractString) in InteractiveUtils at InteractiveUtils/src/editless.jl:266
less(f) in InteractiveUtils at InteractiveUtils/src/editless.jl:274
report_bug(kind) in InteractiveUtils at InteractiveUtils/src/InteractiveUtils.jl:391
separate_kwargs(args...; kwargs...) in InteractiveUtils at InteractiveUtils/src/macros.jl:7
```

`?("somefile")[TAB]`を使うと、すべてのモジュールを対象に検索することもできますが、メソッドの一覧が長くなる場合があります。

閉じ括弧を省略すると、追加の引数が必要になる可能性のある関数も候補に含められます。

```julia-repl
julia> using Mmap

help?> Mmap.?("file",[TAB]
Mmap.Anonymous(name::String, readonly::Bool, create::Bool) in Mmap at Mmap/src/Mmap.jl:16
mmap(file::AbstractString) in Mmap at Mmap/src/Mmap.jl:245
mmap(file::AbstractString, ::Type{T}) where T<:Array in Mmap at Mmap/src/Mmap.jl:245
mmap(file::AbstractString, ::Type{T}, dims::Tuple{Vararg{Integer, N}}) where {T<:Array, N} in Mmap at Mmap/src/Mmap.jl:245
mmap(file::AbstractString, ::Type{T}, dims::Tuple{Vararg{Integer, N}}, offset::Integer; grow, shared) where {T<:Array, N} in Mmap at Mmap/src/Mmap.jl:245
mmap(file::AbstractString, ::Type{T}, len::Integer) where T<:Array in Mmap at Mmap/src/Mmap.jl:251
mmap(file::AbstractString, ::Type{T}, len::Integer, offset::Integer; grow, shared) where T<:Array in Mmap at Mmap/src/Mmap.jl:251
mmap(file::AbstractString, ::Type{T}, dims::Tuple{Vararg{Integer, N}}) where {T<:BitArray, N} in Mmap at Mmap/src/Mmap.jl:316
mmap(file::AbstractString, ::Type{T}, dims::Tuple{Vararg{Integer, N}}, offset::Integer; grow, shared) where {T<:BitArray, N} in Mmap at Mmap/src/Mmap.jl:316
mmap(file::AbstractString, ::Type{T}, len::Integer) where T<:BitArray in Mmap at Mmap/src/Mmap.jl:322
mmap(file::AbstractString, ::Type{T}, len::Integer, offset::Integer; grow, shared) where T<:BitArray in Mmap at Mmap/src/Mmap.jl:322
```

## Syntax Highlighting

REPLでは、入力中の構文がハイライト表示されます。構文ハイライトはデフォルトで有効ですが、`~/.julia/config/startup.jl`で無効にできます。

```julia
atreplinit() do repl
    repl.options.style_input = false
end
```

### Customizing Syntax Highlighting Colors

デフォルトの構文ハイライトテーマは控えめな配色ですが、TOMLファイル`faces.toml`（`.julia/config`内のhttps://julialang.github.io/StyledStrings.jl/dev/#stdlib-styledstrings-face-toml)）を使ってカスタマイズできます。または、face TOMLファイルからfaceを明示的に読み込むこともできます。

!!! details "例：Monokaiカラーテーマ（クリックして展開）"
    ```toml

    # Monokai color theme for Julia syntax highlighting

    [julia_macro]
    foreground = "#A6E22E"

    [julia_symbol]
    foreground = "#AE81FF"

    [julia_singleton_identifier]
    inherit = "julia_symbol"

    [julia_type]
    foreground = "#66D9EF"

    [julia_typedec]
    foreground = "#66D9EF"
    weight = "bold"

    [julia_comment]
    foreground = "#75715E"
    italic = true

    [julia_string]
    foreground = "#E6DB74"

    [julia_regex]
    inherit = "julia_string"

    [julia_backslash_literal]
    foreground = "#FD971F"
    inherit = "julia_string"

    [julia_string_delim]
    foreground = "#E6DB74"
    weight = "bold"

    [julia_cmd]
    inherit = "julia_string"

    [julia_char]
    inherit = "julia_string"

    [julia_char_delim]
    inherit = "julia_string_delim"

    [julia_number]
    foreground = "#AE81FF"

    [julia_bool]
    foreground = "#AE81FF"
    weight = "bold"

    [julia_funcall]
    foreground = "#A6E22E"

    [julia_broadcast]
    foreground = "#F92672"
    weight = "bold"

    [julia_builtin]
    foreground = "#66D9EF"
    weight = "bold"

    [julia_operator]
    foreground = "#F92672"

    [julia_comparator]
    inherit = "julia_operator"

    [julia_assignment]
    foreground = "#F92672"
    weight = "bold"

    [julia_keyword]
    foreground = "#F92672"
    weight = "bold"

    [julia_parentheses]
    foreground = "#F8F8F2"

    [julia_unpaired_parentheses]
    background = "#F92672"
    foreground = "#F8F8F0"
    weight = "bold"

    [julia_error]
    background = "#F92672"
    foreground = "#F8F8F0"

    [julia_rainbow_paren_1]
    foreground = "#A6E22E"
    inherit = "julia_parentheses"

    [julia_rainbow_paren_2]
    foreground = "#66D9EF"
    inherit = "julia_parentheses"

    [julia_rainbow_paren_3]
    foreground = "#FD971F"
    inherit = "julia_parentheses"

    [julia_rainbow_paren_4]
    inherit = "julia_rainbow_paren_1"

    [julia_rainbow_paren_5]
    inherit = "julia_rainbow_paren_2"

    [julia_rainbow_paren_6]
    inherit = "julia_rainbow_paren_3"

    # Rainbow brackets
    [julia_rainbow_bracket_1]
    foreground = "#AE81FF"
    inherit = "julia_parentheses"

    [julia_rainbow_bracket_2]
    foreground = "#E6DB74"
    inherit = "julia_parentheses"

    [julia_rainbow_bracket_3]
    inherit = "julia_rainbow_bracket_1"

    [julia_rainbow_bracket_4]
    inherit = "julia_rainbow_bracket_2"

    [julia_rainbow_bracket_5]
    inherit = "julia_rainbow_bracket_1"

    [julia_rainbow_bracket_6]
    inherit = "julia_rainbow_bracket_2"

    # Rainbow curlies
    [julia_rainbow_curly_1]
    foreground = "#F92672"
    inherit = "julia_parentheses"

    [julia_rainbow_curly_2]
    foreground = "#A6E22E"
    inherit = "julia_parentheses"

    [julia_rainbow_curly_3]
    inherit = "julia_rainbow_curly_1"

    [julia_rainbow_curly_4]
    inherit = "julia_rainbow_curly_2"

    [julia_rainbow_curly_5]
    inherit = "julia_rainbow_curly_1"

    [julia_rainbow_curly_6]
    inherit = "julia_rainbow_curly_2"
    ```


カスタマイズ可能なfaceの一覧は、[JuliaSyntaxHighlighting package documentation](https://julialang.github.io/JuliaSyntaxHighlighting.jl/dev/)を参照してください。

## Customising the history searcher

履歴検索機能では、次のfaceがデフォルトで使われます。これらはカスタマイズできます。

```toml
[REPL.History.search]
separator.fg  = "blue"
prefix.fg = "magenta"
selected.fg = "blue"
unselected.fg = "grey"
hint = { fg = "magenta", slant = "italic", weight ="light" }
results.inherit = "shadow"
match = { weight = "bold", underline = true }
```

## Customizing Colors

JuliaとREPLで使われる色もカスタマイズできます。Juliaプロンプトの色を変更するには、ホームディレクトリに置く`~/.julia/config/startup.jl`ファイルに、たとえば次の設定を追加します。

```julia
function customize_colors(repl)
    repl.prompt_color = Base.text_colors[:cyan]
end

atreplinit(customize_colors)
```

利用可能な色のキーは、REPLのヘルプモードで`Base.text_colors`と入力すると確認できます。また、256色に対応した端末では、0から255までの整数を色のキーとして使えます。

ヘルプとシェルのプロンプト、入力テキスト、応答テキストの色も変更できます。上記の`customize_colors`関数で、`repl`の適切なフィールドを設定します（順に`help_color`、`shell_color`、`input_color`、`answer_color`）。後者の2つについては、`envcolors`フィールドもfalseに設定してください。

色として`Base.text_colors[:bold]`を使うと、太字表示も適用できます。たとえば、応答を太字で表示するには、`~/.julia/config/startup.jl`に次の設定を使います。

```julia
function customize_colors(repl)
    repl.envcolors = false
    repl.answer_color = Base.text_colors[:bold]
end

atreplinit(customize_colors)
```

環境変数を設定すると、警告メッセージや情報メッセージの色も変更できます。たとえば、エラー、警告、情報メッセージをそれぞれマゼンタ、黄色、シアンで表示するには、`~/.julia/config/startup.jl`ファイルに次の設定を追加します。

```julia
ENV["JULIA_ERROR_COLOR"] = :magenta
ENV["JULIA_WARN_COLOR"] = :yellow
ENV["JULIA_INFO_COLOR"] = :cyan
```

## Changing the contextual module which is active at the REPL

REPLに入力した式は、デフォルトでは`Main`モジュール内で評価されます。

```julia-repl
julia> @__MODULE__
Main
```

関数`REPL.activate(m)`を使うと、このコンテキストモジュールを変更できます。`m`には`Module`を指定します。または、REPLにモジュール名を入力し、その名前の上にカーソルを置いてAlt-m（MacOSではEsc-m）を押しても変更できます。空のプロンプトでこのキー操作を行うと、直前にアクティブだった非`Main`モジュールと`Main`の間でコンテキストが切り替わります。アクティブなモジュールはプロンプトに表示されます（`Main`の場合を除く）。

```julia-repl
julia> using REPL

julia> REPL.activate(Base)

(Base) julia> @__MODULE__
Base

(Base) julia> using REPL # Need to load REPL into Base module to use it

(Base) julia> REPL.activate(Main)

julia>

julia> Core<Alt-m> # using the keybinding to change module

(Core) julia>

(Core) julia> <Alt-m> # going back to Main via keybinding

julia>

julia> <Alt-m> # going back to previously-active Core via keybinding

(Core) julia>
```

モジュール引数を省略できる関数では、多くの場合、デフォルトでREPLのコンテキストモジュールが使われます。たとえば、`varinfo()`を呼び出すと、現在アクティブなモジュールの変数が表示されます。

```julia-repl
julia> module CustomMod
           export var, f
           var = 1
           f(x) = x^2
       end;

julia> REPL.activate(CustomMod)

(Main.CustomMod) julia> varinfo()
  name         size summary
  ––––––––– ––––––– ––––––––––––––––––––––––––––––––––
  CustomMod         Module
  f         0 bytes f (generic function with 1 method)
  var       8 bytes Int64
```

## Numbered prompt

IPython REPLやMathematicaノートブックに似た、入力プロンプトに番号を付け、出力に接頭辞を付けるインターフェースも利用できます。これを有効にするには、`REPL.numbered_prompt!()`を呼び出します。起動時から有効にするには、次の設定を

```julia
atreplinit() do repl
    @eval import REPL
    if !isdefined(repl, :interface)
        repl.interface = REPL.setup_interface(repl)
    end
    REPL.numbered_prompt!(repl)
end
```

`startup.jl`ファイルに追加します。番号付きプロンプトでは、変数`Out[n]`（`n`は整数）を使って、以前の結果を参照できます。

```julia-repl
In [1]: 5 + 3
Out[1]: 8

In [2]: Out[1] + 5
Out[2]: 13

In [3]: Out
Out[3]: Dict{Int64, Any} with 2 entries:
  2 => 13
  1 => 8
```

!!! note
    以前のREPL評価の出力はすべて`Out`変数に保存されます。そのため、配列などの大きなインメモリオブジェクトを多数返す場合は注意が必要です。`Out`に参照が残っている限り、それらのオブジェクトはガベージコレクションの対象になりません。`Out`内のオブジェクトへの参照を削除するには、`empty!(Out)`で履歴全体を消去するか、`Out[n] = nothing`で個別の項目を消去します。


## TerminalMenus

TerminalMenusはJulia REPLのサブモジュールで、端末上に小さく控えめな対話型メニューを表示できます。

### Examples

```julia
import REPL
using REPL.TerminalMenus

options = ["apple", "orange", "grape", "strawberry",
            "blueberry", "peach", "lemon", "lime"]

```

#### RadioMenu

RadioMenuでは、一覧から1つの選択肢を選べます。`request`関数は対話型メニューを表示し、選択された項目のインデックスを返します。ユーザーが「q」または`ctrl-c`を押すと、`request`は`-1`を返します。

```julia
# `pagesize` is the number of items to be displayed at a time.
#  The UI will scroll if the number of options is greater
#   than the `pagesize`
menu = RadioMenu(options, pagesize=4)

# `request` displays the menu and returns the index after the
#   user has selected a choice
choice = request("Choose your favorite fruit:", menu)

if choice != -1
    println("Your favorite fruit is ", options[choice], "!")
else
    println("Menu canceled.")
end

```

出力：

```
Choose your favorite fruit:
^  grape
   strawberry
 > blueberry
v  peach
Your favorite fruit is blueberry!
```

#### MultiSelectMenu

MultiSelectMenuでは、一覧から複数の選択肢を選べます。

```julia
# here we use the default `pagesize` 10
menu = MultiSelectMenu(options)

# `request` returns a `Set` of selected indices
# if the menu us canceled (ctrl-c or q), return an empty set
choices = request("Select the fruits you like:", menu)

if length(choices) > 0
    println("You like the following fruits:")
    for i in choices
        println("  - ", options[i])
    end
else
    println("Menu canceled.")
end
```

出力：

```
Select the fruits you like:
[press: Enter=toggle, a=all, n=none, d=done, q=abort]
   [ ] apple
 > [X] orange
   [X] grape
   [ ] strawberry
   [ ] blueberry
   [X] peach
   [ ] lemon
   [ ] lime
You like the following fruits:
  - orange
  - grape
  - peach
```

### Customization / Configuration

#### ConfiguredMenu subtypes

Julia 1.6以降では、メニューの設定にはコンストラクターを使う方法が推奨されています。たとえば、デフォルトの複数選択メニュー

```
julia> menu = MultiSelectMenu(options, pagesize=5);

julia> request(menu) # ASCII is used by default
[press: Enter=toggle, a=all, n=none, d=done, q=abort]
   [ ] apple
   [X] orange
   [ ] grape
 > [X] strawberry
v  [ ] blueberry
```

は、選択や移動にUnicode文字を使って次のように表示できます。

```julia-repl
julia> menu = MultiSelectMenu(options, pagesize=5, charset=:unicode);

julia> request(menu)
[press: Enter=toggle, a=all, n=none, d=done, q=abort]
   ⬚ apple
   ✓ orange
   ⬚ grape
 → ✓ strawberry
↓  ⬚ blueberry
```

さらに細かい設定も可能です。

```julia-repl
julia> menu = MultiSelectMenu(options, pagesize=5, charset=:unicode, checked="YEP!", unchecked="NOPE", cursor='⧐');

julia> request(menu)
julia> request(menu)
[press: Enter=toggle, a=all, n=none, d=done, q=abort]
   NOPE apple
   YEP! orange
   NOPE grape
 ⧐ YEP! strawberry
↓  NOPE blueberry
```

全体に適用される`charset`オプションのほか、`RadioMenu`では次のオプションを設定できます。

  * `cursor::Char='>'|'→'`：カーソルに使う文字
  * `up_arrow::Char='^'|'↑'`：上矢印に使う文字
  * `down_arrow::Char='v'|'↓'`：下矢印に使う文字
  * `updown_arrow::Char='I'|'↕'`：1行ページで上下矢印に使う文字
  * `scroll_wrap::Bool=false`：メニューの先頭または末尾で折り返すかどうか
  * `ctrl_c_interrupt::Bool=true`：`false`の場合、^Cで空を返す。`true`の場合、^CでInterruptException()をスローする

`MultiSelectMenu`では、さらに次のオプションを設定できます。

  * `checked::String="[X]"|"✓"`：選択済み項目に使う文字列
  * `unchecked::String="[ ]"|"⬚")`：未選択項目に使う文字列

独自のメニュー型を作成することもできます。`TerminalMenus.ConfiguredMenu`から派生した型では、構築時にメニューオプションを設定します。

#### Legacy interface

Julia 1.6より前のバージョンでは、`TerminalMenus.config()`を呼び出してメニューを設定する方法も使えます。この方法はJulia 1.xの全バージョンで引き続きサポートされています。

## References

### REPL

```@docs
Base.atreplinit
```

### TerminalMenus

### Menus

```@docs
REPL.TerminalMenus.RadioMenu
REPL.TerminalMenus.MultiSelectMenu
```

#### Configuration

```@docs
REPL.TerminalMenus.Config
REPL.TerminalMenus.MultiSelectConfig
REPL.TerminalMenus.config
```

#### User interaction

```@docs
REPL.TerminalMenus.request
```

#### AbstractMenu extension interface

`AbstractMenu`のサブタイプはすべてmutableでなければならず、`pagesize::Int`および`pageoffset::Int`フィールドを含む必要があります。また、すべてのサブタイプで次の関数を実装する必要があります。

```@docs
REPL.TerminalMenus.pick
REPL.TerminalMenus.cancel
REPL.TerminalMenus.writeline
```

さらに、`options`または`numoptions`のいずれかを実装する必要があります。

```@docs
REPL.TerminalMenus.options
REPL.TerminalMenus.numoptions
```

サブタイプに`selected`という名前のフィールドがない場合は、次の関数も実装する必要があります。

```@docs
REPL.TerminalMenus.selected
```

次の項目は任意ですが、追加のカスタマイズに利用できます。

```@docs
REPL.TerminalMenus.header
REPL.TerminalMenus.keypress
```
