```julia
rmprocs(pids...; waitfor=typemax(Int))
```

指定したワーカーを削除します。ワーカーを追加または削除できるのはプロセス 1 だけです。

引数 `waitfor` は、ワーカーのシャットダウンを待つ時間を指定します。

  * 指定しない場合、`rmprocs` は、要求されたすべての `pids` が削除されるまで待機します。
  * 要求された `waitfor` 秒以内にすべてのワーカーを終了できない場合、[`ErrorException`](@ref) が発生します。
  * `waitfor` の値が 0 の場合、呼び出しは直ちに戻り、別のタスクでワーカーの削除がスケジュールされます。スケジュールされた [`Task`](@ref) オブジェクトが返されます。他の並列呼び出しを行う前に、そのタスクに対して [`wait`](@ref) を呼び出してください。

# Examples

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
