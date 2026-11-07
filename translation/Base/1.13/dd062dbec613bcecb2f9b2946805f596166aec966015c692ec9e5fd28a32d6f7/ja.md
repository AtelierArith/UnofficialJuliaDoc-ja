```julia
^(x, y)
```

べき乗演算子。

`x` と `y` が整数の場合、結果がオーバーフローすることがあります。科学表記で数値を入力するには、`1.2 * 10^3` ではなく、[`Float64`](@ref) リテラル（`1.2e3` など）を使用してください。

`y` が `Int` リテラルの場合（たとえば、`x^2` の `2` や、`x^-3` の `-3`）、コンパイラは Julia コード `x^y` を `Base.literal_pow(^, x, Val(y))` に変換し、指数の値に基づくコンパイル時特殊化を可能にします。（デフォルトのフォールバックとして `Base.literal_pow(^, x, Val(y)) = ^(x,y)` があり、通常は呼び出し側の名前空間で `^` が定義されていない限り、`^ == Base.^` となります。）`y` が負の整数リテラルの場合、`Base.literal_pow` はデフォルトで演算を `inv(x)^-y` に変換します。このとき `-y` は正の値です。

[`exp2`](@ref)、[`<<`](@ref) も参照してください。

# Examples

```jldoctest
julia> 3^5
243

julia> 3^-1  # uses Base.literal_pow
0.3333333333333333

julia> p = -1;

julia> 3^p
ERROR: DomainError with -1:
Cannot raise an integer x to a negative power -1.
[...]

julia> 3.0^p
0.3333333333333333

julia> 10^19 > 0  # integer overflow
false

julia> big(10)^19 == 1e19
true
```
