class UmlgeneratorMainView extends KDView

  constructor: (options = {}, data) ->

    super options, data

    @loading     = new KDCustomHTMLView
      tagName    : "img"
      cssClass   : "pulsing loading"
      attributes :
        src      : "http://www.plantuml.com/plantuml/img/PO-n3i8m34HtVuKHQ-d4n82A4498hPZw0OQO4ZLrWfF0xvDE85KttZlTNHCJQSgJ0uYZbK1A4zxeFWxgivYZTrvnVThE0kWZAsxsU0YX8w61TOVNm88K0Yg_CiV41dxs3FTTUsPXfUGBVf7IACbIiZB0lxTaMq-cK1K6nnGPFsHJNTVBL9o7b5Pq9S6cmYUz6HzPLW0DYod_lW00"

    appManager = KD.getSingleton "appManager"
    appManager.require "Teamwork", =>
      @workspace  = new Workspace
        title                 : "UMLGenerator"
        cssClass              : "umlgenerator"
        name                  : "UMLGenerator"
        panels                : [
          title               : "UMLGenerator"
          layout              :
            direction         : "vertical"
            sizes             : ["256px", null]
            splitName         : "BaseSplit"
            views             : [
              {
                type          : "custom"
                name          : "finder"
                paneClass     : UMLGeneratorFinder
              }
              {
                type          : "split"
                name          : "InnerSplit"
                options       :
                  direction   : "vertical"
                  sizes       : ["50%", "50%"]
                views         : [
                  {
                    type      : "editor"
                    name      : "editor"
                  }
                  {
                    type      : "custom"
                    name      : "preview"
                    paneClass : UMLView
                  }
                ]
              }
            ]
        ]

      @workspace.once "viewAppended", =>
        @bindWorkspaceEvents()
        @loading.destroy()

      KD.utils.wait 3000, => @addSubView @workspace
      @bindMenuEvents()

    @addSubView @loading

  bindWorkspaceEvents: ->
    @panel = @workspace.getActivePanel()
    {@finder, @editor, @preview} = @panel.panesByName
    @panel.on "EditorContentChanged", (file, contents) =>
      @file = file
      @preview.generate contents

    {@ace} = @editor
    @ace.once "ace.ready", =>
      @ace.addKeyCombo "SaveCode", "Ctrl-S",       @bound "saveCode"
      @ace.addKeyCombo "SaveUML" , "Ctrl-Shift-S", @bound "saveUML"

    @workspace.on "SampleItemClicked", @bound "showSampleUML"

  bindMenuEvents: ->
    @on "saveCodeMenuItemClicked", @bound "saveCode"
    @on "saveUMLMenuItemClicked",  @bound "saveUML"
    @on "samplesMenuItemClicked",  @bound "showSamplesView"
    @on "infoMenuItemClicked",     @bound "showInformationModal"

    @on "contributeMenuItemClicked", =>
      KD.utils.createExternalLink "https://github.com/fatihacet/UMLGenerator.kdapp"

    @on "generateMenuItemClicked", =>
      @preview.generate @ace.getContents()
      @preview.samples?.destroy()

    @on "exitMenuItemClicked", =>
      appManager = KD.getSingleton "appManager"
      appManager.quit appManager.getFrontApp()
      KD.getSingleton("router").handleRoute "Activity"

  saveCode: ->
    @createDummyFile()  unless @file

    contents = @ace.getContents()
    @preview.generate contents

    saveOptions =
      path      : "/home/#{KD.nick()}/Documents/UMLGenerator"
      vmName    : KD.getSingleton("vmController").defaultVmName

    FSHelper.createRecursiveFolder saveOptions, (err, res) =>
      if err
        return @showNotification "Couldn't create folder Documents/UMLGenerator", "error"

      @file.save contents, (err, response) =>
        title      = "#{@file.name} is saved."
        cssClass   = "success umlgen-notification"

        if err
          title    = "Couldn't save #{@file.name}, try again!"
          cssClass = "error umlgen-notification"

        @showNotification title, cssClass

  saveUML: ->
    @createDummyFile()  unless @file

    vmController = KD.getSingleton "vmController"
    filePath     = "Documents/UMLGenerator"
    fileName     = "#{@file.name.slice(0, @file.name.lastIndexOf(".uml"))}.jpg"
    options      =
      withArgs   : """ mkdir -p #{filePath} && cd #{filePath} && curl -o "#{fileName}" #{@preview.umlSrc} """
      vmName     : vmController.defaultVmName

    vmController.run options, (err, res) =>
      if err or res.exitStatus > 0
        @showNotification "Couldn't save your UML, please try again...", "error"
      else
        @showNotification "Your UML saved into ~/Documents/UMLGenerator/#{@file.name}", "success"

  createDummyFile: ->
    path  = "/home/#{KD.nick()}/Documents/UMLGenerator/Untitled.uml"
    @file = FSHelper.createFileFromPath path

  showSamplesView: ->
    view = new UMLGeneratorSamplesView { delegate: this.workspace }

    @preview.img?.destroy()
    @preview.samples?.destroy()
    @preview.addSubView view, null, yes
    @preview.samples = view

  showSampleUML: (code) ->
    @editor.ace.setContents code
    @preview.generate code

  showNotification: (title = "", cssClass) ->
    cssClass   = KD.utils.curry "umlgen-notification", cssClass
    type       = "mini"
    duration   = 3000

    new KDNotificationView { type, duration, title, cssClass }

  showInformationModal: ->
    new KDModalView
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
        <p>Using this application, you can easily create and save UML diagrams to your Koding VM. UML diagrams will be saved under ~/Documents/UMLGenerator.
        You can save UML code as well. Also you can regenerate your UML from your saved UML code opening the .uml file again.
        Don't forget to check UML samples.</p>
        <p>Feel free to fork and contribute on Github. <a href="http://d.pr/qQDn" target="_blank">Here</a> is the Github repo of the application.</p>
      """

class UMLView extends JView

  constructor: (options = {}, data) ->

    options.cssClass = "umlgen-view"

    super options, data

    @landing   = new KDCustomHTMLView
      cssClass : "umlgen-landing"
      partial  : "Open a .uml file to see the generated UML here<br/>or check the samples"

    @samples   = new UMLGeneratorSamplesView
      delegate : @getDelegate().getDelegate() # TODO: fix this
      addClose : no

    @loading   = new KDLoaderView
      size     :
        width  : 48

  createImg: (src) ->
    @umlSrc      = src
    @img         = new KDCustomHTMLView
      tagName    : "img"
      cssClass   : "uml"
      bind       : "load error"
      attributes : { src }

    @img.once "load",  => @loading.hide()
    @img.once "error", => @loading.hide()

    @addSubView @img

  generate: (contents) ->
    @landing.hide()
    @loading.show()
    @img?.destroy()
    @samples?.destroy()
    @createImg "http://www.plantuml.com/plantuml/img/#{compress contents}"

  pistachio: ->
    """
      {{> @landing}}
      {{> @samples}}
      {{> @loading}}
    """

class UMLGeneratorFinder extends KDView

  constructor: (options = {}, data) ->

    super options, data

    vmController = KD.getSingleton "vmController"
    vmController.fetchDefaultVmName (vmName) =>
      @finder = new NFinderController
        nodeIdPath       : "path"
        nodeParentIdPath : "parentPath"
        contextMenu      : yes
        useStorage       : no

      @addSubView @finder.getView()
      @finder.updateVMRoot vmName, "/home/#{KD.nick()}"

      @finder.on "FileNeedsToBeOpened", (file) =>
        extension = file.getExtension()
        if extension is "uml" then @openFile file
        else
          new KDNotificationView
            title     : "Only .uml files can be opened"
            type      : "mini"
            cssClass  : "error umlgen-notification"
            duration  : 5000

  openFile: (file) ->
    file.fetchContents (err, contents) =>
      if err
        return new KDNotificationView
          type     : "mini"
          cssClass : "error"
          title    : "Sorry, couldn't fetch file content, please try again..."
          duration : 3000

      panel = @getDelegate()
      panel.getPaneByName("editor").ace.setContents contents
      panel.emit "EditorContentChanged", file, contents

class UMLGeneratorSamplesView extends KDView

  constructor: (options = {}, data) ->

    options.addClose ?= yes
    options.cssClass  = "samples-container"

    super options, data

    delegate = @getDelegate()

    if options.addClose
      @addSubView new KDCustomHTMLView
        tagName  : "span"
        partial  : "Close"
        cssClass : "close-link"
        click    : =>
          @destroy()
          delegate.getActivePanel().getPaneByName("preview").img?.show()

    for key, sample of UMLGeneratorSampleCodes
      item = new UMLGeneratorSampleItem { delegate }, sample
      item.on "ItemClicked", => @destroy()
      @addSubView item

class UMLGeneratorSampleItem extends JView

  constructor: (options = {}, data) ->

    options.cssClass = "umlgen-sample-item"

    super options, data

    @on "click", =>
      @emit "ItemClicked"
      @getDelegate().emit "SampleItemClicked", @getData().code

  pistachio: ->
    data = @getData()
    """
      <img src="#{data.preview}" />
      <p>#{data.title}</p>
    """

class UmlgeneratorController extends AppController

  constructor: (options = {}, data) ->

    options.view    = new UmlgeneratorMainView

    options.appInfo =
      name : "Umlgenerator"
      type : "application"

    super options, data


if appView?
  view = new UmlgeneratorMainView
  appView.addSubView view
else
  KD.registerAppClass UmlgeneratorController,
    name     : "Umlgenerator"
    routes   :
      "/:name?/Umlgenerator" : null
      "/:name?/fatihacet/Apps/Umlgenerator" : null
    dockPath : "/fatihacet/Apps/Umlgenerator"
    behavior : "application"
    menu     :
      items  : [
        { title : "Generate",         eventName : "generate"   }
        { type  : "separator"                                  }
        { title : "Save Code",        eventName : "saveCode"   }
        { title : "Save UML",         eventName : "saveUML"    }
        { type  : "separator"                                  }
        { title : "Samples",          eventName : "samples"    }
        { title : "More information", eventName : "info"       }
        { type  : "separator"                                  }
        { title : "Contribute",       eventName : "contribute" }
        { type  : "separator"                                  }
        { title : "Exit",             eventName : "exit"       }
      ]
