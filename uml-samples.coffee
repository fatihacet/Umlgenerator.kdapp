getSkinned = ->
  """
    skinparam backgroundColor #EEEBDC

    skinparam sequence {
      ArrowColor DeepSkyBlue
      ActorBorderColor DeepSkyBlue
      LifeLineBorderColor blue
      LifeLineBackgroundColor #A9DCDF
      
      ParticipantBorderColor DeepSkyBlue
      ParticipantBackgroundColor DodgerBlue
      ParticipantFontName Impact
      ParticipantFontSize 17
      ParticipantFontColor #A9DCDF
      
      ActorBackgroundColor aqua
      ActorFontColor DeepSkyBlue
      ActorFontSize 17
      ActorFontName Aapex
    }
    
    actor User
    participant "First Class" as A
    participant "Second Class" as B
    participant "Last Class" as C
    
    User -> A: DoWork
    activate A
    
    A -> B: Create Request
    activate B
    
    B -> C: DoWork
    activate C
    C --> B: WorkDone
    destroy C
    
    B --> A: Request Created
    deactivate B
    
    A --> User: Done
    deactivate A
  """
  
getHello = ->
  """
    Developer -> Koding : Koding is Amazing

    Developer <- Koding : Welcome to Koding!
  """
  

getClass = ->
  """
  abstract class AbstractList
  abstract AbstractCollection
  interface List
  interface Collection
  
  List <|-- AbstractList
  Collection <|-- AbstractCollection
  
  Collection <|- List
  AbstractCollection <|- AbstractList
  AbstractList <|-- ArrayList
  
  class ArrayList {
    Object[] elementData
    size()
  }
  
  enum TimeUnit {
    DAYS
    HOURS
    MINUTES
  }
  """