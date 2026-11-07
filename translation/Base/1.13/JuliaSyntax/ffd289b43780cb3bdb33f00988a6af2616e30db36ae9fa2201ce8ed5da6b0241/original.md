```julia
register_kinds!(mod, module_id, names)
```

Register custom `Kind`s with the given `names`, belonging to a module `mod`. `names` is an array of arbitrary strings.

In order for kinds to be represented by a small number of bits, some nontrivial cooperation is required between modules using custom kinds:

  * The integer `module_id` is globally unique for each `mod` which will be used together, and not larger than 63.
  * No two modules register the same `name`. The semantics of a given `kind` name should be defined by the module which owns it.

To allow ranges of kinds to be delimited and quickly tested for, some special names are allowed: `BEGIN_section` and `END_section` pairs are detected, and alias the next and previous kind id's respectively so that kinds in `section` can be tested with `BEGIN_section <= k <= END_section`.
