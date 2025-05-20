```
Pair(x, y)
x => y
```

`Pair`オブジェクトを型`Pair{typeof(x), typeof(y)}`で構築します。要素はフィールド`first`と`second`に格納されます。また、反復処理を通じてアクセスすることもできます（ただし、`Pair`はブロードキャスト操作のために単一の「スカラー」として扱われます）。

[`Dict`](@ref)も参照してください。

# 例

```jldoctest
julia> p = "foo" => 7
"foo" => 7

julia> typeof(p)
Pair{String, Int64}

julia> p.first
"foo"

julia> for x in p
           println(x)
       end
foo
7

julia> replace.(["xops", "oxps"], "x" => "o")
2-element Vector{String}:
 "oops"
 "oops"
```
