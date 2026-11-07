`Broadcast.Style{C}()`は、型パラメーター`C`を通じてシグナリングを行う[`BroadcastStyle`](@ref)を定義します。たとえば、`BroadcastStyle`のカスタムサブタイプを作成する代わりに、これを使用できます。

```julia
Base.BroadcastStyle(::Type{<:MyContainer}) = Broadcast.Style{MyContainer}()
```
