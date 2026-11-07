```julia
annotatedstring(values...)
```

任意の数の`values`から、それらの[`print`](@ref)表現を使って`AnnotatedString`を作成します。

これは[`string`](@ref)と同様に動作しますが、存在する注釈（[`AnnotatedString`](@ref)または[`AnnotatedChar`](@ref)の値）を保持します。

[`AnnotatedString`](@ref)および[`AnnotatedChar`](@ref)も参照してください。

## Examples

```jldoctest; setup=:(using Base: AnnotatedString, annotatedstring)
julia> annotatedstring("now an AnnotatedString")
"now an AnnotatedString"

julia> annotatedstring(AnnotatedString("annotated", [(1:9, :label, 1)]), ", and unannotated")
"annotated, and unannotated"
```
