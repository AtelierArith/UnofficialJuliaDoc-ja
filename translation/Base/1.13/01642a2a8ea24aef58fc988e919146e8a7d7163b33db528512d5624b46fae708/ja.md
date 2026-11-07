```julia
thisind(s::AbstractString, i::Integer)::Int
```

`i` が `s` の範囲内にある場合、エンコーディングのコード単位 `i` が属する文字の開始位置のインデックスを返します。つまり、`i` が文字の開始位置であれば `i` を返します。`i` が文字の開始位置でなければ、文字の開始位置まで戻ってそのインデックスを返します。`i` が 0 または `ncodeunits(s)+1` と等しい場合は、`i` を返します。それ以外の場合は `BoundsError` をスローします。

# Examples

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
