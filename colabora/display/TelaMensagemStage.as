package colabora.display 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaMensagemStage extends Sprite
	{
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;
		private var _telaMensagem:TelaMensagem;
		
		public function TelaMensagemStage(w:Number, h:Number, btok:Sprite, btcancel:Sprite, corBG:int = 0, corTexto:int = 0xFFFFFF)
		{
			// criando fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, 32, 32);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// criando tela de mensagens
			this._telaMensagem = new TelaMensagem(w, h, btok, btcancel, corBG, corTexto);
			this.addChild(this._telaMensagem);
			this._telaMensagem.addEventListener(Event.COMPLETE, onComplete);
			this._telaMensagem.addEventListener(Event.CANCEL, onCancel);
			
			// espernado a tela
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Define a mensagem a ser exibida
		 * @param	para	o novo texto a ser exibido
		 * @param	mostrarCancel	mostrar o botão cancelar?
		 */
		public function defineMensagem(para:String, mostrarCancel:Boolean = false):void
		{
			this._telaMensagem.defineMensagem(para, mostrarCancel);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * A tela está disponível.
		 */
		private function onStage(evt:Event):void
		{
			// ajustando fundo
			this._bg.width = this.stage.stageWidth;
			this._bg.height = this.stage.stageHeight;
			
			// ajustando tela
			this._telaMensagem.width = this.stage.stageWidth;
			this._telaMensagem.scaleY = this._telaMensagem.scaleX;
			if (this._telaMensagem.height > this.stage.stageHeight) {
				this._telaMensagem.height = this.stage.stageHeight;
				this._telaMensagem.scaleX = this._telaMensagem.scaleY;
			}
			this._telaMensagem.x = (this.stage.stageWidth - this._telaMensagem.width) / 2;
			this._telaMensagem.y = (this.stage.stageHeight - this._telaMensagem.height) / 2;
		}
		
		/**
		 * Clique no botão ok.
		 */
		private function onComplete(evt:Event):void
		{
			this.dispatchEvent(evt.clone());
		}
		
		/**
		 * Clique no botão cancel.
		 */
		private function onCancel(evt:Event):void
		{
			this.dispatchEvent(evt.clone());
		}
		
	}

}