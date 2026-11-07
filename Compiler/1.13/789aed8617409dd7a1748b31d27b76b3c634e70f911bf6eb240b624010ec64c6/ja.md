```julia
info::UnionSplitInfo <: CallInfo
```

推論がユニオンを分割してメソッド検索空間を分割すると判断した場合、各分割についてメソッド検索クエリを発行します。この情報は、そのような分割が行われたことを示し、各分割に対応する `MethodMatchInfo`（`info.matches::Vector{MethodMatchInfo}`）を囲みます。ジェネリック関数の呼び出しではない文にこの情報を付けることはできません。
