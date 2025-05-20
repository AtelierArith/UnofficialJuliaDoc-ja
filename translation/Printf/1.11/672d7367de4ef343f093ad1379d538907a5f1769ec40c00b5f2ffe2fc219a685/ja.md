```
@printf([io::IO], "%Fmt", args...)
```

C `printf` スタイルのフォーマット指定文字列を使用して `args` を出力します。オプションで、出力をリダイレクトするために最初の引数として `IO` を渡すことができます。

# 例

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

フォーマットの体系的な仕様については、[こちら](https://en.cppreference.com/w/c/io/fprintf)を参照してください。また、印刷されるのではなく `String` として結果を取得するには [`@sprintf`](@ref) を参照してください。

# 注意事項

`Inf` と `NaN` は、フラグ `%a`、`%A`、`%e`、`%E`、`%f`、`%F`、`%g`、および `%G` に対して一貫して `Inf` と `NaN` として出力されます。さらに、浮動小数点数が2つの可能な出力文字列の数値値に等しく近い場合、ゼロからさらに遠い出力文字列が選択されます。

# 例

```jldoctest
julia> @printf("%f %F %f %F", Inf, Inf, NaN, NaN)
Inf Inf NaN NaN

julia> @printf "%.0f %.1f %f" 0.5 0.025 -0.0078125
0 0.0 -0.007812
```

!!! compat "Julia 1.8"
    Julia 1.8 以降、`%s` (文字列) および `%c` (文字) の幅は [`textwidth`](@ref) を使用して計算されます。これは、例えば、ゼロ幅文字（結合文字など）を無視し、特定の「広い」文字（絵文字など）を幅 `2` として扱います。


!!! compat "Julia 1.10"
    `%*s` や `%0*.*f` のような動的幅指定子は、Julia 1.10 が必要です。

