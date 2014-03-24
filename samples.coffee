UMLGeneratorSampleCodes =

  hello     :
    title   : "Hello UML"
    preview : "https://raw.githubusercontent.com/fatihacet/UMLGenerator.kdapp/master/resources/samples/hello.png"
    code    : """
      @startuml
      Koding -> Developer : Welcome to Koding

      Koding <- Developer : Hello Koding

      Developer -> Friend : Did you see Koding?

      Friend -> Koding : Hello Koding

      Friend <- Koding : Welcome to Koding

      Developer <- Friend : Koding is awesome

      Developer -> Friend : Yes, indeed.
      @enduml
    """

  sequence  :
    title   : "Sequence Diagram"
    preview : "https://raw.githubusercontent.com/fatihacet/UMLGenerator.kdapp/master/resources/samples/sequence.png"
    code    : """
      @startuml
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
      @enduml
    """
  class     :
    title   : "Class Diagram"
    preview : "https://raw.githubusercontent.com/fatihacet/UMLGenerator.kdapp/master/resources/samples/class.png"
    code    : """
      @startuml
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
      @enduml
    """

  activity  :
    title   : "Activity Diagram"
    preview : "https://raw.githubusercontent.com/fatihacet/UMLGenerator.kdapp/master/resources/samples/activity.png"
    code    : """
      @startuml
      title Servlet Container

      (*) --> "ClickServlet.handleRequest()"
      --> "new Page"

      if "Page.onSecurityCheck" then
        ->[true] "Page.onInit()"

        if "isForward?" then
         ->[no] "Process controls"

         if "continue processing?" then
           -->[yes] ===RENDERING===
         else
           -->[no] ===REDIRECT_CHECK===
         endif

        else
         -->[yes] ===RENDERING===
        endif

        if "is Post?" then
          -->[yes] "Page.onPost()"
          --> "Page.onRender()" as render
          --> ===REDIRECT_CHECK===
        else
          -->[no] "Page.onGet()"
          --> render
        endif

      else
        -->[false] ===REDIRECT_CHECK===
      endif

      if "Do redirect?" then
       ->[yes] "redirect request"
       --> ==BEFORE_DESTROY===
      else
       if "Do Forward?" then
        -left->[yes] "Forward request"
        --> ==BEFORE_DESTROY===
       else
        -right->[no] "Render page template"
        --> ==BEFORE_DESTROY===
       endif
      endif

      --> "Page.onDestroy()"
      -->(*)
      @enduml
    """

  useCase   :
    title   : "Use Case Diagram"
    preview : "https://raw.githubusercontent.com/fatihacet/UMLGenerator.kdapp/master/resources/samples/usecase.png"
    code    : """
      @startuml
      left to right direction
      skinparam packageStyle rect
      actor customer
      actor clerk
      rectangle checkout {
        customer -- (checkout)
        (checkout) .> (payment) : include
        (help) .> (checkout) : extends
        (checkout) -- clerk
      }
      @enduml
    """

  state     :
    title   : "State Diagram"
    preview : "https://raw.githubusercontent.com/fatihacet/UMLGenerator.kdapp/master/resources/samples/state.png"
    code    : """
      @startuml
      scale 600 width

      [*] -> State1
      State1 --> State2 : Succeeded
      State1 --> [*] : Aborted
      State2 --> State3 : Succeeded
      State2 --> [*] : Aborted
      state State3 {
        state "Long State Name" as long1
        long1 : Just a test
        [*] --> long1
        long1 --> long1 : New Data
        long1 --> ProcessData : Enough Data
      }
      State3 --> State3 : Failed
      State3 --> [*] : Succeeded / Save Result
      State3 --> [*] : Aborted
      @enduml
    """
