```julia
if/elseif/else
```

`if`/`elseif`/`else`は条件評価を行います。これにより、ブール式の値に応じてコードの一部を評価するかどうかを決められます。`if`/`elseif`/`else`条件構文の構成は次のとおりです。

```julia
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

条件式`x < y`がtrueの場合、対応するブロックが評価されます。そうでない場合は、条件式`x > y`が評価され、trueであれば対応するブロックが評価されます。どちらの式もtrueでない場合は、`else`ブロックが評価されます。`elseif`ブロックと`else`ブロックは省略可能で、`elseif`ブロックは必要な数だけ使用できます。

一部の他の言語とは異なり、条件の型は`Bool`でなければなりません。条件が`Bool`に変換可能であるだけでは不十分です。

```jldoctest
julia> if 1 end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```
