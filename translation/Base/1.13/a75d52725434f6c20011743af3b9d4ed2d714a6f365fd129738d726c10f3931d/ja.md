```julia
RegexMatch <: AbstractMatch
```

文字列内で見つかった[`Regex`](@ref)への単一のマッチを表す型です。通常は[`match`](@ref)関数によって作成されます。

`match`フィールドには、マッチした文字列全体の部分文字列が格納されます。`captures`フィールドには、各キャプチャグループの部分文字列が番号をインデックスとして格納されます。キャプチャグループ名でインデックスを指定するには、例に示すように、マッチオブジェクト全体をインデックス指定します。マッチの開始位置は`offset`フィールドに格納されます。`offsets`フィールドには、各キャプチャグループの開始位置が格納されます。キャプチャされなかったグループは0で示されます。

この型は、`Regex`のキャプチャグループを反復処理するイテレータとして使用でき、各グループでキャプチャされた部分文字列を順に返します。そのため、マッチのキャプチャを分割代入できます。グループがキャプチャされなかった場合は、部分文字列の代わりに`nothing`が返されます。

`RegexMatch`オブジェクトを受け取るメソッドは、[`iterate`](@ref)、[`length`](@ref)、[`eltype`](@ref)、[`keys`](@ref keys(::RegexMatch))、[`haskey`](@ref)、[`getindex`](@ref)に対して定義されています。キーには、キャプチャグループの名前または番号を指定します。詳しくは[`keys`](@ref keys(::RegexMatch))を参照してください。

`Tuple(m)`、`NamedTuple(m)`、`Dict(m)`を使うと、`RegexMatch`オブジェクトから、より柔軟なコレクション型を構築できます。

!!! compat "Julia 1.11"
    RegexMatchesからNamedTupleやDictを構築するには、Julia 1.11が必要です。


# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\S+$"m
julia> m = match(r"(?<hour>\d+):(?<minute>\d+)(am|pm)?", "11:30 in the morning")
RegexMatch("11:30", hour="11", minute="30", 3=nothing)

julia> m.match
"11:30"

julia> m.captures
3-element Vector{Union{Nothing, SubString{String}}}:
 "11"
 "30"
 nothing


julia> m["minute"]
"30"

julia> hr, min, ampm = m; # destructure capture groups by iteration

julia> hr
"11"

julia> Dict(m)
Dict{Any, Union{Nothing, SubString{String}}} with 3 entries:
  "hour"   => "11"
  3        => nothing
  "minute" => "30"
```
