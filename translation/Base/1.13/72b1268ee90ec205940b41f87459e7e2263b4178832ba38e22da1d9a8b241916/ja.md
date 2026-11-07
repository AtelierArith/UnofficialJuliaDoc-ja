```julia
hash(x[, h::UInt])::UInt
```

`isequal(x,y)` が成り立つときに `isequal(hash(x), hash(y))` となるような整数ハッシュコードを計算します。省略可能な第2引数 `h` は、結果と混合する別のハッシュコードです。

新しい型では2引数形式を実装してください。通常は、内容のハッシュ同士（および `h`）を混合するため、2引数の `hash` メソッドを再帰的に呼び出します。通常、`hash` を実装する型は、上記の性質を保証するために、独自の [`==`](@ref)（したがって [`isequal`](@ref)）も実装する必要があります。

ハッシュ値は、新しい Julia プロセスを開始すると変わることがあります。

!!! warning
    2引数形式を実装する際、第2引数 `h` に `h = UInt(0)` のようなデフォルト値を指定してはいけません。これにより、フォールバック（[Note on Optional and keyword Arguments](@ref) を参照）よりも具体的な1引数メソッドが暗黙に作られますが、シードが誤っている可能性があり、ハッシュの不整合を引き起こすためです。


```jldoctest; filter = r"0x[0-9a-f]{16}"
julia> a = hash(10)
0x759d18cc5346a65f

julia> hash(10, a) # only use the output of another hash function as the second argument
0x03158cd61b1b0bd1
```

関連項目: [`objectid`](@ref)、[`Dict`](@ref)、[`Set`](@ref)。
