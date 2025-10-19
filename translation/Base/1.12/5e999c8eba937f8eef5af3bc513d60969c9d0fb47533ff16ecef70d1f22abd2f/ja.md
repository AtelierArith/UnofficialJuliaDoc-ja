```julia
isvalid(s::AbstractString, i::Integer) -> Bool
```

与えられたインデックスが`s`内の文字のエンコーディングの開始位置であるかどうかを示す述語。`isvalid(s, i)`がtrueの場合、`s[i]`はそのインデックスで始まるエンコーディングの文字を返します。falseの場合、`s[i]`は無効なインデックスエラーまたは範囲エラーを発生させます。`i`が範囲内であるかどうかに依存します。`isvalid(s, i)`がO(1)関数であるためには、`s`のエンコーディングが[自己同期](https://en.wikipedia.org/wiki/Self-synchronizing_code)でなければなりません。これはJuliaの一般的な文字列サポートの基本的な前提です。

他にも[`getindex`](@ref)、[`iterate`](@ref)、[`thisind`](@ref)、[`nextind`](@ref)、[`prevind`](@ref)、[`length`](@ref)を参照してください。

# 例

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
