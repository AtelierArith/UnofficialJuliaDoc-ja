```
open(fd::OS_HANDLE) -> IO
```

生のファイルディスクリプタを取得し、Julia対応のIOタイプでラップし、fdハンドルの所有権を取得します。元のハンドルの所有権のキャプチャを避けるために、`open(Libc.dup(fd))`を呼び出します。

!!! warning
    システムの他の部分によってすでに所有されているハンドルに対してこれを呼び出さないでください。

