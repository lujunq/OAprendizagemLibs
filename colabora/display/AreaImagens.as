package colabora.display 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AreaImagens extends Sprite 
	{
		
		/**
		 * Largura original da área de imagem.
		 */
		public var oWidth:Number;
		
		/**
		 * Altura original da área de imagem.
		 */
		public var oHeight:Number;
		
		// VARIÁVEIS PRIVADAS
		
		private var _holder:Sprite;			// container para as imagens adicionadas
		private var _mask:Shape;			// máscara para as imagens adicionadas
		private var _bg:Shape;				// fundo da imagem
		
		public function AreaImagens(w:Number, h:Number, corBG:uint = 0) 
		{
			super();
			
			// guardando tamanho original
			this.oWidth = w;
			this.oHeight = h;
			
			// fundo da imagem
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, w, h);
			this._bg.graphics.endFill();
			super.addChild(this._bg);
			
			// container das imagens
			this._holder = new Sprite();
			super.addChild(this._holder);
			
			// máscara do container
			this._mask = new Shape();
			this._mask.graphics.beginFill(0);
			this._mask.graphics.drawRect(0, 0, w, h);
			this._mask.graphics.endFill();
			super.addChild(this._mask);
			this._holder.mask = this._mask;
		}
		
		// SOMENTE LEITURA
		
		/**
		 * Container onde as imagens são adicionadas.
		 */
		public function get container():Sprite
		{
			return (this._holder);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Adicionando imagens ao container.
		 * @param	child	a imagem a ser adicionada
		 */
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return (this._holder.addChild(child));
		}
		
		/**
		 * Removendo imagens do container.
		 * @param	child	a imagem a ser removida
		 */
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			return (this._holder.removeChild(child));
		}
		
		/**
		 * Remove todas as imagens adicionadas ao container.
		 * @param	beginIndex	índice inicial
		 * @param	endIndex	índice final
		 */
		override public function removeChildren(beginIndex:int = 0, endIndex:int = 2147483647):void 
		{
			this._holder.removeChildren(beginIndex, endIndex);
		}
		
		/**
		 * Prepara um bitmap data com a imagem atual, no tamanho original definido.
		 * @return	bitmap data com a imagem atual
		 */
		public function getBitmapData():BitmapData 
		{
			// guardando tamanho atual
			var current:Point = new Point(this.width, this.height);
			// revertendo ao tamanho definido (o da máscara)
			this.width = this._bg.width;
			this.height = this._bg.height;
			// preparando o bitmap data
			var bdata:BitmapData = new BitmapData(int(this.width), int(this.height));
			bdata.draw(this);
			// voltando ao tamanho original
			this.width = current.x;
			this.height = current.y;
			// retornando o bitmap data
			return (bdata);
		}
		
		/**
		 * Cria uma imagem a partir do conteúdo da área.
		 * @param	mode	modo da imagem (PNG ou JPG)
		 * @param	quality	qualidade da codificação (apenas para JPG, 0 a 100)
		 * @return
		 */
		public function getPicture(mode:String = 'jpg', quality:int = 80):ByteArray
		{
			mode = mode.toLowerCase();
			var bdata:BitmapData = this.getBitmapData();
			if (mode == 'png') {
				return (bdata.encode(new Rectangle(0, 0, bdata.width, bdata.height), new PNGEncoderOptions()));
			} else {
				mode = 'jpg';
				quality = int(quality);
				if (quality < 10) quality = 10;
					else if (quality > 100) quality = 100;
				return (bdata.encode(new Rectangle(0, 0, bdata.width, bdata.height), new JPEGEncoderOptions(quality)));
			}
		}
		
		/**
		 * Posiciona a área de imagem dentro de um objeto de display.
		 * @param	holder	display para encaixar
		 */
		public function fitOn(holder:DisplayObject):void
		{
			if (holder is Stage) {
				var hstage:Stage = holder as Stage;
				this.width = hstage.stageWidth;
				this.scaleY = this.scaleX;
				if (this.height > hstage.stageHeight) {
					this.height = hstage.stageHeight;
					this.scaleX = this.scaleY;
				}
				this.x = (hstage.stageWidth - this.width) / 2;
				this.y = (hstage.stageHeight - this.height) / 2;
			} else {
				this.width = holder.width;
				this.scaleY = this.scaleX;
				if (this.height > holder.height) {
					this.height = holder.height;
					this.scaleX = this.scaleY;
				}
				this.x = holder.x + ((holder.width - this.width) / 2);
				this.y = holder.y + ((holder.height - this.height) / 2);
			}
		}
		
		/**
		 * Posiciona a área de imagem dentro de uma área definida.
		 * @param	holder	área para encaixar
		 */
		public function fitOnArea(area:Rectangle):void
		{
			this.scaleX = area.width / this.oWidth;
			this.scaleY = area.height / this.oHeight;
			if (this.scaleX > this.scaleY) {
				this.scaleX = this.scaleY;
			} else {
				this.scaleY = this.scaleX;
			}
			this.x = area.x + ((area.width - (this.oWidth * this.scaleX)) / 2);
			this.y = area.y + ((area.height - (this.oHeight * this.scaleY)) / 2);
		}
		
		/**
		 * Libera recursos usados pelo objeto.
		 */
		public function dispose():void
		{
			this.removeChildren();
			super.removeChildren();
			this._holder.mask = null;
			this._holder = null;
			this._mask.graphics.clear();
			this._mask = null;
			this._bg.graphics.clear();
			this._bg = null;
		}
		
	}

}