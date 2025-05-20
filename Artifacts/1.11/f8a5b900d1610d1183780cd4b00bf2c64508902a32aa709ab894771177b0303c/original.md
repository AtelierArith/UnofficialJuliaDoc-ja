```
with_artifacts_directory(f::Function, artifacts_dir::String)
```

Helper function to allow temporarily changing the artifact installation and search directory.  When this is set, no other directory will be searched for artifacts, and new artifacts will be installed within this directory.  Similarly, removing an artifact will only effect the given artifact directory.  To layer artifact installation locations, use the typical Julia depot path mechanism.
