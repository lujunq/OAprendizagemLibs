package colabora.display 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaAjuda extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;						// fundo de imagem
		private var _paginas:Vector.<Bitmap>;		// páginas da tela de ajuda
		private var _atual:int = 0;					// página atual
		private var _prox:Sprite;					// mover para a próxima página
		private var _ant:Sprite;					// mover para a página anterior
		private var _fechar:Sprite;					// fechar tela
		private var _barra:Sprite;					// barra inferior de botões
		private var _botoes:Vector.<Sprite>;		// botões de navegação
		private var _btpg:Vector.<int>;				// páginas para os botões de navegação
		
		public function TelaAjuda(pg:Vector.<Bitmap>, prox:Sprite, ant:Sprite, fech:Sprite) 
		{
			// recebendo dados
			this._paginas = pg;
			this._atual = 0;
			
			// preparando fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(0);
			this._bg.graphics.drawRect(0, 0, 32, 32);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// adicionando a primeira imagem
			this.addChild(this._paginas[this._atual]);
			
			// botões de navegação
			this._prox = prox;
			this._ant = ant;
			this._prox.addEventListener(MouseEvent.CLICK, onProxima);
			this._ant.addEventListener(MouseEvent.CLICK, onAnterior);
			this.addChild(this._prox);
			this.addChild(this._ant);
			
			// fechar
			this._fechar = fech;
			this._fechar.addEventListener(MouseEvent.CLICK, onFechar);
			this.addChild(this._fechar);
			
			// barra inferior
			this._barra = new Sprite();
			this.addChild(this._barra);
			this._botoes = new Vector.<Sprite>();
			this._btpg = new Vector.<int>();
			
			// verificando a tela
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Muda para a próxima página.
		 */
		public function proxima():void
		{
			this._atual++;
			if (this._atual >= this._paginas.length) this._atual = this._paginas.length - 1;
			this.removeChildren();
			this.addChild(this._bg);
			this.addChild(this._paginas[this._atual]);
			this.addChild(this._prox);
			this.addChild(this._ant);
			this.addChild(this._fechar);
			this.addChild(this._barra);
			this.ajusta();
		}
		
		/**
		 * Muda para a página anterior.
		 */
		public function anterior():void
		{
			this._atual--;
			if (this._atual < 0) this._atual = 0;
			this.removeChildren();
			this.addChild(this._bg);
			this.addChild(this._paginas[this._atual]);
			this.addChild(this._prox);
			this.addChild(this._ant);
			this.addChild(this._fechar);
			this.addChild(this._barra);
			this.ajusta();
		}
		
		/**
		 * Ajusta a exibição para a página atual.
		 */
		public function ajusta():void
		{
			if (this.stage) {
				this._bg.width = this.stage.stageWidth;
				this._bg.height = this.stage.stageHeight;
				
				this._paginas[this._atual].width = this.stage.stageWidth;
				this._paginas[this._atual].scaleY = this._paginas[this._atual].scaleX;
				if (this._paginas[this._atual].height > this.stage.stageHeight) {
					this._paginas[this._atual].height = this.stage.stageHeight;
					this._paginas[this._atual].scaleX = this._paginas[this._atual].scaleY;
				}
				this._paginas[this._atual].x = (this._bg.width - this._paginas[this._atual].width) / 2;
				this._paginas[this._atual].y = (this._bg.height - this._paginas[this._atual].height) / 2;
				
				this._prox.width = this._ant.width = this.stage.stageWidth / 14;
				this._prox.scaleY = this._prox.scaleX;
				this._ant.scaleY = this._ant.scaleX;
				this._ant.x = 0;
				this._prox.x = this.stage.stageWidth - this._prox.width;
				this._ant.y = (this.stage.stageHeight - this._ant.height) / 2;
				this._prox.y = (this.stage.stageHeight - this._prox.height) / 2;
				
				this._ant.visible = true;
				this._prox.visible = true;
				
				if (this._atual == 0) this._ant.visible = false;
				if (this._atual >= (this._paginas.length - 1)) this._prox.visible = false;
				
				this._fechar.width = this.stage.stageWidth / 14;
				this._fechar.scaleY = this._fechar.scaleX;
				this._fechar.x = this.stage.stageWidth - this._fechar.width;
				this._fechar.y = 0;
				
				if (this._botoes.length > 0) {
					var intervalo:Number = this.stage.stageWidth;
					for (var i:int = 0; i < this._botoes.length; i++) {
						this._botoes[i].height = this.stage.stageHeight / 10;
						this._botoes[i].scaleX = this._botoes[i].scaleY;
						intervalo -= this._botoes[i].width;
					}
					intervalo = intervalo / (this._botoes.length + 1);
					var pos:Number = intervalo;
					for (i=0; i < this._botoes.length; i++) {
						this._botoes[i].x = pos;
						pos = this._botoes[i].x + this._botoes[i].width + intervalo;
					}
					this._barra.y = this.stage.stageHeight - this._barra.height;
				}
			}
		}
		
		/**
		 * Abre uma página.
		 * @param	num	o número da página a abrir
		 */
		public function abre(num:int):void
		{
			if ((num < this._paginas.length) && (num >= 0)) {
				this._atual = num;
				this.removeChildren();
				this.addChild(this._bg);
				this.addChild(this._paginas[this._atual]);
				this.addChild(this._prox);
				this.addChild(this._ant);
				this.addChild(this._fechar);
				this.addChild(this._barra);
				this.ajusta();
			}
		}
		
		/**
		 * Adicionando um botão de navegação.
		 * @param	gr	gráfico do botão
		 * @param	pg	página a abrir
		 */
		public function adicionaBotao(gr:Sprite, pg:int):void
		{
			this._botoes.push(gr);
			this._btpg.push(pg);
			gr.addEventListener(MouseEvent.CLICK, onBotao);
			this._barra.addChild(gr);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * A tela ficou disponível.
		 */
		private function onStage(evt:Event):void
		{
			this.ajusta();
		}
		
		/**
		 * A tela foi escondida.
		 */
		private function onNoStage(evt:Event):void
		{
			this.abre(0);
		}
		
		/**
		 * Próxima página.
		 */
		private function onProxima(evt:MouseEvent):void
		{
			this.proxima();
		}
		
		/**
		 * Página anterior.
		 */
		private function onAnterior(evt:MouseEvent):void
		{
			this.anterior();
		}
		
		/**
		 * Fechar.
		 */
		private function onFechar(evt:MouseEvent):void
		{
			this.parent.removeChild(this);
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * Clique em um botão de navegação.
		 */
		private function onBotao(evt:MouseEvent):void
		{
			var indice:int = -1;
			for (var i:int = 0; i < this._botoes.length; i++) {
				if (evt.target == this._botoes[i]) indice = i;
			}
			if (indice >= 0) {
				if (indice < this._btpg.length) this.abre(this._btpg[indice]);
			}
		}
		
	}

}