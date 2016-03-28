package art.ciclope.managana.net 
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Webview extends EventDispatcher 
	{
		
		private var _view:StageWebView;
		private var _history:Vector.<String> = new Vector.<String>();
		private var _cursor:int = -1;
		
		private var _calls:Array = new Array();
		
		public function Webview() 
		{
			this._view = new StageWebView(true);
			this._view.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onChanging);
			this._view.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onChange);
			this._view.addEventListener(ErrorEvent.ERROR, onError);
			this._view.addEventListener(Event.ACTIVATE, onActivate);
			this._view.addEventListener(Event.COMPLETE, onComplete);
			this._view.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this._view.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);;
		}
		
		public function get stage():Stage {
			return (this._view.stage);
		}
		public function set stage(to:Stage):void {
			this._view.stage = to;
		}
		
		public function get viewPort():Rectangle {
			return (this._view.viewPort);
		}
		public function set viewPort(to:Rectangle):void {
			this._view.viewPort = to;
		}
		
		public function get isHistoryBackEnabled():Boolean {
			return (this._view.isHistoryBackEnabled);
		}
		
		public function get isHistoryForwardEnabled():Boolean {
			return (this._view.isHistoryForwardEnabled);
		}
		
		public function get location():String {
			return (this._view.location);
		}
		
		public function get title():String {
			return (this._view.title);
		}
		
		public function assignFocus(direction:String = 'none'):void {
			this._view.assignFocus(direction);
		}
		
		public function setCallback(name:String, method:Function):void {
			this._calls[name] = method;
		}
		
		public function removeCallback(name:String):Boolean {
			if (this._calls[name] == null) {
				return (false);
			} else {
				delete(this._calls[name]);
				return (true);
			}
		}
		
		public function clearCallbacks():void {
			for (var index:String in this._calls) {
				delete(this._calls[index]);
			}
		}
		
		public function hasCallback(name:String):Boolean {
			return (this._calls[name] != null);
		}
		
		public function dispose():void {
			this._view.stage = null;
			this._view.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onChanging);
			this._view.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onChange);
			this._view.removeEventListener(ErrorEvent.ERROR, onError);
			this._view.removeEventListener(Event.ACTIVATE, onActivate);
			this._view.removeEventListener(Event.COMPLETE, onComplete);
			this._view.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this._view.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			this._view.dispose();
			this._view = null;
			
			this.clearCallbacks();
			this._calls = null;
		}
		
		public function drawViewPortToBitmapData(bitmap:BitmapData):void {
			this._view.drawViewPortToBitmapData(bitmap);
		}
		
		public function historyBack():void {
			this._view.historyBack();
		}
		
		public function historyForward():void {
			this._view.historyForward();
		}
		
		public function loadString(text:String, mimeType:String = "text/html"):void {
			this._view.loadString(text, mimeType);
		}
		
		public function loadURL(url:String):void {
			this._view.loadURL(url);
		}
		
		public function reload():void {
			this._view.reload();
		}
		
		public function stop():void {
			this._view.stop();
		}
		
		public function callJS(name:String, data:String):void {
			this._view.loadURL("javascript:" + name + "('" + encodeURI(data) + "');");
		}
		
		public function setViewArea(x:Number, y:Number, width:Number, height:Number):void {
			this._view.viewPort = new Rectangle(x, y, width, height);
		}
		
		private function onChanging(evt:LocationChangeEvent):void {
			if (evt.location.substr(0, 11).toLocaleLowerCase() == 'http://api/') {
				evt.preventDefault();
				try {
					var data:Object = JSON.parse(decodeURI(evt.location.substr(11)));
					if (data.ac != null) {
						if (this.hasCallback(String(data.ac))) {
							this._calls[String(data.ac)](data);
						}
					}
				} catch (e:Error) {
					// do nothing: malformed data sent
				}
				
			} else {
				this.dispatchEvent(evt.clone());
			}
		}
		
		private function onChange(evt:LocationChangeEvent):void {
			this.dispatchEvent(evt.clone());
		}
		
		private function onError(evt:ErrorEvent):void {
			this.dispatchEvent(evt.clone());
		}
		
		private function onActivate(evt:Event):void {
			this.dispatchEvent(evt.clone());
		}
		
		private function onComplete(evt:Event):void {
			this.dispatchEvent(evt.clone());
		}
		
		private function onFocusIn(evt:FocusEvent):void {
			this.dispatchEvent(evt.clone());
		}
		
		private function onFocusOut(evt:FocusEvent):void {
			this.dispatchEvent(evt.clone());
		}
		
	}

}