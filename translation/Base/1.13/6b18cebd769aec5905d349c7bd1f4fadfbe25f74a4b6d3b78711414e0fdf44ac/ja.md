```julia
sprint(f::Function, args...; context=nothing, sizehint=0)
```

指定した関数を、I/Oストリームと追加の引数を渡して呼び出します。このI/Oストリームに書き込まれた内容は、文字列として返されます。

省略可能なキーワード引数 `context` には、`:key=>value` のペア、`:key=>value` のペアのタプル、または `IO` あるいは [`IOContext`](@ref) オブジェクトを指定できます。これらの属性は、`f` に渡されるI/Oストリームに使用されます。省略可能な `sizehint` は、文字列の書き込みに使うバッファに割り当てるサイズ（バイト単位）の目安です。

!!! compat "Julia 1.7"
    キーワード `context` にタプルを渡すには、Julia 1.7以降が必要です。


# Examples

```jldoctest
julia> sprint(show, 66.66666; context=:compact => true)
"66.6667"

julia> sprint(showerror, BoundsError([1], 100))
"BoundsError: attempt to access 1-element Vector{Int64} at index [100]"
```
