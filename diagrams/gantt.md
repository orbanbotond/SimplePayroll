```puml
@startuml
[Domain] lasts 3 days and is colored in Lavender/LightBlue
[Class Loader] lasts 1 days and is colored in LightBlue/Green and starts 6 days after [Domain]'s end
[Refactoring by Concepts] lasts 1 days and is colored in Lavender/LightBlue and starts 1 days after [Class Loader]'s end
[ROM] lasts 7 days and is colored in Coral/Green and starts 1 days after [Refactoring by Concepts]'s end
[Migrations] lasts 1 days and is colored in Coral/Green and starts 6 days after [Refactoring by Concepts]'s end
[Complex Use Cases] lasts 3 days and is colored in Lavender/LightBlue and starts 6 days after [ROM]'s end
[Domain Driven Framework] lasts 6 days and is colored in LightGreen/Green and starts 6 days after [Complex Use Cases]'s end
@enduml
```
