```julia
bind(chnl::Channel, task::Task)
```

`chnl`のライフタイムをタスクに関連付けます。タスクが終了すると、`Channel` `chnl`は自動的に閉じられます。タスク内で捕捉されなかった例外は、`chnl`で待機しているすべてのタスクに伝播します。

`chnl`オブジェクトは、タスクの終了とは無関係に明示的に閉じることができます。タスクが終了しても、すでに閉じられている`Channel`オブジェクトには影響しません。

チャネルが複数のタスクに関連付けられている場合、最初に終了したタスクがチャネルを閉じます。複数のチャネルが同じタスクに関連付けられている場合、そのタスクが終了すると、関連付けられているすべてのチャネルが閉じられます。

# Examples

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
