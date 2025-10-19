```julia
Pair(x, y)
x => y
```

型 `Pair{typeof(x), typeof(y)}` の `Pair` オブジェクトを構築します。要素は `first` と `second` フィールドに格納されます。また、反復処理を通じてアクセスすることもできます（ただし、`Pair` はブロードキャスト操作のために単一の「スカラー」として扱われます）。

参照: [`Dict`](@ref)。

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
