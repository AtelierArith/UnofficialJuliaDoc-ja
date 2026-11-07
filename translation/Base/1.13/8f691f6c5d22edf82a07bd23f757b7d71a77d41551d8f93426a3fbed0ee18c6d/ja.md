```julia
prevind(str::AbstractString, i::Integer, n::Integer=1)::Int
```

  * ケース `n == 1`

    `i` が `str` の範囲内にある場合、エンコーディングがインデックス `i` より前から始まる文字の開始位置を返します。つまり、`i` が文字の開始位置であれば、直前の文字の開始位置を返します。`i` が文字の開始位置でない場合は、文字の開始位置まで巻き戻して、そのインデックスを返します。`i` が `1` と等しい場合は、`0` を返します。`i` が `ncodeunits(str)+1` と等しい場合は、`lastindex(str)` を返します。それ以外の場合は `BoundsError` をスローします。
  * ケース `n > 1`

    `n==1` に対して、`prevind` を `n` 回適用した場合と同様に動作します。唯一の違いは、`n` が非常に大きく、`prevind` を適用すると `0` に達する場合、残りの各反復で返される値が `1` ずつ減少することです。このため、この場合、`prevind` は負の値を返すことがあります。
  * ケース `n == 0`

    `i` が `str` における有効なインデックスであるか、`ncodeunits(str)+1` と等しい場合に限り、`i` を返します。それ以外の場合は、`StringIndexError` または `BoundsError` がスローされます。

# Examples

```jldoctest
julia> prevind("α", 3)
1

julia> prevind("α", 1)
0

julia> prevind("α", 0)
ERROR: BoundsError: attempt to access 2-codeunit String at index [0]
[...]

julia> prevind("α", 2, 2)
0

julia> prevind("α", 2, 3)
-1
```
