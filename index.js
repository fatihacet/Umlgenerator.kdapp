/* Compiled by KD on Wed May 29 2013 14:20:53 GMT+0000 (UTC) */
(function() {
/* KDAPP STARTS */
/* BLOCK STARTS: /home/fatihacet/Applications/UMLGenerator.kdapp/app/uml-samples.coffee */
var getActivity, getChart, getClass, getHello, getSequence, getState, getUseCase;

getHello = function() {
  return "Koding -> Developer : Welcome to Koding\n\nKoding <- Developer : Hello Koding\n\nDeveloper -> Friend : Did you see Koding?\n\nFriend -> Koding : Hello Koding\n\nFriend <- Koding : Welcome to Koding\n\nDeveloper <- Friend : Koding is awesome\n\nDeveloper -> Friend : Yes, indeed.";
};

getSequence = function() {
  return "skinparam backgroundColor #EEEBDC\n\nskinparam sequence {\n  ArrowColor DeepSkyBlue\n  ActorBorderColor DeepSkyBlue\n  LifeLineBorderColor blue\n  LifeLineBackgroundColor #A9DCDF\n  \n  ParticipantBorderColor DeepSkyBlue\n  ParticipantBackgroundColor DodgerBlue\n  ParticipantFontName Impact\n  ParticipantFontSize 17\n  ParticipantFontColor #A9DCDF\n  \n  ActorBackgroundColor aqua\n  ActorFontColor DeepSkyBlue\n  ActorFontSize 17\n  ActorFontName Aapex\n}\n\nactor User\nparticipant \"First Class\" as A\nparticipant \"Second Class\" as B\nparticipant \"Last Class\" as C\n\nUser -> A: DoWork\nactivate A\n\nA -> B: Create Request\nactivate B\n\nB -> C: DoWork\nactivate C\nC --> B: WorkDone\ndestroy C\n\nB --> A: Request Created\ndeactivate B\n\nA --> User: Done\ndeactivate A";
};

getClass = function() {
  return "abstract class AbstractList\nabstract AbstractCollection\ninterface List\ninterface Collection\n\nList <|-- AbstractList\nCollection <|-- AbstractCollection\n\nCollection <|- List\nAbstractCollection <|- AbstractList\nAbstractList <|-- ArrayList\n\nclass ArrayList {\n  Object[] elementData\n  size()\n}\n\nenum TimeUnit {\n  DAYS\n  HOURS\n  MINUTES\n}";
};

getActivity = function() {
  return "title Servlet Container\n\n(*) --> \"ClickServlet.handleRequest()\"\n--> \"new Page\"\n\nif \"Page.onSecurityCheck\" then\n  ->[true] \"Page.onInit()\"\n  \n  if \"isForward?\" then\n   ->[no] \"Process controls\"\n   \n   if \"continue processing?\" then\n     -->[yes] ===RENDERING===\n   else\n     -->[no] ===REDIRECT_CHECK===\n   endif\n   \n  else\n   -->[yes] ===RENDERING===\n  endif\n  \n  if \"is Post?\" then\n    -->[yes] \"Page.onPost()\"\n    --> \"Page.onRender()\" as render\n    --> ===REDIRECT_CHECK===\n  else\n    -->[no] \"Page.onGet()\"\n    --> render\n  endif\n  \nelse\n  -->[false] ===REDIRECT_CHECK===\nendif\n\nif \"Do redirect?\" then\n ->[yes] \"redirect request\"\n --> ==BEFORE_DESTROY===\nelse\n if \"Do Forward?\" then\n  -left->[yes] \"Forward request\"\n  --> ==BEFORE_DESTROY===\n else\n  -right->[no] \"Render page template\"\n  --> ==BEFORE_DESTROY===\n endif\nendif\n\n--> \"Page.onDestroy()\"\n-->(*)";
};

getUseCase = function() {
  return "left to right direction\nskinparam packageStyle rect\nactor customer\nactor clerk\nrectangle checkout {\n  customer -- (checkout)\n  (checkout) .> (payment) : include\n  (help) .> (checkout) : extends\n  (checkout) -- clerk\n}";
};

getState = function() {
  return "scale 600 width\n\n[*] -> State1\nState1 --> State2 : Succeeded\nState1 --> [*] : Aborted\nState2 --> State3 : Succeeded\nState2 --> [*] : Aborted\nstate State3 {\n  state \"Long State Name\" as long1\n  long1 : Just a test\n  [*] --> long1\n  long1 --> long1 : New Data\n  long1 --> ProcessData : Enough Data\n}\nState3 --> State3 : Failed\nState3 --> [*] : Succeeded / Save Result\nState3 --> [*] : Aborted";
};

getChart = function() {
  return "@startjcckit(600,300)\ndata/curves = c1 c2 c3\ndata/c1/y = 1998 1999 2000 2001 2002\ndata/c1/x = 31 32 44 61 55\ndata/c2/y = 1998 1999 2000 2001 2002\ndata/c2/x = 54 59 50 31 38\ndata/c3/y = 1998 1999 2000 2001 2002\ndata/c3/x = 15  9  6  8  7\nbackground = 0xffffff\ndefaultCoordinateSystem/ticLabelFormat = %d\ndefaultCoordinateSystem/ticLabelAttributes/fontSize = 0.03\ndefaultCoordinateSystem/axisLabelAttributes/fontSize = 0.04\ndefaultCoordinateSystem/axisLabelAttributes/fontStyle = bold\nplot/coordinateSystem/xAxis/ = defaultCoordinateSystem/\nplot/coordinateSystem/xAxis/axisLabel =  \nplot/coordinateSystem/xAxis/ticLabelFormat = %d%% \nplot/coordinateSystem/xAxis/grid = true\nplot/coordinateSystem/xAxis/minimum = 0\nplot/coordinateSystem/xAxis/maximum = 100\nplot/coordinateSystem/yAxis/ = defaultCoordinateSystem/\nplot/coordinateSystem/yAxis/axisLabel = year\nplot/coordinateSystem/yAxis/minimum = 2002.5\nplot/coordinateSystem/yAxis/maximum = 1997.5\nplot/initialHintForNextCurve/className = jcckit.plot.PositionHint\nplot/initialHintForNextCurve/position = 0.15 0\ndefaultDefinition/symbolFactory/className = jcckit.plot.BarFactory\ndefaultDefinition/symbolFactory/stacked = true\ndefaultDefinition/symbolFactory/size = 0.07\ndefaultDefinition/symbolFactory/horizontalBars = true\ndefaultDefinition/symbolFactory/attributes/className = jcckit.graphic.BasicGraphicAttributes\ndefaultDefinition/symbolFactory/attributes/lineColor = 0\ndefaultDefinition/withLine = false\nplot/curveFactory/definitions = def1 def2 def3\nplot/curveFactory/def1/ = defaultDefinition/\nplot/curveFactory/def1/symbolFactory/attributes/fillColor = 0xcaff\nplot/curveFactory/def2/ = defaultDefinition/\nplot/curveFactory/def2/symbolFactory/attributes/fillColor = 0xffca00\nplot/curveFactory/def3/ = defaultDefinition/\nplot/curveFactory/def3/symbolFactory/attributes/fillColor = 0xa0ff80\nplot/legendVisible = false\n@endjcckit";
};
/* BLOCK STARTS: /home/fatihacet/Applications/UMLGenerator.kdapp/app/main.coffee */
var UMLGenerator, nickname,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

nickname = KD.whoami().profile.nickname;

UMLGenerator = (function(_super) {
  __extends(UMLGenerator, _super);

  function UMLGenerator(options, data) {
    var about, generateButton, headerRight, resetButton, samples, saveButton, saveCodeButton,
      _this = this;

    if (options == null) {
      options = {};
    }
    options.cssClass = "uml-generator";
    UMLGenerator.__super__.constructor.call(this, options, data);
    this.header = new KDView({
      cssClass: "uml-generator-header-view"
    });
    this.header.addSubView(resetButton = new KDButtonView({
      title: "Reset",
      cssClass: "editor-button uml-reset-button",
      callback: function() {
        return _this.reset();
      }
    }));
    this.header.addSubView(saveCodeButton = new KDButtonView({
      title: "Save Code",
      cssClass: "editor-button uml-save-code-button",
      callback: function() {
        return _this.saveCode();
      }
    }));
    this.header.addSubView(saveButton = new KDButtonView({
      title: "Save Output",
      cssClass: "editor-button uml-save-button",
      callback: function() {
        return _this.saveUML();
      }
    }));
    this.header.addSubView(headerRight = new KDView({
      cssClass: "uml-generator-header-right"
    }));
    headerRight.addSubView(about = new KDCustomHTMLView({
      partial: "",
      cssClass: "editor-button uml-question-mark",
      click: function() {
        return new KDModalView({
          title: "About",
          cssClass: "uml-generator-about",
          overlay: true,
          content: "<h3>About UML</h3>\n<p>\n  <strong>Unified Modeling Language (UML)</strong> is a standardized general-purpose modeling language in the field of object-oriented software engineering. \n  The Unified Modeling Language includes a set of graphic notation techniques to create visual models of object-oriented software-intensive systems.\n</p>\n<p>\n  This application uses PlantUML as a service. You can find the details at <a href=\"http://d.pr/mxgO\" target=\"_blank\">PlantUML's home page</a>. If you need more documentation \n  about PlantUML, you can download <a href=\"http://d.pr/f/wyeB\" target=\"_blank\">PlantUML Language Reference Guide</a>.\n</p>\n<h3>About Application</h3>\n<p>Using this application, you can easily create and save UML diagrams to your Koding directory. UML diagrams will be saved under ~/Documents/UMLGenerator.\nYou can save UML code as well. Also you can regenerate your UML from your saved UML code by dragging .uml file over the editor. \nYou can try sample UML codes by using \"Sample UML Diagrams\" menu button.</p>\n<p>Feel free to fork and contribute on Github. <a href=\"http://d.pr/qQDn\" target=\"_blank\">Here</a> is the Github repo of the application.</p>"
        });
      }
    }));
    headerRight.addSubView(samples = new KDButtonViewWithMenu({
      title: "Sample UML Codes",
      cssClass: "uml-samples-button editor-button",
      callback: function() {
        return _this.reset();
      },
      menu: function() {
        return {
          "Hello Koding": {
            callback: function() {
              return _this.reset();
            }
          },
          "Sequence Diagram (skinned)": {
            callback: function() {
              return _this.openUML(getSequence());
            }
          },
          "Class Diagram": {
            callback: function() {
              return _this.openUML(getClass());
            }
          },
          "Activity Diagram": {
            callback: function() {
              return _this.openUML(getActivity());
            }
          },
          "Use Case Diagram": {
            callback: function() {
              return _this.openUML(getUseCase());
            }
          },
          "State Diagram": {
            callback: function() {
              return _this.openUML(getState());
            }
          },
          "Scientific Chart": {
            callback: function() {
              return _this.openUML(getChart());
            }
          }
        };
      }
    }));
    headerRight.addSubView(generateButton = new KDButtonView({
      title: "Generate",
      cssClass: "editor-button uml-generate-button",
      callback: function() {
        return _this.generateUML();
      }
    }));
    this.ace = options.ace;
    this.aceView = new KDView;
    this.UMLImagePath = KD.utils.proxifyUrl("http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmKl18pSd9XtAvk5pWQcnq4Mh2KtEIytDJ5KgmAGGQvbQKcPgN0bJebP-P1rALM9vQ3D80KmrL00IuhKQe8Tfge4AurOueLYfa5iCS0G00");
    this.sampleUMLImagePath = this.UMLImagePath;
    this.sampleUMLCode = getHello();
    this.umlView = new KDView({
      cssClass: "uml-generator-image",
      partial: "<img id=\"uml\" src=\"" + this.UMLImagePath + "\" />"
    });
    this.umlView.addSubView(this.loader = new KDLoaderView({
      size: {
        width: 30
      }
    }));
    this.baseView = new KDSplitView({
      resizable: true,
      sizes: ["50%", null],
      views: [this.aceView, this.umlView]
    });
    this.aceEditor = this.ace.edit(this.aceView.domElement[0]);
    this.editorSession = this.aceEditor.getSession();
    this.editorSession.setMode("ace/mode/text");
    this.aceEditor.setTheme("ace/theme/monokai");
    this.editorSession.setValue(this.sampleUMLCode);
    this.aceEditor.commands.addCommand({
      name: "find",
      bindKey: {
        win: 'Ctrl-S',
        mac: 'Command-S'
      },
      exec: function() {
        return _this.generateUML();
      }
    });
    this.baseView.addSubView(this.dropTarget = new KDView({
      cssClass: "uml-generator-drop-target",
      bind: "dragstart dragend dragover drop dragenter dragleave"
    }));
    this.dropTarget.hide();
    this.dropTarget.on("drop", function(e) {
      return _this.open(e.originalEvent.dataTransfer.getData("Text"));
    });
    KD.getSingleton("windowController").registerListener({
      KDEventTypes: ["DragEnterOnWindow", "DragExitOnWindow"],
      listener: this,
      callback: function(pubInst, event) {
        _this.dropTarget.show();
        if (event.type === "drop") {
          return _this.dropTarget.hide();
        }
      }
    });
  }

  UMLGenerator.prototype.saveUML = function() {
    var _this = this;

    return this.openSaveDialog(function() {
      var fileName, filePath;

      filePath = "/Users/" + nickname + "/Documents/UMLGenerator";
      fileName = "" + (_this.inputFileName.getValue()) + ".jpg";
      _this.lastSavedFilePath = filePath + "/" + fileName;
      _this.doKiteRequest("mkdir -p " + filePath + " ; cd " + filePath + " ; curl -o \"" + fileName + "\" " + _this.UMLImagePath, function(res) {
        return new KDNotificationView({
          type: "mini",
          title: "Your UML diagram has been saved!",
          cssClass: "success"
        }, _this.openFolders());
      });
      return _this.saveDialog.hide();
    });
  };

  UMLGenerator.prototype.saveCode = function() {
    var _this = this;

    return this.openSaveDialog(function() {
      var fileName, filePath;

      filePath = "/Users/" + nickname + "/Documents/UMLGenerator";
      fileName = "" + (_this.inputFileName.getValue()) + ".uml";
      _this.lastSavedFilePath = filePath + "/" + fileName;
      return _this.doKiteRequest("mkdir -p " + filePath + " ; cd " + filePath + " ; echo " + (FSHelper.escapeFilePath(_this.editorSession.getValue())) + " > " + fileName, function(res) {
        new KDNotificationView({
          type: "mini",
          cssClass: "success",
          title: "Your UML code has been saved!"
        }, _this.openFolders());
        return _this.saveDialog.hide();
      });
    });
  };

  UMLGenerator.prototype.reset = function() {
    this.editorSession.setValue(this.sampleUMLCode);
    document.getElementById("uml").setAttribute("src", this.sampleUMLImagePath);
    return this.UMLImagePath = this.sampleUMLImagePath;
  };

  UMLGenerator.prototype.open = function(path) {
    var ext,
      _this = this;

    ext = KD.utils.getFileExtension(path);
    if (ext !== "uml") {
      return new KDNotificationView({
        type: "mini",
        cssClass: "error",
        title: "Dropped item must have .uml extension",
        duration: 3000
      });
    } else {
      return this.doKiteRequest("cat " + path, function(res) {
        return _this.openUML(res);
      });
    }
  };

  UMLGenerator.prototype.openUML = function(umlCode) {
    this.editorSession.setValue(umlCode);
    return this.generateUML();
  };

  UMLGenerator.prototype.openSaveDialog = function(callback) {
    var form, inputFileName, labelFileName, saveDialog, wrapper,
      _this = this;

    this.addSubView(this.saveDialog = saveDialog = new KDDialogView({
      cssClass: "save-as-dialog",
      duration: 200,
      topOffset: 0,
      overlay: true,
      height: "auto",
      buttons: {
        Save: {
          style: "modal-clean-gray",
          callback: function() {
            return callback(_this.inputFileName.getValue());
          }
        },
        Cancel: {
          style: "modal-cancel",
          callback: function() {
            return saveDialog.hide();
          }
        }
      }
    }));
    saveDialog.addSubView(wrapper = new KDView({
      cssClass: "kddialog-wrapper"
    }));
    wrapper.addSubView(form = new KDFormView);
    form.addSubView(labelFileName = new KDLabelView({
      title: "Filename: (file will be saved into ~/Documents/UMLGenerator/)"
    }));
    form.addSubView(this.inputFileName = inputFileName = new KDInputView({
      label: labelFileName,
      defaultValue: "my-uml"
    }));
    saveDialog.show();
    return inputFileName.setFocus();
  };

  UMLGenerator.prototype.generateUML = function() {
    var _this = this;

    this.loader.show();
    this.umlView.addSubView(this.loaderView = new KDView({
      cssClass: "uml-generator-loader-view"
    }));
    return this.doKiteRequest("curl -d img='" + (this.editorSession.getValue()) + "' https://acet.koding.com/.applications/umlgenerator/resources/uml-gen.php", function(res) {
      document.getElementById("uml").setAttribute("src", KD.utils.proxifyUrl(res));
      _this.UMLImagePath = res;
      return KD.utils.wait(1000, function() {
        _this.loader.hide();
        return _this.loaderView.destroy();
      });
    });
  };

  UMLGenerator.prototype.openFolders = function() {
    var docRoot, files, finderController, root, treeController,
      _this = this;

    root = "/Users/" + nickname;
    docRoot = "" + root + "/Documents";
    files = [root, docRoot, "" + docRoot + "/UMLGenerator"];
    finderController = KD.getSingleton('finderController');
    treeController = finderController.treeController;
    return finderController.multipleLs(files, function(err, res) {
      var fsItems;

      fsItems = FSHelper.parseLsOutput(files, res);
      treeController.addNodes(fsItems);
      return treeController.selectNode(treeController.nodes[_this.lastSavedFilePath]);
    });
  };

  UMLGenerator.prototype.doKiteRequest = function(command, callback) {
    var _this = this;

    return KD.getSingleton('kiteController').run(command, function(err, res) {
      var _ref, _ref1;

      if (!err) {
        if (callback) {
          return callback(res);
        }
      } else {
        new KDNotificationView({
          title: "An error occured while processing your request, try again please!",
          type: "mini",
          cssClass: "error",
          duration: 3000
        });
        if ((_ref = _this.loader) != null) {
          _ref.hide();
        }
        return (_ref1 = _this.loaderView) != null ? _ref1.destroy() : void 0;
      }
    });
  };

  UMLGenerator.prototype.pistachio = function() {
    return "{{> this.header }}\n{{> this.baseView }}";
  };

  return UMLGenerator;

})(JView);
/* BLOCK STARTS: /home/fatihacet/Applications/UMLGenerator.kdapp/index.coffee */
require(["ace/ace"], function(Ace) {
  var umlGenerator;

  umlGenerator = new UMLGenerator({
    ace: Ace
  });
  return appView.addSubView(umlGenerator);
});

/* KDAPP ENDS */
}).call();