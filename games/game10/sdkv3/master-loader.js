"use strict";

var scripts = document.getElementsByTagName("script"),
    scriptUrl = scripts[scripts.length - 1].src,
    root = scriptUrl.split("/master-loader.js")[0],
    loaders = {
        unity: "/unity.js",
        "unity-2020": "/unity-2020.js"
    };

if (
    0 <= window.location.href.indexOf("pokiForceLocalLoader") &&
    (
        loaders.unity = "/unity.js",
        root = "/loaders"
    )
) {}

if (!window.config) throw Error("window.config not found");

var loader = loaders[window.config.loader];

if (!loader) throw Error('Loader "' + window.config.loader + '" not found');

if (!window.config.unityWebglLoaderUrl) {
    window.config.unityWebglLoaderUrl = root + "/UnityLoader.js";
}

var sdkScript = document.createElement("script");

sdkScript.src = root + "/poki-sdk.js";

sdkScript.onload = function() {
    var i = document.createElement("script");
    i.src = root + loader;
    document.body.appendChild(i);
};

document.body.appendChild(sdkScript);
