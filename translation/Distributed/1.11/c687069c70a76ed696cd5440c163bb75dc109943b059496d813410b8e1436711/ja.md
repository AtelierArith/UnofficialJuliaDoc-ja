```julia
launch(manager::ClusterManager, params::Dict, launched::Array, launch_ntfy::Condition)
```

クラスター管理ツールによって実装されます。この関数が起動する Julia ワーカーごとに、`WorkerConfig` エントリーを `launched` に追加し、`launch_ntfy` に通知する必要があります。`manager` で要求されたすべてのワーカーの起動が完了したら、この関数は必ず終了しなければなりません。`params` は、[`addprocs`](@ref) の呼び出し時に渡されたすべてのキーワード引数を格納した辞書です。
