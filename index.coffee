{nickname}  = KD.whoami().profile

class UMLGenerator extends JView
  constructor: (options = {}, data) ->
    options.cssClass = "uml-generator"
    
    super options, data
    
    @header = new KDView
      cssClass : "uml-generator-header-view"

    @header.addSubView resetButton = new KDButtonView
      title    : "Reset"
      cssClass : "editor-button uml-reset-button"
      callback : => @reset()
    
    @header.addSubView saveCodeButton = new KDButtonView
      title    : "Save Code"
      cssClass : "editor-button uml-save-code-button"
      callback: => @saveCode()
      
    @header.addSubView saveButton = new KDButtonView
      title    : "Save Output"
      cssClass : "editor-button uml-save-button"
      callback : => @saveUML()
      
    @header.addSubView headerRight = new KDView
      cssClass : "uml-generator-header-right"
    
    headerRight.addSubView about = new KDCustomHTMLView
      partial     : ""
      cssClass    : "editor-button uml-question-mark"
      click       : =>
        new KDModalView
          title   : "About"
          cssClass: "uml-generator-about"
          overlay : yes
          content : """
            <h3>About UML</h3>
            <p>
              <strong>Unified Modeling Language (UML)</strong> is a standardized general-purpose modeling language in the field of object-oriented software engineering. 
              The Unified Modeling Language includes a set of graphic notation techniques to create visual models of object-oriented software-intensive systems.
            </p>
            <p>
              This application uses PlantUML as a service. You can find the details at <a href="http://d.pr/mxgO" target="_blank">PlantUML's home page</a>. If you need more documentation 
              about PlantUML, you can download <a href="http://d.pr/f/wyeB" target="_blank">PlantUML Language Reference Guide</a>.
            </p>
            <h3>About Application</h3>
            <p>Using this application, you can easily create and save UML diagrams to your Koding directory. UML diagrams will be saved under ~/Documents/UMLGenerator.
            You can save UML code as well. Also you can regenerate your UML from your saved UML code by dragging .uml file over the editor. 
            You can try sample UML codes by using "Sample UML Diagrams" menu button.</p>
            <p>Feel free to fork and contribute on Github. <a href="http://d.pr/qQDn" target="_blank">Here</a> is the Github repo of the application.</p>
          """
          
    headerRight.addSubView samples = new KDButtonViewWithMenu
      title    : "Sample UML Codes"
      cssClass : "uml-samples-button editor-button"
      callback : => @reset()
      menu     : =>
        "Hello Koding": 
          callback: => @reset()
        "Sequence Diagram (skinned)": 
          callback: => @openUML getSequence()
        "Class Diagram":
          callback: => @openUML getClass()
        "Activity Diagram": 
          callback: => @openUML getActivity()
        "Use Case Diagram":
          callback: => @openUML getUseCase()
        "State Diagram":
          callback: => @openUML getState()
        "Scientific Chart": 
          callback: => @openUML getChart()
    
    headerRight.addSubView generateButton = new KDButtonView
      title    : "Generate"
      cssClass : "editor-button uml-generate-button"
      callback : => @generateUML()
    
    @ace = options.ace
    
    @aceView = new KDView
    
    @UMLImagePath = KD.utils.proxifyUrl "http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmKl18pSd9XtAvk5pWQcnq4Mh2KtEIytDJ5KgmAGGQvbQKcPgN0bJebP-P1rALM9vQ3D80KmrL00IuhKQe8Tfge4AurOueLYfa5iCS0G00"
    
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
    @editorSession = @aceEditor.getSession()
    @editorSession.setMode  "ace/mode/text"
    @aceEditor.setTheme     "ace/theme/monokai"
    @editorSession.setValue @sampleUMLCode
    @aceEditor.commands.addCommand 
      name      : "find"
      bindKey   : 
        win     : 'Ctrl-S'
        mac     : 'Command-S'
      exec      : => @generateUML()
    
    @baseView.addSubView @dropTarget = new KDView
      cssClass  : "uml-generator-drop-target"
      bind      : "dragstart dragend dragover drop dragenter dragleave"
      
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
      filePath           = "/Users/#{nickname}/Documents/UMLGenerator"
      fileName           = "#{@inputFileName.getValue()}.jpg"
      @lastSavedFilePath = filePath + "/" + fileName
      @doKiteRequest """mkdir -p #{filePath} ; cd #{filePath} ; curl -o "#{fileName}" #{@UMLImagePath}""", (res) =>
        new KDNotificationView
          type     : "mini"
          title    : "Your UML diagram has been saved!"
          cssClass : "success"
          @openFolders()
      @saveDialog.hide()
      
  saveCode: ->
    @openSaveDialog =>
      filePath           = "/Users/#{nickname}/Documents/UMLGenerator"
      fileName           = "#{@inputFileName.getValue()}.uml"
      @lastSavedFilePath = filePath + "/" + fileName
      @doKiteRequest """mkdir -p #{filePath} ; cd #{filePath} ; echo #{FSHelper.escapeFilePath @editorSession.getValue()} > #{fileName}""", (res) =>
        new KDNotificationView
          type     : "mini"
          cssClass : "success" 
          title    : "Your UML code has been saved!"
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
        type     : "mini"
        cssClass : "error"
        title    : "Dropped item must have .uml extension"
        duration : 3000
        
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
      defaultValue : "my-uml"
      
    saveDialog.show()
    inputFileName.setFocus()
  
  generateUML: ->
    @loader.show()
    @umlView.addSubView @loaderView = new KDView
      cssClass : "uml-generator-loader-view"
    
    @doKiteRequest "curl -d img='#{@editorSession.getValue()}' https://acet.koding.com/.applications/umlgenerator/resources/uml-gen.php", (res) =>
      document.getElementById("uml").setAttribute "src", KD.utils.proxifyUrl res
        
      @UMLImagePath = res
      KD.utils.wait 1000, => 
        @loader.hide()
        @loaderView.destroy()
        
  openFolders: ->
    root     = "/Users/#{nickname}"
    docRoot  = "#{root}/Documents"
    files    = [root, docRoot, "#{docRoot}/UMLGenerator"]

    finderController = KD.getSingleton('finderController')
    {treeController} = finderController
    finderController.multipleLs files, (err, res) =>
      fsItems = FSHelper.parseLsOutput files, res
      treeController.addNodes fsItems
      treeController.selectNode treeController.nodes[@lastSavedFilePath]
    
  doKiteRequest: (command, callback) ->
    KD.getSingleton('kiteController').run command, (err, res) =>
      unless err
        callback(res) if callback
      else 
        new KDNotificationView
          title    : "An error occured while processing your request, try again please!"
          type     : "mini"
          cssClass : "error"
          duration : 3000
        @loader?.hide()
        @loaderView?.destroy()
          
  pistachio: ->
    """
      {{> @header }}
      {{> @baseView }}
    """

do ->
  require ["ace/ace"], (Ace) ->
    appView.addSubView new UMLGenerator
      ace: Ace
