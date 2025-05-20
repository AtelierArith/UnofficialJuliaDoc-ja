```
^(x, y)
```

累乗演算子。

`x` と `y` が整数の場合、結果がオーバーフローする可能性があります。科学的表記法で数値を入力するには、`1.2 * 10^3` の代わりに `1.2e3` のような [`Float64`](@ref) リテラルを使用してください。

`y` が `Int` リテラル（例えば `x^2` の `2` や `x^-3` の `-3`）である場合、Julia コード `x^y` はコンパイラによって `Base.literal_pow(^, x, Val(y))` に変換され、指数の値に対するコンパイル時の特殊化が可能になります。（デフォルトのフォールバックとして、`Base.literal_pow(^, x, Val(y)) = ^(x,y)` があり、通常 `^ == Base.^` ですが、呼び出し名前空間で `^` が定義されている場合は除きます。）`y` が負の整数リテラルである場合、デフォルトでは `Base.literal_pow` は操作を `inv(x)^-y` に変換します。ここで `-y` は正の値です。

他にも [`exp2`](@ref)、[`<<`](@ref) を参照してください。

# 例

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
