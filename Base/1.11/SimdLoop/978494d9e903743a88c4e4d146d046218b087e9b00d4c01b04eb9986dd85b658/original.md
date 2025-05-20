```
@simd
```

Annotate a `for` loop to allow the compiler to take extra liberties to allow loop re-ordering

!!! warning
    This feature is experimental and could change or disappear in future versions of Julia. Incorrect use of the `@simd` macro may cause unexpected results.


The object iterated over in a `@simd for` loop should be a one-dimensional range. By using `@simd`, you are asserting several properties of the loop:

  * It is safe to execute iterations in arbitrary or overlapping order, with special consideration for reduction variables.
  * Floating-point operations on reduction variables can be reordered or contracted, possibly causing different results than without `@simd`.

In many cases, Julia is able to automatically vectorize inner for loops without the use of `@simd`. Using `@simd` gives the compiler a little extra leeway to make it possible in more situations. In either case, your inner loop should have the following properties to allow vectorization:

  * The loop must be an innermost loop
  * The loop body must be straight-line code. Therefore, [`@inbounds`](@ref) is   currently needed for all array accesses. The compiler can sometimes turn   short `&&`, `||`, and `?:` expressions into straight-line code if it is safe   to evaluate all operands unconditionally. Consider using the [`ifelse`](@ref)   function instead of `?:` in the loop if it is safe to do so.
  * Accesses must have a stride pattern and cannot be "gathers" (random-index   reads) or "scatters" (random-index writes).
  * The stride should be unit stride.

!!! note
    The `@simd` does not assert by default that the loop is completely free of loop-carried memory dependencies, which is an assumption that can easily be violated in generic code. If you are writing non-generic code, you can use `@simd ivdep for ... end` to also assert that:


  * There exists no loop-carried memory dependencies
  * No iteration ever waits on a previous iteration to make forward progress.
