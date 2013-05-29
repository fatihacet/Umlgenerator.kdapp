require ["ace/ace"], (Ace) ->
  umlGenerator = new UMLGenerator
    ace: Ace
  
  appView.addSubView umlGenerator