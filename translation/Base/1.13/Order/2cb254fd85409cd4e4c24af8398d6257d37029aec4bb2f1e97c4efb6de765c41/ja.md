```julia
ord(lt, by, rev::Union{Bool, Nothing}, order::Ordering=Forward)
```

[`Ordering`](@ref) オブジェクトは、[`sort!`](@ref) と同じ引数を使って構築します。要素はまず関数 `by`（[`identity`](@ref) の場合もあります）で変換され、その後、関数 `lt` または既存の順序 `order` に従って比較されます。`lt` は [`isless`](@ref)、または [`sort!`](@ref) の `lt` パラメーターと同じ規則に従う関数でなければなりません。最後に、`rev=true` の場合は、結果の順序が逆になります。

`isless` 以外の `lt` と、[`Base.Order.Forward`](@ref) または [`Base.Order.Reverse`](@ref) 以外の `order` を同時に渡すことはできません。それ以外のオプションはすべて独立しており、任意の組み合わせで併用できます。
