```julia
widenreturn(𝕃ᵢ::AbstractLattice, @nospecialize(rt), info::BestguessInfo) -> new_bestguess
widenreturn_noslotwrapper(𝕃ᵢ::AbstractLattice, @nospecialize(rt), info::BestguessInfo) -> new_bestguess
```

戻り値の推論型 `rt` を、キャッシュに保存でき、かつプロシージャ間解析で有効かつ適切な型に変換します。たとえば、`rt isa Conditional` の場合、`rt` は `InterConditional` またはキャッシュ可能な別の格子要素に変換する必要があります。

外部格子 `𝕃ᵢ::ExternalLattice` では、次をオーバーロードできます。

  * `widenreturn(𝕃ᵢ::ExternalLattice, @nospecialize(rt), info::BestguessInfo)`
  * `widenreturn_noslotwrapper(𝕃ᵢ::ExternalLattice, @nospecialize(rt), info::BestguessInfo)`
