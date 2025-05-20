```
cycle(iter[, n::Int])
```

`iter`を永遠に循環するイテレータです。`n`が指定されている場合、`iter`をその回数だけ循環します。`iter`が空の場合、`cycle(iter)`および`cycle(iter, n)`も空になります。

`Iterators.cycle(iter, n)`は[`Base.repeat`](@ref)`(vector, n)`の遅延等価であり、[`Iterators.repeated`](@ref)`(iter, n)`は遅延[`Base.fill`](@ref)`(item, n)`です。

!!! compat "Julia 1.11"
    メソッド`cycle(iter, n)`はJulia 1.11で追加されました。


# 例

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
