```julia
pipeline(command, redir::Pair{<:Integer, <:Redirectable})
```

`command` のファイルディスクリプター番号 `redir.first` を、指定された `redir.second` との間でリダイレクトします。指定できるのは、I/O ストリーム、ファイル名、またはファイルディスクリプターです。このメソッドは主に、キーワード引数インターフェースではサポートされていない、標準の I/O 以外の追加ファイルディスクリプターを渡すために使用します。

!!! compat "Julia 1.13"
    このメソッドを使用するには、Julia 1.13 以降が必要です。

