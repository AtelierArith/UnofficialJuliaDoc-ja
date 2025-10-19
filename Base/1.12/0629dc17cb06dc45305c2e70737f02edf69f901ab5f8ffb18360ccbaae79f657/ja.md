```julia
bind(chnl::Channel, task::Task)
```

`chnl`のライフタイムをタスクに関連付けます。タスクが終了すると、`Channel` `chnl`は自動的に閉じられます。タスク内で捕捉されない例外は、`chnl`のすべての待機者に伝播されます。

`chnl`オブジェクトは、タスクの終了とは独立して明示的に閉じることができます。終了したタスクは、すでに閉じられた`Channel`オブジェクトには影響を与えません。

チャネルが複数のタスクにバインドされている場合、最初に終了したタスクがチャネルを閉じます。同じタスクに複数のチャネルがバインドされている場合、タスクの終了はすべてのバインドされたチャネルを閉じます。

# 例

```jldoctest
julia> c = Channel(0);

julia> task = @async foreach(i->put!(c, i), 1:4);

julia> bind(c,task);

julia> for i in c
           @show i
       end;
i = 1
i = 2
i = 3
i = 4

julia> isopen(c)
false
```

```jldoctest
julia> c = Channel(0);

julia> task = @async (put!(c, 1); error("foo"));

julia> bind(c, task);

julia> take!(c)
1

julia> put!(c, 1);
ERROR: TaskFailedException
Stacktrace:
[...]
    nested task error: foo
[...]
```
