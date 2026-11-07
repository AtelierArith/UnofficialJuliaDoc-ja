```julia
OncePerThread{T}(init::Function)() -> T
```

`OncePerThread` オブジェクトを呼び出すと、スレッドごとに関数 `initializer` をちょうど1回実行し、型 `T` の値を返します。同じスレッドでの以降の呼び出し、および同じスレッド ID を指定した並行または将来の呼び出しでは、常にまったく同じ値が返されます。また、既存の任意のスレッドの threadid でオブジェクトをインデックス指定すると、そのスレッドに保存された値を取得できます（このスレッド上で初期化することもできます）。誤った使い方をするとデータ競合やメモリ破損につながる可能性があるため、この動作がライブラリのスレッド安全性設計に適合する場合にのみ使用してください。

!!! warning
    Task が必ず1つのスレッドだけで実行されるとは限らないため、ここで返される値は他の値とエイリアスする場合や、プログラムの実行中に変化する場合があります。この関数は将来非推奨になる可能性があります。initializer が yield すると、呼び出し後に現在のタスクを実行するスレッドは、呼び出し開始時のスレッドと異なる場合があります。


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
