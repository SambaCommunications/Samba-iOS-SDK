function createUnrulyPlayer() {
    if (window.addEventListener) {
        addEventListener("message", onCallbackMessage);
    } else {
        attachEvent("onmessage", onCallbackMessage);
    }
}

var ios = null;

function setupDelegate(delegate) {
    this.ios = delegate
}

function onCallbackMessage(event) {
    console.log(event);
    var action=event.data;
    console.log(action);
    switch (action) {
        case eventType.ContentReady.toString():
            console.log("Content Ready");
            ios.adImpression();
            break;
        case eventType.PlayStarted.toString():
            console.log("Ad started");
            ios.adStarted();
            break;
        case eventType.AdVideoFirstQuartile.toString():
            ios.adVideoFirstQuartile();
            break;
        case eventType.AdVideoMidpoint.toString():
            ios.adVideoMidPoint();
            break;
        case eventType.AdVideoThirdQuartile.toString():
            ios.adVideoThirdQuartile();
            break;
        case eventType.PlayCompleted.toString():
            ios.adCompleted();
            break;
        case eventType.AdClicked.toString():
            ios.adClicked();
            break;
    }
}
