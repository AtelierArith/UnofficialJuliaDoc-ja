```julia
OncePerThread{T}(init::Function)() -> T
```

`OncePerThread` オブジェクトを呼び出すと、スレッドごとに関数 `initializer` がちょうど1回実行され、`T` 型の値が返されます。同じスレッドでの以降の呼び出しや、同じスレッド ID を指定した並行または将来の呼び出しでは、常にまったく同じ値が返されます。また、既存の任意のスレッドの threadid でこのオブジェクトをインデックスすると、そのスレッドに保存された値を取得できます（または、このスレッド上で初期化できます）。誤った使い方はデータ競合やメモリ破損につながる可能性があるため、ライブラリのスレッド安全性の設計上、その動作が適切な場合にのみ使用してください。

!!! warning
    Task が必ず1つのスレッドだけで実行されるとは限りません。そのため、ここで返される値は他の値とエイリアスする場合や、プログラムの実行中に変化する場合があります。この関数は将来非推奨になる可能性があります。initializer が yield すると、この呼び出しの後に現在のタスクを実行するスレッドは、呼び出し開始時のスレッドと異なる場合があります。


関連項目: [`OncePerTask`](@ref)。

!!! compat "Julia 1.12"
    この型を使用するには Julia 1.12 以降が必要です。


## Example

```jldoctest
julia> const thread_state = Base.OncePerThread{Vector{UInt32}}() do
           println("Making lazy thread value...done.")
           return [Libc.rand()]
       end;

julia> (threadvec = thread_state()) |> typeof
Making lazy thread value...done.
Vector{UInt32} (alias for Array{UInt32, 1})

julia> threadvec === fetch(@async thread_state())
true

julia> threadvec === thread_state[Threads.threadid()]
true
```
