```julia
Channel{T=Any}(func::Function, size=0; taskref=nothing, spawn=false, threadpool=nothing)
```

`func`から新しいタスクを作成し、[`bind`](@ref)で型が`T`、サイズが`size`の新しいチャネルに接続して、タスクをスケジュールします。これらすべてを1回の呼び出しで行います。タスクが終了すると、チャネルは自動的に閉じられます。

`func`は、バインドされたチャネルだけを引数として受け取る必要があります。

作成したタスクへの参照が必要な場合は、キーワード引数`taskref`に`Ref{Task}`オブジェクトを渡します。

`spawn=true`の場合、`func`用に作成された`Task`は、別のスレッドで並行してスケジュールされることがあります。これは、[`Threads.@spawn`](@ref)を使ってタスクを作成するのと同等です。

`spawn=true`の場合、`threadpool`引数が設定されていなければ、デフォルトで`:default`になります。

`threadpool`引数が設定されている場合（`:default`または`:interactive`）、これは`spawn=true`を意味し、新しいタスクは指定されたスレッドプールで起動されます。

`Channel`を返します。

# Examples

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

作成したタスクへの参照:

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
    `spawn=`パラメーターはJulia 1.3で追加されました。このコンストラクターもJulia 1.3で追加されました。それ以前のJuliaでは、Channelはキーワード引数で`size`と`T`を設定していましたが、これらのコンストラクターは非推奨です。


!!! compat "Julia 1.9"
    `threadpool=`引数はJulia 1.9で追加されました。


```jldoctest
julia> chnl = Channel{Char}(1, spawn=true) do ch
           for c in "hello world"
               put!(ch, c)
           end
       end;

julia> String(collect(chnl))
"hello world"
```
