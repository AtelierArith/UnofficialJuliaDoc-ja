```julia
keys(m::RegexMatch)::Vector
```

基になる正規表現のすべてのキャプチャグループについて、キーのベクトルを返します。キャプチャグループがマッチしなかった場合でも、そのキーは含まれます。つまり、`idx` は、`m[idx] == nothing` であっても戻り値に含まれます。

名前のないキャプチャグループのキーは、インデックスに対応する整数です。名前付きキャプチャグループのキーは文字列です。

!!! compat "Julia 1.7"
    このメソッドは Julia 1.7 で追加されました


# Examples

```jldoctest
julia> keys(match(r"(?<hour>\d+):(?<minute>\d+)(am|pm)?", "11:30"))
3-element Vector{Any}:
  "hour"
  "minute"
 3
```
