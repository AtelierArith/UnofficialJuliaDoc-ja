```
occursin(haystack)
```

引数が `haystack` に存在するかどうかをチェックする関数を作成します。すなわち、`needle -> occursin(needle, haystack)` と同等の関数です。

返される関数の型は `Base.Fix2{typeof(occursin)}` です。

!!! compat "Julia 1.6"
    このメソッドは Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> search_f = occursin("JuliaLang is a programming language");

julia> search_f("JuliaLang")
true

julia> search_f("Python")
false
```
