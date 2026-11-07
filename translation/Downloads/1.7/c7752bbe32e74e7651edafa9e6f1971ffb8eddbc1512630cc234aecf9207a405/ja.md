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

指定された URL にリクエストを送信し、レスポンスのステータス、ヘッダーなどの情報を格納した `Response` オブジェクトを返します。レスポンスの本文は、指定されていれば `output` に書き込まれ、指定されていなければ破棄されます。HTTP/S リクエストでは、`input` ストリームが指定されている場合は `PUT` リクエストが送信されます。そうでなく、`output` ストリームが指定されている場合は `GET` リクエストが送信されます。どちらも指定されていない場合は `HEAD` リクエストが送信されます。その他のプロトコルでは、入力と出力の組み合わせに応じて適切なデフォルトのメソッドが使用されます。以下のオプションは、`download` 関数とは異なります。

  * `input` ではリクエスト本文を指定できます。指定した場合、デフォルトで `PUT` リクエストが送信されます。
  * `progress` は、アップロードとダウンロードの進捗を示す 4 つの整数を受け取るコールバックです。
  * `throw` は、リクエストエラー時に例外をスローするか、`RequestError` を返すかを制御します。

リクエストした URL をダウンロードできなかった場合（2xx 以外のステータスコードが返された場合）にエラーをスローする `download` とは異なり、`request` はレスポンスのステータスコードにかかわらず `Response` オブジェクトを返します。レスポンス自体を取得できなかった場合は、`RequestError` がスローされるか、返されます。

`interrupt` キーワード引数を指定する場合、その値は `Base.Event` オブジェクトでなければなりません。リクエストの実行中にイベントが発生すると、リクエストはキャンセルされ、エラーがスローされます。たとえば、ユーザーがダウンロードをキャンセルしたい場合など、時間のかかるリクエストを中断するために使用できます。
