package  colabora.qrcode {
	
	// FLASH PACKAGES
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	// QRCODE
	import com.davikingcode.nativeExtensions.zxing.ZXing;
	import com.davikingcode.nativeExtensions.zxing.ZXingEvent;
	
	
	public class QrCodeReader extends Sprite {
		
		// CONSTANTS
		
		private const INTERVAL:uint = 3000;		// data read interval (milliseconds)
		
		// VARIABLES
		
		private var _bg:Shape;					// dark background
		private var _video:Video;				// display video
		private var _camera:Camera;				// input camera
		private var _data:BitmapData;			// bitmap data read from camera
		private var _interval:int;				// bitmap fetch interval
		private var _zxing:ZXing;				// qrcode parser
		private var _parser:Function;			// link parser
		private var _automatic:Boolean;			// automatically run any progress code found?
		private var _closebt:Sprite;			// the close button
		
		/**
		 * QRCodeReader constructor.
		 * @param	w	screen width
		 * @param	h	screen height
		 */
		public function QrCodeReader(w:Number, h:Number, parser:Function, closebt:Sprite, automatic:Boolean = true) {
			super();
			// create background
			this._bg = new Shape();
			this._bg.graphics.beginFill(0x000000);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			// create video
			this._video = new Video(960, 540);
			this._video.smoothing = true;
			this.addChild(this._video);
			// prepare data
			this._interval = -1;
			this._data = new BitmapData(this._video.width, this._video.height);
			// prepare parser
			this._zxing = new ZXing();
			// close button
			this._closebt = closebt;
			this.addChild(this._closebt);
			// place images
			this.resize(w, h);
			// set progress code parser
			this._parser = parser;
			this._automatic = automatic;
		}
		
		// PUBLIC METHODS
		
		/**
		 * Start qrcode reading and display interface.
		 */
		public function startReading(w:int = 960, h:int = 540, fps:int = 10):void {
			// prepare camera and video
			this._camera = Camera.getCamera();
			this._camera.setMode(w, h, fps);
			this._video.attachCamera(this._camera);
			// keep checking recorded image for qrcodes
			if (this._interval >= 0) {
				try {
					clearInterval(this._interval);
				} catch (e:Error) { /* do nothing */ }
			}
			this._interval = setInterval(this.fetchImage, INTERVAL);
			this._zxing.addEventListener(ZXingEvent.SUCCESS, onZXingScan);
			this._zxing.addEventListener(ZXingEvent.FAIL, onZXingScan);
			this._closebt.addEventListener(MouseEvent.CLICK, onCloseBT);
		}
		
		/**
		 * Resize the qrcode reading interface;
		 * @param	w	stage width
		 * @param	h	stage height
		 */
		public function resize(w:Number, h:Number):void {
			this._bg.width = w;
			this._bg.height = h;
			this._video.width = uint(Math.round(w));
			this._video.height = uint(Math.round(w * 9 / 16));
			if (this._video.height > h) {
				this._video.height = uint(Math.round(h));
				this._video.width = uint(Math.round(h * 16 / 9));
			}
			this._video.x = (w - this._video.width) / 2;
			this._video.y = (h - this._video.height) / 2;
			if (this._data != null) {
				this._data.dispose();
				this._data = null;
			}
			this._data = new BitmapData(this._video.width, this._video.height);
			this._closebt.x = w - this._closebt.width - 10;
			this._closebt.y = h - this._closebt.height - 10;
		}
		
		/**
		 * Close qrcode reading interface and stop parsing.
		 * @param	dispatch	dispatch the close event?
		 */
		public function close(dispatch:Boolean =  true):void {
			if (this._interval >= 0) {
				try {
					clearInterval(this._interval);
				} catch (e:Error) { /* do nothing */ }
			}
			this._interval = -1;
			this._video.attachCamera(null);
			if (this._zxing.hasEventListener(ZXingEvent.SUCCESS)) this._zxing.removeEventListener(ZXingEvent.SUCCESS, onZXingScan);
			if (this._zxing.hasEventListener(ZXingEvent.FAIL)) this._zxing.removeEventListener(ZXingEvent.FAIL, onZXingScan);
			if (this._closebt.hasEventListener(MouseEvent.CLICK))  this._closebt.removeEventListener(MouseEvent.CLICK, onCloseBT);
			this._camera = null;
			if (dispatch) this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		// PRIVATE METHODS
		
		/**
		 * Fetch an image from video and try to parse it.
		 */
		private function fetchImage():void {
			// fetch bitmap from video
			this._data.draw(this._video);
			this._zxing.decodeFromBitmapData(this._data);
		}
		
		/**
		 * The qrcode parse for a fetched image was finished.
		 * @param	evt	information about the parsing result
		 */
		private function onZXingScan(evt:ZXingEvent):void {
			if (evt.type == ZXingEvent.SUCCESS) {
				this._parser(evt.url);
			}
		}
		
		/**
		 * Close button was pressed.
		 */
		private function onCloseBT(evt:MouseEvent):void {
			this.close();
		}
	}

}