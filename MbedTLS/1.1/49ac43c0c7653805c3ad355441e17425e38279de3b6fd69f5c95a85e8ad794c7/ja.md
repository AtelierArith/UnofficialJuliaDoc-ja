```
iswritable(ctx::SSLContext)
```

真である、ただし：

  * `close(::SSLContext)` が呼び出された場合、または
  * `closewrite(::SSLContext)` が呼び出された場合、または
  * ピアが接続を閉じた場合。
