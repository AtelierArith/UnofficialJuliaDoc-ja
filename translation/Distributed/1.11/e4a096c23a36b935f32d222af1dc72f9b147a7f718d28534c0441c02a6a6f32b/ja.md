```julia
rmprocs(pids...; waitfor=typemax(Int))
```

指定されたワーカーを削除します。プロセス1のみがワーカーを追加または削除できることに注意してください。

引数 `waitfor` は、ワーカーがシャットダウンするまでの待機時間を指定します：

  * 指定しない場合、`rmprocs` は要求されたすべての `pids` が削除されるまで待機します。
  * 要求された `waitfor` 秒前にすべてのワーカーを終了できない場合、[`ErrorException`](@ref) が発生します。
  * `waitfor` の値が0の場合、呼び出しは即座に戻り、ワーカーは別のタスクで削除される予定です。スケジュールされた [`Task`](@ref) オブジェクトが返されます。ユーザーは、他の並列呼び出しを行う前にタスクに対して [`wait`](@ref) を呼び出す必要があります。

# 例

```julia-repl
$ julia -p 5

julia> t = rmprocs(2, 3, waitfor=0)
Task (runnable) @0x0000000107c718d0

julia> wait(t)

julia> workers()
3-element Array{Int64,1}:
 4
 5
 6
```
