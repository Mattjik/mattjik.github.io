// Local stand-in for Poki's SDK and Unity bridge, so the game runs entirely from this site.
(function () {
  var unity = null;
  var queue = [];
  var bridgeObject = null;

  function send(method, value) {
    if (!bridgeObject) return;
    if (unity) {
      value === undefined ? unity.SendMessage(bridgeObject, method) : unity.SendMessage(bridgeObject, method, value);
    } else {
      queue.push([method, value]);
    }
  }

  window.setUnityInstance = function (instance) {
    unity = instance;
    var pending = queue;
    queue = [];
    pending.forEach(function (m) { send(m[0], m[1]); });
  };

  var noop = function () {};
  window.PokiSDK = {
    init: function () { return Promise.resolve(); },
    setDebug: noop,
    gameLoadingStart: noop,
    gameLoadingProgress: noop,
    gameLoadingFinished: noop,
    gameplayStart: noop,
    gameplayStop: noop,
    commercialBreak: function () { return Promise.resolve(); },
    rewardedBreak: function () { return Promise.resolve(true); },
    shareableURL: function () { return Promise.resolve(location.href); },
    getURLParam: function (name) { return new URLSearchParams(location.search).get(name) || ""; },
    getLanguage: function () { return (navigator.language || "en").split("-")[0]; },
    isAdBlocked: function () { return false; },
    displayAd: noop,
    destroyAd: noop,
    customEvent: noop,
    measure: noop,
    movePill: noop,
    logError: function (e) { console.warn("[game]", e); },
    openExternalLink: function (url) { window.open(url, "_blank", "noopener"); return ""; },
    happyTime: noop,
  };

  window.initPokiBridge = function (gameObjectName) {
    bridgeObject = gameObjectName;
    window.commercialBreak = function () {
      send("commercialBreakCompleted");
    };
    window.rewardedBreak = function () {
      send("rewardedBreakCompleted", "true");
    };
    window.shareableURL = function () {
      send("shareableURLResolved", location.href);
    };
    // Tell the game the "SDK" is ready.
    setTimeout(function () { send("ready"); }, 0);
  };
})();
