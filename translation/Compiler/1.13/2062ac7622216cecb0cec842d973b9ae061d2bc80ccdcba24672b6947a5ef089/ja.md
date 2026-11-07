```julia
const VarTable = Vector{VarState}
```

ローカル変数を推論された型に対応付ける拡張ラティスは、`AbstractLattice`として表されます。各インデックスは、各ローカル変数を識別する`SlotNumber`の`id`に対応します。フロー依存解析を可能にするため、`InferenceState`は各SSA文で複数の`VarTable`を保持する点に注意してください。
