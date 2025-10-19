Unsafe pointer operations are compatible with loading and storing pointers declared with `_Atomic` and `std::atomic` type in C11 and C++23 respectively. An error may be thrown if there is not support for atomically loading the Julia type `T`.

See also: [`unsafe_load`](@ref), [`unsafe_modify!`](@ref), [`unsafe_replace!`](@ref), [`unsafe_store!`](@ref), [`unsafe_swap!`](@ref)
