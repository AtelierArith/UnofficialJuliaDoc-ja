```julia
sprint(f::Function, args...; context=nothing, sizehint=0)
```

指定された関数をI/Oストリームと供給された追加引数で呼び出します。このI/Oストリームに書き込まれたすべての内容は文字列として返されます。`context`は、プロパティが使用される[`IOContext`](@ref)であるか、プロパティとその値を指定する`Pair`、または複数のプロパティとその値を指定する`Pair`のタプルであることができます。`sizehint`はバッファの容量（バイト単位）を示唆します。

オプションのキーワード引数`context`は、`:key=>value`ペア、`:key=>value`ペアのタプル、または`f`に渡されるI/Oストリームに使用される属性を持つ`IO`または[`IOContext`](@ref)オブジェクトに設定できます。オプションの`sizehint`は、文字列を書き込むために使用されるバッファに割り当てることが推奨されるサイズ（バイト単位）です。

!!! compat "Julia 1.7"
    キーワード`context`にタプルを渡すには、Julia 1.7以降が必要です。


# 例

```jldoctest
julia> sprint(show, 66.66666; context=:compact => true)
"66.6667"

julia> sprint(showerror, BoundsError([1], 100))
"BoundsError: attempt to access 1-element Vector{Int64} at index [100]"
```
