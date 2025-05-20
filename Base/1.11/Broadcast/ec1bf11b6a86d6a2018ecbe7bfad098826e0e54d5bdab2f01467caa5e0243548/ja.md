```
combine_styles(cs...) -> BroadcastStyle
```

任意の数の値引数に対して使用する `BroadcastStyle` を決定します。各引数のスタイルを取得するために [`BroadcastStyle`](@ref) を使用し、スタイルを組み合わせるために [`result_style`](@ref) を使用します。

# 例

```jldoctest
julia> Broadcast.combine_styles([1], [1 2; 3 4])
Base.Broadcast.DefaultArrayStyle{2}()
```
