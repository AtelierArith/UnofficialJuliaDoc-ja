```julia
@irrational sym [val] def
```

式 `def` で与えられる `BigFloat` を用いて、任意精度の定義を持つ新しい値 `Irrational`、`sym` を定義します。

事前計算した値 `Float64` `val` を指定することもできます。この値は `Float64(def)` と等しくなければなりません。省略した場合、`val` は自動的に計算されます。

`big(def) isa BigFloat` または `Float64(val) == Float64(def)` が `false` を返すと、`AssertionError` がスローされます。

!!! warning
    このマクロは、`Base` Julia の外部では使用しないでください。

    このマクロは、呼び出された場所にかかわらず、新しい型 `Irrational{:sym}` を作成します。そのため、異なる値を持つ同名の無理数を2つのパッケージが定義すると、定義が競合する可能性があります。


# Examples

```jldoctest
julia> Base.@irrational twoπ 2*big(π)

julia> twoπ
twoπ = 6.2831853071795...

julia> Base.@irrational sqrt2 1.4142135623730950488 √big(2)

julia> sqrt2
sqrt2 = 1.4142135623730...

julia> Base.@irrational sqrt2 1.4142135623730950488 big(2)
ERROR: AssertionError: big($(Expr(:escape, :sqrt2))) isa BigFloat

julia> Base.@irrational sqrt2 1.41421356237309 √big(2)
ERROR: AssertionError: Float64($(Expr(:escape, :sqrt2))) == Float64(big($(Expr(:escape, :sqrt2))))
```
