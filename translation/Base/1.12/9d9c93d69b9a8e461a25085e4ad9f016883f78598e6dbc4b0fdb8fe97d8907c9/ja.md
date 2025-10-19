```julia
occursin(haystack)
```

`haystack`に引数が含まれているかどうかをチェックする関数を作成します。つまり、`needle -> occursin(needle, haystack)`に相当する関数です。

返される関数は`Base.Fix2{typeof(occursin)}`型です。

!!! compat "Julia 1.6"
    このメソッドはJulia 1.6以降が必要です。


# 例

```jldoctest
julia> search_f = occursin("JuliaLang is a programming language");

julia> search_f("JuliaLang")
true

julia> search_f("Python")
false
```
