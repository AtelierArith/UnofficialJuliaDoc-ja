```julia
log(b,x)
```

`x`の底`b`の対数を計算します。負の[`Real`](@ref)引数に対しては[`DomainError`](@ref)をスローします。

# 例

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> log(4,8)
1.5

julia> log(4,2)
0.5

julia> log(-2, 3)
ERROR: DomainError with -2.0:
logは負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。log(Complex(x))を試してください。
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]

julia> log(2, -3)
ERROR: DomainError with -3.0:
logは負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。log(Complex(x))を試してください。
Stacktrace:
 [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
[...]
```

!!! note
    `b`が2または10の累乗である場合、[`log2`](@ref)または[`log10`](@ref)を使用するべきです。これらは通常、より速く、より正確です。例えば、

    ```jldoctest
    julia> log(100,1000000)
    2.9999999999999996

    julia> log10(1000000)/2
    3.0
    ```

