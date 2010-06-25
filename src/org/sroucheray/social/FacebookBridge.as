package org.sroucheray.social {
	import org.osflash.thunderbolt.Logger;

	import flash.external.ExternalInterface;

	/**
	 * Simple class to talk to Facebook new Graph API through JavaScript
	 * @see http://developers.facebook.com/docs/reference/javascript/
	 * 
	 * This class is tied to the JavaScript facebook-as3bridge.js
	 * @see http://github.com/sroucheray/sroucheray-as3/blob/master/javascript/facebook-as3bridge.js
	 * @author sroucheray
	 */
	public class FacebookBridge {
		private static var _instance : FacebookBridge;
		
		private var currentCallback : Function;

		public function FacebookBridge(pvt : PrivateClass) {
			super();
			if(pvt == null) {
				throw new Error("Error: Instantiation failed: Use FBBridge.instance instead of new.");
			}
		}
		
		/**
		 * Singleton, when using instance methods make sure to get the callback
		 * before making the next call
		 */
		public static function get instance() : FacebookBridge {
			if(!_instance) {
				_instance = new FacebookBridge(new PrivateClass());
				if(_instance.hasExternalInterface()){
					ExternalInterface.addCallback("callBack", _instance.genericCallback);
				}
			}
			return _instance;
		}
		
		/**
		 * Load facebook
		 * @param callBackFunction
		 * @param local : The language Facebook will use in UI
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.init
		 */
		public function loadFacebook(callBackFunction : Function, local : String = "en_US") : void {
			if(hasExternalInterface()){
				currentCallback = callBackFunction;
				ExternalInterface.call("FBBridge.loadFacebook", local);
			}
		}
		
		/**
		 * Get the login status
		 * @param callBackFunction
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.getLoginStatus
		 */
		public function getLoginStatus(callBackFunction : Function):void{
			if(hasExternalInterface()){
				currentCallback = callBackFunction;
				ExternalInterface.call("FBBridge.getLoginStatus");
			}
		}
		
		/**
		 * Login to Facebook
		 * @param callBackFunction
		 * @param options
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.login
		 */
		public function login(callBackFunction : Function, options : Object = null):void{
			if(hasExternalInterface()){
				currentCallback = callBackFunction;
				ExternalInterface.call("FBBridge.login", options || {});
			}
		}
		
		/**
		 * Logout from Facebook
		 * @param callBackFunction
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.logout
		 */
		public function logout(callBackFunction : Function):void{
			if(hasExternalInterface()){
				currentCallback = callBackFunction;
				ExternalInterface.call("FBBridge.logout");
			}
		}
		
		/**
		 * Call any API method
		 * @param callBackFunction
		 * @param path
		 * @param params
		 * @param method
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.api
		 */
		public function api(callBackFunction : Function, path : String, params : Object = null, method : String = "GET"):void{
			if(hasExternalInterface()){
				if(!params) params = {};
				currentCallback = callBackFunction;
				ExternalInterface.call("FBBridge.api", path, method, params);
			}
		}
		
		/**
		 * Call any Facebook UI method
		 * @param callBackFunction
		 * @param params
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.ui
		 */
		public function ui(callBackFunction : Function, params : Object = null):void{
			if(hasExternalInterface()){
				if(!params) params = {};
				currentCallback = callBackFunction;
				ExternalInterface.call("FBBridge.ui", params);
			}
		}

		private function hasExternalInterface() : Boolean {
			if(!ExternalInterface.available){
				Logger.info("ExternalInterface not available");
			}
			return ExternalInterface.available;
		}

		private function genericCallback(response : Object = null) : void {
			if(currentCallback is Function) {
				currentCallback(response);
			}
		}
	}
}

internal class PrivateClass {
}
