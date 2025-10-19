```julia
week(dt::TimeType) -> Int64
```

`Date` または `DateTime` の [ISO week date](https://en.wikipedia.org/wiki/ISO_week_date) を [`Int64`](@ref) として返します。年の最初の週は、その年の最初の木曜日を含む週であり、これにより1月4日以前の日付が前年の最後の週に含まれることがあります。例えば、`week(Date(2005, 1, 1))` は2004年の53週目です。

# 例

```jldoctest
julia> week(Date(1989, 6, 22))
25

julia> week(Date(2005, 1, 1))
53

julia> week(Date(2004, 12, 31))
53
```
