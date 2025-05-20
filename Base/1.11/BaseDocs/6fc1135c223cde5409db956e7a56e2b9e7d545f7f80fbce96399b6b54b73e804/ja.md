```
invoke(f, argtypes::Type, args...; kwargs...)
```

指定された引数 `args` に対して、指定された型 `argtypes` に一致する与えられた汎用関数 `f` のメソッドを呼び出します。引数 `args` は `argtypes` で指定された型に準拠している必要があり、すなわち自動的な変換は行われません。このメソッドは、最も特定の一致するメソッド以外のメソッドを呼び出すことを可能にし、より一般的な定義の動作が明示的に必要な場合に便利です（しばしば同じ関数のより特定のメソッドの実装の一部として）。

自分が書いていない関数に対して `invoke` を使用する際は注意が必要です。与えられた `argtypes` に対してどの定義が使用されるかは、関数が特定の `argtypes` での呼び出しが公開APIの一部であると明示的に述べていない限り、実装の詳細です。例えば、以下の例での `f1` と `f2` の間の変更は、通常、呼び出し側からは通常の（非 `invoke`）呼び出しで見えないため、互換性があると見なされます。しかし、`invoke` を使用すると変更が見えます。

# 例

```jldoctest
julia> f(x::Real) = x^2;

julia> f(x::Integer) = 1 + invoke(f, Tuple{Real}, x);

julia> f(2)
5

julia> f1(::Integer) = Integer
       f1(::Real) = Real;

julia> f2(x::Real) = _f2(x)
       _f2(::Integer) = Integer
       _f2(_) = Real;

julia> f1(1)
Integer

julia> f2(1)
Integer

julia> invoke(f1, Tuple{Real}, 1)
Real

julia> invoke(f2, Tuple{Real}, 1)
Integer
```
