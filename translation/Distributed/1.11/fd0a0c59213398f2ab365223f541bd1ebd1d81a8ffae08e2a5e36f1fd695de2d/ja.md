```julia
launch(manager::ClusterManager, params::Dict, launched::Array, launch_ntfy::Condition)
```

クラスターマネージャによって実装されます。この関数によって起動されたすべてのJuliaワーカーについて、`launched`に`WorkerConfig`エントリを追加し、`launch_ntfy`に通知する必要があります。この関数は、`manager`によって要求されたすべてのワーカーが起動されると終了しなければなりません。`params`は、[`addprocs`](@ref)が呼び出されたすべてのキーワード引数の辞書です。
