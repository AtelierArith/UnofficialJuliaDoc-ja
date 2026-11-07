```julia
occursin(haystack)
```

引数が`haystack`に含まれているかどうかを判定する関数を作成します。つまり、`needle -> occursin(needle, haystack)`と同等の関数です。

返される関数の型は`Base.Fix2{typeof(occursin)}`です。

!!! compat "Julia 1.6"
    このメソッドはJulia 1.6以降で使用できます。


# Examples

```jldoctest
julia> search_f = occursin("JuliaLang is a programming language");

julia> search_f("JuliaLang")
true

julia> search_f("Python")
false
```
