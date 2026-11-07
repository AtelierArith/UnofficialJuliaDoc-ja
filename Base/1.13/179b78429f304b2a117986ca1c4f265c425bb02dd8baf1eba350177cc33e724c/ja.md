```julia
pipeline(command, redir::Pair{<:Integer, <:Redirectable})
```

`command` のファイル記述子番号 `redir.first` を、指定された `redir.second` との間でリダイレクトします。指定先には、I/O ストリーム、ファイル名、またはファイル記述子を指定できます。このメソッドは主に、キーワード引数インターフェースではサポートされていない、標準 I/O 以外の追加ファイル記述子を渡すために使用します。

!!! compat "Julia 1.13"
    このメソッドを使用するには、Julia 1.13 以降が必要です。

