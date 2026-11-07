```julia
Event([autoreset=false])
```

レベルトリガー型のイベントソースを作成します。`Event`に対して[`wait`](@ref)を呼び出したタスクは、`Event`に対して[`notify`](@ref)が呼び出されるまで、一時停止してキューに入れられます。`notify`が呼び出されると、`Event`はシグナル状態を維持し、`reset`が呼び出されるまで、待機中のタスクがブロックされなくなります。

`autoreset`がtrueの場合、`notify`を呼び出すたびに、`wait`から解放されるタスクは最大1つです。

これにより、notify/waitに対してacquire/releaseメモリ順序が保証されます。

!!! compat "Julia 1.1"
    この機能を使用するには、Julia 1.1以降が必要です。


!!! compat "Julia 1.8"
    `autoreset`の機能とメモリ順序の保証を利用するには、Julia 1.8以降が必要です。

