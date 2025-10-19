```julia
if/elseif/else
```

`if`/`elseif`/`else` は条件評価を行い、ブール式の値に応じてコードの一部を評価するかどうかを決定します。以下は `if`/`elseif`/`else` 条件構文の構造です：

```julia
if x < y
    println("x は y より小さい")
elseif x > y
    println("x は y より大きい")
else
    println("x は y と等しい")
end
```

条件式 `x < y` が真であれば、対応するブロックが評価されます。そうでなければ、条件式 `x > y` が評価され、もしそれが真であれば、対応するブロックが評価されます。どちらの式も真でない場合は、`else` ブロックが評価されます。`elseif` と `else` ブロックはオプションであり、必要に応じて任意の数の `elseif` ブロックを使用できます。

他のいくつかの言語とは異なり、条件は `Bool` 型でなければなりません。条件が `Bool` に変換可能であるだけでは不十分です。

```jldoctest
julia> if 1 end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```
