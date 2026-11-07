```julia
ReentrantLock()
```

[`Task`](@ref)を同期するための再入可能ロックを作成します。同じタスクは、必要な回数だけロックを取得できます（名前に「再入可能」とあるのはこのためです）。各[`lock`](@ref)には、対応する[`unlock`](@ref)が必要です。

`lock`を呼び出すと、対応する`unlock`が呼び出されるまで、そのスレッドでファイナライザーが実行されなくなります。以下に示す標準的なロックパターンは通常どおり使用できますが、tryとlockの順序を逆にしたり、tryブロック自体を省略したりしないよう注意してください（たとえば、ロックを保持したままreturnしようとする場合など）。

ロックおよびロック解除の呼び出しでは、acquire/releaseメモリ順序が保証されます。

```julia
lock(l)
try
    <atomic work>
finally
    unlock(l)
end
```

[`!islocked(lck::ReentrantLock)`](@ref islocked)が成立する場合、ほかのタスクが「同時に」ロックを取得しようとしていなければ、[`trylock(lck)`](@ref trylock)は成功します。
