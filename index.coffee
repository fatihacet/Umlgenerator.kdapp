KD.enableLogs()

{nickname}  = KD.whoami().profile

class UMLGenerator extends JView
  constructor: (options = {}) ->
    options.cssClass = "uml-generator"
    
    super options
    
    @header = new KDHeaderView
      cssClass : "uml-generator-header-view"
      type     : "small"

    @header.addSubView @resetButton = new KDButtonView
      title    : "Reset"
      cssClass : "editor-button uml-reset-button"
      callback : => @reset()
    
    @header.addSubView @saveCodeButton = new KDButtonView
      title    : "Save Code"
      cssClass : "editor-button uml-save-code-button"
      callback: => @saveCode()
    
    @header.addSubView @saveButton = new KDButtonView
      title    : "Save Output"
      cssClass : "editor-button uml-save-button"
      callback : => @saveUML()
    
    @header.addSubView @generateButton = new KDButtonView
      title    : "Generate"
      cssClass : "editor-button uml-generate-button"
      callback : => @generateUML()
    
    @header.addSubView @samples = new KDButtonViewWithMenu
      title    : "Sample UML Codes"
      cssClass : "uml-samples-button editor-button"
      callback : => @reset()
      menu     : =>
        "Hello Koding": ->
          callback: => @reset()
        "Skinned Sequence Diagram": 
          callback: => @openUML getSkinned()
        "Class Diagram":
          callback: => @openUML getClass()
    
    @header.addSubView @openTip = new KDCustomHTMLView
      partial     : "?"
      cssClass    : "editor-button uml-question-mark"
      tooltip     : 
        title     : "You can open saved .uml files <br /> by dragging over the editor."
        placement : "bottom"

    @ace = options.ace
    
    @aceView = new KDView
    
    @UMLImagePath = "https://api.koding.com/1.0/image.php?url=http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmWZ4oYnKSSnEhW4mkBXUuGXjTXCBmr9pa_DnKXP9yg9WY0000"
    
    @sampleUMLImagePath = @UMLImagePath
    
    @sampleUMLCode = getHello()
    
    @umlView = new KDView
      cssClass : "uml-generator-image" 
      partial  : """
        <img id="uml" src="#{@UMLImagePath}" />
      """
      
    @umlView.addSubView @loader = new KDLoaderView
      size    :
        width : 30
        
    @baseView = new KDSplitView
      resizable : true
      sizes     : [ "50%", null ]
      views     : [ @aceView, @umlView ]
      
    @aceEditor = @ace.edit @aceView.domElement[0]
    @aceEditor.setTheme "ace/theme/monokai"
    @editorSession = @aceEditor.getSession()
    @editorSession.setMode  "ace/mode/text"
    @editorSession.setValue @sampleUMLCode
    
    @baseView.addSubView @dropTarget = new KDView
      cssClass   : "uml-generator-drop-target"
      bind       : "dragstart dragend dragover drop dragenter dragleave"
      
    @dropTarget.hide()
    
    @dropTarget.on "drop", (e) =>
      @open e.originalEvent.dataTransfer.getData "Text"
      
    KD.getSingleton("windowController").registerListener
      KDEventTypes : ["DragEnterOnWindow", "DragExitOnWindow"]
      listener : @
      callback : (pubInst, event) =>
        @dropTarget.show()
        @dropTarget.hide() if event.type is "drop"
      
  saveUML: ->
    @openSaveDialog =>
      filePath = "/Users/#{nickname}/Documents/UMLGenerator"
      fileName = "#{@inputFileName.getValue()}.jpg"
      @doKiteRequest """mkdir -p #{filePath} ; cd #{filePath} ; curl -o "#{fileName}" #{@UMLImagePath}""", (res) =>
        new KDNotificationView
          type  : "mini"
          title : "Your UML diagram has been saved!"
          @openFolders()
      @saveDialog.hide()
      
  saveCode: ->
    @openSaveDialog =>
      filePath = "/Users/#{nickname}/Documents/UMLGenerator"
      fileName = "#{@inputFileName.getValue()}.uml"
      @doKiteRequest """mkdir -p #{filePath} ; cd #{filePath} ; echo #{FSHelper.escapeFilePath @editorSession.getValue()} > #{fileName}""", (res) =>
        new KDNotificationView
          type  : "mini"
          title : "Your UML code has been saved!"
          @openFolders()
        @saveDialog.hide()
        
  reset: ->
    @editorSession.setValue @sampleUMLCode
    document.getElementById("uml").setAttribute "src", @sampleUMLImagePath
    @UMLImagePath = @sampleUMLImagePath
    
  open: (path) ->
    ext = KD.utils.getFileExtension path
    if ext isnt "uml"
      return new KDNotificationView
        title    : "Dropped item must have .uml extension"
        duration : 3000
        type     : "mini"
    else 
      @doKiteRequest "cat #{path}", (res) =>
        @openUML res
        
  openUML: (umlCode) ->
    @editorSession.setValue umlCode
    @generateUML()
      
  openSaveDialog: (callback) ->
    @addSubView @saveDialog = saveDialog = new KDDialogView
      cssClass      : "save-as-dialog"
      duration      : 200
      topOffset     : 0
      overlay       : yes
      height        : "auto"
      buttons       :
        Save        :
          style     : "modal-clean-gray"
          callback  : () =>
            callback @inputFileName.getValue()
        Cancel :
          style     : "modal-cancel"
          callback  : ()->
            saveDialog.hide()

    saveDialog.addSubView wrapper = new KDView
      cssClass : "kddialog-wrapper"

    wrapper.addSubView form = new KDFormView

    form.addSubView labelFileName = new KDLabelView
      title : "Filename: (file will be saved into ~/Documents/UMLGenerator/)"

    form.addSubView @inputFileName = inputFileName = new KDInputView
      label        : labelFileName
      defaultValue : "sample-uml"
      
    saveDialog.show()
    inputFileName.setFocus()
  
  generateUML: ->
    @loader.show()
    @umlView.addSubView @loaderView = new KDView
      cssClass : "uml-generator-loader-view"
    
    @doKiteRequest "curl -d img='#{@editorSession.getValue()}' https://fatihacet.koding.com/.applications/umlgenerator/resources/uml-gen.php", (res) =>
      document.getElementById("uml").setAttribute "src", res
        
      @UMLImagePath = res
      KD.utils.wait 1000, => 
        @loader.hide()
        @loaderView.destroy()
        
  openFolders: ->
    root    = "/Users/#{nickname}"
    docRoot = root + "/Documents"
    
    files = [root, docRoot, "#{docRoot}/UMLGenerator"]

    finderController = KD.getSingleton('finderController')
    finderController.multipleLs files, (err, res) =>
      fsItems = FSHelper.parseLsOutput files, res
      finderController.treeController.addNodes fsItems
    
  doKiteRequest: (command, callback) ->
    KD.getSingleton('kiteController').run command, (err, res) =>
      unless err
        callback(res) if callback
      else 
        new KDNotificationView
          title    : "An error occured while processing your request, try again please!"
          duration : 3000
          
  pistachio: ->
    """
      {{> @header }}
      {{> @baseView }}
    """

do ->
  require ["ace/ace"], (Ace) ->
    appView.addSubView new UMLGenerator
      ace: Ace