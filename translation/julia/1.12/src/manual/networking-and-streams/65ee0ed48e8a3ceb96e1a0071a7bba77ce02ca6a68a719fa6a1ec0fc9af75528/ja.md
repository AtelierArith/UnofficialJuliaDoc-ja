# Networking and Streams

Juliaは、端末、パイプ、TCPソケットなどのストリーミングI/Oオブジェクトを扱うための豊富なインターフェースを提供します。これらのオブジェクトは、データをストリームのような方法で送受信できるようにし、データが利用可能になると順次処理されることを意味します。このインターフェースは、システムレベルでは非同期ですが、プログラマーには同期的な方法で提示されます。これは、Juliaの協調スレッド機能（[coroutine](@ref man-tasks)）を多用することで実現されています。

## Basic Stream I/O

すべてのJuliaストリームは、少なくとも [`read`](@ref) と [`write`](@ref) メソッドを公開しており、ストリームを最初の引数として取ります。例えば：

```julia-repl
julia> write(stdout, "Hello World");  # suppress return value 11 with ;
Hello World
julia> read(stdin, Char)

'\n': ASCII/Unicode U+000a (category Cc: Other, control)
```

[`write`](@ref)は、[`stdout`](@ref)に書き込まれたバイト数（`"Hello World"`のバイト数）である11を返しますが、この戻り値は`;`で抑制されています。

ここでEnterが再度押されたため、Juliaは改行を読み取ります。さて、この例からわかるように、[`write`](@ref)は、書き込むデータをその第二引数として受け取ります。一方、[`read`](@ref)は、読み取るデータの型を第二引数として受け取ります。

例えば、シンプルなバイト配列を読み取るには、次のようにします:

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

しかし、これは少し面倒なので、いくつかの便利なメソッドが提供されています。たとえば、上記を次のように書くことができます：

```julia-repl
julia> read(stdin, 4)
abcd
4-element Vector{UInt8}:
 0x61
 0x62
 0x63
 0x64
```

または、行全体を読みたかった場合は：

```julia-repl
julia> readline(stdin)
abcd
"abcd"
```

注意してください。ターミナルの設定によっては、TTY（"テレタイプ端末"）が行バッファリングされている場合があり、そのため`stdin`データがJuliaに送信される前に追加のエンターが必要になることがあります。TTYでコマンドラインからJuliaを実行すると、出力はデフォルトでコンソールに送信され、標準入力はキーボードから読み取られます。

[`stdin`](@ref)のすべての行を読むには、[`eachline`](@ref)を使用できます：

```julia
for line in eachline(stdin)
    print("Found $line")
end
```

または [`read`](@ref) 文字単位で読みたい場合:

```julia
while !eof(stdin)
    x = read(stdin, Char)
    println("Found: $x")
end
```

## Text I/O

[`write`](@ref) メソッドは、バイナリストリームで動作することに注意してください。特に、値は任意の標準的なテキスト表現に変換されることはなく、そのまま書き出されます：

```jldoctest
julia> write(stdout, 0x61);  # suppress return value 1 with ;
a
```

`a`は[`stdout`](@ref)によって[`write`](@ref)関数によって書き込まれ、返される値は`1`です（`0x61`は1バイトです）。

テキストI/Oには、ニーズに応じて[`print`](@ref)または[`show`](@ref)メソッドを使用してください（これら2つのメソッドの違いについての詳細な議論は、ドキュメントを参照してください）：

```jldoctest
julia> print(stdout, 0x61)
97
```

[Custom pretty-printing](@ref man-custom-pretty-printing) の詳細については、カスタムタイプの表示メソッドを実装する方法を参照してください。

## IO Output Contextual Properties

時には、IO出力は、表示メソッドにコンテキスト情報を渡す能力から恩恵を受けることがあります。[`IOContext`](@ref)オブジェクトは、IOオブジェクトに任意のメタデータを関連付けるためのフレームワークを提供します。例えば、`:compact => true`は、呼び出された表示メソッドが短い出力を印刷すべきであるというヒントパラメータをIOオブジェクトに追加します（該当する場合）。一般的なプロパティのリストについては、`4d61726b646f776e2e436f64652822222c2022494f436f6e746578742229_40726566`のドキュメントを参照してください。

## Working with Files

ファイルにコンテンツを書き込むには、`write(filename::String, content)` メソッドを使用します:

```julia-repl
julia> write("hello.txt", "Hello, World!")
13
```

*(`13`は書き込まれたバイト数です。)*

ファイルの内容は、`read(filename::String)` メソッドを使用して読み取ることができます。また、`read(filename::String, String)` を使用すると、内容を文字列として取得できます。

```julia-repl
julia> read("hello.txt", String)
"Hello, World!"
```

### Advanced: streaming files

`read` および `write` メソッドは、ファイルの内容を読み書きすることを可能にします。他の多くの環境と同様に、Julia には [`open`](@ref) 関数があり、これはファイル名を受け取り、ファイルから読み書きするために使用できる [`IOStream`](@ref) オブジェクトを返します。例えば、`hello.txt` というファイルがあり、その内容が `Hello, World!` の場合：

```julia-repl
julia> f = open("hello.txt")
IOStream(<file hello.txt>)

julia> readlines(f)
1-element Vector{String}:
 "Hello, World!"
```

ファイルに書き込みたい場合は、書き込み（`"w"`）フラグで開くことができます：

```julia-repl
julia> f = open("hello.txt","w")
IOStream(<file hello.txt>)

julia> write(f,"Hello again.")
12
```

`hello.txt`の内容をこの時点で確認すると、空であることに気付くでしょう。実際には何もディスクに書き込まれていません。これは、`IOStream`が閉じられる前に書き込みが実際にディスクにフラッシュされないためです。

```julia-repl
julia> close(f)
```

`hello.txt`を再度調べると、その内容が変更されていることがわかります。

ファイルを開き、その内容に対して何かを行い、再び閉じるというのは非常に一般的なパターンです。これを簡単にするために、[`open`](@ref) の別の呼び出しが存在し、最初の引数として関数を、2番目の引数としてファイル名を取ります。ファイルを開き、ファイルを引数として関数を呼び出し、その後再び閉じます。例えば、次のような関数があるとします：

```julia
function read_and_capitalize(f::IOStream)
    return uppercase(read(f, String))
end
```

あなたは呼び出すことができます:

```julia-repl
julia> open(read_and_capitalize, "hello.txt")
"HELLO AGAIN."
```

`hello.txt`を開き、`read_and_capitalize`を呼び出し、`hello.txt`を閉じて、大文字に変換された内容を返します。

名前付き関数を定義する必要すら避けるために、`do`構文を使用して、即座に無名関数を作成することができます：

```julia-repl
julia> open("hello.txt") do f
           uppercase(read(f, String))
       end
"HELLO AGAIN."
```

標準出力をファイルにリダイレクトしたい場合

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

標準出力をファイルにリダイレクトすることで、プログラムの出力を保存して分析したり、プロセスを自動化したり、コンプライアンス要件を満たしたりするのに役立ちます。

## A simple TCP example

TCPソケットに関する簡単な例から始めましょう。この機能は、`Sockets`という標準ライブラリパッケージに含まれています。まずはシンプルなサーバーを作成しましょう：

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

UnixソケットAPIに慣れている人には、メソッド名が馴染み深く感じられるでしょうが、その使用法は生のUnixソケットAPIよりも若干簡単です。最初の呼び出し [`listen`](@ref) は、この場合指定されたポート（2000）で接続を待機するサーバーを作成します。同じ関数は、さまざまな他の種類のサーバーを作成するためにも使用できます：

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

最後の呼び出しの戻り値の型が異なることに注意してください。これは、このサーバーがTCPではなく、名前付きパイプ（Windows）またはUNIXドメインソケットでリッスンしているためです。また、Windowsの名前付きパイプ形式は特定のパターンである必要があり、名前のプレフィックス（`\\.\pipe\`）が[file type](https://docs.microsoft.com/windows/desktop/ipc/pipe-names)を一意に識別します。TCPと名前付きパイプまたはUNIXドメインソケットの違いは微妙で、[`accept`](@ref)と[`connect`](@ref)メソッドに関係しています。`4d61726b646f776e2e436f64652822222c20226163636570742229_40726566`メソッドは、私たちが作成したサーバーに接続しているクライアントへの接続を取得しますが、`4d61726b646f776e2e436f64652822222c2022636f6e6e6563742229_40726566`関数は、指定されたメソッドを使用してサーバーに接続します。`4d61726b646f776e2e436f64652822222c2022636f6e6e6563742229_40726566`関数は、[`listen`](@ref)と同じ引数を取るため、環境（ホスト、カレントワーキングディレクトリなど）が同じであれば、接続を確立するためにリッスンしたときと同じ引数を`4d61726b646f776e2e436f64652822222c2022636f6e6e6563742229_40726566`に渡すことができるはずです。それでは、上記のサーバーを作成した後にそれを試してみましょう。

```julia-repl
julia> connect(2000)
TCPSocket(open, 0 bytes waiting)

julia> Hello World
```

予想通り、「Hello World」が表示されました。では、実際に裏で何が起こったのかを分析してみましょう。[`connect`](@ref)を呼び出したとき、私たちはちょうど作成したサーバーに接続します。一方、accept関数は新しく作成されたソケットへのサーバー側の接続を返し、接続が成功したことを示すために「Hello World」を表示します。

Juliaの大きな強みは、I/Oが実際には非同期で行われているにもかかわらず、APIが同期的に公開されているため、コールバックやサーバーが実行されることを確認することを心配する必要がなかったことです。[`connect`](@ref)を呼び出すと、現在のタスクは接続が確立されるのを待ち、その後に実行を続けました。この一時停止の間に、サーバータスクは実行を再開しました（接続要求が利用可能になったため）、接続を受け入れ、メッセージを印刷し、次のクライアントを待ちました。読み書きは同じ方法で機能します。これを確認するために、次のシンプルなエコーサーバーを考えてみましょう：

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

他のストリームと同様に、ソケットを切断するには [`close`](@ref) を使用してください：

```julia-repl
julia> close(clientside)
```

## Resolving IP Addresses

[`connect`](@ref) メソッドの1つで、[`listen`](@ref) メソッドに従わないのは `connect(host::String,port)` です。このメソッドは、`host` パラメータで指定されたホストに、`port` パラメータで指定されたポートで接続を試みます。これにより、次のようなことが可能になります：

```julia-repl
julia> connect("google.com", 80)
TCPSocket(RawFD(30) open, 0 bytes waiting)
```

この機能の基盤は [`getaddrinfo`](@ref) であり、適切なアドレス解決を行います：

```julia-repl
julia> getaddrinfo("google.com")
ip"74.125.226.225"
```

## Asynchronous I/O

All I/O operations exposed by [`Base.read`](@ref) and [`Base.write`](@ref) can be performed asynchronously through the use of [coroutines](@ref man-tasks). You can create a new coroutine to read from or write to a stream using the [`Threads.@spawn`](@ref) macro:

```julia-repl
julia> task = Threads.@spawn open("foo.txt", "w") do io
           write(io, "Hello, World!")
       end;

julia> wait(task)

julia> readlines("foo.txt")
1-element Vector{String}:
 "Hello, World!"
```

複数の非同期操作を同時に実行し、それらがすべて完了するのを待ちたい状況に遭遇することはよくあります。[`@sync`](@ref) マクロを使用すると、ラップされたすべてのコルーチンが終了するまでプログラムをブロックすることができます。

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

Juliaは、ユーザーデータグラムプロトコル（[UDP](https://datatracker.ietf.org/doc/html/rfc768)）を使用して、IPv4およびIPv6で[multicast](https://datatracker.ietf.org/doc/html/rfc1112)をサポートしています。

Transmission Control Protocol（[TCP](https://datatracker.ietf.org/doc/html/rfc793)）とは異なり、UDPはアプリケーションのニーズについてほとんど仮定をしません。TCPはフロー制御（スループットを最大化するために加速および減速します）、信頼性（失われたまたは破損したパケットは自動的に再送信されます）、シーケンシング（パケットはアプリケーションに渡される前にオペレーティングシステムによって順序付けられます）、セグメントサイズ、およびセッションのセットアップとテardownを提供します。UDPはそのような機能を提供しません。

UDPの一般的な用途はマルチキャストアプリケーションです。TCPは正確に2つのデバイス間の通信のためのステートフルプロトコルです。UDPは特別なマルチキャストアドレスを使用して、多くのデバイス間で同時に通信を可能にします。

### Receiving IP Multicast Packets

UDPマルチキャストでデータを送信するには、ソケットで単に`recv`を実行すると、受信した最初のパケットが返されます。ただし、送信した最初のパケットであるとは限らないことに注意してください！

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

UDPマルチキャストでデータを送信するには、単にソケットに`send`します。送信者がマルチキャストグループに参加する必要はないことに注意してください。

```julia
using Sockets
group = ip"228.5.6.7"
socket = Sockets.UDPSocket()
send(socket, group, 6789, "Hello over IPv4")
close(socket)
```

### IPv6 Example

この例は、前のプログラムと同じ機能を提供しますが、ネットワーク層プロトコルとしてIPv6を使用しています。

リスナー:

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

送信者:

```julia
using Sockets
group = Sockets.IPv6("ff05::5:6:7")
socket = Sockets.UDPSocket()
send(socket, group, 6789, "Hello over IPv6")
close(socket)
```
