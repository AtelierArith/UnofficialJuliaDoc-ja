Validate package versions one at a time, by checking what would happen by forcing that version and propagating the constraints. Versions which lead to unsatisfiable constraints are then diabled. If all versions of a package (including "uninstalled") are invalid, then the requirements are unsatisfiable.

The algorithm starts from an initial pool of packages to check. Then, for each package, if any invalid version is detected all the neighboring packages in the graph are also added to the pool. If sources are provided, use those packages as initial pool, otherwise the initial pool is the whole graph.

If "skim=true", stop checking each package as soon as a valid version (besides possibly "uninstalled") is found. This is a heuristic that trades thoroughness for speed.
