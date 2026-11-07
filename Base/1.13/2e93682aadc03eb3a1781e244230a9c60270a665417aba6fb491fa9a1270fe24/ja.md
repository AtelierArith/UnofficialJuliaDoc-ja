```julia
Dict([itr])
```

`Dict{K,V}()` は、キーの型が `K`、値の型が `V` のハッシュテーブルを構築します。キーの比較には [`isequal`](@ref) を、ハッシュ値の計算には [`hash`](@ref) を使用します。

反復可能な引数を1つ指定すると、その引数が生成する2要素タプル `(key,value)` からキーと値のペアを取り出し、[`Dict`](@ref) を構築します。

# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> Dict([("A", 1), ("B", 2)])
Dict{String, Int64} with 2 entries:
  "B" => 2
  "A" => 1
```

または、ペアを引数として複数指定することもできます。

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
julia> Dict("A"=>1, "B"=>2)
Dict{String, Int64} with 2 entries:
  "B" => 2
  "A" => 1
```

!!! warning
    キーは変更可能でも構いませんが、格納済みのキーを変更すると、ハッシュテーブルの内部整合性が損なわれ、`Dict` が正しく動作しなくなることがあります。キーを変更する必要がある場合は、代わりに [`IdDict`](@ref) を使用できます。

