```
take!(c::Channel)
```

[`Channel`](@ref) から値を順番に削除して返します。データが利用可能になるまでブロックします。バッファなしのチャネルの場合、別のタスクによって [`put!`](@ref) が実行されるまでブロックします。

# 例

バッファ付きチャネル:

```jldoctest
julia> c = Channel(1);

julia> put!(c, 1);

julia> take!(c)
1
```

バッファなしチャネル:

```jldoctest
julia> c = Channel(0);

julia> task = Task(() -> put!(c, 1));

julia> schedule(task);

julia> take!(c)
1
```
