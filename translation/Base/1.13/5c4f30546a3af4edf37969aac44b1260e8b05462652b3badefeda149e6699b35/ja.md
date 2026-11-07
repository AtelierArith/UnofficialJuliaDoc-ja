```julia
Base.isambiguous(m1, m2; ambiguous_bottom=false)::Bool
```

2つのメソッド `m1` と `m2` が、ある呼び出しシグネチャに対して曖昧になり得るかどうかを判定します。このテストは、同じ関数に属する他のメソッドも考慮して行われます。単独では `m1` と `m2` が曖昧になる可能性があっても、その曖昧さを解消する3つ目のメソッドが定義されていれば、`false` を返します。逆に、単独では `m1` と `m2` の優先順位が決まっていても、それらと順序付けできない3つ目のメソッドがあると、これらが組み合わさって曖昧さを引き起こすことがあります。

パラメトリック型では、`ambiguous_bottom` キーワード引数によって、`Union{}` を型パラメーターの曖昧な共通部分として扱うかどうかを制御します。`true` の場合は曖昧と見なされ、`false` の場合は曖昧と見なされません。

# Examples

```jldoctest
julia> foo(x::Complex{<:Integer}) = 1
foo (generic function with 1 method)

julia> foo(x::Complex{<:Rational}) = 2
foo (generic function with 2 methods)

julia> m1, m2 = collect(methods(foo));

julia> typeintersect(m1.sig, m2.sig)
Tuple{typeof(foo), Complex{Union{}}}

julia> Base.isambiguous(m1, m2, ambiguous_bottom=true)
true

julia> Base.isambiguous(m1, m2, ambiguous_bottom=false)
false
```
