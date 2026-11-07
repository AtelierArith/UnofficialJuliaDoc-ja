```julia
sort(v; alg::Base.Sort.Algorithm=Base.Sort.defalg(v), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
sort(v::NTuple; kws...)::NTuple
```

[`sort!`](@ref)の変種で、`v`のソート済みコピーを返し、`v`自体は変更しません。

辞書の[`keys`](@ref)または[`values`](@ref)に対して`sort`を呼び出すと、`v`が収集されてからソートされます。

!!! compat "Julia 1.12"
    `NTuple`のソートには、Julia 1.12以降が必要です。


!!! compat "Julia 1.13"
    キーセットと値イテレータのソートには、Julia 1.13以降が必要です。


# Examples

```jldoctest
julia> v = [3, 1, 2];

julia> sort(v)
3-element Vector{Int64}:
 1
 2
 3

julia> v
3-element Vector{Int64}:
 3
 1
 2

julia> sort(values(Dict('a'=>2, 'b'=>1)))
2-element Vector{Int64}:
 1
 2
```
