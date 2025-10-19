```julia
@ccall library.function_name(argvalue1::argtype1, ...)::returntype
@ccall function_name(argvalue1::argtype1, ...)::returntype
@ccall $function_pointer(argvalue1::argtype1, ...)::returntype
```

Call a function in a C-exported shared library, specified by `library.function_name`, where `library` is a string constant or literal. The library may be omitted, in which case the `function_name` is resolved in the current process. Alternatively, `@ccall` may also be used to call a function pointer `$function_pointer`, such as one returned by `dlsym`.

Each `argvalue` to `@ccall` is converted to the corresponding `argtype`, by automatic insertion of calls to `unsafe_convert(argtype, cconvert(argtype, argvalue))`. (See also the documentation for [`unsafe_convert`](@ref Base.unsafe_convert) and [`cconvert`](@ref Base.cconvert) for further details.) In most cases, this simply results in a call to `convert(argtype, argvalue)`.

# Examples

```julia
@ccall strlen(s::Cstring)::Csize_t
```

This calls the C standard library function:

```julia
size_t strlen(char *)
```

with a Julia variable named `s`. See also `ccall`.

Varargs are supported with the following convention:

```julia
@ccall printf("%s = %d"::Cstring ; "foo"::Cstring, foo::Cint)::Cint
```

The semicolon is used to separate required arguments (of which there must be at least one) from variadic arguments.

Example using an external library:

```julia
# C signature of g_uri_escape_string:
# char *g_uri_escape_string(const char *unescaped, const char *reserved_chars_allowed, gboolean allow_utf8);

const glib = "libglib-2.0"
@ccall glib.g_uri_escape_string(my_uri::Cstring, ":/"::Cstring, true::Cint)::Cstring
```

The string literal could also be used directly before the function name, if desired `"libglib-2.0".g_uri_escape_string(...`

It's possible to declare the ccall as `gc_safe` by using the `gc_safe = true` option:     @ccall gc*safe=true strlen(s::Cstring)::Csize*t This allows the garbage collector to run concurrently with the ccall, which can be useful whenever the `ccall` may block outside of julia. WARNING: This option should be used with caution, as it can lead to undefined behavior if the ccall calls back into the julia runtime. (`@cfunction`/`@ccallables` are safe however)
