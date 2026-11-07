```julia
struct RequestError <: ErrorException
    url      :: String
    code     :: Int
    message  :: String
    response :: Response
end
```

`RequestError`は、リクエストへの応答が失敗した際の情報を例外オブジェクトとして保持する型です。

  * `url`: リダイレクトを経由する前の、リクエスト対象の元のURL
  * `code`: libcurlのエラーコード。プロトコルのみのエラーが発生した場合は`0`
  * `message`: エラーの内容を示すlibcurlのエラーメッセージ
  * `response`: 取得可能な応答情報を保持する応答オブジェクト

リクエスト自体は成功したものの、2xxの範囲外のステータスコードで示されるプロトコルレベルのエラーが発生した場合も、`download`は同じ`RequestError`型をスローします。この場合、`code`はゼロ、`message`フィールドは空文字列になります。`request` APIが`RequestError`をスローするのは、libcurlのエラー`code`がゼロ以外の場合に限られます。この場合、含まれる`response`オブジェクトの`status`はゼロで、メッセージも空である可能性が高いです。ただし、プロトコルエラーが原因でcurlレベルのエラーがスローされる場合もあり、その場合は内側と外側の両方のコードとメッセージが重要になることがあります。
