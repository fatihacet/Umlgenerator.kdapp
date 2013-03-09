// Compiled by Koding Servers at Fri Mar 08 2013 20:08:28 GMT-0800 (PST) in server time

(function() {

/* KDAPP STARTS */

/* BLOCK STARTS /Source: /Users/fatihacet/Applications/UMLGenerator.kdapp/uml-samples.coffee */

var getClass, getHello, getSkinned;

getSkinned = function() {
  return "skinparam backgroundColor #EEEBDC\n\nskinparam sequence {\n  ArrowColor DeepSkyBlue\n  ActorBorderColor DeepSkyBlue\n  LifeLineBorderColor blue\n  LifeLineBackgroundColor #A9DCDF\n  \n  ParticipantBorderColor DeepSkyBlue\n  ParticipantBackgroundColor DodgerBlue\n  ParticipantFontName Impact\n  ParticipantFontSize 17\n  ParticipantFontColor #A9DCDF\n  \n  ActorBackgroundColor aqua\n  ActorFontColor DeepSkyBlue\n  ActorFontSize 17\n  ActorFontName Aapex\n}\n\nactor User\nparticipant \"First Class\" as A\nparticipant \"Second Class\" as B\nparticipant \"Last Class\" as C\n\nUser -> A: DoWork\nactivate A\n\nA -> B: Create Request\nactivate B\n\nB -> C: DoWork\nactivate C\nC --> B: WorkDone\ndestroy C\n\nB --> A: Request Created\ndeactivate B\n\nA --> User: Done\ndeactivate A";
};

getHello = function() {
  return "Developer -> Koding : Koding is Amazing\n\nDeveloper <- Koding : Welcome to Koding!";
};

getClass = function() {
  return "abstract class AbstractList\nabstract AbstractCollection\ninterface List\ninterface Collection\n\nList <|-- AbstractList\nCollection <|-- AbstractCollection\n\nCollection <|- List\nAbstractCollection <|- AbstractList\nAbstractList <|-- ArrayList\n\nclass ArrayList {\n  Object[] elementData\n  size()\n}\n\nenum TimeUnit {\n  DAYS\n  HOURS\n  MINUTES\n}";
};


/* BLOCK ENDS */



/* BLOCK STARTS /Source: /Users/fatihacet/Applications/UMLGenerator.kdapp/index.coffee */

var UMLGenerator, nickname,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

KD.enableLogs();

nickname = KD.whoami().profile.nickname;

UMLGenerator = (function(_super) {

  __extends(UMLGenerator, _super);

  function UMLGenerator(options) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "uml-generator";
    UMLGenerator.__super__.constructor.call(this, options);
    this.header = new KDHeaderView({
      cssClass: "uml-generator-header-view",
      type: "small"
    });
    this.header.addSubView(this.resetButton = new KDButtonView({
      title: "Reset",
      cssClass: "editor-button uml-reset-button",
      callback: function() {
        return _this.reset();
      }
    }));
    this.header.addSubView(this.saveCodeButton = new KDButtonView({
      title: "Save Code",
      cssClass: "editor-button uml-save-code-button",
      callback: function() {
        return _this.saveCode();
      }
    }));
    this.header.addSubView(this.saveButton = new KDButtonView({
      title: "Save Output",
      cssClass: "editor-button uml-save-button",
      callback: function() {
        return _this.saveUML();
      }
    }));
    this.header.addSubView(this.generateButton = new KDButtonView({
      title: "Generate",
      cssClass: "editor-button uml-generate-button",
      callback: function() {
        return _this.generateUML();
      }
    }));
    this.header.addSubView(this.samples = new KDButtonViewWithMenu({
      title: "Sample UML Codes",
      cssClass: "uml-samples-button editor-button",
      callback: function() {
        return _this.reset();
      },
      menu: function() {
        return {
          "Hello Koding": function() {
            var _this = this;
            return {
              callback: function() {
                return _this.reset();
              }
            };
          },
          "Skinned Sequence Diagram": {
            callback: function() {
              return _this.openUML(getSkinned());
            }
          },
          "Class Diagram": {
            callback: function() {
              return _this.openUML(getClass());
            }
          }
        };
      }
    }));
    this.header.addSubView(this.openTip = new KDCustomHTMLView({
      partial: "?",
      cssClass: "editor-button uml-question-mark",
      tooltip: {
        title: "You can open saved .uml files <br /> by dragging over the editor.",
        placement: "bottom"
      }
    }));
    this.ace = options.ace;
    this.aceView = new KDView;
    this.UMLImagePath = "https://api.koding.com/1.0/image.php?url=http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmWZ4oYnKSSnEhW4mkBXUuGXjTXCBmr9pa_DnKXP9yg9WY0000";
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
    this.aceEditor.setTheme("ace/theme/monokai");
    this.editorSession = this.aceEditor.getSession();
    this.editorSession.setMode("ace/mode/text");
    this.editorSession.setValue(this.sampleUMLCode);
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
      _this.doKiteRequest("mkdir -p " + filePath + " ; cd " + filePath + " ; curl -o \"" + fileName + "\" " + _this.UMLImagePath, function(res) {
        return new KDNotificationView({
          type: "mini",
          title: "Your UML diagram has been saved!"
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
      return _this.doKiteRequest("mkdir -p " + filePath + " ; cd " + filePath + " ; echo " + (FSHelper.escapeFilePath(_this.editorSession.getValue())) + " > " + fileName, function(res) {
        new KDNotificationView({
          type: "mini",
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
        title: "Dropped item must have .uml extension",
        duration: 3000,
        type: "mini"
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
      defaultValue: "sample-uml"
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
    return this.doKiteRequest("curl -d img='" + (this.editorSession.getValue()) + "' https://fatihacet.koding.com/.applications/umlgenerator/resources/uml-gen.php", function(res) {
      document.getElementById("uml").setAttribute("src", res);
      _this.UMLImagePath = res;
      return KD.utils.wait(1000, function() {
        _this.loader.hide();
        return _this.loaderView.destroy();
      });
    });
  };

  UMLGenerator.prototype.openFolders = function() {
    var docRoot, files, finderController, root,
      _this = this;
    root = "/Users/" + nickname;
    docRoot = root + "/Documents";
    files = [root, docRoot, "" + docRoot + "/UMLGenerator"];
    finderController = KD.getSingleton('finderController');
    return finderController.multipleLs(files, function(err, res) {
      var fsItems;
      fsItems = FSHelper.parseLsOutput(files, res);
      return finderController.treeController.addNodes(fsItems);
    });
  };

  UMLGenerator.prototype.doKiteRequest = function(command, callback) {
    var _this = this;
    return KD.getSingleton('kiteController').run(command, function(err, res) {
      if (!err) {
        if (callback) {
          return callback(res);
        }
      } else {
        return new KDNotificationView({
          title: "An error occured while processing your request, try again please!",
          duration: 3000
        });
      }
    });
  };

  UMLGenerator.prototype.pistachio = function() {
    return "{{> this.header}}\n{{> this.baseView}}";
  };

  return UMLGenerator;

})(JView);

(function() {
  return require(["ace/ace"], function(Ace) {
    return appView.addSubView(new UMLGenerator({
      ace: Ace
    }));
  });
})();


/* BLOCK ENDS */

/* KDAPP ENDS */

}).call();