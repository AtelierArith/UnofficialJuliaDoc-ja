```julia
a ? b : c
```

条件式の短縮形。「`a`なら`b`を評価し、そうでなければ`c`を評価する」と読む。[ternary operator](https://en.wikipedia.org/wiki/%3F:)とも呼ばれる。

この構文は`if a; b else c end`と同等だが、`b`や`c`の評価によって生じる副作用よりも、大きな式の一部として使われる`b`または`c`の値を強調したい場合によく使われる。

詳しくは、マニュアルの[control flow](@ref man-conditional-evaluation)の節を参照。

# Examples

```jldoctest
julia> x = 1; y = 2;

julia> x > y ? println("x is larger") : println("x is not larger")
x is not larger

julia> x > y ? "x is larger" : x == y ? "x and y are equal" : "y is larger"
"y is larger"
```
