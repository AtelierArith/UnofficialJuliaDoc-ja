```julia
info::MethodMatchInfo <: CallInfo
```

指定された呼び出し（`info.results`）に対する`:jl_matching_methods`の検索結果から、重要な引数と結果を取得します。この情報は、メソッドテーブルを再度参照することなく、オプティマイザーが利用できます。ジェネリック関数の呼び出しではない文にこの情報を指定することはできません。
