```julia
detect_cxxstring_abi()
```

Inspects the currently running Julia process to see what version of the C++11 string ABI it was compiled with (this is only relevant if compiled with `g++`; `clang` has no incompatibilities yet, bless its heart).  In reality, this actually checks for symbols within LLVM, but that is close enough for our purposes, as you can't mix configurations between Julia and LLVM; they must match.
