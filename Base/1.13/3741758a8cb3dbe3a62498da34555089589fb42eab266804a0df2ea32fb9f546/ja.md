```julia
isvalid(s::AbstractString, i::Integer)::Bool
```

指定されたインデックスが、`s` 内の文字のエンコーディングの開始位置かどうかを示す述語です。`isvalid(s, i)` が true の場合、`s[i]` はそのインデックスからエンコーディングが始まる文字を返します。false の場合、`i` が範囲内にあるかどうかに応じて、`s[i]` は無効なインデックスエラーまたは範囲外エラーを発生させます。`isvalid(s, i)` を O(1) の関数にするには、`s` のエンコーディングが [self-synchronizing](https://en.wikipedia.org/wiki/Self-synchronizing_code) である必要があります。これは Julia の汎用文字列サポートにおける基本的な前提です。

関連項目: [`getindex`](@ref)、[`iterate`](@ref)、[`thisind`](@ref)、[`nextind`](@ref)、[`prevind`](@ref)、[`length`](@ref)。

# Examples

```jldoctest
julia> str = "αβγdef";

julia> isvalid(str, 1)
true

julia> str[1]
'α': Unicode U+03B1 (category Ll: Letter, lowercase)

julia> isvalid(str, 2)
false

julia> str[2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'α', [3]=>'β'
Stacktrace:
[...]
```
