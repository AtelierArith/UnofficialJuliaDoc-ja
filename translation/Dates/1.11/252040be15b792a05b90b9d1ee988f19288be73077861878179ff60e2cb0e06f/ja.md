```julia
week(dt::TimeType)::Int64
```

[ISO week date](https://en.wikipedia.org/wiki/ISO_week_date) を `Date` または `DateTime` の [`Int64`](@ref) として返します。年の第1週は、その年の最初の木曜日を含む週です。そのため、1月4日より前の日付が前年の最終週に含まれる場合があります。たとえば、`week(Date(2005, 1, 1))` は2004年の第53週です。

# Examples

```jldoctest
julia> week(Date(1989, 6, 22))
25

julia> week(Date(2005, 1, 1))
53

julia> week(Date(2004, 12, 31))
53
```
