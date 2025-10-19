```julia
map!(f, values(dict::AbstractDict))
```

`dict`を修正し、各値を`val`から`f(val)`に変換します。`dict`の型は変更できないことに注意してください：`f(val)`が`dict`の値の型のインスタンスでない場合、可能であれば値の型に変換され、それ以外の場合はエラーが発生します。

!!! compat "Julia 1.2"
    `map!(f, values(dict::AbstractDict))`はJulia 1.2以降が必要です。


# 例

```jldoctest
julia> d = Dict(:a => 1, :b => 2)
Dict{Symbol, Int64} with 2 entries:
  :a => 1
  :b => 2

julia> map!(v -> v-1, values(d))
ValueIterator for a Dict{Symbol, Int64} with 2 entries. Values:
  0
  1
```
