```julia
OncePerThread{T}(init::Function)() -> T
```

`OncePerThread`オブジェクトを呼び出すと、関数`initializer`をスレッドごとに正確に1回実行することで、型`T`の値が返されます。同じスレッド内での将来のすべての呼び出し、および同じスレッドIDを持つ同時または将来の呼び出しは、正確に同じ値を返します。このオブジェクトは、既存のスレッドのスレッドIDでインデックスを付けることもでき、そのスレッドに保存されている値を取得（または*このスレッドで初期化*）できます。不適切な使用はデータ競合やメモリ破損を引き起こす可能性があるため、ライブラリのスレッドセーフ設計内でその動作が正しい場合にのみ使用してください。

!!! warning
    タスクが必ずしも1つのスレッドでのみ実行されるわけではないため、ここで返される値は他の値とエイリアスを持ったり、プログラムの途中で変更されたりする可能性があります。この関数は将来的に非推奨になる可能性があります。初期化子がyieldする場合、呼び出しの開始時と呼び出し後に現在のタスクを実行しているスレッドは同じではないかもしれません。


関連情報: [`OncePerTask`](@ref).

!!! compat "Julia 1.12"
    この型はJulia 1.12以降が必要です。


## 例

```jldoctest
julia> const thread_state = Base.OncePerThread{Vector{UInt32}}() do
           println("Lazy thread valueを作成中...完了。")
           return [Libc.rand()]
       end;

julia> (threadvec = thread_state()) |> typeof
Lazy thread valueを作成中...完了。
Vector{UInt32} (alias for Array{UInt32, 1})

julia> threadvec === fetch(@async thread_state())
true

julia> threadvec === thread_state[Threads.threadid()]
true
```
