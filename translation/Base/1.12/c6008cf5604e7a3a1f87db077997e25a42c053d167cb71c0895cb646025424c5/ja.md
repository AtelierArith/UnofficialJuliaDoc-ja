```julia
RegexMatch <: AbstractMatch
```

文字列内で見つかった[`Regex`](@ref)への単一の一致を表す型。通常は[`match`](@ref)関数から作成されます。

`match`フィールドは、全体の一致した文字列の部分文字列を格納します。`captures`フィールドは、番号でインデックス付けされた各キャプチャグループの部分文字列を格納します。キャプチャグループ名でインデックス付けするには、全体の一致オブジェクトを代わりにインデックス付けする必要があります。マッチの開始位置は`offset`フィールドに格納されます。`offsets`フィールドは、各キャプチャグループの開始位置を格納し、0はキャプチャされなかったグループを示します。

この型は、`Regex`のキャプチャグループを反復処理するイテレータとして使用でき、各グループでキャプチャされた部分文字列を生成します。このため、マッチのキャプチャを分解することができます。グループがキャプチャされなかった場合、部分文字列の代わりに`nothing`が生成されます。

`RegexMatch`オブジェクトを受け入れるメソッドは、[`iterate`](@ref)、[`length`](@ref)、[`eltype`](@ref)、[`keys`](@ref keys(::RegexMatch))、[`haskey`](@ref)、および[`getindex`](@ref)に対して定義されており、キーはキャプチャグループの名前または番号です。詳細については、[`keys`](@ref keys(::RegexMatch))を参照してください。

`Tuple(m)`、`NamedTuple(m)`、および`Dict(m)`を使用して、`RegexMatch`オブジェクトからより柔軟なコレクション型を構築できます。

!!! compat "Julia 1.11"
    RegexMatchesからNamedTuplesおよびDictsを構築するには、Julia 1.11が必要です


# 例

```jldoctest
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

julia> hr, min, ampm = m; # 反復処理によるキャプチャグループの分解

julia> hr
"11"

julia> Dict(m)
Dict{Any, Union{Nothing, SubString{String}}} with 3 entries:
  "hour"   => "11"
  3        => nothing
  "minute" => "30"
```
