```julia
Base.Math.scaleinv(x)
```

`(scale, invscale)` を計算します。`scale` と `invscale` は非サブノーマルであり（https://en.wikipedia.org/wiki/Subnormal_number) は有限の 2 のべき乗）、`scale * invscale == 1` と `scale` はおおよそ `abs(x)` 程度になります。Inf、NaN、ゼロを入力した場合も、有限かつ非ゼロの値が返されます。これらの値を使うと、丸め誤差や除算を伴わずに計算をスケーリングし、オーバーフローやアンダーフローを防げます。

不安定な詳細: `x isa IEEEFLoat` の場合、可能であれば `scale` は `prevpow(2,abs(x))` に選ばれます。ただし、floatmin(x) 未満にも inv(floatmin(x)) を超える値にもなりません。`Inf` と `NaN` は `inv(floatmin(x))` に解決されます。この動作は変更される可能性があります。

# Examples

```jldoctest
julia> Base.Math.scaleinv(7.5)
(4.0, 0.25)
```
