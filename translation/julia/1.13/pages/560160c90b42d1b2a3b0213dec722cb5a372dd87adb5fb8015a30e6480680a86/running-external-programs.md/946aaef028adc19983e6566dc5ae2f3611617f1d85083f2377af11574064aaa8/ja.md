# Running External Programs

Julia は、コマンドを表すバッククォート記法をシェル、Perl、Ruby から借用しています。ただし Julia では、次のように記述した場合、

```jldoctest
julia> `echo hello`
`echo hello`
```

さまざまなシェル、Perl、Ruby での動作とは、いくつかの点で異なります。

  * コマンドをすぐに実行するのではなく、バッククォートはコマンドを表す [`Cmd`](@ref) オブジェクトを作成します。このオブジェクトを使って、パイプでほかのコマンドと接続したり、[`run`](@ref) したり、[`read`](@ref) や [`write`](@ref) したりできます。
  * コマンドを実行しても、明示的に設定しない限り、Julia はその出力を捕捉しません。デフォルトでは、コマンドの出力は [`stdout`](@ref) に送られます。これは、`libc` の `system` 呼び出しと同じです。
  * コマンドはシェルを介さずに実行されます。Julia はコマンド構文を直接解析し、シェルと同様に、シェルの引用符構文に従って変数を適切に展開し、単語に分割します。コマンドは `julia` の直接の子プロセスとして、`fork` および `exec` の呼び出しを使って実行されます。

!!! note
    以下では、Linux や MacOS のような Posix 環境を前提としています。Windows では、`echo` や `dir` など、多くの類似コマンドは外部プログラムではなく、シェル `cmd.exe` 自体に組み込まれています。こうしたコマンドを実行する方法の一つは、`cmd.exe` を呼び出すことです。たとえば `cmd /C echo hello` のようにします。あるいは、Cygwin などの Posix 環境内で Julia を実行することもできます。


外部プログラムを実行する簡単な例を見てみましょう。

```jldoctest
julia> mycommand = `echo hello`
`echo hello`

julia> typeof(mycommand)
Cmd

julia> run(mycommand);
hello
```

`hello` は、`echo` コマンドの出力で、[`stdout`](@ref) に送られます。外部コマンドの実行に失敗すると、run メソッドは [`ProcessFailedException`](@ref) をスローします。

外部コマンドの出力を読み取りたい場合は、代わりに [`read`](@ref) または [`readchomp`](@ref) を使えます。

```jldoctest
julia> read(`echo hello`, String)
"hello\n"

julia> readchomp(`echo hello`)
"hello"
```

より一般的には、[`open`](@ref) を使って、外部コマンドからの読み取りや外部コマンドへの書き込みを行えます。

```jldoctest
julia> open(`less`, "w", stdout) do io
           for i = 1:3
               println(io, i)
           end
       end
1
2
3
```

コマンドのプログラム名と個々の引数には、コマンドを文字列の配列とみなしてアクセスし、反復処理できます。

```jldoctest
julia> collect(`echo "foo bar"`)
2-element Vector{String}:
 "echo"
 "foo bar"

julia> `echo "foo bar"`[2]
"foo bar"
```

`IOBuffer` を渡し、後からそこから読み取ることもできます。

```jldoctest
julia> io = PipeBuffer(); # PipeBuffer is a type of IOBuffer

julia> run(`echo world`, devnull, io, stderr);

julia> readlines(io)
1-element Vector{String}:
 "world"
```

## [Interpolation](@id command-interpolation)

もう少し複雑な処理として、変数 `file` に格納されたファイル名をコマンドの引数として使う場合を考えてみましょう。文字列リテラルの場合と同様に、展開には `$` を使えます（[Strings](@ref) を参照）。

```jldoctest
julia> file = "/etc/passwd"
"/etc/passwd"

julia> `sort $file`
`sort /etc/passwd`
```

シェル経由で外部プログラムを実行する際によくある落とし穴は、ファイル名にシェルで特別な意味を持つ文字が含まれていると、意図しない動作を引き起こす可能性があることです。たとえば、`/etc/passwd` ではなく、ファイル `/Volumes/External HD/data.csv` の内容を並べ替えたいとします。試してみましょう。

```jldoctest
julia> file = "/Volumes/External HD/data.csv"
"/Volumes/External HD/data.csv"

julia> `sort $file`
`sort '/Volumes/External HD/data.csv'`
```

ファイル名はどのように引用符で囲まれたのでしょうか。Julia は `file` が単一の引数として展開されることを認識し、その単語を引用符で囲みます。厳密には、これは正確な説明ではありません。`file` の値はシェルによって解釈されないため、実際に引用符で囲む必要はありません。引用符はユーザーに表示するためだけに挿入されます。シェルの単語の一部として値を展開する場合も、同様に機能します。

```jldoctest
julia> path = "/Volumes/External HD"
"/Volumes/External HD"

julia> name = "data"
"data"

julia> ext = "csv"
"csv"

julia> `sort $path/$name.$ext`
`sort '/Volumes/External HD/data.csv'`
```

ご覧のとおり、変数 `path` に含まれる空白は適切にエスケープされています。では、複数の単語を展開したい場合はどうすればよいでしょうか。その場合は、配列（またはほかの反復可能なコンテナ）を使います。

```jldoctest
julia> files = ["/etc/passwd","/Volumes/External HD/data.csv"]
2-element Vector{String}:
 "/etc/passwd"
 "/Volumes/External HD/data.csv"

julia> `grep foo $files`
`grep foo /etc/passwd '/Volumes/External HD/data.csv'`
```

配列をシェルの単語の一部として展開すると、Julia はシェルの `{a,b,c}` 引数生成をエミュレートします。

```jldoctest
julia> names = ["foo","bar","baz"]
3-element Vector{String}:
 "foo"
 "bar"
 "baz"

julia> `grep xylophone $names.txt`
`grep xylophone foo.txt bar.txt baz.txt`
```

さらに、同じ単語に複数の配列を展開すると、シェルの直積生成の動作がエミュレートされます。

```jldoctest
julia> names = ["foo","bar","baz"]
3-element Vector{String}:
 "foo"
 "bar"
 "baz"

julia> exts = ["aux","log"]
2-element Vector{String}:
 "aux"
 "log"

julia> `rm -f $names.$exts`
`rm -f foo.aux foo.log bar.aux bar.log baz.aux baz.log`
```

配列リテラルも展開できるため、一時的な配列オブジェクトをあらかじめ作成しなくても、この生成機能を利用できます。

```jldoctest
julia> `rm -rf $["foo","bar","baz","qux"].$["aux","log","pdf"]`
`rm -rf foo.aux foo.log foo.pdf bar.aux bar.log bar.pdf baz.aux baz.log baz.pdf qux.aux qux.log qux.pdf`
```

## Quoting

やがて、もっと複雑なコマンドを書きたくなり、引用符が必要になります。シェルのプロンプトで Perl のワンライナーを実行する簡単な例を示します。

```
sh$ perl -le '$|=1; for (0..3) { print }'
0
1
2
3
```

Perl の式を単一引用符で囲む必要があるのは、二つの理由からです。空白によって式が複数のシェル単語に分割されるのを防ぐため、そして `$|` のような Perl 変数（そう、これは Perl の変数名です）が展開されないようにするためです。一方、展開させたい場合は、二重引用符を使うこともあります。

```
sh$ first="A"
sh$ second="B"
sh$ perl -le '$|=1; print for @ARGV' "1: $first" "2: $second"
1: A
2: B
```

一般に、Julia のバッククォート構文は、シェルコマンドをそのままバッククォート内にコピー＆ペーストしても動作するよう、慎重に設計されています。エスケープ、引用符、展開の動作はシェルと同じです。唯一の違いは、展開が Julia に組み込まれており、単一の文字列値と複数の値を格納するコンテナを区別できることです。先ほどの二つの例を Julia で試してみましょう。

```jldoctest
julia> A = `perl -le '$|=1; for (0..3) { print }'`
`perl -le '$|=1; for (0..3) { print }'`

julia> run(A);
0
1
2
3

julia> first = "A"; second = "B";

julia> B = `perl -le 'print for @ARGV' "1: $first" "2: $second"`
`perl -le 'print for @ARGV' '1: A' '2: B'`

julia> run(B);
1: A
2: B
```

結果は同じです。Julia の展開動作はシェルの動作を模倣しつつ、いくつかの点で改善されています。Julia は第一級の反復可能オブジェクトをサポートしていますが、多くのシェルでは空白で分割した文字列を使うため、曖昧さが生じるからです。シェルコマンドを Julia に移植する際は、まずそのままコピー＆ペーストしてみてください。Julia は実行前にコマンドを表示するので、何も変更せずに、その解釈を簡単かつ安全に確認できます。

## Pipelines

`|`、`&`、`>` などのシェルのメタ文字は、Julia のバッククォート内では引用符で囲むか、エスケープする必要があります。

```jldoctest
julia> run(`echo hello '|' sort`);
hello | sort

julia> run(`echo hello \| sort`);
hello | sort
```

この式は `echo` コマンドを呼び出し、三つの単語を引数として渡します。引数は `hello`、`|`、`sort` です。その結果、`hello | sort` という一行が出力されます。では、パイプラインを作るにはどうすればよいでしょうか。バッククォート内で `'|'` を使う代わりに、[`pipeline`](@ref) を使います。

```jldoctest
julia> run(pipeline(`echo hello`, `sort`));
hello
```

これにより、`echo` コマンドの出力が `sort` コマンドにパイプで渡されます。もちろん、並べ替える行が一つしかないので、あまり面白い例ではありません。もっと興味深い処理もできます。

```julia-repl
julia> run(pipeline(`cut -d: -f3 /etc/passwd`, `sort -n`, `tail -n5`))
210
211
212
213
214
```

これは UNIX システムで最も大きいユーザー ID を五つ表示します。`cut`、`sort`、`tail` の各コマンドは、シェルプロセスを介さず、現在の `julia` プロセスの直接の子プロセスとして起動されます。通常はシェルが行うパイプの設定やファイル記述子の接続を、Julia 自身が行います。Julia がこれを直接行うため、より適切に制御でき、シェルにはできない処理も可能です。

Julia では複数のコマンドを並列に実行できます。

```jldoctest; filter = r"(world\nhello|hello\nworld)"
julia> run(`echo hello` & `echo world`);
world
hello
```

二つの `echo` プロセスがほぼ同時に起動され、互いに共有する [`stdout`](@ref) 記述子と、親プロセスである `julia` プロセスに対して、どちらが先に書き込むかを競うため、ここでの出力順序は決定的ではありません。Julia では、両方のプロセスの出力を別のプログラムにパイプで渡すこともできます。

```jldoctest
julia> run(pipeline(`echo world` & `echo hello`, `sort`));
hello
world
```

UNIX の仕組みとしては、単一の UNIX パイプオブジェクトが作成され、二つの `echo` プロセスがそこに書き込み、パイプのもう一端から `sort` コマンドが読み取ります。

IO のリダイレクトは、`pipeline` 関数にキーワード引数 `stdin`、`stdout`、`stderr` を渡すことで行えます。

```julia
pipeline(`do_work`, stdout=pipeline(`sort`, "out.txt"), stderr="errs.txt")
```

### Avoiding Deadlock in Pipelines

単一のプロセスからパイプラインの両端を読み書きする場合、カーネルにすべてのデータをバッファリングさせないようにすることが重要です。

たとえば、コマンドの出力をすべて読み取る場合は、`wait(process)` ではなく `read(out, String)` を呼び出してください。前者はプロセスが書き込むデータをすべて積極的に読み取りますが、後者は読み取り側が接続されるまで、データをカーネルのバッファに格納しようとするためです。

よく使われる別の方法は、パイプラインの読み取り側と書き込み側を別々の [`Task`](@ref) に分けることです。

```julia
writer = Threads.@spawn write(process, "data")
reader = Threads.@spawn do_compute(read(process, String))
wait(writer)
fetch(reader)
```

（通常、読み取り側は独立したタスクではありません。すぐに `fetch` するためです。）

### Complex Example

高水準プログラミング言語、第一級のコマンド抽象化、プロセス間のパイプの自動設定を組み合わせると、強力な機能が得られます。簡単に作成できる複雑なパイプラインの例として、Perl のワンライナーを多用している点はご容赦いただき、さらに高度な例をいくつか紹介します。

```jldoctest prefixer; filter = r"([A-B] [0-5])"
julia> prefixer(prefix, sleep) = `perl -nle '$|=1; print "'$prefix' ", $_; sleep '$sleep';'`;

julia> run(pipeline(`perl -le '$|=1; for(0..5){ print; sleep 1 }'`, prefixer("A",2) & prefixer("B",2)));
B 0
A 1
B 2
A 3
B 4
A 5
```

これは、一つの生産者から二つの並行する消費者にデータを送る典型的な例です。一つの `perl` プロセスが、0 から 5 までの数字を含む行を生成します。その出力を二つの並列プロセスが消費し、一方は各行の先頭に文字「A」を、もう一方は文字「B」を付けます。どちらの消費者が最初の行を受け取るかは決定的ではありませんが、いったん競争に勝つと、その後は二つのプロセスが交互に行を消費します。（Perl で `$|=1` を設定すると、print 文のたびに [`stdout`](@ref) ハンドルがフラッシュされます。この例を動作させるにはこれが必要です。そうしないと、出力全体がバッファリングされて一度にパイプへ書き込まれ、一方の消費者プロセスだけが読み取ることになります。）

さらに複雑な、多段階の生産者・消費者の例を示します。

```jldoctest prefixer; filter = r"[A-B] [X-Z] [0-5]"
julia> run(pipeline(`perl -le '$|=1; for(0..5){ print; sleep 1 }'`,
           prefixer("X",3) & prefixer("Y",3) & prefixer("Z",3),
           prefixer("A",2) & prefixer("B",2)));
A X 0
B Y 1
A Z 2
B X 3
A Y 4
B Z 5
```

この例は前の例と似ていますが、消費者の段階が二つあります。また、各段階のレイテンシが異なるため、飽和したスループットを維持できるよう、並列ワーカーの数を変えています。

これらの例を実際に試して、動作を確認することを強くお勧めします。

## `Cmd` Objects

バッククォート構文は [`Cmd`](@ref) 型のオブジェクトを作成します。このようなオブジェクトは、既存の `Cmd` や引数のリストから直接作成することもできます。

```julia
run(Cmd(`pwd`, dir=".."))
run(Cmd(["pwd"], detach=true, ignorestatus=true))
```

これにより、キーワード引数を使って `Cmd` の実行環境に関するいくつかの設定を指定できます。たとえば、`dir` キーワードを使うと、`Cmd` の作業ディレクトリを指定できます。

```jldoctest
julia> run(Cmd(`pwd`, dir="/"));
/
```

また、`env` キーワードを使うと、実行環境の変数を設定できます。

```jldoctest
julia> run(Cmd(`sh -c "echo foo \$HOWLONG"`, env=("HOWLONG" => "ever!",)));
foo ever!
```

その他のキーワード引数については、[`Cmd`](@ref) を参照してください。[`setenv`](@ref) コマンドと [`addenv`](@ref) コマンドを使って、`Cmd` の実行環境変数を置き換えたり、追加したりすることもできます。

```jldoctest
julia> run(setenv(`sh -c "echo foo \$HOWLONG"`, ("HOWLONG" => "ever!",)));
foo ever!

julia> run(addenv(`sh -c "echo foo \$HOWLONG"`, "HOWLONG" => "ever!"));
foo ever!
```
