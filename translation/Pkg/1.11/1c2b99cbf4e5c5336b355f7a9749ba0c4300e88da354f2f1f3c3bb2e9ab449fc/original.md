```
Pkg.project()::ProjectInfo
```

This feature is considered experimental.

Request a `ProjectInfo` struct which contains information about the active project.

# `ProjectInfo` fields

| Field        | Description                                                                                 |
|:------------ |:------------------------------------------------------------------------------------------- |
| name         | The project's name                                                                          |
| uuid         | The project's UUID                                                                          |
| version      | The project's version                                                                       |
| ispackage    | Whether the project is a package (has a name and uuid)                                      |
| dependencies | The project's direct dependencies as a `Dict` which maps dependency name to dependency UUID |
| path         | The location of the project file which defines the active project                           |
