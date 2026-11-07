```julia
struct DefaultStable <: Algorithm end
```

`DefaultStable` is an algorithm which indicates that a fast, general purpose sorting algorithm should be used, but does not specify exactly which algorithm.

Currently, when sorting short NTuples, this is an unrolled mergesort, and otherwise it is composed of two parts: the [`InitialOptimizations`](@ref) and a hybrid of Radix, Insertion, Counting, Quick sorts.

We begin with MissingOptimization because it has no runtime cost when it is not triggered and can enable other optimizations to be applied later. For example, BoolOptimization cannot apply to an `AbstractVector{Union{Missing, Bool}}`, but after [`MissingOptimization`](@ref) is applied, that input will be converted into am `AbstractVector{Bool}`.

We next apply [`BoolOptimization`](@ref) because it also has no runtime cost when it is not triggered and when it is triggered, it is an incredibly efficient algorithm (sorting `Bool`s is quite easy).

Next, we dispatch to [`InsertionSort`](@ref) for inputs with `length <= 10`. This dispatch occurs before the [`IEEEFloatOptimization`](@ref) pass because the [`IEEEFloatOptimization`](@ref)s are not beneficial for very small inputs.

To conclude the [`InitialOptimizations`](@ref), we apply [`IEEEFloatOptimization`](@ref).

After these optimizations, we branch on whether radix sort and related algorithms can be applied to the input vector and ordering. We conduct this branch by testing if `UIntMappable(v, order) !== nothing`. That is, we see if we know of a reversible mapping from `eltype(v)` to `UInt` that preserves the ordering `order`. We perform this check after the initial optimizations because they can change the input vector's type and ordering to make them `UIntMappable`.

If the input is not [`UIntMappable`](@ref), then we perform a presorted check and dispatch to [`ScratchQuickSort`](@ref).

Otherwise, we dispatch to [`InsertionSort`](@ref) for inputs with `length <= 40` and then perform a presorted check ([`CheckSorted`](@ref)).

We check for short inputs before performing the presorted check to avoid the overhead of the check for small inputs. Because the alternate dispatch is to [`InsertionSort`](@ref) which has efficient `O(n)` runtime on presorted inputs, the check is not necessary for small inputs.

We check if the input is reverse-sorted for long vectors (more than 500 elements) because the check is essentially free unless the input is almost entirely reverse sorted.

Note that once the input is determined to be [`UIntMappable`](@ref), we know the order forms a [total order](wikipedia.org/wiki/Total_order) over the inputs and so it is impossible to perform an unstable sort because no two elements can compare equal unless they *are* equal, in which case switching them is undetectable. We utilize this fact to perform a more aggressive reverse sorted check that will reverse the vector `[3, 2, 2, 1]`.

After these potential fast-paths are tried and failed, we [`ComputeExtrema`](@ref) of the input. This computation has a fairly fast `O(n)` runtime, but we still try to delay it until it is necessary.

Next, we [`ConsiderCountingSort`](@ref). If the range the input is small compared to its length, we apply [`CountingSort`](@ref).

Next, we [`ConsiderRadixSort`](@ref). This is similar to the dispatch to counting sort, but we consider the number of *bits* in the range, rather than the range itself. Consequently, we apply [`RadixSort`](@ref) for any reasonably long inputs that reach this stage.

Finally, if the input has length less than 80, we dispatch to [`InsertionSort`](@ref) and otherwise we dispatch to [`ScratchQuickSort`](@ref).
