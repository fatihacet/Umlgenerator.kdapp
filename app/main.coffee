{nickname}      = KD.whoami().profile
{defaultVmName} = KD.getSingleton "vmController"
timestamp       = Date.now()

class UMLGenerator extends JView

  constructor: (options = {}, data) ->
    
    options.cssClass = "uml-generator"
    
    super options, data
    
    @on "generateMenuItemClicked",   => @generateUML()
    @on "resetMenuItemClicked",      => @reset()
    @on "saveCodeMenuItemClicked",   => @saveCode()
    @on "saveOutputMenuItemClicked", => @saveUML()
    @on "aboutMenuItemClicked",      => @showAbout()
    @on "docMenuItemClicked",        => @showDocumentation()
    @on "samplesMenuItemClicked",    => @showSamples()
     
    @ace                = options.ace
    @UMLImagePath       = KD.utils.proxifyUrl "http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmKl18pSd9XtAvk5pWQcnq4Mh2KtEIytDJ5KgmAGGQvbQKcPgN0bJebP-P1rALM9vQ3D80KmrL00IuhKQe8Tfge4AurOueLYfa5iCS0G00"
    @sampleUMLImagePath = @UMLImagePath  
    @sampleUMLCode      = getHello()
    @aceView            = new KDView
    @umlView            = new KDView
      cssClass          : "uml-generator-image" 
      partial           : """<img id="uml" src="#{@UMLImagePath}" />"""
      
    @umlView.addSubView @loader = new KDLoaderView
      size    :
        width : 30
        
    @baseView   = new KDSplitView
      resizable : true
      sizes     : [ "50%", null ]
      views     : [ @aceView, @umlView ]
      
    @aceEditor     = @ace.edit @aceView.domElement[0]
    @editorSession = @aceEditor.getSession()
    @editorSession.setMode  "ace/mode/text"
    @editorSession.setValue @sampleUMLCode
    @aceEditor.setTheme     "ace/theme/monokai"
    
    @aceEditor.commands.addCommand 
      name     : "find"
      bindKey  : 
        win    : "Ctrl-S"
        mac    : "Command-S"
      exec     : => @generateUML()
    
    @baseView.addSubView @dropTarget = new KDView
      cssClass : "uml-generator-drop-target"
      bind     : "dragstart dragend dragover drop dragenter dragleave"
      
    @dropTarget.hide()
    
    @dropTarget.on "drop", (e) =>
      @open e.originalEvent.dataTransfer.getData "Text"
    
    windowController = KD.getSingleton "windowController"
    windowController.on "DragEnterOnWindow", => @dropTarget.show()
    windowController.on "DragExitOnWindow" , => @dropTarget.hide()
    
    hookFile = FSHelper.createFileFromPath "Web/.applications/umlgen-hook.php"
    hookFile.save UMLGenerator.hookFileContent, (err, res) ->
      if err
        modal = new KDBlockingModalView
          title        : "Something wrong"
          overlay      : yes
          content      : "<p>Sorry but, UMLGenerator app couldn't create hook file that will help you to create UML diagrams. This means you cannot save your UML diagrams. You can report this issue to app author.</p>"
          buttons      : 
            OK         :
              title    : "Close the app"
              cssClass : "clean-gray"
              callback : -> 
                appManager = KD.getSingleton "appManager"
                appManager.quit appManager.frontApp
    
  saveUML: ->
    @openSaveDialog =>
      filePath = "Documents/UMLGenerator"
      fileName = "#{@inputFileName.getValue()}.jpg"
      @doKiteRequest """mkdir -p #{filePath} ; cd #{filePath} ; curl -o "#{fileName}" #{@UMLImagePath}""", (res) =>
        new KDNotificationView
          type     : "mini"
          title    : "Your UML diagram has been saved into ~/Documents/UMLGenerator."
          cssClass : "success"
        @saveDialog.hide()
      
  saveCode: ->
    @openSaveDialog =>
      filePath = "Documents/UMLGenerator"
      fileName = "#{@inputFileName.getValue()}.uml"
      @doKiteRequest "mkdir -p #{filePath} ; cd #{filePath}", (res) =>
        file = FSHelper.createFileFromPath "#{filePath}/#{fileName}"
        file.save @editorSession.getValue(), (err, res) =>
          new KDNotificationView
            type     : "mini"
            cssClass : "success" 
            title    : "Your UML code has been saved into ~/Documents/UMLGenerator."
          @saveDialog.hide()
        
  reset: ->
    @editorSession.setValue @sampleUMLCode
    document.getElementById("uml").setAttribute "src", @sampleUMLImagePath
    @UMLImagePath = @sampleUMLImagePath
    
  open: (path) ->
    ext = FSFile.getFileExtension path
    if ext isnt "uml"
      return new KDNotificationView
        type     : "mini"
        cssClass : "error"
        title    : "Dropped item must have .uml extension"
        duration : 3000
        
    else
      @doKiteRequest "cat #{FSHelper.plainPath path}", (res) =>
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
    
    @doKiteRequest """wget -qO- --post-data="img=#{@editorSession.getValue().replace /[\r\n]/g, "\\n"}" http://#{defaultVmName}/.applications/umlgen-hook.php""", (res) =>
      document.getElementById("uml").setAttribute "src", KD.utils.proxifyUrl res
        
      @UMLImagePath = res
      KD.utils.wait 1000, => 
        @loader.hide()
        @loaderView.destroy()
  
  showAbout: ->
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
      
  showDocumentation: ->
    new KDNotificationView
      title: "Documentation will be added soon!"
      type : "mini"
      
  showSamples: ->
    new KDNotificationView
      title: "Sample diagrams will be added soon!"
      type : "mini"
        
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
      {{> @baseView}}
    """
    
UMLGenerator.hookFileContent = """
<?php 

function encodep($text) { 
     $data = utf8_encode($text); 
     $compressed = gzdeflate($data, 9); 
     return encode64($compressed); 
} 

function encode6bit($b) { 
     if ($b < 10) { 
          return chr(48 + $b); 
     } 
     $b -= 10; 
     if ($b < 26) { 
          return chr(65 + $b); 
     } 
     $b -= 26; 
     if ($b < 26) { 
          return chr(97 + $b); 
     } 
     $b -= 26; 
     if ($b == 0) { 
          return '-'; 
     } 
     if ($b == 1) { 
          return '_'; 
     } 
     return '?'; 
} 

function append3bytes($b1, $b2, $b3) { 
     $c1 = $b1 >> 2; 
     $c2 = (($b1 & 0x3) << 4) | ($b2 >> 4); 
     $c3 = (($b2 & 0xF) << 2) | ($b3 >> 6); 
     $c4 = $b3 & 0x3F; 
     $r = ""; 
     $r .= encode6bit($c1 & 0x3F); 
     $r .= encode6bit($c2 & 0x3F); 
     $r .= encode6bit($c3 & 0x3F); 
     $r .= encode6bit($c4 & 0x3F); 
     return $r; 
} 

function encode64($c) { 
     $str = ""; 
     $len = strlen($c); 
     for ($i = 0; $i < $len; $i+=3) { 
            if ($i+2==$len) { 
                  $str .= append3bytes(ord(substr($c, $i, 1)), ord(substr($c, $i+1, 1)), 0); 
            } else if ($i+1==$len) { 
                  $str .= append3bytes(ord(substr($c, $i, 1)), 0, 0); 
            } else { 
                  $str .= append3bytes(ord(substr($c, $i, 1)), ord(substr($c, $i+1, 1)), ord(substr($c, $i+2, 1))); 
            } 
     } 
     return $str; 
} 

$path = "https://koding.com/-/imageProxy?url=http://www.plantuml.com/plantuml/img/"; 


$path .= encodep(str_replace('\n', "\n", $_POST['img'])); 

echo $path;

?> 
"""
