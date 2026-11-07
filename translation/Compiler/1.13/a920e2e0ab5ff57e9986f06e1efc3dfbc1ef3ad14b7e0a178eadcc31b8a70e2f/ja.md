```julia
widenreturn(𝕃ᵢ::AbstractLattice, @nospecialize(rt), info::BestguessInfo) -> new_bestguess
widenreturn_noslotwrapper(𝕃ᵢ::AbstractLattice, @nospecialize(rt), info::BestguessInfo) -> new_bestguess
```

戻り値の推論型 `rt` を、キャッシュに保存でき、かつプロシージャ間解析で有効かつ適切な型に変換します。たとえば、`rt isa Conditional` の場合、`rt` は `InterConditional` または別のキャッシュ可能な格子要素に変換されます。

外部格子 `𝕃ᵢ::ExternalLattice` では、次のメソッドをオーバーロードできます。

  * `widenreturn(𝕃ᵢ::ExternalLattice, @nospecialize(rt), info::BestguessInfo)`
  * `widenreturn_noslotwrapper(𝕃ᵢ::ExternalLattice, @nospecialize(rt), info::BestguessInfo)`
