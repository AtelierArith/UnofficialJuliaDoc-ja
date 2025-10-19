```julia
download(url, [ output = tempname() ];
    [ method = "GET", ]
    [ headers = <none>, ]
    [ timeout = <none>, ]
    [ progress = <none>, ]
    [ verbose = false, ]
    [ debug = <none>, ]
    [ downloader = <default>, ]
) -> output

    url        :: AbstractString
    output     :: Union{AbstractString, AbstractCmd, IO}
    method     :: AbstractString
    headers    :: Union{AbstractVector, AbstractDict}
    timeout    :: Real
    progress   :: (total::Integer, now::Integer) --> Any
    verbose    :: Bool
    debug      :: (type, message) --> Any
    downloader :: Downloader
```

指定されたurlからファイルをダウンロードし、`output`に保存します。指定されていない場合は、一時的なパスに保存されます。`output`は`IO`ハンドルでも可能で、その場合はレスポンスの本文がそのハンドルにストリーミングされ、ハンドルが返されます。`output`がコマンドの場合、そのコマンドが実行され、出力がstdinに送信されます。

`downloader`キーワード引数が提供される場合、それは`Downloader`オブジェクトでなければなりません。同じ`Downloader`によって行われるダウンロード間でリソースと接続が共有され、オブジェクトがガーベジコレクションされるか、一定の猶予期間内にダウンロードが行われなかった場合に自動的にクリーンアップされます。設定と使用法についての詳細は`Downloader`を参照してください。

`headers`キーワード引数が提供される場合、それはすべての要素が文字列のペアであるベクターまたは辞書でなければなりません。これらのペアは、HTTP/SなどのプロトコルでサポートされているURLをダウンロードする際にヘッダーとして渡されます。

`timeout`キーワード引数は、ダウンロードが完了するまでのタイムアウトを秒単位で指定し、ミリ秒単位の解像度を持ちます。デフォルトではタイムアウトは設定されていませんが、`Inf`のタイムアウト値を渡すことで明示的に要求することもできます。別に、20秒間データを受信しない場合、ダウンロードはタイムアウトします。このタイムアウトを無効にする方法については、extended helpを参照してください。

`progress`キーワード引数が提供される場合、それは進行中のダウンロードのサイズとステータスに関する更新があるたびに呼び出されるコールバック関数でなければなりません。コールバックは、ダウンロードの合計サイズ（バイト単位）と、これまでにダウンロードされたバイト数を表す2つの整数引数`total`と`now`を取る必要があります。`total`は最初はゼロで、サーバーがダウンロードの合計サイズを示す（例：`Content-Length`ヘッダーで）までゼロのままです。したがって、適切に動作するプログレスコールバックは、合計サイズがゼロであることを適切に処理する必要があります。

`verbose`オプションがtrueに設定されている場合、ダウンロード機能を実装するために使用される`libcurl`は、デバッグ情報を`stderr`に出力します。`debug`オプションが2つの`String`引数を受け取る関数に設定されている場合、verboseオプションは無視され、代わりに`stderr`に出力されるはずのデータが`type`と`message`引数を持つ`debug`コールバックに渡されます。`type`引数は、どのようなイベントが発生したかを示し、`TEXT`、`HEADER IN`、`HEADER OUT`、`DATA IN`、`DATA OUT`、`SSL DATA IN`または`SSL DATA OUT`のいずれかです。`message`引数はデバッグイベントの説明です。

## Extended Help

さらなるカスタマイズには、[`Downloader`](@ref)と[`easy_hook`s](https://github.com/JuliaLang/Downloads.jl#mutual-tls-using-downloads)を使用してください。たとえば、データが受信されない場合の20秒のタイムアウトを無効にするには、次のようにします。

```jl
downloader = Downloads.Downloader()
downloader.easy_hook = (easy, info) -> Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_LOW_SPEED_TIME, 0)

Downloads.download("https://httpbingo.julialang.org/delay/30"; downloader)
```
