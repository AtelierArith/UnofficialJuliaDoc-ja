```julia
info::UnionSplitInfo <: CallInfo
```

推論によって union を分割し、メソッド検索空間を区分することになった場合、各区分についてメソッド検索クエリが発行されます。この情報は、そのような区分が行われたことを示し、各区分に対応する `MethodMatchInfo`（`info.matches::Vector{MethodMatchInfo}`）を囲みます。ジェネリック関数の呼び出しではない文にこの情報を付けることはできません。
