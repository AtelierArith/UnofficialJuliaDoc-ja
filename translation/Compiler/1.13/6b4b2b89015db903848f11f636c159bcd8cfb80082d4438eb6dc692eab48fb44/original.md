```julia
codeinfo_for_const(interp::AbstractInterpreter, mi::MethodInstance, worlds::WorldRange, edges::SimpleVector, @nospecialize(val))
```

Return a fake CodeInfo that just contains `return $val`. This function is used in various reflection APIs when asking for the code of a function that inference has found to just return a constant. For such functions, no code is actually stored - the constant is used directly. However, because this is an ABI implementation detail, it is nice to maintain consistency and just synthesize a CodeInfo when the reflection APIs ask for them - this function does that.
