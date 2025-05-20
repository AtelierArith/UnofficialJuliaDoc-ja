```
isopen(object) -> Bool
```

オブジェクト（ストリームやタイマーなど）がまだ閉じられていないかどうかを判断します。一度オブジェクトが閉じられると、新しいイベントを生成することはありません。ただし、閉じられたストリームにはまだバッファに読み取るデータが残っている可能性があるため、データを読み取る能力を確認するには[`eof`](@ref)を使用してください。ストリームが書き込み可能または読み取り可能になると通知を受けるには、`FileWatching`パッケージを使用してください。

# 例

```jldoctest
julia> io = open("my_file.txt", "w+");

julia> isopen(io)
true

julia> close(io)

julia> isopen(io)
false
```
