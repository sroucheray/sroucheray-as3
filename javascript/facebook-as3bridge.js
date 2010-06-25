(function(){
	/* Requires customization */
	//The id of the SWF
	var _as_swf_name = "";
	//You facebook api key
	var _apiKey = "";
	/* End customisation */
	
	if(!window.FBBridge) {
		window.FBBridge = {};
	}

	//Generic method to call a ActionScript method
	function handleResponse(response) {
		if (arguments.length > 0) {
			document[_as_swf_name]["callBack"](response);
		} else {
			document[_as_swf_name]["callBack"]();
		}
	};

	FBBridge.loadFacebook = function(local){
		var aLocal = local || "en_US";
		var e = document.createElement('script'); e.async = "true";
		e.src = document.location.protocol + '//connect.facebook.net/'+aLocal+'/all.js';
		
		var div = document.createElement('div');
		div.setAttribute("id", "fb-root");
		document.getElementsByTagName("body")[0].appendChild(div);
		div.appendChild(e);
	};

	FBBridge.getLoginStatus = function(){
		FB.getLoginStatus(handleResponse);
	};

	FBBridge.login = function(options){
		 FB.login(handleResponse, options);
	};

	FBBridge.logout = function(){
		 FB.logout(handleResponse);
	};

	FBBridge.api = function(path, method, params){
		 FB.api(path, method, params, handleResponse);
	};

	FBBridge.ui = function(params){
		 FB.ui(params, handleResponse);
	};

	window.fbAsyncInit = function() {
		FB.init({appId: _apiKey, status: true, cookie: true, xfbml: true});
		/* FB.Event.subscribe('auth.sessionChange', function(response) {
			 if (response.session) {
			   // A user has logged in, and a new cookie has been saved
			 } else {
			   // The user has logged out, and the cookie has been cleared
			 }
		 });*/

		handleResponse();
	};
})();