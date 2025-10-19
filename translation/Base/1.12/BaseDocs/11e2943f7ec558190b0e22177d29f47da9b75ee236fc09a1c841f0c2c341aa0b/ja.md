```julia
DomainError(val)
DomainError(val, msg)
```

関数またはコンストラクタへの引数 `val` が有効なドメインの外にあります。

# 例

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrtは負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。sqrt(Complex(x))を試してください。
Stacktrace:
[...]
```
