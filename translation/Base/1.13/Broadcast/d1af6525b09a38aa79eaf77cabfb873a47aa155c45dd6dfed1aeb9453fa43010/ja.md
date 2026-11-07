```julia
combine_styles(cs...)::BroadcastStyle
```

任意個数の値引数に対して、どの`BroadcastStyle`を使用するかを決定します。各引数のスタイルを取得するには[`BroadcastStyle`](@ref)を使用し、スタイルの結合には[`result_style`](@ref)を使用します。

# Examples

```jldoctest
julia> Broadcast.combine_styles([1], [1 2; 3 4])
Base.Broadcast.DefaultArrayStyle{2}()
```
