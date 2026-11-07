```julia
channeled_tasks(n::Int, funcs...; ctypes=fill(Any,n), csizes=fill(0,n))
```

`n` チャネルを作成し、指定された関数から開始するタスクに一度の呼び出しでバインドするための便利なメソッドです。各 `func` は、作成されたチャネルを引数として受け取る `n` を受け付ける必要があります。チャネルの型とサイズは、それぞれキーワード引数 `ctypes` と `csizes` で指定できます。指定しない場合、すべてのチャネルの型は `Channel{Any}(0)` になります。

作成されたチャネルとタスクを含むタプル `(Array{Channel}, Array{Task})` を返します。
