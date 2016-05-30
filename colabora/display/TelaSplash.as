package colabora.display 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaSplash extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _fundo:Bitmap;		// imagem de fundo
		private var _cor:Shape;			// cor de fundo
		private var _tempo:int;			// tempo para retirada da tela (em segundos)
		
		public function TelaSplash(gr:Bitmap, tp:int = 1) 
		{
			this._fundo = gr;
			this._tempo = tp;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * A tela ficou disponível.
		 * @param	evt
		 */
		private function onStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			this._fundo.width = this.stage.stageWidth;
			this._fundo.scaleY = this._fundo.scaleX;
			if (this._fundo.height > this.stage.stageHeight) {
				this._fundo.height = this.stage.stageHeight;
				this._fundo.scaleX = this._fundo.scaleY;
			}
			this._fundo.x = (this.stage.stageWidth - this._fundo.width) / 2;
			this._fundo.y = (this.stage.stageHeight - this._fundo.height) / 2;
			
			this._cor = new Shape();
			this._cor.graphics.beginFill(0);
			this._cor.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this._cor.graphics.endFill();
			
			this.addChild(this._cor);
			this.addChild(this._fundo);
			
			setTimeout(sair, this._tempo * 1000);
		}
		
		/**
		 * O tempo da tela splash terminou.
		 */
		private function sair():void
		{
			if (this.parent != null) this.parent.removeChild(this);
			this.removeChildren();
			this._fundo.bitmapData.dispose();
			this._fundo = null;
			this._cor.graphics.clear();
			this._cor = null;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
	}

}