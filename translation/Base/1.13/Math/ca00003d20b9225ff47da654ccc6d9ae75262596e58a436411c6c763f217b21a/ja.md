```julia
fastabs(x::Number)
```

大まかな大きさの比較に使える、`abs`に似た高速な関数。ほとんどの`x`では`fastabs`は`abs(x)`と同等ですが、複素数の`x`に対しては、`hypot`を必要とせずに`abs(real(x))+abs(imag(x))`を計算します。
