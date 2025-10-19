```julia
annotatedstring(values...)
```

任意の数の `values` から [`print`](@ref) された表現を使用して `AnnotatedString` を作成します。

これは [`string`](@ref) のように動作しますが、存在する注釈（[`AnnotatedString`](@ref) または [`AnnotatedChar`](@ref) 値の形で）を保持することに注意を払います。

[`AnnotatedString`](@ref) と [`AnnotatedChar`](@ref) も参照してください。

## 例

```jldoctest; setup=:(using Base: AnnotatedString, annotatedstring)
julia> annotatedstring("now a AnnotatedString")
"now a AnnotatedString"

julia> annotatedstring(AnnotatedString("annotated", [(1:9, :label, 1)]), ", and unannotated")
"annotated, and unannotated"
```
