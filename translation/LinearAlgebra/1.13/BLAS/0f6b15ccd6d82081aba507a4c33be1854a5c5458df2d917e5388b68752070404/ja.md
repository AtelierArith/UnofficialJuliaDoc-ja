```julia
iamax(n, dx, incx)
iamax(dx)
```

`dx` の要素のうち、絶対値が最大の要素のインデックスを求めます。`n` は `dx` の長さ、`incx` はストライドです。`n` と `incx` が指定されていない場合、それぞれのデフォルト値は `n=length(dx)` と `incx=stride1(dx)` です。
