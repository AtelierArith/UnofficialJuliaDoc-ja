```julia
map!(f, values(dict::AbstractDict))
```

`dict`を変更し、各値を`val`から`f(val)`へ変換します。`dict`の型は変更できない点に注意してください。`f(val)`が`dict`の値型のインスタンスでない場合、可能であれば値型に変換され、変換できなければエラーが発生します。

!!! compat "Julia 1.2"
    `map!(f, values(dict::AbstractDict))`にはJulia 1.2以降が必要です。


# Examples

```jldoctest; filter = r"^\s+\S+(\s+=>\s+\d)?$"m
julia> d = Dict(:a => 1, :b => 2)
Dict{Symbol, Int64} with 2 entries:
  :a => 1
  :b => 2

julia> map!(v -> v-1, values(d))
ValueIterator for a Dict{Symbol, Int64} with 2 entries. Values:
  0
  1
```
