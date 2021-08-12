
var open = XMLHttpRequest.prototype.open;

XMLHttpRequest.prototype.open = function() {
    this.addEventListener("load", function() {
        if (this.responseURL.includes("get_lyrics.ajax")) {
            var message = { "status" : this.status, "responseURL" : this.responseURL, "response" : this.response };
            webkit.messageHandlers.handler.postMessage(message);
        }
    });
    open.apply(this, arguments);
};
