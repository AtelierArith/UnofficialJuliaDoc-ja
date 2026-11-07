```julia
gen_call_with_extracted_types(__module__, fcn, ex, kws = Expr[]; is_source_reflection = !is_code_macro(fcn), supports_binding_reflection = false, use_signature_tuple = false)
```

Destructures the input expression `ex` into a function call or a binding access, then generates a call to either:

  * `fcn(f, tt; kws...)`
  * `fcn(sigt; kws...)` # if `use_signature_tuple = true`
  * `fcn(mod, name; kws...)` # if `supports_binding_reflection = true`

## `fcn` API requirements

`fcn` is a user function expected to satisfy the following API:

  * `fcn(f, tt)`: `f` is a value (such as `sum`, unlike `typeof(sum)`), and `tt := Tuple{argtypes...}` is a `Tuple` holding argument types. `f` may be a `Core.OpaqueClosure`.

If `use_signature_tuple = true`:

  * `fcn(sigt)`: `sigt := Tuple{typeof(f), argtypes...}` represents the low-level signature tuple to be used for introspection.

If `supports_binding_reflection = true`:

  * `fcn(mod::Module, name::Symbol)`: `name` is the name of a binding that may or may not exist in `mod`.

!!! warning
    This function is not public and may be subject to breaking changes. However, we recognize that it may be very convenient for macro developers, and as it is already used by a certain number of packages, we will do our best to avoid breakages.


## Examples

Here are a few usage patterns that may help you get started.

For most "code" macros (`@code_typed`, `@code_llvm`, `@code_native` etc):

```julia
    gen_call_with_extracted_types(__module__, fcn, ex, kws; is_source_reflection = false, use_signature_tuple = true #= may be false =#)
```

For source reflection macros (`@which`, `@edit`, `@less` etc):

```julia
    gen_call_with_extracted_types(__module__, fcn, ex, kws; is_source_reflection = true, use_signature_tuple = true #= may be false =#)
```

# Extended help

## Type annotations

Type annotations may be used instead of concrete values for the callable or for any of the arguments. The generated code will directly use the right-hand side of the type annotation instead of extracting the type of a value at runtime.

!!! compat "Julia 1.13"
    Support for type annotations requires at least Julia 1.13.


This is particularly useful for callable objects (notably, for those that are hard to construct by hand on the spot), or when wanting to provide a type that is not concrete. However, support for callable objects requires setting `use_signature_tuple` to true, which is not a default (see the corresponding section below).

Constraints on type parameters are also supported with a `where` syntax, enabling these patterns:

  * `f(x::Vector{T}, y::T) where {T}`
  * `(::Returns{T})() where {T<:Real}`
  * `(::MyPolynomial{N,T})(::T, ::AbstractArray{T,N}) where {N,T}`

Type-annotated expressions may be mixed with runtime values, as in `x + ::Float64`.

## Broadcasting

When `ex` is a broadcasting expression (a broadcasted assignment `a .+= b` or a broadcasted function call `a .+ b`), there is no actual function that corresponds to this expression because lowering maps it to more than one call.

If `is_source_reflection` is true, we assume that `fcn` uses provenance information (e.g. used by `@edit` to go to a source location, or `@which` to get the method matching the input). In this case, we don't have a clear semantic source to give (shall it be `broadcasted`, or `materialize`, or something else?), so we return a throwing expression.

However, if provenance is not of interest, we define an intermediate function on the spot that performs the broadcast, then carry on using this function. For example, for the input expression `a .+ b`, we emit the anonymous function `(a, b) -> a .+ b` then call `fcn` just as if the user had issued a call to this anonymous function. That should be the desired behavior for most macros that want to map an expression to the corresponding generated code, as in `@code_typed` or `@code_llvm` for instance.

## Binding reflection

Expressions of the form `a.b` (or `a.b.c` and so on) are by default interpreted as calls to `getproperty`. However, if the value corresponding to the left-hand side (`a`, `a.b`, etc) is a module, some implementations may instead be interested in the binding lookup, instead of the function call. If that is the case, `supports_binding_reflection` may be set to `true` which will emit a call to `fcn(a, :b)` (or `fcn(a.b, :c)` etc).

## Tuple signature type

If `use_signature_tuple = true`, then a single tuple consisting of `Tuple{ft, argtypes...}` will be formed and provided to `fcn`. `fcn` is then expected to use `ft` as the callable type with no further transformation.

This behavior is required to enable support type-annotated callable objects.

To understand this requirement, we'll use `code_typed` as an example. `code_typed(f, ())` interprets its input as the signature `Tuple{typeof(f)}`, and `code_typed(Returns{Int}, ())` interprets that as the signature `Tuple{Type{Returns{Int}}}`, corresponding to the type constructor. To remove the ambiguity, `code_typed` must support an implementation that directly accepts a function type. This implementation is assumed to be the method for `fcn(sigt::Type{<:Tuple})`.
