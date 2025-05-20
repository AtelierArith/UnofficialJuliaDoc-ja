```
Base.isambiguous(m1, m2; ambiguous_bottom=false) -> Bool
```

2つのメソッド `m1` と `m2` が、ある呼び出しシグネチャに対して曖昧であるかどうかを判断します。このテストは、同じ関数の他のメソッドの文脈で実行されます。孤立している場合、`m1` と `m2` は曖昧である可能性がありますが、曖昧さを解決する第三のメソッドが定義されている場合、これは `false` を返します。逆に、孤立している場合、`m1` と `m2` は順序付けられている可能性がありますが、第三のメソッドがそれらと一緒にソートできない場合、共に曖昧さを引き起こす可能性があります。

パラメトリック型の場合、`ambiguous_bottom` キーワード引数は、`Union{}` が型パラメータの曖昧な交差としてカウントされるかどうかを制御します。`true` の場合、曖昧と見なされ、`false` の場合はそうではありません。

# 例

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
