```julia
nextind(str::AbstractString, i::Integer, n::Integer=1)::Int
```

  * ケース `n == 1`

    `i` が `str` の範囲内にある場合、`i` より後からエンコーディングが始まる文字の開始位置のインデックスを返します。つまり、`i` が文字の開始位置であれば、次の文字の開始位置を返します。`i` が文字の開始位置でない場合は、次の文字の開始位置まで進み、そのインデックスを返します。`i` が `0` と等しい場合は、`1` を返します。`i` が範囲内にあり、かつ `lastindex(str)` 以上の場合は、`ncodeunits(str)+1` を返します。それ以外の場合は `BoundsError` をスローします。
  * ケース `n > 1`

    `n==1` に対して `nextind` を `n` 回適用した場合と同様に動作します。唯一の違いは、`n` が非常に大きく、`nextind` を適用すると `ncodeunits(str)+1` に達する場合、残りの各反復で返される値が `1` ずつ増加することです。したがって、この場合、`nextind` は `ncodeunits(str)+1` より大きい値を返すことがあります。
  * ケース `n == 0`

    `i` が `str` の有効なインデックスであるか、`0` と等しい場合に限り、`i` を返します。それ以外の場合は、`StringIndexError` または `BoundsError` がスローされます。

# Examples

```jldoctest
julia> nextind("α", 0)
1

julia> nextind("α", 1)
3

julia> nextind("α", 3)
ERROR: BoundsError: attempt to access 2-codeunit String at index [3]
[...]

julia> nextind("α", 0, 2)
3

julia> nextind("α", 1, 2)
4
```
