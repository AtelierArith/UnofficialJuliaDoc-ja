```
ord(lt, by, rev::Union{Bool, Nothing}, order::Ordering=Forward)
```

同じ引数を使用して[`sort!`](@ref)オブジェクトから[`Ordering`](@ref)オブジェクトを構築します。要素は最初に関数`by`（これは[`identity`](@ref)である可能性があります）によって変換され、その後、関数`lt`または既存の順序`order`に従って比較されます。`lt`は[`isless`](@ref)であるか、[`sort!`](@ref)の`lt`パラメータと同じルールに従う関数である必要があります。最後に、`rev=true`の場合、結果の順序は逆になります。

`isless`以外の`lt`を[`Base.Order.Forward`](@ref)または[`Base.Order.Reverse`](@ref)以外の`order`と一緒に渡すことは許可されていません。それ以外は、すべてのオプションは独立しており、すべての可能な組み合わせで一緒に使用できます。
