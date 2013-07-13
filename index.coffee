require ["ace/ace"], (Ace) ->
  umlGenerator = new UMLGenerator
    ace: Ace
  
  appView.addSubView umlGenerator
  
  menuItems   = [ "generate", "reset", "saveCode", "saveOutput", "samples", "doc", "about" ]
  
  menuItems.forEach (item) =>
    eventName = "#{item}MenuItemClicked"
    appView.on eventName, => umlGenerator.emit eventName