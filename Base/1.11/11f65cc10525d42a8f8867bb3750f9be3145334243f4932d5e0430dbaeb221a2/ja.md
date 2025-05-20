```
Event([autoreset=false])
```

レベルトリガーイベントソースを作成します。`Event`上で[`wait`](@ref)を呼び出すタスクは、`notify`が`Event`上で呼び出されるまで、一時停止してキューに入れられます。`notify`が呼び出されると、`Event`はシグナル状態のままとなり、`reset`が呼び出されるまで、タスクはそれを待っている間にブロックされなくなります。

`autoreset`がtrueの場合、`notify`の呼び出しごとに、`wait`から解放されるタスクは最大で1つになります。

これは、notify/waitに対して取得と解放のメモリ順序を提供します。

!!! compat "Julia 1.1"
    この機能は少なくともJulia 1.1が必要です。


!!! compat "Julia 1.8"
    `autoreset`機能とメモリ順序の保証には、少なくともJulia 1.8が必要です。

