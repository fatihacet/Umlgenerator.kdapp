// Compiled by Koding Servers at Tue Jan 22 2013 18:55:29 GMT-0800 (PST) in server time

(function() {

/* KDAPP STARTS */

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
      type: "small",
      title: "UML Generator"
    });
    this.buttonsView = new KDView({
      cssClass: "uml-generator-buttons-view"
    });
    this.buttonsView.addSubView(this.resetButton = new KDButtonView({
      title: "Reset",
      cssClass: "kdbutton editor-button reset-button",
      callback: function() {
        return _this.reset();
      }
    }));
    this.buttonsView.addSubView(this.generateButton = new KDButtonView({
      title: "Generate",
      cssClass: "kdbutton editor-button generate-button",
      callback: function() {
        return _this.generateUML();
      }
    }));
    this.buttonsView.addSubView(this.saveButton = new KDButtonViewWithMenu({
      cssClass: "editor-button with-menu save-button",
      title: "Save",
      menu: function() {
        return {
          "Save UML Code": {
            callback: function() {
              return _this.saveCode();
            }
          }
        };
      },
      callback: function() {
        return _this.saveUML();
      }
    }));
    this.header.addSubView(this.buttonsView);
    this.ace = options.ace;
    this.aceView = new KDView;
    this.UMLImagePath = "http://www.plantuml.com/plantuml/img/SqajIyt9BqWjKj2rK_3EJydCIrUmWZ4oYnKSSnEhW4mkBXUuGXjTXCBmr9pa_DnKXP9yg9WY0000";
    this.sampleUMLImagePath = this.UMLImagePath;
    this.sampleUMLCode = "Developer -> Koding : Koding is Amazing\n\nDeveloper <- Koding : Welcome to Koding!";
    this.umlView = new KDView({
      cssClass: "uml-generator-image",
      partial: "<img id=\"uml\" src=\"" + this.UMLImagePath + "\" />"
    });
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
  }

  UMLGenerator.prototype.saveUML = function() {
    var _this = this;
    return this.openSaveDialog(function() {
      var fileName, filePath;
      filePath = "/Users/" + nickname + "/trunk/";
      fileName = "" + (_this.inputFileName.getValue()) + ".jpg";
      _this.doKiteRequest("cd " + filePath + " ; curl -o \"" + fileName + "\" " + _this.UMLImagePath, function(res) {
        return new KDNotificationView({
          type: "mini",
          title: "Your UML diagram has been saved!"
        });
      });
      return _this.saveDialog.hide();
    });
  };

  UMLGenerator.prototype.saveCode = function() {
    var _this = this;
    return this.openSaveDialog(function() {
      var fileName, filePath;
      filePath = "/Users/" + nickname + "/trunk/";
      fileName = "" + (_this.inputFileName.getValue()) + ".uml";
      return _this.doKiteRequest("cd " + filePath + " ; echo " + (FSHelper.escapeFilePath(_this.editorSession.getValue())) + " > " + fileName, function(res) {
        new KDNotificationView({
          type: "mini",
          title: "Your UML code has been saved!"
        });
        return _this.saveDialog.hide();
      });
    });
  };

  UMLGenerator.prototype.reset = function() {
    this.editorSession.setValue(this.sampleUMLCode);
    document.getElementById("uml").setAttribute("src", this.sampleUMLImagePath);
    return this.UMLImagePath = this.sampleUMLImagePath;
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
      title: "Filename:"
    }));
    form.addSubView(this.inputFileName = inputFileName = new KDInputView({
      label: labelFileName,
      defaultValue: "sample-uml"
    }));
    saveDialog.show();
    return inputFileName.setFocus();
  };

  UMLGenerator.prototype.generateUML = function() {
    var timestamp, value,
      _this = this;
    timestamp = +new Date();
    value = "" + (FSHelper.escapeFilePath(this.editorSession.getValue()));
    return this.doKiteRequest("cd /Users/" + nickname + "/Applications/UMLGenerator.kdapp ; php uml-gen.php " + value, function(res) {
      document.getElementById("uml").setAttribute("src", res);
      return _this.UMLImagePath = res;
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