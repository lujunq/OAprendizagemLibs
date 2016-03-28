package colabora.oaprendizagem.servidor 
{
	import art.ciclope.managana.net.Webview;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AreaWeb extends Sprite
	{
		
		// VARIÁVEIS
		protected var _wview:Webview;			// componente webview
		protected var _resposta:Function;		// função de resposta
		private var _bg:Shape;					// fundo de imagem
		
		public function AreaWeb(w:int = 160, h:int = 90) 
		{
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(0, 0);
			this._bg.graphics.drawRect(0, 0, w, h);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// janela web
			this._wview = new Webview();
			this._wview.setViewArea(this.x, this.y, w, h);
			
			// stage
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Posição X.
		 */
		override public function get x():Number 
		{
			return super.x;
		}
		override public function set x(value:Number):void 
		{
			super.x = value;
			this._wview.setViewArea(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Posição Y.
		 */
		override public function get y():Number 
		{
			return super.y;
		}
		override public function set y(value:Number):void 
		{
			super.y = value;
			this._wview.setViewArea(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Comprimento.
		 */
		override public function get width():Number 
		{
			return super.width;
		}
		override public function set width(value:Number):void 
		{
			super.width = value;
			this._wview.setViewArea(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Largura.
		 */
		override public function get height():Number 
		{
			return super.height;
		}
		override public function set height(value:Number):void 
		{
			super.height = value;
			this._wview.setViewArea(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Libera recursos usados pelo objeto.
		 */
		public function dispose():void
		{
			this.removeChildren();
			this._bg.graphics.clear();
			this._bg = null;
			this._wview.stage = null;
			this._wview.dispose();
			this._wview = null;
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
			this._resposta = null;
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Objeto adicionado ao stage.
		 */
		private function onStage(evt:Event):void
		{
			this._wview.stage = this.stage;
		}
		
		/**
		 * Objeto removido do stage.
		 */
		private function onNoStage(evt:Event):void
		{
			this._wview.stage = null;
		}
	}

}