```julia
 isidentifier(s) -> Bool
```

シンボルまたは文字列 `s` に、Julia コードで有効な通常の識別子（2項演算子または単項演算子ではないもの）として解析される文字が含まれているかどうかを返します。詳しくは [`Base.isoperator`](@ref) も参照してください。

Julia の内部では、`\0` を除き、`Symbol` に任意の文字列を使用できます。また、マクロは周囲のコードとの名前の衝突を避けるため、`#` を含む変数名を自動的に使用します。パーサーが変数を認識するには、限られた文字セット（Unicode によって大幅に拡張されています）が使われます。`isidentifier()` を使うと、シンボルに有効な文字が含まれているかどうかをパーサーに直接問い合わせられます。

# Examples

```jldoctest
julia> Meta.isidentifier(:x), Meta.isidentifier("1x")
(true, false)
```
