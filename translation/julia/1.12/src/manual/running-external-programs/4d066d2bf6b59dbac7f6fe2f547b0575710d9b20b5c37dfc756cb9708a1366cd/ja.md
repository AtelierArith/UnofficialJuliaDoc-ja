# Running External Programs

ジュリアはシェル、Perl、Rubyからコマンドのバックティック表記を借用しています。しかし、ジュリアでは次のように書きます。

```jldoctest
julia> `echo hello`
`echo hello`
```

いくつかの点で、さまざまなシェル、Perl、またはRubyでの動作と異なります:

  * 代わりにコマンドを即座に実行するのではなく、バックティックはコマンドを表す [`Cmd`](@ref) オブジェクトを作成します。このオブジェクトを使用して、他のコマンドとパイプで接続することができます。[`run`](@ref) それを、そして [`read`](@ref) または [`write`](@ref) に接続します。
  * コマンドが実行されると、Juliaは特にその出力をキャプチャするように設定しない限り、出力をキャプチャしません。デフォルトでは、コマンドの出力は [`stdout`](@ref) に送られます。これは `libc` の `system` コールを使用した場合と同様です。
  * コマンドはシェルを介して実行されることはありません。代わりに、Juliaはコマンド構文を直接解析し、シェルが行うように変数を適切に補間し、単語で分割します。コマンドは`julia`の即時子プロセスとして実行され、`fork`および`exec`呼び出しを使用します。

!!! note
    以下は、LinuxやMacOSのようなPosix環境を前提としています。Windowsでは、`echo`や`dir`などの多くの類似コマンドは外部プログラムではなく、代わりにシェル`cmd.exe`自体に組み込まれています。これらのコマンドを実行する1つのオプションは、`cmd.exe`を呼び出すことです。例えば、`cmd /C echo hello`のように実行します。あるいは、CygwinのようなPosix環境内でJuliaを実行することもできます。


外部プログラムを実行する簡単な例は次のとおりです：

```jldoctest
julia> mycommand = `echo hello`
`echo hello`

julia> typeof(mycommand)
Cmd

julia> run(mycommand);
hello
```

`hello`は、`echo`コマンドの出力であり、[`stdout`](@ref)に送信されます。外部コマンドが正常に実行されない場合、runメソッドは[`ProcessFailedException`](@ref)をスローします。

外部コマンドの出力を読みたい場合は、[`read`](@ref) または [`readchomp`](@ref) を代わりに使用できます:

```jldoctest
julia> read(`echo hello`, String)
"hello\n"

julia> readchomp(`echo hello`)
"hello"
```

より一般的には、[`open`](@ref)を使用して、外部コマンドから読み取ったり、書き込んだりすることができます。

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

コマンドのプログラム名と個々の引数は、コマンドが文字列の配列のようにアクセスされ、反復処理されることができます：

```jldoctest
julia> collect(`echo "foo bar"`)
2-element Vector{String}:
 "echo"
 "foo bar"

julia> `echo "foo bar"`[2]
"foo bar"
```

`IOBuffer`を渡すこともでき、後でそこから読み取ることができます：

```jldoctest
julia> io = PipeBuffer(); # PipeBuffer is a type of IOBuffer

julia> run(`echo world`, devnull, io, stderr);

julia> readlines(io)
1-element Vector{String}:
 "world"
```

## [Interpolation](@id command-interpolation)

ファイルの名前を変数 `file` に格納し、その名前をコマンドの引数として使用したい場合、少し複雑なことをしたいとします。文字列リテラルのように `$` を使って補間することができます（[Strings](@ref) を参照）。

```jldoctest
julia> file = "/etc/passwd"
"/etc/passwd"

julia> `sort $file`
`sort /etc/passwd`
```

シェルを介して外部プログラムを実行する際の一般的な落とし穴は、ファイル名にシェルに特別な意味を持つ文字が含まれている場合、それが望ましくない動作を引き起こす可能性があることです。例えば、`/etc/passwd`の代わりに、ファイル`/Volumes/External HD/data.csv`の内容をソートしたいとしましょう。試してみましょう：

```jldoctest
julia> file = "/Volumes/External HD/data.csv"
"/Volumes/External HD/data.csv"

julia> `sort $file`
`sort '/Volumes/External HD/data.csv'`
```

ファイル名はどのように引用されるのか？Juliaは`file`が単一の引数として補間されることを知っているので、単語をあなたのために引用します。実際には、それは完全に正確ではありません：`file`の値は決してシェルによって解釈されないため、実際の引用は必要ありません。引用符はユーザーへの提示のためだけに挿入されます。これは、シェルの単語の一部として値を補間しても機能します：

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

ご覧のとおり、`path` 変数内のスペースは適切にエスケープされています。しかし、複数の単語を*挿入*したい場合はどうすればよいでしょうか？その場合は、配列（または他のイテラブルコンテナ）を使用してください：

```jldoctest
julia> files = ["/etc/passwd","/Volumes/External HD/data.csv"]
2-element Vector{String}:
 "/etc/passwd"
 "/Volumes/External HD/data.csv"

julia> `grep foo $files`
`grep foo /etc/passwd '/Volumes/External HD/data.csv'`
```

シェルの単語の一部として配列を補間すると、Juliaはシェルの`{a,b,c}`引数生成をエミュレートします：

```jldoctest
julia> names = ["foo","bar","baz"]
3-element Vector{String}:
 "foo"
 "bar"
 "baz"

julia> `grep xylophone $names.txt`
`grep xylophone foo.txt bar.txt baz.txt`
```

さらに、複数の配列を同じ単語に補間すると、シェルのデカルト積生成の動作がエミュレートされます：

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

リテラル配列を補間できるため、一時的な配列オブジェクトを最初に作成する必要なく、この生成機能を使用できます:

```jldoctest
julia> `rm -rf $["foo","bar","baz","qux"].$["aux","log","pdf"]`
`rm -rf foo.aux foo.log foo.pdf bar.aux bar.log bar.pdf baz.aux baz.log baz.pdf qux.aux qux.log qux.pdf`
```

## Quoting

必然的に、あまりにも単純ではないコマンドを書きたいと思うようになり、引用符を使用する必要があります。以下は、シェルプロンプトでのPerlのワンライナーの簡単な例です：

```
sh$ perl -le '$|=1; for (0..3) { print }'
0
1
2
3
```

Perlの式は、2つの理由からシングルクォートで囲む必要があります。1つ目は、スペースが式を複数のシェルワードに分割しないようにするため、2つ目は、`$|`のようなPerlの変数の使用が補間を引き起こさないようにするためです。他のケースでは、補間が*発生する*ようにダブルクォートを使用したい場合もあります。

```
sh$ first="A"
sh$ second="B"
sh$ perl -le '$|=1; print for @ARGV' "1: $first" "2: $second"
1: A
2: B
```

一般的に、Juliaのバックティック構文は慎重に設計されており、シェルコマンドをそのままバックティックに切り取って貼り付けることができ、動作します：エスケープ、引用、および補間の動作はシェルと同じです。唯一の違いは、補間が統合されており、Juliaの単一の文字列値と複数の値のコンテナの概念を認識していることです。上記の2つの例をJuliaで試してみましょう：

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

結果は同じであり、Juliaの補間動作はシェルの動作を模倣していますが、Juliaがファーストクラスのイテラブルオブジェクトをサポートしているため、いくつかの改善があります。一方で、ほとんどのシェルはこれに対してスペースで分割された文字列を使用しているため、あいまいさが生じます。シェルコマンドをJuliaに移植しようとする際は、まずコピー＆ペーストを試してみてください。Juliaはコマンドを実行する前に表示するため、簡単に安全にその解釈を確認することができ、何の損害も与えることはありません。

## Pipelines

シェルのメタキャラクタ、例えば `|`、`&`、および `>` は、Juliaのバックティック内で引用符を付ける（またはエスケープする）必要があります：

```jldoctest
julia> run(`echo hello '|' sort`);
hello | sort

julia> run(`echo hello \| sort`);
hello | sort
```

この式は、`echo` コマンドを `hello`、`|`、および `sort` の3つの単語を引数として呼び出します。その結果、単一の行が印刷されます: `hello | sort`。では、パイプラインはどのように構築するのでしょうか？バックティック内で `'|'` を使用する代わりに、[`pipeline`](@ref) を使用します:

```jldoctest
julia> run(pipeline(`echo hello`, `sort`));
hello
```

これは `echo` コマンドの出力を `sort` コマンドにパイプします。もちろん、ソートする行が1つしかないので、これはあまり面白くありませんが、もっと興味深いことができることは確かです：

```julia-repl
julia> run(pipeline(`cut -d: -f3 /etc/passwd`, `sort -n`, `tail -n5`))
210
211
212
213
214
```

これはUNIXシステム上で最も高い5つのユーザーIDを印刷します。`cut`、`sort`、および`tail`コマンドはすべて、現在の`julia`プロセスの即時の子プロセスとして生成され、間にシェルプロセスはありません。Julia自体が、通常シェルによって行われるパイプの設定やファイルディスクリプタの接続を行います。Juliaがこれを自分で行うため、より良い制御を保持し、シェルではできないいくつかのことを行うことができます。

Juliaは複数のコマンドを並行して実行できます：

```jldoctest; filter = r"(world\nhello|hello\nworld)"
julia> run(`echo hello` & `echo world`);
world
hello
```

出力の順序は非決定的です。なぜなら、2つの `echo` プロセスがほぼ同時に開始され、互いに共有する [`stdout`](@ref) ディスクリプタへの最初の書き込みを競い合うからです。Juliaは、これら2つのプロセスの出力を別のプログラムにパイプすることを許可します：

```jldoctest
julia> run(pipeline(`echo world` & `echo hello`, `sort`));
hello
world
```

UNIXの配管の観点から見ると、ここで起こっているのは、単一のUNIXパイプオブジェクトが作成され、両方の`echo`プロセスによって書き込まれ、パイプのもう一方の端が`sort`コマンドによって読み取られるということです。

IOリダイレクションは、`pipeline`関数にキーワード引数`stdin`、`stdout`、および`stderr`を渡すことで実現できます：

```julia
pipeline(`do_work`, stdout=pipeline(`sort`, "out.txt"), stderr="errs.txt")
```

### Avoiding Deadlock in Pipelines

パイプラインの両端から単一のプロセスで読み書きする際には、カーネルにすべてのデータをバッファリングさせないようにすることが重要です。

例えば、コマンドの出力をすべて読み取る場合は、`read(out, String)`を呼び出し、`wait(process)`は呼び出さないでください。前者はプロセスによって書き込まれたすべてのデータを積極的に消費しますが、後者はリーダーが接続されるのを待ちながらデータをカーネルのバッファに保存しようとします。

別の一般的な解決策は、パイプラインのリーダーとライターを別々の [`Task`](@ref) に分けることです:

```julia
writer = Threads.@spawn write(process, "data")
reader = Threads.@spawn do_compute(read(process, String))
wait(writer)
fetch(reader)
```

（一般的に、リーダーは別のタスクではなく、私たちはすぐに`fetch`するので）。

### Complex Example

高水準プログラミング言語、ファーストクラスのコマンド抽象、およびプロセス間のパイプの自動設定の組み合わせは、非常に強力です。簡単に作成できる複雑なパイプラインの感覚を与えるために、ここにいくつかのより洗練された例を示します。Perlのワンライナーの過剰な使用についてお詫び申し上げます。

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

これは、1つのプロデューサーが2つの同時コンシューマーにデータを供給する古典的な例です。1つの `perl` プロセスが0から5までの数字を含む行を生成し、2つの並行プロセスがその出力を消費します。1つは行の先頭に「A」を付け、もう1つは「B」を付けます。最初の行をどちらのコンシューマーが取得するかは非決定的ですが、一度そのレースに勝つと、行は1つのプロセスと次にもう1つのプロセスによって交互に消費されます。（Perlで `$|=1` を設定すると、各print文が [`stdout`](@ref) ハンドルをフラッシュするため、この例が機能するために必要です。そうでなければ、すべての出力がバッファリングされ、一度にパイプに印刷され、1つのコンシューマープロセスによってのみ読み取られます。）

ここにさらに複雑なマルチステージのプロデューサー-コンシューマーの例があります:

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

この例は前の例と似ていますが、消費者の段階が2つあり、段階ごとにレイテンシが異なるため、飽和スループットを維持するために異なる数の並列ワーカーを使用します。

これらのすべての例を試して、どのように機能するかを確認することを強くお勧めします。

## `Cmd` Objects

バックティック構文は、タイプ [`Cmd`](@ref) のオブジェクトを作成します。このようなオブジェクトは、既存の `Cmd` または引数のリストから直接構築することもできます：

```julia
run(Cmd(`pwd`, dir=".."))
run(Cmd(["pwd"], detach=true, ignorestatus=true))
```

これにより、キーワード引数を介して`Cmd`の実行環境のいくつかの側面を指定できます。たとえば、`dir`キーワードは`Cmd`の作業ディレクトリを制御します：

```jldoctest
julia> run(Cmd(`pwd`, dir="/"));
/
```

`env` キーワードを使用すると、実行環境変数を設定できます：

```jldoctest
julia> run(Cmd(`sh -c "echo foo \$HOWLONG"`, env=("HOWLONG" => "ever!",)));
foo ever!
```

[`Cmd`](@ref) の追加キーワード引数を参照してください。 [`setenv`](@ref) および [`addenv`](@ref) コマンドは、それぞれ `Cmd` 実行環境変数を置き換えたり追加したりする別の手段を提供します。

```jldoctest
julia> run(setenv(`sh -c "echo foo \$HOWLONG"`, ("HOWLONG" => "ever!",)));
foo ever!

julia> run(addenv(`sh -c "echo foo \$HOWLONG"`, "HOWLONG" => "ever!"));
foo ever!
```
