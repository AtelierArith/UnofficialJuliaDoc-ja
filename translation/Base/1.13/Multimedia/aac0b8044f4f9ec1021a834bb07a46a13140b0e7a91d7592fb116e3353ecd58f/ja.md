```julia
displayable(mime)::Bool
displayable(d::AbstractDisplay, mime)::Bool
```

指定された`mime`型（文字列）が、現在のディスプレイスタック内のいずれかのディスプレイで表示可能かどうかを示すブール値を返します。第2の形式では、`d`ディスプレイで表示可能かどうかを示します。
