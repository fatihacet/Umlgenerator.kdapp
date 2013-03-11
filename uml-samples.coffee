getHello = ->
  """
    Koding -> Developer : Welcome to Koding
    
    Koding <- Developer : Hello Koding
    
    Developer -> Friend : Did you see Koding?
    
    Friend -> Koding : Hello Koding
    
    Friend <- Koding : Welcome to Koding
    
    Developer <- Friend : Koding is awesome
    
    Developer -> Friend : Yes, indeed.
  """

getSequence = ->
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

getActivity = ->
  """
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
  """
  
getUseCase = ->
  """
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
  """
  
getState = ->
  """
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
  """
  
getChart = ->
  """
  @startjcckit(600,300)
  data/curves = c1 c2 c3
  data/c1/y = 1998 1999 2000 2001 2002
  data/c1/x = 31 32 44 61 55
  data/c2/y = 1998 1999 2000 2001 2002
  data/c2/x = 54 59 50 31 38
  data/c3/y = 1998 1999 2000 2001 2002
  data/c3/x = 15  9  6  8  7
  background = 0xffffff
  defaultCoordinateSystem/ticLabelFormat = %d
  defaultCoordinateSystem/ticLabelAttributes/fontSize = 0.03
  defaultCoordinateSystem/axisLabelAttributes/fontSize = 0.04
  defaultCoordinateSystem/axisLabelAttributes/fontStyle = bold
  plot/coordinateSystem/xAxis/ = defaultCoordinateSystem/
  plot/coordinateSystem/xAxis/axisLabel =  
  plot/coordinateSystem/xAxis/ticLabelFormat = %d%% 
  plot/coordinateSystem/xAxis/grid = true
  plot/coordinateSystem/xAxis/minimum = 0
  plot/coordinateSystem/xAxis/maximum = 100
  plot/coordinateSystem/yAxis/ = defaultCoordinateSystem/
  plot/coordinateSystem/yAxis/axisLabel = year
  plot/coordinateSystem/yAxis/minimum = 2002.5
  plot/coordinateSystem/yAxis/maximum = 1997.5
  plot/initialHintForNextCurve/className = jcckit.plot.PositionHint
  plot/initialHintForNextCurve/position = 0.15 0
  defaultDefinition/symbolFactory/className = jcckit.plot.BarFactory
  defaultDefinition/symbolFactory/stacked = true
  defaultDefinition/symbolFactory/size = 0.07
  defaultDefinition/symbolFactory/horizontalBars = true
  defaultDefinition/symbolFactory/attributes/className = jcckit.graphic.BasicGraphicAttributes
  defaultDefinition/symbolFactory/attributes/lineColor = 0
  defaultDefinition/withLine = false
  plot/curveFactory/definitions = def1 def2 def3
  plot/curveFactory/def1/ = defaultDefinition/
  plot/curveFactory/def1/symbolFactory/attributes/fillColor = 0xcaff
  plot/curveFactory/def2/ = defaultDefinition/
  plot/curveFactory/def2/symbolFactory/attributes/fillColor = 0xffca00
  plot/curveFactory/def3/ = defaultDefinition/
  plot/curveFactory/def3/symbolFactory/attributes/fillColor = 0xa0ff80
  plot/legendVisible = false
  @endjcckit
  """