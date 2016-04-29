package colabora.display 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaMensagem extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;
		private var _btOK:Sprite;
		private var _btCancel:Sprite;
		private var _texto:TextField;
		private var _cor:int;
		
		public function TelaMensagem(w:Number, h:Number, btok:Sprite, btcancel:Sprite, corBG:int = 0, corTexto:int = 0xFFFFFF) 
		{
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, w, h);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// botões
			this._btOK = btok;
			this._btOK.addEventListener(MouseEvent.CLICK, onOk);
			this.addChild(this._btOK);
			this._btCancel = btcancel;
			this._btCancel.addEventListener(MouseEvent.CLICK, onCancel);
			this.addChild(this._btCancel);
			
			// texto
			this._texto = new TextField();
			this._texto.defaultTextFormat = new TextFormat('_sans', 40, corTexto);
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this._texto.selectable = false;
			this._texto.x = this._texto.y = 30;
			this._cor = corTexto;
			this.addChild(this._texto);
			
			// definindo tamanho de botões e texto
			var tamanho:Number;
			var intervalo:Number;
			
			if (w > h) { // retrato
				tamanho = h / 7;
				intervalo = ((2 * (h / 7)) / 6);
				
				this._btCancel.width = this._btCancel.height = tamanho;
				this._btOK.width = this._btOK.height = tamanho;
				
				this._btOK.x = w - 10 - this._btOK.width;
				this._btOK.y = h - intervalo - this._btOK.height;
				this._btCancel.x = w - 10 - this._btCancel.width;
				this._btCancel.y = this._btOK.y - intervalo - this._btCancel.height;
				
				this._texto.width = w - 50 - this._btCancel.width;
				this._texto.height = h - 60;
				
			} else {
				tamanho = w / 7;
				intervalo = ((2 * (w / 7)) / 6);
				
				this._btCancel.width = this._btCancel.height = tamanho;
				this._btOK.width = this._btOK.width = tamanho;
				
				this._btCancel.x = 10;
				this._btCancel.y = h - 10 - this._btCancel.height;
				this._btOK.x = w - 10 - this._btOK.width;
				this._btOK.y = h - 10 - this._btOK.height;
				
				this._texto.width = w - 60;
				this._texto.height = h - 50 - this._btCancel.height;
			}
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Define a mensagem a ser exibida
		 * @param	para	o novo texto a ser exibido
		 * @param	mostrarCancel	mostrar o botão cancelar?
		 */
		public function defineMensagem(para:String, mostrarCancel:Boolean = false):void
		{
			this._texto.htmlText = para;
			this._btCancel.visible = mostrarCancel;
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Clique no botão OK.
		 */
		private function onOk(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Clique no botão cancelar.
		 */
		private function onCancel(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CANCEL));
		}
		
	}

}