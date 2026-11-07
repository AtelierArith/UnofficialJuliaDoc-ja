The module `Core.Compiler.Timings` provides a simple implementation of nested timers that can be used to measure the exclusive time spent inferring each method instance that is recursively inferred during type inference.

This is meant to be internal to the compiler, and makes some specific assumptions about being used for this purpose alone.
