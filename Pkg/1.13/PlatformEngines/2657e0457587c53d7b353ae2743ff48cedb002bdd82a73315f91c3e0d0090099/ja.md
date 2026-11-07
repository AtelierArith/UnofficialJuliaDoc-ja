```julia
cancel_downloads(cancellation::DownloadCancellation)
```

`cancellation`のスコープ内で進行中のダウンロードを中止し、今後そのスコープ内で開始されるダウンロードは、転送を開始せずに直ちに失敗させます。
