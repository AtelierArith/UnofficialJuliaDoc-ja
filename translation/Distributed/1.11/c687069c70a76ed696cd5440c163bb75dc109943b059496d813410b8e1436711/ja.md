```julia
launch(manager::ClusterManager, params::Dict, launched::Array, launch_ntfy::Condition)
```

クラスター管理者によって実装されます。この関数が起動する Julia ワーカーごとに、`launched` に `WorkerConfig` エントリーを追加し、`launch_ntfy` に通知する必要があります。`manager` で要求されたすべてのワーカーを起動したら、この関数は必ず終了しなければなりません。`params` は、[`addprocs`](@ref) の呼び出し時に指定されたすべてのキーワード引数を格納する辞書です。
