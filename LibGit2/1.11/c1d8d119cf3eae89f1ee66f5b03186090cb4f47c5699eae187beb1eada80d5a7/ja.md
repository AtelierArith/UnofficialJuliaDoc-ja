```julia
ls(rmt::GitRemote)::Vector{GitRemoteHead}
```

リモートリポジトリの参照広告リストを取得します。

この関数は、接続後にのみ呼び出してください（[`connect`](@ref) を参照）。
