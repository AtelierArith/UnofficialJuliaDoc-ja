```julia
iamax(n, dx, incx)
iamax(dx)
```

`dx`の最大絶対値を持つ要素のインデックスを見つけます。`n`は`dx`の長さで、`incx`はストライドです。`n`と`incx`が指定されていない場合、デフォルト値`n=length(dx)`および`incx=stride1(dx)`が仮定されます。
