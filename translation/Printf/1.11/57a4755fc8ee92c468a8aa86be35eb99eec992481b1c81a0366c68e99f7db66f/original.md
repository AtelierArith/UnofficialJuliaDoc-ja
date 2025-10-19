```julia
@printf([io::IO], "%Fmt", args...)
```

Print `args` using C `printf` style format specification string. Optionally, an `IO` may be passed as the first argument to redirect output.

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

For a systematic specification of the format, see [here](https://en.cppreference.com/w/c/io/fprintf). See also [`@sprintf`](@ref) to get the result as a `String` instead of it being printed.

# Caveats

`Inf` and `NaN` are printed consistently as `Inf` and `NaN` for flags `%a`, `%A`, `%e`, `%E`, `%f`, `%F`, `%g`, and `%G`. Furthermore, if a floating point number is equally close to the numeric values of two possible output strings, the output string further away from zero is chosen.

# Examples

```jldoctest
julia> @printf("%f %F %f %F", Inf, Inf, NaN, NaN)
Inf Inf NaN NaN

julia> @printf "%.0f %.1f %f" 0.5 0.025 -0.0078125
0 0.0 -0.007812
```

!!! compat "Julia 1.8"
    Starting in Julia 1.8, `%s` (string) and `%c` (character) widths are computed using [`textwidth`](@ref), which e.g. ignores zero-width characters (such as combining characters for diacritical marks) and treats certain "wide" characters (e.g. emoji) as width `2`.


!!! compat "Julia 1.10"
    Dynamic width specifiers like `%*s` and `%0*.*f` require Julia 1.10.

