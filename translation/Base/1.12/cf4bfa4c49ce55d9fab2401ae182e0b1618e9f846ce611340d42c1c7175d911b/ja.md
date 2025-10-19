```julia
nextind(str::AbstractString, i::Integer, n::Integer=1) -> Int
```

  * ケース `n == 1`

    もし `i` が `s` の範囲内であれば、インデックス `i` の後にエンコーディングが始まる文字の開始位置のインデックスを返します。言い換えれば、`i` が文字の開始位置であれば次の文字の開始位置を返し、`i` が文字の開始位置でない場合は、文字の開始位置まで進んでそのインデックスを返します。もし `i` が `0` に等しい場合は `1` を返します。もし `i` が範囲内であるが `lastindex(str)` 以上であれば `ncodeunits(str)+1` を返します。それ以外の場合は `BoundsError` をスローします。
  * ケース `n > 1`

    `n==1` の場合に `nextind` を `n` 回適用するように動作します。唯一の違いは、`n` が非常に大きく、`nextind` を適用すると `ncodeunits(str)+1` に達する場合、残りの各反復で返される値が `1` 増加することです。つまり、この場合 `nextind` は `ncodeunits(str)+1` より大きな値を返すことができます。
  * ケース `n == 0`

    `i` が `s` の有効なインデックスであるか `0` に等しい場合のみ `i` を返します。それ以外の場合は `StringIndexError` または `BoundsError` がスローされます。

# 例

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
