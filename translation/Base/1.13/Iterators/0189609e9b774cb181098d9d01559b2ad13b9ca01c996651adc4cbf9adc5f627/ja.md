```julia
cycle(iter[, n::Int])
```

`iter`を無限に繰り返すイテレータです。`n`を指定すると、`iter`をその回数だけ繰り返します。`iter`が空の場合、`cycle(iter)`と`cycle(iter, n)`も空になります。

`Iterators.cycle(iter, n)`は[`Base.repeat`](@ref)`(vector, n)`の遅延評価版です。また、[`Iterators.repeated`](@ref)`(iter, n)`は、[`Base.fill`](@ref)`(item, n)`の遅延評価版です。

!!! compat "Julia 1.11"
    メソッド`cycle(iter, n)`はJulia 1.11で追加されました。


# Examples

```jldoctest
julia> for (i, v) in enumerate(Iterators.cycle("hello"))
           print(v)
           i > 10 && break
       end
hellohelloh

julia> foreach(print, Iterators.cycle(['j', 'u', 'l', 'i', 'a'], 3))
juliajuliajulia

julia> repeat([1,2,3], 4) == collect(Iterators.cycle([1,2,3], 4))
true

julia> fill([1,2,3], 4) == collect(Iterators.repeated([1,2,3], 4))
true
```
