```julia
with_download_cancellation(f, cancellation::DownloadCancellation)
```

`f`を実行し、その中で開始されたすべてのダウンロード（`f`によって生成されたタスク上で開始されたものも含む）を`cancellation`に登録します。
