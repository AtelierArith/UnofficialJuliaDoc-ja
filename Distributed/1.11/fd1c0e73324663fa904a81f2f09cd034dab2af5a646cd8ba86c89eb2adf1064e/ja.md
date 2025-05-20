```
addprocs(manager::ClusterManager; kwargs...) -> プロセス識別子のリスト
```

指定されたクラスターマネージャーを介してワーカープロセスを起動します。

例えば、Beowulfクラスタは、パッケージ`ClusterManagers.jl`に実装されたカスタムクラスターマネージャーを介してサポートされています。

新しく起動されたワーカーがマスターからの接続確立を待つ秒数は、ワーカープロセスの環境内の変数`JULIA_WORKER_TIMEOUT`を介して指定できます。TCP/IPをトランスポートとして使用する場合にのみ関連します。

REPLをブロックせずにワーカーを起動するには、またはプログラム的にワーカーを起動する場合は、`addprocs`を独自のタスクで実行します。

# 例

```julia
# 忙しいクラスタでは、非同期に`addprocs`を呼び出す
t = @async addprocs(...)
```

```julia
# ワーカーがオンラインになるときに利用する
if nprocs() > 1   # 少なくとも1つの新しいワーカーが利用可能であることを確認
   ....   # 分散実行を行う
end
```

```julia
# 新しく起動されたワーカーIDまたはエラーメッセージを取得する
if istaskdone(t)   # `addprocs`が完了したか確認し、`fetch`がブロックしないようにする
    if nworkers() == N
        new_pids = fetch(t)
    else
        fetch(t)
    end
end
```
