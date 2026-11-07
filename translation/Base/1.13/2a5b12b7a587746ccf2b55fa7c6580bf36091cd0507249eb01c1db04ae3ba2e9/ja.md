```julia
BitArray{N} <: AbstractArray{Bool, N}
```

各ブール値を1ビットだけで表す、省メモリな`N`次元ブール配列。

`BitArray`は8バイトごとに最大64個の値を格納するため、`Array{Bool, N}`と比べてメモリ効率が8倍になり、一部の操作を64個の値に対して一度に実行できます。

Juliaはデフォルトで、ブール要素を生成する[broadcasting](@ref Broadcasting)操作（`.==`のようなドット付き比較を含む）や、関数[`trues`](@ref)および[`falses`](@ref)から、`BitArrays`を返します。

!!! note
    パック形式で格納されるため、`BitArray`の要素に対する並行アクセスのうち、少なくとも1つが書き込みである場合、スレッドセーフではありません。

