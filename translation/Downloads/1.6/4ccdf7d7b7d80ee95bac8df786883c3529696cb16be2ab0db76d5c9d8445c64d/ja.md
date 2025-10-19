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

指定されたURLにリクエストを行い、ステータス、ヘッダー、およびレスポンスに関するその他の情報をキャプチャする`Response`オブジェクトを返します。レスポンスのボディは、指定されている場合は`output`に書き込まれ、そうでない場合は破棄されます。HTTP/Sリクエストの場合、`input`ストリームが指定されている場合は`PUT`リクエストが行われます。そうでない場合、`output`ストリームが指定されている場合は`GET`リクエストが行われます。どちらも指定されていない場合は`HEAD`リクエストが行われます。他のプロトコルの場合、要求された入力と出力の組み合わせに基づいて適切なデフォルトメソッドが使用されます。以下のオプションは`download`関数とは異なります：

  * `input`はリクエストボディを提供することを可能にします。提供された場合はデフォルトで`PUT`リクエストになります。
  * `progress`はアップロードとダウンロードの進行状況のための4つの整数を受け取るコールバックです。
  * `throw`はリクエストエラーが発生した場合に`RequestError`をスローするかどうかを制御します。

要求されたURLがダウンロードできなかった場合（非2xxステータスコードで示される）にエラーをスローする`download`とは異なり、`request`はレスポンスのステータスコードに関係なく`Response`オブジェクトを返します。レスポンスを取得する際にエラーが発生した場合は、`RequestError`がスローまたは返されます。

`interrupt`キーワード引数が提供されている場合、それは`Base.Event`オブジェクトでなければなりません。リクエストが進行中にイベントがトリガーされると、リクエストはキャンセルされ、エラーがスローされます。これは、ユーザーがダウンロードをキャンセルしたい場合など、長時間実行されるリクエストを中断するために使用できます。
