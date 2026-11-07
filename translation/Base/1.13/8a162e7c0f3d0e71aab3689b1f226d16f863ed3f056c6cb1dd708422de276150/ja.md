```julia
IdDict([itr])
```

`IdDict{K,V}()` は、[`objectid`](@ref) をハッシュ関数、`===` を等価性判定として、キーの型が `K`、値の型が `V` のハッシュテーブルを構築します。詳しくは [`Dict`](@ref) を参照してください。また、集合版については [`IdSet`](@ref) を参照してください。

以下の例では、`Dict` のキーはすべて `isequal` であるため、同じハッシュ値になり、上書きされます。一方、`IdDict` はオブジェクト ID に基づいてハッシュ化するため、3 つの異なるキーが保持されます。

# Examples

```jldoctest; filter = r"  \S+ +=> \S+" => "  KEY => VALUE"
julia> Dict(true => "yes", 1 => "no", 1.0 => "maybe")
Dict{Real, String} with 1 entry:
  1.0 => "maybe"

julia> IdDict(true => "yes", 1 => "no", 1.0 => "maybe")
IdDict{Any, String} with 3 entries:
  true => "yes"
  1.0  => "maybe"
  1    => "no"
```
