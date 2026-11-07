```julia
@printf([io::IO], "%Fmt", args...)
```

C `printf`形式の書式指定文字列を使って、`args`を出力します。出力先を変更する場合は、`IO`を最初の引数として渡すこともできます。

# Examples

```jldoctest
julia> @printf "Hello %s" "world"
Hello world

julia> @printf "Scientific notation %e" 1.234
Scientific notation 1.234000e+00

julia> @printf "Scientific notation three digits %.3e" 1.23456
Scientific notation three digits 1.235e+00

julia> @printf "Decimal two digits %.2f" 1.23456
Decimal two digits 1.23

julia> @printf "Padded to length 5 %5i" 123
Padded to length 5   123

julia> @printf "Padded with zeros to length 6 %06i" 123
Padded with zeros to length 6 000123

julia> @printf "Use shorter of decimal or scientific %g %g" 1.23 12300000.0
Use shorter of decimal or scientific 1.23 1.23e+07

julia> @printf "Use dynamic width and precision  %*.*f" 10 2 0.12345
Use dynamic width and precision        0.12
```

書式の体系的な仕様については、[here](https://en.cppreference.com/w/c/io/fprintf)を参照してください。また、出力する代わりに結果を`String`として取得するには、[`@sprintf`](@ref)を参照してください。

# Caveats

フラグ`%a`、`%A`、`%e`、`%E`、`%f`、`%F`、`%g`、`%G`では、`Inf`と`NaN`は、それぞれ一貫して`Inf`と`NaN`として出力されます。さらに、浮動小数点数が2つの出力文字列の数値に等距離である場合は、ゼロから遠い方の出力文字列が選ばれます。

# Examples

```jldoctest
julia> @printf("%f %F %f %F", Inf, Inf, NaN, NaN)
Inf Inf NaN NaN

julia> @printf "%.0f %.1f %f" 0.5 0.025 -0.0078125
0 0.0 -0.007812
```

!!! compat "Julia 1.8"
    Julia 1.8以降では、`%s`（文字列）と`%c`（文字）の幅は、[`textwidth`](@ref)を使って計算されます。たとえば、結合文字などのゼロ幅文字は無視され、特定の「幅広」文字（絵文字など）は幅`2`として扱われます。


!!! compat "Julia 1.10"
    `%*s`や`%0*.*f`のような動的幅指定子には、Julia 1.10が必要です。

