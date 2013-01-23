KD.enableLogs()

{nickname}  = KD.whoami().profile

class UMLGenerator extends JView
  constructor: (options = {}) ->
    options.cssClass = "uml-generator"
    
    super options
    
    @header = new KDHeaderView
      cssClass : "uml-generator-header-view"
      type     : "small"
      title    : "UML Generator"
    
    
    @buttonsView = new KDView
      cssClass : "uml-generator-buttons-view"
      
    
    @buttonsView.addSubView @resetButton = new KDButtonView
      title    : "Reset"
      cssClass : "kdbutton editor-button reset-button"
      callback : =>
        @reset()
        
    
    @buttonsView.addSubView @generateButton = new KDButtonView
      title    : "Generate"
      cssClass : "kdbutton editor-button generate-button"
      callback : =>
        @generateUML()
        
    
    @buttonsView.addSubView @saveButton = new KDButtonViewWithMenu
      cssClass : "editor-button with-menu save-button"
      title    : "Save"
      menu     : =>
        "Save UML Code": 
          callback: =>
            @saveCode()
      callback: =>
        @saveUML()
        
    
    @header.addSubView @buttonsView
    
    
    @ace = options.ace
    
    
    @aceView = new KDView
    
    
    @UMLImagePath = "http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmWZ4oYnKSSnEhW4mkBXUuGXjTXCBmr9pa_DnKXP9yg9WY0000"
    
    
    @sampleUMLImagePath = @UMLImagePath
    
    
    @sampleUMLCode = """
      Developer -> Koding : Koding is Amazing

      Developer <- Koding : Welcome to Koding!
    """
    
    
    @umlView = new KDView
      cssClass : "uml-generator-image" 
      partial  : """
        <img id="uml" src="#{@UMLImagePath}" />
      """
      
      
    @baseView = new KDSplitView
      resizable : true
      sizes     : [ "50%", null ]
      views     : [ @aceView, @umlView ]
      
      
    @aceEditor = @ace.edit @aceView.domElement[0]
    @aceEditor.setTheme "ace/theme/monokai"
    @editorSession = @aceEditor.getSession()
    @editorSession.setMode  "ace/mode/text"
    @editorSession.setValue @sampleUMLCode
    
    
  saveUML: ->
    @openSaveDialog =>
      filePath = "/Users/#{nickname}/trunk/"
      fileName = "#{@inputFileName.getValue()}.jpg"
      @doKiteRequest """cd #{filePath} ; curl -o "#{fileName}" #{@UMLImagePath}""", (res) =>
        new KDNotificationView
          type  : "mini"
          title : "Your UML diagram has been saved!"
      @saveDialog.hide()
      
      
  saveCode: ->
    @openSaveDialog =>
      filePath = "/Users/#{nickname}/trunk/"
      fileName = "#{@inputFileName.getValue()}.uml"
      @doKiteRequest """cd #{filePath} ; echo #{FSHelper.escapeFilePath @editorSession.getValue()} > #{fileName}""", (res) =>
        new KDNotificationView
          type  : "mini"
          title : "Your UML code has been saved!"
        @saveDialog.hide()
        
        
  reset: ->
    @editorSession.setValue @sampleUMLCode
    document.getElementById("uml").setAttribute "src", @sampleUMLImagePath
    @UMLImagePath = @sampleUMLImagePath
    
    
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
      title : "Filename:"

    form.addSubView @inputFileName = inputFileName = new KDInputView
      label        : labelFileName
      defaultValue : "sample-uml"
      
    saveDialog.show()
    inputFileName.setFocus()
  
    
  generateUML: ->
    timestamp = +new Date()
    value     = "#{FSHelper.escapeFilePath @editorSession.getValue()}"
    
    @doKiteRequest "cd /Users/#{nickname}/Applications/UMLGenerator.kdapp ; php uml-gen.php #{value}", (res) =>
      document.getElementById("uml").setAttribute "src", res
      @UMLImagePath = res
    
  
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