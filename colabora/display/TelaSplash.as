package colabora.display 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaSplash extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _cor:Shape;					// cor de fundo
		private var _tempo:int;					// tempo para retirada da tela (em segundos)
		private var _video:Video;				// display de vídeo
		private var _connection:NetConnection;	// conexão para o vídeo
		private var _stream:NetStream;			// acesso ao vídeo
		
		public function TelaSplash(tp:int = 1) 
		{
			this._tempo = tp;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function resize():void
		{
			if ((this._video != null) && (this.stage != null)) {
				if (this.stage.stageWidth > this.stage.stageHeight) {
					this._video.height = this.stage.stageHeight;
					this._video.width = 1280 * (this._video.height / 720);
				} else {
					this._video.width = this.stage.stageWidth;
					this._video.height = 1280 * (this._video.width / 720);
				}
				this._video.x = (this.stage.stageWidth - this._video.width) / 2;
				this._video.y = (this.stage.stageHeight - this._video.height) / 2;
			}
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * A tela ficou disponível.
		 * @param	evt
		 */
		private function onStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// criando vídeo
			this._video = new Video();
			
			// criando conexão para video
			this._connection = new NetConnection();
			this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this._connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this._connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._connection.connect(null);
			
			// preparando fluxo de vídeo
			this._stream = new NetStream(this._connection);
			this._stream.checkPolicyFile = true;
			this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			var clientObj:Object = {
				'onMetaData': this.metadataEvent,
				'onImageData': this.imagedataEvent,
				'onPlayStatus': this.playstatusEvent,
				'onCuePoint': this.cuepointEvent
				};
			this._stream.client = clientObj;
			
			// adicionando fluxo ao display de vídeo
			this._video.attachNetStream(this._stream);
			
			// ajustando fundo
			this._cor = new Shape();
			this._cor.graphics.beginFill(0xFFFFFF);
			this._cor.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this._cor.graphics.endFill();
			this.addChild(this._cor);
			
			// tocando o vídeo
			this._stream.play(File.applicationDirectory.resolvePath('splash.mp4').url);
		}
		
		/**
		 * O tempo da tela splash terminou.
		 */
		private function sair():void
		{
			if (this.parent != null) this.parent.removeChild(this);
			this.removeChildren();
			this._cor.graphics.clear();
			this._cor = null;
			this._video.attachNetStream(null);
			this._video = null;
			this._connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this._connection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this._connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._connection = null;
			//this._stream.client = null;
			this._stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this._stream = null;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Net status event.
		 */
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case 'NetStream.Play.Start':
					// ajustar tamanho do vídeo
					if (this.stage.stageWidth > this.stage.stageHeight) {
						this._video.height = this.stage.stageHeight;
						this._video.width = 1280 * (this._video.height / 720);
					} else {
						this._video.width = this.stage.stageWidth;
						this._video.height = 1280 * (this._video.width / 720);
					}
					this._video.x = (this.stage.stageWidth - this._video.width) / 2;
					this._video.y = (this.stage.stageHeight - this._video.height) / 2;
					this._video.smoothing = true;
					this.addChild(this._video);
					// preparar a saída do splash
					setTimeout(sair, this._tempo * 1000);
					break;
			}
		}
		
		/**
		 * IO error event.
		 */
		private function ioErrorHandler(evt:IOErrorEvent):void {
			trace ('vídeo splash não encontrado');
			this.sair();
		}
		
		/**
		 * Security error event.
		 */
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			trace ('falha de segurança ao acessar vídeo splash');
			this.sair();
		}
		
		/**
		 * Async error event.
		 */
		private function asyncErrorHandler(evt:AsyncErrorEvent):void { 
			trace ('falha de sincronia ao acessar vídeo splash');
			this.sair();
		}
			
		/**
		 * Metadata received.
		 */
		private function metadataEvent(data:Object):void { }
		
		/**
		 * Image data received.
		 */
		private function imagedataEvent(data:Object):void { }
		
		/**
		 * Playstatus data received.
		 */
		private function playstatusEvent(data:Object):void { }
		
		/**
		 * Cuepoint data received.
		 */
		private function cuepointEvent(data:Object):void { }
	}

}