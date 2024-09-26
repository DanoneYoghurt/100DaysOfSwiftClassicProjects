//
//  Action.js
//  project19
//
//  Created by Антон Баскаков on 25.09.2024.
//

var Action = function() {};

Action.prototype = {

run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title });
},

finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"];
        eval(customJavaScript);
}

};

var ExtensionPreprocessingJS = new Action
