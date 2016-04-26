var bindFacebookEvents,
    initializeFacebookSDK,
    loadFacebookSDK,
    restoreFacebookRoot,
    saveFacebookRoot;

bindFacebookEvents = function() {
  $(document).on('turbolinks:request-start', saveFacebookRoot)
             .on('turbolinks:load', restoreFacebookRoot)
             .on('turbolinks:load', function() {
    return typeof FB !== "undefined" && FB !== null ? FB.XFBML.parse() : void 0;
  });
  return this.fbEventsBound = true;
};

saveFacebookRoot = function() {
  if ($('#fb-root').length) {
    return this.fbRoot = $('#fb-root').detach();
  }
};

restoreFacebookRoot = function() {
  if (this.fbRoot != null) {
    if ($('#fb-root').length) {
      return $('#fb-root').replaceWith(this.fbRoot);
    } else {
      return $('body').append(this.fbRoot);
    }
  }
};

loadFacebookSDK = function() {
  window.fbAsyncInit = initializeFacebookSDK;
  return $.getScript("//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5");
};

initializeFacebookSDK = function() {
  return FB.init({
    appId: '1096980653700006',
    version : 'v2.5',
    status: true,
    cookie: true,
    xfbml: true
  });
};
