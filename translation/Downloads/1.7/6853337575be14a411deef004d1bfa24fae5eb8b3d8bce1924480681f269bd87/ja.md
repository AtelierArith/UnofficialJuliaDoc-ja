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

指定した URL からファイルをダウンロードし、`output` に保存します。指定がない場合は、一時パスに保存します。`output` には `IO` ハンドルを指定することもできます。その場合、レスポンスの本文がそのハンドルにストリーミングされ、ハンドルが返されます。`output` がコマンドの場合は、そのコマンドを実行し、標準入力に出力を送ります。

`downloader` キーワード引数を指定する場合、その値は `Downloader` オブジェクトでなければなりません。同じ `Downloader` を使って実行するダウンロード間では、リソースと接続が共有されます。オブジェクトがガベージコレクションされるか、一定の猶予期間にわたってダウンロードに使用されなかった場合、これらは自動的に解放されます。設定と使用方法については、`Downloader` を参照してください。

`headers` キーワード引数を指定する場合、その値は、要素がすべて文字列のペアであるベクターまたは辞書でなければなりません。これらのペアは、HTTP/S など、ヘッダーに対応するプロトコルで URL をダウンロードする際にヘッダーとして渡されます。

`timeout` キーワード引数は、ダウンロード完了までのタイムアウトを秒単位（ミリ秒精度）で指定します。デフォルトではタイムアウトは設定されませんが、`Inf` をタイムアウト値として渡すことで、明示的にタイムアウトなしを指定することもできます。これとは別に、データを受信しない状態が20秒続くと、ダウンロードはタイムアウトします。このタイムアウトを無効にする方法については、拡張ヘルプを参照してください。

`progress` キーワード引数を指定する場合、その値は、ダウンロードのサイズや進行状況に関する更新があるたびに呼び出されるコールバック関数でなければなりません。コールバックは、ダウンロードの合計サイズ（バイト単位）を表す `total` と、これまでにダウンロードされたバイト数を表す `now` の2つの整数引数を受け取ります。`total` は最初は0で、サーバーからダウンロードの合計サイズ（たとえば `Content-Length` ヘッダーによる通知）が示されるまで0のままです。合計サイズが通知されない場合もあります。そのため、適切な進捗コールバックは、合計サイズが0の場合も問題なく処理できる必要があります。

`verbose` オプションを true に設定すると、ダウンロード機能の実装に使われる `libcurl` が、デバッグ情報を `stderr` に出力します。`debug` オプションに、2つの `String` 引数を受け取る関数を設定した場合、verbose オプションは無視されます。その代わり、`stderr` に出力されるはずのデータが、`type` と `message` を引数として `debug` コールバックに渡されます。`type` 引数は発生したイベントの種類を示し、値は `TEXT`、`HEADER IN`、`HEADER OUT`、`DATA IN`、`DATA OUT`、`SSL DATA IN`、`SSL DATA OUT` のいずれかです。`message` 引数は、デバッグイベントの説明です。

## Extended Help

さらに細かく設定するには、[`Downloader`](@ref) と [`easy_hook`s](https://github.com/JuliaLang/Downloads.jl#mutual-tls-using-downloads) を使用してください。たとえば、データを受信しない状態が20秒続いた場合のタイムアウトを無効にするには、次のようにします。

```jl
downloader = Downloads.Downloader()
downloader.easy_hook = (easy, info) -> Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_LOW_SPEED_TIME, 0)

Downloads.download("https://httpbingo.julialang.org/delay/30"; downloader)
```
