```
thisind(s::AbstractString, i::Integer) -> Int
```

`s`内の`i`が範囲内であれば、`i`が属する文字のエンコーディングコードユニットの開始位置のインデックスを返します。言い換えれば、`i`が文字の開始位置であれば`i`を返し、`i`が文字の開始位置でなければ、文字の開始位置まで巻き戻してそのインデックスを返します。`i`が0または`ncodeunits(s)+1`に等しい場合は`i`を返します。それ以外の場合は`BoundsError`をスローします。

# 例

```jldoctest
julia> thisind("α", 0)
0

julia> thisind("α", 1)
1

julia> thisind("α", 2)
1

julia> thisind("α", 3)
3

julia> thisind("α", 4)
ERROR: BoundsError: attempt to access 2-codeunit String at index [4]
[...]

julia> thisind("α", -1)
ERROR: BoundsError: attempt to access 2-codeunit String at index [-1]
[...]
```
