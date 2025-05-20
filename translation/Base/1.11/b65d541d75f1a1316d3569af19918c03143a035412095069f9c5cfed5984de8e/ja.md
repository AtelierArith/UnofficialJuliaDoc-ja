```
Channel{T=Any}(func::Function, size=0; taskref=nothing, spawn=false, threadpool=nothing)
```

`func`から新しいタスクを作成し、それを型`T`およびサイズ`size`の新しいチャネルにバインドし、タスクをスケジュールします。すべてが1回の呼び出しで行われます。タスクが終了すると、チャネルは自動的に閉じられます。

`func`は、バインドされたチャネルを唯一の引数として受け入れる必要があります。

作成されたタスクへの参照が必要な場合は、キーワード引数`taskref`を介して`Ref{Task}`オブジェクトを渡してください。

`spawn=true`の場合、`func`のために作成された`Task`は、別のスレッドで並行してスケジュールされる可能性があり、これは[`Threads.@spawn`](@ref)を介してタスクを作成することに相当します。

`spawn=true`で`threadpool`引数が設定されていない場合、デフォルトは`:default`です。

`threadpool`引数が設定されている場合（`:default`または`:interactive`）、これは`spawn=true`を意味し、新しいタスクは指定されたスレッドプールにスパーンされます。

`Channel`を返します。

# 例

```jldoctest
julia> chnl = Channel() do ch
           foreach(i -> put!(ch, i), 1:4)
       end;

julia> typeof(chnl)
Channel{Any}

julia> for i in chnl
           @show i
       end;
i = 1
i = 2
i = 3
i = 4
```

作成されたタスクを参照する：

```jldoctest
julia> taskref = Ref{Task}();

julia> chnl = Channel(taskref=taskref) do ch
           println(take!(ch))
       end;

julia> istaskdone(taskref[])
false

julia> put!(chnl, "Hello");
Hello

julia> istaskdone(taskref[])
true
```

!!! compat "Julia 1.3"
    `spawn=`パラメータはJulia 1.3で追加されました。このコンストラクタはJulia 1.3で追加されました。以前のバージョンのJuliaでは、Channelはキーワード引数を使用して`size`と`T`を設定しましたが、それらのコンストラクタは非推奨です。


!!! compat "Julia 1.9"
    `threadpool=`引数はJulia 1.9で追加されました。


```jldoctest
julia> chnl = Channel{Char}(1, spawn=true) do ch
           for c in "hello world"
               put!(ch, c)
           end
       end
Channel{Char}(1) (2 items available)

julia> String(collect(chnl))
"hello world"
```
