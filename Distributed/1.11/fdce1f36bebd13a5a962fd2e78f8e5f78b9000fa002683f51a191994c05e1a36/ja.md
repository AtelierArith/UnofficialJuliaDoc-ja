```julia
addprocs(manager::ClusterManager; kwargs...) -> List of process identifiers
```

指定したクラスターマネージャーを介してワーカープロセスを起動します。

たとえば、パッケージ `ClusterManagers.jl` で実装されたカスタムクラスターマネージャーを使って、Beowulf クラスターを利用できます。

新たに起動したワーカーがマスターとの接続確立を待つ秒数は、ワーカープロセスの環境変数 `JULIA_WORKER_TIMEOUT` で指定できます。この設定が適用されるのは、トランスポートに TCP/IP を使用する場合のみです。

ワーカーの起動中に REPL（プログラムから起動する場合は、呼び出し元の関数）をブロックしないようにするには、`addprocs` を独立したタスク内で実行します。

# Examples

```julia
# On busy clusters, call `addprocs` asynchronously
t = @async addprocs(...)
```

```julia
# Utilize workers as and when they come online
if nprocs() > 1   # Ensure at least one new worker is available
   ....   # perform distributed execution
end
```

```julia
# Retrieve newly launched worker IDs, or any error messages
if istaskdone(t)   # Check if `addprocs` has completed to ensure `fetch` doesn't block
    if nworkers() == N
        new_pids = fetch(t)
    else
        fetch(t)
    end
end
```
