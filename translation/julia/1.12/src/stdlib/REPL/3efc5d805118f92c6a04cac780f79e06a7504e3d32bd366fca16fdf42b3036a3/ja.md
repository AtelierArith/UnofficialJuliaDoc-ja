```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/docs/src/index.md"
```

# The Julia REPL

Juliaには、`julia`実行可能ファイルに組み込まれたフル機能のインタラクティブコマンドラインREPL（読み取り-評価-印刷ループ）が付属しています。Juliaステートメントの迅速かつ簡単な評価を可能にするだけでなく、検索可能な履歴、タブ補完、多くの便利なキーバインディング、専用のヘルプおよびシェルモードがあります。REPLは、引数なしで`julia`を呼び出すか、実行可能ファイルをダブルクリックすることで開始できます：

```@eval
using REPL
io = IOBuffer()
REPL.banner(io)
banner = String(take!(io))
import Markdown
Markdown.parse("```\n\$ julia\n\n$(banner)\njulia>\n```")
```

インタラクティブセッションを終了するには、空白行で `^D` を入力します。これは、コントロールキーと `d` キーを同時に押すことを意味します。または、`exit()` と入力してからリターンまたはエンターキーを押します。REPLはバナーと `julia>` プロンプトであなたを迎えます。

## The different prompt modes

### The Julian mode

REPLには5つの主要な操作モードがあります。最初で最も一般的なのは、ジュリアプロンプトです。これはデフォルトの操作モードであり、各新しい行は最初に`julia>`で始まります。ここでは、ジュリアの式を入力できます。完全な式を入力した後にリターンまたはエンターを押すと、入力が評価され、最後の式の結果が表示されます。

```jldoctest
julia> string(1 + 2)
"3"
```

インタラクティブな作業に特有の便利な機能がいくつかあります。結果を表示するだけでなく、REPLは結果を変数 `ans` にバインドします。行の末尾にセミコロンを付けることで、結果の表示を抑制するフラグとして使用できます。

```jldoctest
julia> string(3 * 4);

julia> ans
"12"
```

Juliaモードでは、REPLは*プロンプトペースト*と呼ばれる機能をサポートしています。これは、`julia>`で始まるテキストをREPLにペーストするときにアクティブになります。この場合、`julia>`で始まる式（および他のREPLモードのプロンプト：`shell>`、`help?>`、`pkg>`）のみが解析され、他のものは削除されます。これにより、プロンプトや出力を取り除くことなく、REPLセッションからコピーしたテキストの塊をペーストすることが可能になります。この機能はデフォルトで有効ですが、`REPL.enable_promptpaste(::Bool)`を使用して任意に無効または有効にすることができます。有効になっている場合は、この段落の上にあるコードブロックをREPLに直接ペーストして試すことができます。この機能は、ペーストが発生したときの検出に制限があるため、標準のWindowsコマンドプロンプトでは動作しません。

A non-[`nothing`](@ref) result of executing an expression is displayed by the REPL using the [`show`](@ref) function with a specific [`IOContext`](@ref) (via [`display`](@ref), which defaults to calling `show(io, MIME("text/plain"), ans)`, which in turn defaults to `show(io, ans)`). In particular, the `:limit` attribute is set to `true`. Other attributes can receive in certain `show` methods a default value if it's not already set, like `:compact`. It's possible, as an experimental feature, to specify the attributes used by the REPL via the `Base.active_repl.options.iocontext` dictionary (associating values to attributes). For example:

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

この辞書の値を起動時に自動的に定義するために、例えば `~/.julia/config/startup.jl` ファイル内で [`atreplinit`](@ref) 関数を使用することができます。

```julia
atreplinit() do repl
    repl.options.iocontext[:compact] = false
end
```

### Help mode

カーソルが行の先頭にあるとき、プロンプトは `?` を入力することでヘルプモードに変更できます。Juliaはヘルプモードで入力されたものに対して、ヘルプやドキュメントを表示しようとします：

```julia-repl
julia> ? # upon typing ?, the prompt changes (in place) to: help?>

help?> string
search: string String Cstring Cwstring RevString randstring bytestring SubString

  string(xs...)

  Create a string from any values using the print function.
```

マクロ、型、変数もクエリできます：

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

[`apropos`](@ref)を使用して、すべてのドックストリングを検索する文字列または正規表現リテラル:

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

ヘルプモードのもう一つの機能は、拡張ドキュメント文字列にアクセスできることです。これを行うには、`?Print`の代わりに`??Print`のように入力すると、ソースコードのドキュメントから`# Extended help`セクションが表示されます。

ヘルプモードは、行の先頭でバックスペースを押すことで終了できます。

### [Shell mode](@id man-shell-mode)

ヘルプモードがドキュメントへの迅速なアクセスに便利であるのと同様に、もう一つの一般的なタスクは、システムシェルを使用してシステムコマンドを実行することです。行の先頭で`?`を入力するとヘルプモードに入るのと同様に、セミコロン（`;`）を入力するとシェルモードに入ります。そして、行の先頭でバックスペースを押すことで終了できます。

```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> echo hello
hello
```

!!! note
    Windowsユーザーの場合、JuliaのシェルモードはWindowsシェルコマンドを公開していません。したがって、これは失敗します：


```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> dir
ERROR: IOError: could not spawn `dir`: no such file or directory (ENOENT)
Stacktrace!
.......
```

ただし、次のようにして `PowerShell` にアクセスできます:

```julia-repl
julia> ; # upon typing ;, the prompt changes (in place) to: shell>

shell> powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.
PS C:\Users\elm>
```

... と `cmd.exe` にそのように ( `dir` コマンドを参照):

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

パッケージマネージャーモードは、パッケージの読み込みと更新のための特別なコマンドを受け付けます。このモードには、Julian REPLプロンプトで `]` キーを押すことで入ることができ、CTRL-Cを押すか、行の先頭でバックスペースキーを押すことで終了します。このモードのプロンプトは `pkg>` です。このモードは独自のヘルプモードをサポートしており、`pkg>` プロンプトの行の先頭で `?` を押すことで入ることができます。パッケージマネージャーモードは、[https://julialang.github.io/Pkg.jl/v1/](https://julialang.github.io/Pkg.jl/v1/) で入手可能なPkgマニュアルに文書化されています。

### Search modes

すべてのモードで、実行された行は履歴ファイルに保存され、検索可能です。以前の履歴をインクリメンタル検索するには、`^R` – コントロールキーと`r`キーを同時に押します。プロンプトは```(reverse-i-search)`':```に変わり、検索クエリを入力すると引用符の中に表示されます。クエリに一致する最新の結果は、さらに入力されるとコロンの右側に動的に更新されます。同じクエリを使用して古い結果を見つけるには、再度`^R`を入力するだけです。

`^R`が逆検索であるのと同様に、`^S`は前方検索であり、プロンプトは```(i-search)`':```です。これら二つは互いに組み合わせて使用することができ、前のまたは次の一致する結果をそれぞれ移動することができます。

すべての実行されたコマンドは、実行された日時と現在のREPLモードとともに `~/.julia/logs/repl_history.jl` に記録されます。検索モードは、このログファイルを検索して、以前に実行したコマンドを見つけます。これは、Juliaに `--history-file=no` フラグを渡すことで、起動時に無効にすることができます。

## Key bindings

Julia REPLはキー バインディングをうまく活用しています。いくつかの制御キー バインディングはすでに上で紹介されました（`^D`で終了、`^R`および`^S`で検索）、しかし、さらに多くのものがあります。制御キーに加えて、メタキー バインディングもあります。これらはプラットフォームによって異なりますが、ほとんどのターミナルは、キーを押しながらaltキーまたはoptionキーを使用してメタキーを送信することをデフォルトとしています（またはそのように設定できます）、またはEscを押してからキーを押すことができます。

| Keybinding           | Description                                                                                                |
|:-------------------- |:---------------------------------------------------------------------------------------------------------- |
| **Program control**  |                                                                                                            |
| `^D`                 | Exit (when buffer is empty)                                                                                |
| `^C`                 | Interrupt or cancel                                                                                        |
| `^L`                 | Clear console screen                                                                                       |
| Return/Enter, `^J`   | New line, executing if it is complete                                                                      |
| meta-Return/Enter    | Insert new line without executing it                                                                       |
| `?` or `;`           | Enter help or shell mode (when at start of a line)                                                         |
| `^R`, `^S`           | Incremental history search, described above                                                                |
| **Cursor movement**  |                                                                                                            |
| Right arrow, `^F`    | Move right one character                                                                                   |
| Left arrow, `^B`     | Move left one character                                                                                    |
| ctrl-Right, `meta-F` | Move right one word                                                                                        |
| ctrl-Left, `meta-B`  | Move left one word                                                                                         |
| Home, `^A`           | Move to beginning of line                                                                                  |
| End, `^E`            | Move to end of line                                                                                        |
| Up arrow, `^P`       | Move up one line (or change to the previous history entry that matches the text before the cursor)         |
| Down arrow, `^N`     | Move down one line (or change to the next history entry that matches the text before the cursor)           |
| Shift-Arrow Key      | Move cursor according to the direction of the Arrow key, while activating the region ("shift selection")   |
| Page-up, `meta-P`    | Change to the previous history entry                                                                       |
| Page-down, `meta-N`  | Change to the next history entry                                                                           |
| `meta-<`             | Change to the first history entry (of the current session if it is before the current position in history) |
| `meta->`             | Change to the last history entry                                                                           |
| `^-Space`            | Set the "mark" in the editing region (and de-activate the region if it's active)                           |
| `^-Space ^-Space`    | Set the "mark" in the editing region and make the region "active", i.e. highlighted                        |
| `^G`                 | De-activate the region (i.e. make it not highlighted)                                                      |
| `^X^X`               | Exchange the current position with the mark                                                                |
| **Editing**          |                                                                                                            |
| Backspace, `^H`      | Delete the previous character, or the whole region when it's active                                        |
| Delete, `^D`         | Forward delete one character (when buffer has text)                                                        |
| meta-Backspace       | Delete the previous word                                                                                   |
| `meta-d`             | Forward delete the next word                                                                               |
| `^W`                 | Delete previous text up to the nearest whitespace                                                          |
| `meta-w`             | Copy the current region in the kill ring                                                                   |
| `meta-W`             | "Kill" the current region, placing the text in the kill ring                                               |
| `^U`                 | "Kill" to beginning of line, placing the text in the kill ring                                             |
| `^K`                 | "Kill" to end of line, placing the text in the kill ring                                                   |
| `^Y`                 | "Yank" insert the text from the kill ring                                                                  |
| `meta-y`             | Replace a previously yanked text with an older entry from the kill ring                                    |
| `^T`                 | Transpose the characters about the cursor                                                                  |
| `meta-Up arrow`      | Transpose current line with line above                                                                     |
| `meta-Down arrow`    | Transpose current line with line below                                                                     |
| `meta-u`             | Change the next word to uppercase                                                                          |
| `meta-c`             | Change the next word to titlecase                                                                          |
| `meta-l`             | Change the next word to lowercase                                                                          |
| `^/`, `^_`           | Undo previous editing action                                                                               |
| `^Q`                 | Write a number in REPL and press `^Q` to open editor at corresponding stackframe or method                 |
| `meta-Left Arrow`    | Indent the current line on the left                                                                        |
| `meta-Right Arrow`   | Indent the current line on the right                                                                       |
| `meta-.`             | Insert last word from previous history entry                                                               |
| `meta-e`             | Edit the current input in an editor                                                                        |

### Customizing keybindings

JuliaのREPLのキーバインディングは、`REPL.setup_interface`に辞書を渡すことでユーザーの好みに完全にカスタマイズできます。この辞書のキーは文字または文字列である可能性があります。キー`'*'`はデフォルトのアクションを指します。Controlキーと文字`x`のバインディングは`"^x"`で示されます。Metaキーと`x`は`"\\M-x"`または`"\ex"`と書くことができ、Controlキーと`x`は`"\\C-x"`または`"^x"`と書くことができます。カスタムキーマップの値は、`nothing`（入力を無視することを示す）またはシグネチャ`(PromptState, AbstractREPL, Char)`を受け入れる関数でなければなりません。`REPL.setup_interface`関数は、REPLが初期化される前に呼び出す必要があり、操作を[`atreplinit`](@ref)で登録します。たとえば、履歴をプレフィックス検索なしで移動するために上矢印キーと下矢印キーをバインドするには、次のコードを`~/.julia/config/startup.jl`に置くことができます：

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

ユーザーは、キー入力に対する利用可能なアクションを発見するために `LineEdit.jl` を参照する必要があります。

## Tab completion

REPLのJulian、pkg、helpモードでは、関数や型の最初の数文字を入力し、タブキーを押すことで、すべての一致する項目のリストを取得できます。

```julia-repl
julia> x[TAB]
julia> xor
```

場合によっては、次の曖昧さまで名前の一部しか完成しません：

```julia-repl
julia> mapf[TAB]
julia> mapfold
```

タブを再度押すと、これを完了する可能性のある項目のリストが表示されます：

```julia-repl
julia> mapfold[TAB]
mapfoldl mapfoldr
```

入力行の最後に単一の完全なタブ補完結果が利用可能で、2文字以上が入力されている場合、補完のヒントが薄い色で表示されます。これは `Base.active_repl.options.hint_tab_completes = false` を使用するか、追加することで無効にできます。

```
atreplinit() do repl
    if VERSION >= v"1.11.0-0"
        repl.options.hint_tab_completes = false
    end
end
```

`~/.julia/config/startup.jl` に。

!!! compat "Julia 1.11"
    タブ補完ヒントはJulia 1.11で追加されました。


REPLの他のコンポーネントと同様に、検索は大文字と小文字を区別します：

```julia-repl
julia> stri[TAB]
stride     strides     string      strip

julia> Stri[TAB]
StridedArray    StridedMatrix    StridedVecOrMat  StridedVector    String
```

タブキーは、LaTeXの数学記号をそのUnicodeの同等物に置き換え、LaTeXの一致リストを取得するためにも使用できます。

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

マニュアルの [Unicode Input](@ref) セクションに、タブ補完の完全なリストがあります。

文字列とJuliaのシェルモードに対するパスの補完が機能します:

```julia-repl
julia> path="/[TAB]"
.dockerenv  .juliabox/   boot/        etc/         lib/         media/       opt/         root/        sbin/        sys/         usr/
.dockerinit bin/         dev/         home/        lib64/       mnt/         proc/        run/         srv/         tmp/         var/
shell> /[TAB]
.dockerenv  .juliabox/   boot/        etc/         lib/         media/       opt/         root/        sbin/        sys/         usr/
.dockerinit bin/         dev/         home/        lib64/       mnt/         proc/        run/         srv/         tmp/         var/
```

辞書のキーはタブ補完も可能です：

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

タブ補完はフィールドの補完にも役立ちます：

```julia-repl
julia> x = 3 + 4im;

julia> x.[TAB][TAB]
im re

julia> import UUIDs

julia> UUIDs.uuid[TAB][TAB]
uuid1        uuid4         uuid5        uuid_version
```

関数からの出力のフィールドも完了できます：

```julia-repl
julia> split("","")[1].[TAB]
lastindex  offset  string
```

関数からの出力のフィールドの完成は型推論を使用し、関数が型安定である場合にのみフィールドを提案できます。

タブ補完は、入力引数に一致する利用可能なメソッドの調査に役立ちます：

```julia-repl
julia> max([TAB] # All methods are displayed, not shown here due to size of the list

julia> max([1, 2], [TAB] # All methods where `Vector{Int}` matches as first argument
max(x, y) in Base at operators.jl:215
max(a, b, c, xs...) in Base at operators.jl:281

julia> max([1, 2], max(1, 2), [TAB] # All methods matching the arguments.
max(x, y) in Base at operators.jl:215
max(a, b, c, xs...) in Base at operators.jl:281
```

キーワードは、以下の行のように `;` の後に提案されたメソッドに表示されます。ここでは `limit` と `keepempty` がキーワード引数です：

```julia-repl
julia> split("1 1 1", [TAB]
split(str::AbstractString; limit, keepempty) in Base at strings/util.jl:302
split(str::T, splitter; limit, keepempty) where T<:AbstractString in Base at strings/util.jl:277
```

メソッドの完了は型推論を使用しており、したがって、引数が関数からの出力であっても引数が一致するかどうかを確認できます。完了が一致しないメソッドを削除できるためには、関数が型安定である必要があります。

特定の引数タイプで使用できるメソッドを知りたい場合は、関数名として `?` を使用します。これは、単一の文字列を受け入れるInteractiveUtils内の関数を探す例を示しています：

```julia-repl
julia> InteractiveUtils.?("somefile")[TAB]
edit(path::AbstractString) in InteractiveUtils at InteractiveUtils/src/editless.jl:197
less(file::AbstractString) in InteractiveUtils at InteractiveUtils/src/editless.jl:266
```

このリストは、文字列に対して呼び出すことができる `InteractiveUtils` モジュールのメソッドです。デフォルトでは、すべての引数が `Any` として型付けされているメソッドは除外されていますが、TABの代わりにSHIFT-TABを押すことでそれらも見ることができます。

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

`?("somefile")[TAB]` を使用して、すべてのモジュールを横断することもできますが、メソッドリストは長くなることがあります。

閉じ括弧を省略することで、追加の引数が必要な関数を含めることができます：

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

## Customizing Colors

JuliaとREPLで使用される色はカスタマイズ可能です。Juliaプロンプトの色を変更するには、次のようなものを`~/.julia/config/startup.jl`ファイルに追加できます。このファイルはホームディレクトリ内に配置する必要があります。

```julia
function customize_colors(repl)
    repl.prompt_color = Base.text_colors[:cyan]
end

atreplinit(customize_colors)
```

利用可能なカラキーは、REPLのヘルプモードで `Base.text_colors` と入力することで確認できます。さらに、整数の0から255は、256色サポートのある端末のカラキーとして使用できます。

ヘルプとシェルのプロンプト、入力および回答テキストの色を変更するには、上記の `customize_colors` 関数で `repl` の適切なフィールド（それぞれ `help_color`、`shell_color`、`input_color`、および `answer_color`）を設定します。後者の2つについては、`envcolors` フィールドも false に設定されていることを確認してください。

太字のフォーマットを適用することも可能で、`Base.text_colors[:bold]`を色として使用します。たとえば、回答を太字フォントで印刷するには、次のように`~/.julia/config/startup.jl`に記述できます：

```julia
function customize_colors(repl)
    repl.envcolors = false
    repl.answer_color = Base.text_colors[:bold]
end

atreplinit(customize_colors)
```

警告および情報メッセージを表示するために使用される色をカスタマイズするには、適切な環境変数を設定することができます。たとえば、エラーメッセージ、警告メッセージ、情報メッセージをそれぞれマゼンタ、黄色、シアンで表示するには、次の内容を `~/.julia/config/startup.jl` ファイルに追加できます：

```julia
ENV["JULIA_ERROR_COLOR"] = :magenta
ENV["JULIA_WARN_COLOR"] = :yellow
ENV["JULIA_INFO_COLOR"] = :cyan
```

## Changing the contextual module which is active at the REPL

REPLで式を入力すると、それらはデフォルトで`Main`モジュール内で評価されます;

```julia-repl
julia> @__MODULE__
Main
```

このコンテキストモジュールは、`REPL.activate(m)` 関数を介して変更することが可能で、ここで `m` は `Module` です。または、REPLでモジュールを入力し、モジュール名の上にカーソルを置いてキーbinding Alt-m（MacOSではEsc-m）を押すことでも変更できます。空のプロンプトでキーbindingを押すと、以前にアクティブだった非`Main`モジュールと`Main`の間でコンテキストが切り替わります。アクティブなモジュールはプロンプトに表示されます（`Main`の場合を除く）：

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

オプションのモジュール引数を取る関数は、しばしばREPLコンテキストモジュールにデフォルト設定されます。例えば、`varinfo()`を呼び出すと、現在アクティブなモジュールの変数が表示されます：

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

インターフェースを取得することは可能で、これはIPython REPLやMathematicaノートブックに似ており、番号付きの入力プロンプトと出力プレフィックスがあります。これは`REPL.numbered_prompt!()`を呼び出すことで実現されます。これを起動時に有効にしたい場合は、追加してください。

```julia
atreplinit() do repl
    @eval import REPL
    if !isdefined(repl, :interface)
        repl.interface = REPL.setup_interface(repl)
    end
    REPL.numbered_prompt!(repl)
end
```

`startup.jl`ファイルに。番号付きプロンプトでは、変数 `Out[n]`（ここで `n` は整数）を使用して以前の結果を参照できます：

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
    すべての出力が以前のREPL評価から`Out`変数に保存されるため、大きなメモリ内オブジェクト（配列など）を多く返す場合は注意が必要です。これらのオブジェクトへの参照が`Out`に残っている限り、ガーベジコレクションから保護されます。`Out`内のオブジェクトへの参照を削除する必要がある場合は、`empty!(Out)`を使用して保存されている履歴全体をクリアするか、`Out[n] = nothing`を使用して個々のエントリをクリアできます。


## TerminalMenus

TerminalMenusはJulia REPLのサブモジュールであり、ターミナル内で小さく、目立たないインタラクティブメニューを可能にします。

### Examples

```julia
import REPL
using REPL.TerminalMenus

options = ["apple", "orange", "grape", "strawberry",
            "blueberry", "peach", "lemon", "lime"]

```

#### RadioMenu

RadioMenuは、ユーザーがリストから1つのオプションを選択できるようにします。`request`関数はインタラクティブなメニューを表示し、選択された選択肢のインデックスを返します。ユーザーが'q'または`ctrl-c`を押すと、`request`は`-1`を返します。

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

出力:

```
Choose your favorite fruit:
^  grape
   strawberry
 > blueberry
v  peach
Your favorite fruit is blueberry!
```

#### MultiSelectMenu

MultiSelectMenuは、ユーザーがリストから多くの選択肢を選択できるようにします。

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

出力:

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

Julia 1.6以降、メニューを構成する推奨方法はコンストラクタを介することです。たとえば、デフォルトの複数選択メニュー

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

Unicodeの選択とナビゲーション文字を使用して描画できます。

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

より詳細な設定も可能です：

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

全体の `charset` オプションに加えて、`RadioMenu` の設定可能なオプションは次のとおりです：

  * `cursor::Char='>'|'→'`: カーソルに使用する文字
  * `up_arrow::Char='^'|'↑'`: 上矢印に使用する文字
  * `down_arrow::Char='v'|'↓'`: 下矢印に使用する文字
  * `updown_arrow::Char='I'|'↕'`: 一行ページで上下矢印に使用する文字
  * `scroll_wrap::Bool=false`: メニューの先頭/末尾でオプションでラップアラウンドします
  * `ctrl_c_interrupt::Bool=true`: `false`の場合、^Cで空を返し、`true`の場合、^CでInterruptException()をスローします。

`MultiSelectMenu` は次の機能を追加します:

  * `checked::String="[X]"|"✓"`: チェック済みのために使用する文字列
  * `unchecked::String="[ ]"|"⬚")`: チェックされていない場合に使用する文字列

独自の新しいメニュータイプを作成できます。`TerminalMenus.ConfiguredMenu`から派生したタイプは、構築時にメニューオプションを設定します。

#### Legacy interface

Julia 1.6以前、そしてJulia 1.x全体でサポートされている間、`TerminalMenus.config()`を呼び出すことでメニューを設定することもできます。

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

`AbstractMenu`の任意のサブタイプは可変でなければならず、`pagesize::Int`および`pageoffset::Int`のフィールドを含む必要があります。任意のサブタイプは、次の関数も実装しなければなりません：

```@docs
REPL.TerminalMenus.pick
REPL.TerminalMenus.cancel
REPL.TerminalMenus.writeline
```

`options` または `numoptions` のいずれかを実装する必要があります:

```@docs
REPL.TerminalMenus.options
REPL.TerminalMenus.numoptions
```

サブタイプに `selected` という名前のフィールドがない場合、次のことも実装する必要があります。

```@docs
REPL.TerminalMenus.selected
```

以下はオプションですが、追加のカスタマイズを可能にします：

```@docs
REPL.TerminalMenus.header
REPL.TerminalMenus.keypress
```
