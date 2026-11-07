```julia
alias::MustAlias
```

この格子要素は、親オブジェクトの同一性を再符号化しながら、オブジェクトのフィールドへの参照をラップします。これにより、`isa` や `===` などの組み込み関数がオブジェクトのフィールド型に課す制約を、同じオブジェクトフィールドへの別の参照にも伝播できます。重要な注意点として、この格子要素は、スロットオブジェクトが再代入されるまで、ラップされたスロットオブジェクトのフィールドが変化しないという不変条件を前提としています。つまり、推論ではオブジェクトごとのメモリ効果を追跡していないため、ラップされたオブジェクトフィールドは定数である必要があります。特に、`maybe_const_fldidx` は lift を使って、指定された格子要素が `MustAlias` でラップ可能かどうかを確認します。例：

```juila
let alias = getfield(x::Some{Union{Nothing,String}}, :value)::MustAlias(x, Some{Union{Nothing,String}}, 1, Union{Nothing,String})
    if alias === nothing
        # May assume `getfield(x, :value)` is `nothing` now
    else
        # May assume `getfield(x, :value)` is `::String` now
    end
end
```

注：現在、この格子要素は abstractinterpret でのみ使用され、最適化では使用されません。
