```julia
Iterators.reverse(itr)
```

イテレータ `itr` が与えられた場合、`reverse(itr)` は同じコレクションの逆順のイテレータです。このイテレータは「遅延」型であり、逆順にするためにコレクションのコピーを作成しません。詳細は [`Base.reverse`](@ref) を参照してください。

（デフォルトでは、これは `itr` をラップする `Iterators.Reverse` オブジェクトを返します。対応する [`iterate`](@ref) メソッドが定義されている場合、これはイテレート可能ですが、いくつかの `itr` タイプはより特化した `Iterators.reverse` の動作を実装している場合があります。）

すべてのイテレータタイプ `T` が逆順のイテレーションをサポートしているわけではありません。もし `T` がサポートしていない場合、`Iterators.reverse(itr::T)` をイテレートすると、`Iterators.Reverse{T}` の `iterate` メソッドが欠けているため、[`MethodError`](@ref) がスローされます。（これらのメソッドを実装するには、元のイテレータ `itr::T` を `r::Iterators.Reverse{T}` オブジェクトから `r.itr` によって取得できます。より一般的には、`Iterators.reverse(r)` を使用できます。）

# 例

```jldoctest
julia> foreach(println, Iterators.reverse(1:5))
5
4
3
2
1
```
