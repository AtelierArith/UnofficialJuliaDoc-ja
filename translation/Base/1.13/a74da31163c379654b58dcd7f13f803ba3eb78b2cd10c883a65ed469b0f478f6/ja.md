```julia
RangeStepStyle(instance)
RangeStepStyle(T::Type)
```

インスタンスまたは型が、完全に規則的なステップ幅の範囲を構築できるかどうかを示します。規則的なステップ幅とは、範囲内の連続する2要素の差が常に [`step`](@ref) と完全に一致することを意味します。つまり、範囲 `r::AbstractRange{T}` では次のようになります。

```julia
all(diff(r) .== step(r))
```

型 `T` から常に規則的なステップ幅の範囲が生成される場合は、次のメソッドを定義します。

```julia
Base.RangeStepStyle(::Type{<:AbstractRange{<:T}}) = Base.RangeStepRegular()
```

これにより、[`hash`](@ref) は、`AbstractRange{T}` オブジェクトに対して、デフォルトの O(N) アルゴリズム（N は範囲の長さ）ではなく、O(1) アルゴリズムを使用できます。

場合によっては、ステップ幅が規則的かどうかは、要素の型 `T` だけでなく、ステップの型 `S` にも依存します。その場合は、より具体的なメソッドを定義します。

```julia
Base.RangeStepStyle(::Type{<:OrdinalRange{<:T, <:S}}) = Base.RangeStepRegular()
```

デフォルトでは、要素型が `Integer` のサブタイプである範囲を除き、すべての範囲型は `RangeStepIrregular` であると見なされます。
