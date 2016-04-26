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
		
		public function TelaMensagem(btok:Sprite, btcancel:Sprite, corBG:int = 0, corTexto:int = 0xFFFFFF) 
		{
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, 100, 100);
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
			this._texto.defaultTextFormat = new TextFormat('_sans', 20, corTexto);
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this._texto.selectable = false;
			this._texto.x = this._texto.y = 10;
			this._cor = corTexto;
			this.addChild(this._texto);
			
			// verificando exibição
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
			this._texto.htmlText = para;
			this._btCancel.visible = mostrarCancel;
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Mensagem adicionada à tela.
		 */
		private function onStage(evt:Event):void
		{
			// fundo
			this._bg.width = stage.stageWidth;
			this._bg.height = stage.stageHeight;
			
			// definindo tamanho de botões e texto
			var tamanho:Number;
			var intervalo:Number;
			var tamTexto:int;
			if (this.stage.stageWidth > this.stage.stageHeight) { // retrato
				tamanho = stage.stageHeight / 7;
				intervalo = ((2 * (stage.stageHeight / 7)) / 6);
				tamTexto = int(Math.ceil(stage.stageWidth / 40));
				
				this._btCancel.width = this._btCancel.height = tamanho;
				this._btOK.width = this._btOK.height = tamanho;
				
				this._btOK.x = stage.stageWidth - 10 - this._btOK.width;
				this._btOK.y = stage.stageHeight - intervalo - this._btOK.height;
				this._btCancel.x = stage.stageWidth - 10 - this._btCancel.width;
				this._btCancel.y = this._btOK.y - intervalo - this._btCancel.height;
				
				this._texto.defaultTextFormat = new TextFormat('_sans', tamTexto, this._cor);
				this._texto.width = stage.stageWidth - 30 - this._btCancel.width;
				this._texto.height = stage.stageHeight - 20;
				
			} else {
				tamanho = stage.stageWidth / 7;
				intervalo = ((2 * (stage.stageWidth / 7)) / 6);
				tamTexto = int(Math.ceil(stage.stageHeight / 40));
				
				this._btCancel.width = this._btCancel.height = tamanho;
				this._btOK.width = this._btOK.width = tamanho;
				
				this._btCancel.x = 10;
				this._btCancel.y = stage.stageHeight - 10 - this._btCancel.height;
				this._btOK.x = stage.stageWidth - 10 - this._btOK.width;
				this._btOK.y = stage.stageHeight - 10 - this._btOK.height;
				
				this._texto.defaultTextFormat = new TextFormat('_sans', tamTexto, this._cor);
				this._texto.width = stage.stageWidth -20;
				this._texto.height = stage.stageHeight - 30 - this._btCancel.height;
			}
			
			// texto
			
		}
		
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