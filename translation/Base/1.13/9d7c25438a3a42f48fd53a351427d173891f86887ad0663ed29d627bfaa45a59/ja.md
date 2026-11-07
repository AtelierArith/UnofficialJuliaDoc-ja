```julia
Pair(x, y)
x => y
```

型が`Pair{typeof(x), typeof(y)}`の`Pair`オブジェクトを構築します。要素はフィールド`first`および`second`に格納されます。反復処理によってアクセスすることもできます（ただし、ブロードキャスト演算では`Pair`は単一の「スカラー」として扱われます）。

[`Dict`](@ref)も参照してください。

# Examples

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
