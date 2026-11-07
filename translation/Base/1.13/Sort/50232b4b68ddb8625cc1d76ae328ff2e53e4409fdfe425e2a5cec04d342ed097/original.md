```julia
IEEEFloatOptimization(next) isa Base.Sort.Algorithm
```

Move NaN values to the end, partition by sign, and reinterpret the rest as unsigned integers.

IEEE floating point numbers (`Float64`, `Float32`, and `Float16`) compare the same as unsigned integers with the bits with a few exceptions. This pass

This pass is triggered for both `sort([1.0, NaN, 3.0])` and `sortperm([1.0, NaN, 3.0])`.
