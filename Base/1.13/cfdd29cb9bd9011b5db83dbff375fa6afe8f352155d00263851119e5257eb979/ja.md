```julia
AbstractSlices{S,N} <: AbstractArray{S,N}
```

親配列の一部の次元に沿ったスライスの配列のスーパータイプです。ビューを返し、その他の次元のデータはすべて選択します。

`parent` は親配列を返します。
