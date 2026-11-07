`alignment(io, X)`は、小数点などの位置合わせの基準となる要素の左右に必要な文字数を示すタプル（left, right）を返します。

# Examples

```jldoctest
julia> Base.alignment(stdout, 42)
(2, 0)

julia> Base.alignment(stdout, 4.23)
(1, 3)

julia> Base.alignment(stdout, 1 + 10im)
(3, 5)
```
