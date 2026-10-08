window.PokiSDK = new Proxy({}, {
  get: function (target, name) {
    if (name === "then") return undefined;
    return function () {
      if (name === "isAdBlocked") return false;
      return Promise.resolve(name === "rewardedBreak" ? true : undefined);
    };
  }
});