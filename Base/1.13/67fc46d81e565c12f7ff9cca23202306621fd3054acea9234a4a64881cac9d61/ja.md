`alignment(io, X)` は、位置合わせの対象となる小数点などの特徴の左右に必要な文字数を示すタプル (left,right) を返します。

# Examples

```jldoctest
julia> Base.alignment(stdout, 42)
(2, 0)

julia> Base.alignment(stdout, 4.23)
(1, 3)

julia> Base.alignment(stdout, 1 + 10im)
(3, 5)
```
