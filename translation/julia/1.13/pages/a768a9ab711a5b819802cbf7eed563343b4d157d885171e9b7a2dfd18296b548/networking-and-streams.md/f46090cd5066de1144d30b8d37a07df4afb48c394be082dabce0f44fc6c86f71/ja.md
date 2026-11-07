# Networking and Streams

Julia には、端末、パイプ、TCP ソケットなどのストリーミング I/O オブジェクトを扱うための豊富なインターフェースが用意されています。これらのオブジェクトでは、データをストリームとして送受信できます。つまり、データは利用可能になった順に処理されます。このインターフェースはシステムレベルでは非同期ですが、プログラマーには同期的な形式で提供されます。これは、Julia の協調的スレッド機能（[coroutine](@ref man-tasks)）を多用することで実現されています。

## Basic Stream I/O

Julia のすべてのストリームは、少なくとも [`read`](@ref) メソッドと [`write`](@ref) メソッドを公開しています。どちらもストリームを第 1 引数に取ります。たとえば、次のようになります。

```julia-repl
julia> write(stdout, "Hello World");  # suppress return value 11 with ;
Hello World
julia> read(stdin, Char)

'\n': ASCII/Unicode U+000a (category Cc: Other, control)
```

[`write`](@ref) は、[`stdout`](@ref) に書き込まれたバイト数（`"Hello World"`）である 11 を返します。ただし、この戻り値は `;` によって表示されません。

ここでは、Julia に改行を読み込ませるため、もう一度 Enter キーを押しました。この例から分かるように、[`write`](@ref) は書き込むデータを第 2 引数に取る一方、[`read`](@ref) は読み込むデータの型を第 2 引数に取ります。

たとえば、単純なバイト配列を読み込むには、次のようにします。

```julia-repl
julia> x = zeros(UInt8, 4)
4-element Vector{UInt8}:
 0x00
 0x00
 0x00
 0x00

julia> read!(stdin, x)
abcd
4-element Vector{UInt8}:
 0x61
 0x62
 0x63
 0x64
```

ただし、これは少し扱いにくいため、いくつかの便利なメソッドが用意されています。たとえば、上の処理は次のようにも書けます。

```julia-repl
julia> read(stdin, 4)
abcd
4-element Vector{UInt8}:
 0x61
 0x62
 0x63
 0x64
```

行全体を読み込みたい場合は、次のようにします。

```julia-repl
julia> readline(stdin)
abcd
"abcd"
```

端末の設定によっては、TTY（「テレタイプ端末」）が行バッファリングを行うため、`stdin` のデータが Julia に送られる前に、もう一度 Enter キーを押す必要がある場合があります。TTY 上でコマンドラインから Julia を実行すると、出力は既定でコンソールに送られ、標準入力はキーボードから読み込まれます。

[`stdin`](@ref) からすべての行を読み込むには、[`eachline`](@ref) を使います。

```julia
for line in eachline(stdin)
    print("Found $line")
end
```

文字単位で読み込む場合は、[`read`](@ref) を使います。

```julia
while !eof(stdin)
    x = read(stdin, Char)
    println("Found: $x")
end
```

## Text I/O

前述の [`write`](@ref) メソッドは、バイナリストリームを対象とする点に注意してください。特に、値は標準的なテキスト表現に変換されず、そのまま書き出されます。

```jldoctest
julia> write(stdout, 0x61);  # suppress return value 1 with ;
a
```

[`write`](@ref) 関数によって `a` が [`stdout`](@ref) に書き込まれ、戻り値は `1` になります（`0x61` は 1 バイトだからです）。

テキスト I/O には、用途に応じて [`print`](@ref) または [`show`](@ref) メソッドを使います（この 2 つのメソッドの違いについて詳しくは、それぞれのドキュメントを参照してください）。

```jldoctest
julia> print(stdout, 0x61)
97
```

カスタム型の display メソッドの実装方法については、[Custom pretty-printing](@ref man-custom-pretty-printing) を参照してください。

## IO Output Contextual Properties

IO 出力では、show メソッドにコンテキスト情報を渡せると便利な場合があります。[`IOContext`](@ref) オブジェクトは、任意のメタデータを IO オブジェクトに関連付けるための仕組みを提供します。たとえば、`:compact => true` は IO オブジェクトにヒント用のパラメーターを追加し、呼び出された show メソッドに（可能であれば）短い出力を行うよう指示します。一般的なプロパティの一覧については、[`IOContext`](@ref) のドキュメントを参照してください。

## Working with Files

`write(filename::String, content)` メソッドを使うと、ファイルに内容を書き込めます。

```julia-repl
julia> write("hello.txt", "Hello, World!")
13
```

*（`13` は書き込まれたバイト数です。）*

`read(filename::String)` メソッドを使うとファイルの内容を読み込めます。また、内容を文字列として読み込むには `read(filename::String, String)` を使います。

```julia-repl
julia> read("hello.txt", String)
"Hello, World!"
```

### Advanced: streaming files

上記の `read` メソッドと `write` メソッドを使うと、ファイルの内容を読み書きできます。Julia には、ほかの多くの環境と同様に [`open`](@ref) 関数もあります。この関数はファイル名を受け取り、そのファイルの読み書きに使える [`IOStream`](@ref) オブジェクトを返します。たとえば、内容が `Hello, World!` の `hello.txt` というファイルがあるとします。

```julia-repl
julia> f = open("hello.txt")
IOStream(<file hello.txt>)

julia> readlines(f)
1-element Vector{String}:
 "Hello, World!"
```

ファイルに書き込むには、write フラグ（`"w"`）を指定して開きます。

```julia-repl
julia> f = open("hello.txt","w")
IOStream(<file hello.txt>)

julia> write(f,"Hello again.")
12
```

この時点で `hello.txt` の内容を確認すると、空のままであることが分かります。実際には、まだ何もディスクに書き込まれていません。書き込み内容がディスクにフラッシュされる前に、`IOStream` を閉じる必要があるためです。

```julia-repl
julia> close(f)
```

もう一度 `hello.txt` を確認すると、内容が変更されていることが分かります。

ファイルを開き、その内容を処理してから閉じる、というのはよくあるパターンです。これを簡単に行うため、[`open`](@ref) には別の呼び出し方もあります。第 1 引数に関数、第 2 引数にファイル名を渡すと、ファイルを開き、そのファイルを引数として関数を呼び出した後、ファイルを閉じます。たとえば、次の関数があるとします。

```julia
function read_and_capitalize(f::IOStream)
    return uppercase(read(f, String))
end
```

次のように呼び出せます。

```julia-repl
julia> open(read_and_capitalize, "hello.txt")
"HELLO AGAIN."
```

これにより、`hello.txt` を開き、その内容に対して `read_and_capitalize` を呼び出し、`hello.txt` を閉じて、大文字に変換した内容を返します。

名前付き関数を定義する手間も省きたい場合は、無名関数をその場で作成する `do` 構文を使えます。

```julia-repl
julia> open("hello.txt") do f
           uppercase(read(f, String))
       end
"HELLO AGAIN."
```

標準出力をファイルにリダイレクトするには、

```# Open file for writing
out_file = open("output.txt", "w")

# Redirect stdout to file
redirect_stdout(out_file) do
    # Your code here
    println("This output goes to `out_file` via the `stdout` variable.")
end

# Close file
close(out_file)

```

標準出力をファイルにリダイレクトすると、プログラムの出力を保存して分析したり、処理を自動化したり、コンプライアンス要件に対応したりできます。

## A simple TCP example

TCP ソケットを使った簡単な例から始めましょう。この機能は、`Sockets` という標準ライブラリパッケージで提供されています。まず、簡単なサーバーを作成します。

```julia-repl
julia> using Sockets

julia> errormonitor(Threads.@spawn begin
           server = listen(2000)
           while true
               sock = accept(server)
               println("Hello World\n")
           end
       end)
Task (runnable) @0x00007fd31dc11ae0
```

Unix ソケット API に慣れている方には、メソッド名に見覚えがあるでしょう。ただし、使い方は生の Unix ソケット API よりもやや簡単です。最初の [`listen`](@ref) 呼び出しでは、この例の場合、指定したポート（2000）で着信接続を待ち受けるサーバーを作成します。同じ関数を使って、ほかの種類のサーバーも作成できます。

```julia-repl
julia> listen(2000) # Listens on localhost:2000 (IPv4)
Sockets.TCPServer(active)

julia> listen(ip"127.0.0.1",2000) # Equivalent to the first
Sockets.TCPServer(active)

julia> listen(ip"::1",2000) # Listens on localhost:2000 (IPv6)
Sockets.TCPServer(active)

julia> listen(IPv4(0),2001) # Listens on port 2001 on all IPv4 interfaces
Sockets.TCPServer(active)

julia> listen(IPv6(0),2001) # Listens on port 2001 on all IPv6 interfaces
Sockets.TCPServer(active)

julia> listen("testsocket") # Listens on a UNIX domain socket
Sockets.PipeServer(active)

julia> listen("\\\\.\\pipe\\testsocket") # Listens on a Windows named pipe
Sockets.PipeServer(active)
```

最後の呼び出しでは戻り値の型が異なることに注意してください。このサーバーは TCP ではなく、名前付きパイプ（Windows）または UNIX ドメインソケットで待ち受けるためです。また、Windows の名前付きパイプでは、名前のプレフィックス（`\\.\pipe\`）によって [file type](https://docs.microsoft.com/windows/desktop/ipc/pipe-names) が一意に識別されるよう、所定の形式にする必要があります。TCP と名前付きパイプまたは UNIX ドメインソケットの違いは微妙で、[`accept`](@ref) メソッドと [`connect`](@ref) メソッドに関係します。[`accept`](@ref) メソッドは、先ほど作成したサーバーに接続しようとしているクライアントとの接続を取得します。一方、[`connect`](@ref) 関数は、指定した方式でサーバーに接続します。[`connect`](@ref) 関数は [`listen`](@ref) と同じ引数を取るため、環境（ホスト、cwd など）が同じであれば、listen に渡したものと同じ引数を [`connect`](@ref) に渡して接続を確立できます。それでは、先ほど作成したサーバーを使って試してみましょう。

```julia-repl
julia> connect(2000)
TCPSocket(open, 0 bytes waiting)

julia> Hello World
```

予想どおり、「Hello World」と表示されました。では、内部で何が起きたのかを見てみましょう。[`connect`](@ref) を呼び出すと、先ほど作成したサーバーに接続します。その間に accept 関数は、新しく作成されたソケットへのサーバー側の接続を返し、接続が成功したことを示すために「Hello World」と表示します。

Julia の大きな強みの 1 つは、実際の I/O が非同期に行われていても、API が同期的に公開されていることです。そのため、コールバックを気にしたり、サーバーが実行されるように手配したりする必要はありません。[`connect`](@ref) を呼び出すと、現在のタスクは接続が確立されるまで待機し、確立後にのみ実行を再開します。この待機中に、サーバータスクは実行を再開します（接続要求が届いたためです）。そして接続を受け入れ、メッセージを表示して、次のクライアントを待ちます。読み書きも同じように動作します。次の簡単なエコーサーバーで確認してみましょう。

```julia-repl
julia> errormonitor(Threads.@spawn begin
           server = listen(2001)
           while true
               sock = accept(server)
               Threads.@spawn while isopen(sock)
                   write(sock, readline(sock, keep=true))
               end
           end
       end)
Task (runnable) @0x00007fd31dc12e60

julia> clientside = connect(2001)
TCPSocket(RawFD(28) open, 0 bytes waiting)

julia> errormonitor(Threads.@spawn while isopen(clientside)
           write(stdout, readline(clientside, keep=true))
       end)
Task (runnable) @0x00007fd31dc11870

julia> println(clientside,"Hello World from the Echo Server")
Hello World from the Echo Server
```

ほかのストリームと同様に、ソケットを切断するには [`close`](@ref) を使います。

```julia-repl
julia> close(clientside)
```

## Resolving IP Addresses

[`connect`](@ref) のメソッドのうち、[`listen`](@ref) メソッドに従わないものの 1 つが `connect(host::String,port)` です。このメソッドは、`host` パラメーターで指定されたホストの、`port` パラメーターで指定されたポートへの接続を試みます。たとえば、次のように使えます。

```julia-repl
julia> connect("google.com", 80)
TCPSocket(RawFD(30) open, 0 bytes waiting)
```

この機能の基盤となるのは [`getaddrinfo`](@ref) で、適切なアドレス解決を行います。

```julia-repl
julia> getaddrinfo("google.com")
ip"74.125.226.225"
```

## Asynchronous I/O

[`Base.read`](@ref) と [`Base.write`](@ref) が公開するすべての I/O 操作は、[coroutines](@ref man-tasks) を使って非同期に実行できます。[`Threads.@spawn`](@ref) マクロを使うと、ストリームの読み書きを行う新しいコルーチンを作成できます。

```julia-repl
julia> task = Threads.@spawn open("foo.txt", "w") do io
           write(io, "Hello, World!")
       end;

julia> wait(task)

julia> readlines("foo.txt")
1-element Vector{String}:
 "Hello, World!"
```

複数の非同期操作を並行して実行し、すべての完了を待ちたい場面はよくあります。[`@sync`](@ref) マクロを使うと、ラップしたすべてのコルーチンが終了するまでプログラムをブロックできます。

```julia-repl
julia> using Sockets

julia> @sync for hostname in ("google.com", "github.com", "julialang.org")
           Threads.@spawn begin
               conn = connect(hostname, 80)
               write(conn, "GET / HTTP/1.1\r\nHost:$(hostname)\r\n\r\n")
               readline(conn, keep=true)
               println("Finished connection to $(hostname)")
           end
       end
Finished connection to google.com
Finished connection to julialang.org
Finished connection to github.com
```

## Multicast

Julia は、User Datagram Protocol（[UDP](https://datatracker.ietf.org/doc/html/rfc768)）をトランスポートとして、IPv4 および IPv6 上の [multicast](https://datatracker.ietf.org/doc/html/rfc1112) をサポートしています。

Transmission Control Protocol（[TCP](https://datatracker.ietf.org/doc/html/rfc793)）とは異なり、UDP はアプリケーションの要件についてほとんど前提を置きません。TCP は、フロー制御（スループットを最大化するために速度を上げたり下げたりする）、信頼性（失われたパケットや破損したパケットを自動的に再送する）、順序制御（アプリケーションに渡す前に OS がパケットを並べ替える）、セグメントサイズの制御、セッションの確立と終了を提供します。UDP には、こうした機能はありません。

UDP の一般的な用途の 1 つがマルチキャストアプリケーションです。TCP は、ちょうど 2 台のデバイス間で通信するためのステートフルなプロトコルです。一方、UDP では特別なマルチキャストアドレスを使い、複数のデバイスと同時に通信できます。

### Receiving IP Multicast Packets

UDP マルチキャストでデータを送信するには、ソケットに対して `recv` を実行するだけです。最初に受信したパケットが返されます。ただし、それが送信した最初のパケットとは限らない点に注意してください。

```julia
using Sockets
group = ip"228.5.6.7"
socket = Sockets.UDPSocket()
bind(socket, ip"0.0.0.0", 6789)
join_multicast_group(socket, group)
println(String(recv(socket)))
leave_multicast_group(socket, group)
close(socket)
```

### Sending IP Multicast Packets

UDP マルチキャストでデータを送信するには、ソケットに対して `send` を実行するだけです。送信側はマルチキャストグループに参加する必要がないことに注意してください。

```julia
using Sockets
group = ip"228.5.6.7"
socket = Sockets.UDPSocket()
send(socket, group, 6789, "Hello over IPv4")
close(socket)
```

### IPv6 Example

この例は、前のプログラムと同じ機能を提供しますが、ネットワーク層プロトコルとして IPv6 を使います。

リスナー：

```julia
using Sockets
group = Sockets.IPv6("ff05::5:6:7")
socket = Sockets.UDPSocket()
bind(socket, Sockets.IPv6("::"), 6789)
join_multicast_group(socket, group)
println(String(recv(socket)))
leave_multicast_group(socket, group)
close(socket)
```

送信側：

```julia
using Sockets
group = Sockets.IPv6("ff05::5:6:7")
socket = Sockets.UDPSocket()
send(socket, group, 6789, "Hello over IPv6")
close(socket)
```
