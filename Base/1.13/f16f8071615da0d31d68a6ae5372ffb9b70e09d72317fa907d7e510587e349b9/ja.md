```julia
@irrational sym [val] def
```

`Irrational` の新しい値 `sym` を定義します。`BigFloat` を用いた式 `def` によって、任意精度で定義します。

事前計算した `Float64` の値 `val` を指定することもできます。この値は `Float64(def)` と等しくなければなりません。省略した場合は、`val` が自動的に計算されます。

`big(def) isa BigFloat` または `Float64(val) == Float64(def)` が `false` を返すと、`AssertionError` がスローされます。

!!! warning
    このマクロは `Base` Julia の外部では使用しないでください。

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
