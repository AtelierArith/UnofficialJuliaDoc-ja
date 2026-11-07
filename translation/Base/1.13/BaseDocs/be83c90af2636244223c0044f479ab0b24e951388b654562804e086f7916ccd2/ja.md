unsafeポインター操作は、C11では型が`_Atomic`、C++23では型が`std::atomic`と宣言されたポインターの読み込みおよび書き込みに対応しています。Juliaの型`T`をアトミックに読み込む機能がサポートされていない場合、エラーがスローされることがあります。

関連項目: [`unsafe_load`](@ref)、[`unsafe_modify!`](@ref)、[`unsafe_replace!`](@ref)、[`unsafe_store!`](@ref)、[`unsafe_swap!`](@ref)
