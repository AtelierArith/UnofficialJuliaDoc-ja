```
readavailable(ctx::SSLContext)
```

`ctx`から利用可能な復号化データを読み取りますが、追加のデータが到着するのを待ちません。

一度に読み取れる復号化データの量は`MBEDTLS_SSL_MAX_CONTENT_LEN`によって制限されています。
