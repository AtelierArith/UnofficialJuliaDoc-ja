```julia
request(url;
    [ input = <none>, ]
    [ output = <none>, ]
    [ method = input ? "PUT" : output ? "GET" : "HEAD", ]
    [ headers = <none>, ]
    [ timeout = <none>, ]
    [ progress = <none>, ]
    [ verbose = false, ]
    [ debug = <none>, ]
    [ throw = true, ]
    [ downloader = <default>, ]
    [ interrupt = <none>, ]
) -> Union{Response, RequestError}

    url        :: AbstractString
    input      :: Union{AbstractString, AbstractCmd, IO}
    output     :: Union{AbstractString, AbstractCmd, IO}
    method     :: AbstractString
    headers    :: Union{AbstractVector, AbstractDict}
    timeout    :: Real
    progress   :: (dl_total, dl_now, ul_total, ul_now) --> Any
    verbose    :: Bool
    debug      :: (type, message) --> Any
    throw      :: Bool
    downloader :: Downloader
    interrupt  :: Base.Event
```

指定された URL にリクエストを送信し、ステータス、ヘッダー、その他のレスポンス情報を格納した `Response` オブジェクトを返します。レスポンスボディは、指定されている場合は `output` に書き込まれ、指定されていない場合は破棄されます。HTTP/S リクエストでは、`input` ストリームが指定されていれば `PUT` リクエストを送信します。そうでなく、`output` ストリームが指定されていれば `GET` リクエストを送信します。どちらも指定されていない場合は、`HEAD` リクエストを送信します。その他のプロトコルでは、入力と出力の組み合わせに応じて適切なデフォルトのメソッドが使用されます。以下のオプションは、`download` 関数とは異なります。

  * `input` を使うとリクエストボディを指定できます。指定した場合、デフォルトでは `PUT` リクエストが送信されます。
  * `progress` は、アップロードとダウンロードの進捗を表す4つの整数を受け取るコールバックです。
  * `throw` は、リクエストエラー時に例外をスローするか、`RequestError` を返すかを制御します。

リクエストした URL をダウンロードできなかった場合（2xx 以外のステータスコードで示されます）にエラーをスローする `download` とは異なり、`request` はレスポンスのステータスコードにかかわらず `Response` オブジェクトを返します。レスポンス自体を取得できなかった場合は、`RequestError` がスローされるか、返されます。

`interrupt` キーワード引数を指定する場合は、`Base.Event` オブジェクトでなければなりません。リクエストの実行中にイベントが発生すると、リクエストはキャンセルされ、エラーがスローされます。たとえば、ユーザーがダウンロードをキャンセルしたい場合など、時間のかかるリクエストを中断するために使用できます。
