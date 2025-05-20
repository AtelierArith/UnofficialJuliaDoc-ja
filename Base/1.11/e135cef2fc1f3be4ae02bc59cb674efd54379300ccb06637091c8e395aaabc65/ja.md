```
isready(c::Channel)
```

[`Channel`](@ref) に値が格納されているかどうかを判断します。即座に返され、ブロックしません。

バッファなしのチャネルの場合、[`put!`](@ref) を待機しているタスクがある場合は `true` を返します。

# 例

バッファ付きチャネル:

```jldoctest
julia> c = Channel(1);

julia> isready(c)
false

julia> put!(c, 1);

julia> isready(c)
true
```

バッファなしチャネル:

```jldoctest
julia> c = Channel();

julia> isready(c)  # 値を入れるために待機しているタスクはありません!
false

julia> task = Task(() -> put!(c, 1));

julia> schedule(task);  # put! タスクをスケジュールする

julia> isready(c)
true
```
