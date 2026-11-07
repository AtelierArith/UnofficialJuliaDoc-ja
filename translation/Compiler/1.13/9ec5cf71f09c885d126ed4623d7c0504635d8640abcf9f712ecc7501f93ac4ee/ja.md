```julia
info::MethodMatchInfo <: CallInfo
```

指定された呼び出し（`info.results`）に対する`:jl_matching_methods`の検索結果と、そこで使われた主要な引数を保持します。この情報は、メソッドテーブルを再度参照することなく、オプティマイザーが利用できます。ジェネリック関数の呼び出しではない文にこの情報を指定することはできません。
