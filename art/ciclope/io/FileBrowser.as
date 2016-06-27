package art.ciclope.io 
{
	import art.ciclope.managana.net.Webview;
	import colabora.oaprendizagem.servidor.Listagem;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class FileBrowser extends Sprite 
	{
	
		// VARIÁVEIS PÚBLICAS
		
		public var escolhido:Object;
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;
		private var _webview:Webview;
		private var _btOK:Sprite;
		private var _btCancel:Sprite;
		private var _htmlIni:String;
		private var _htmlFim:String;
		private var _tipo:String;
		
		public function FileBrowser(btOK:Sprite, btCancel:Sprite, corBG:int = 0x404040) 
		{
			super();
			
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// webview
			this._webview = new Webview();
			this._webview.setCallback('select', this.onSelect);
			
			// botões
			this._btOK = btOK;
			this._btOK.addEventListener(MouseEvent.CLICK, onOK);
			this.addChild(this._btOK);
			this._btCancel = btCancel;
			this._btCancel.addEventListener(MouseEvent.CLICK, onCancel);
			this.addChild(this._btCancel);
			
			// recuperando textos html
			var stream:FileStream = new FileStream();
			stream.open(File.applicationDirectory.resolvePath('listaArquivosInicio.html'), FileMode.READ);
			this._htmlIni = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			stream.open(File.applicationDirectory.resolvePath('listaProjetosFim.html'), FileMode.READ);
			this._htmlFim = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			// verificando o stage
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
			
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Inicia a criação da lista de projetos.
		 * @return	TRUE se o processe de recuperação foi iniciado
		 */
		public function listar(tipo:String = 'zip', titulo:String = ''):void
		{
			var docs:File = File.documentsDirectory;
			var lista:Array = docs.getDirectoryListing();
			var txlista:String = '';
			
			var arqID:int = 0;
			for (var i:int = 0; i < lista.length; i++) {
				var arq:File = lista[i] as File;
				if (arq.isDirectory) {
					var lista2:Array = arq.getDirectoryListing();
					for (var i2:int = 0; i2 < lista2.length; i2++) {
						var arq2:File = lista2[i2] as File;
						if (!arq2.isDirectory) {
							if (arq2.extension == tipo) {
								txlista += "<div onclick='onSelect(\"id" + arqID + "\", \"" + arq2.nativePath + "\");' id='id" + arqID + "' name='arqdiv' class='unselect'>" + arq2.name + "</div>";
								arqID++;
							}
						}
					}
				} else {
					if (arq.extension == tipo) {
						txlista += "<div onclick='onSelect(\"id" + arqID + "\", \"" + arq.url + "\");' id='id" + arqID + "' name='arqdiv' class='unselect'>" + arq.name + "</div>";
						arqID++;
					}
				}
			}
			
			this._webview.loadString(this._htmlIni + '<h1>' + titulo + '</h1>' + txlista + this._htmlFim);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Um projeto foi selecionado na lista.
		 */
		private function onSelect(dados:Object):void
		{
			this.escolhido = dados;
		}
		
		/**
		 * A tela foi adicionada à área visível.
		 */
		private function onStage(evt:Event):void
		{
			var btscala:Number = 10;
			// ajustando fundo
			this._bg.width = stage.stageWidth;
			this._bg.height = stage.stageHeight;
			
			// conferindo proporção de tela
			if (stage.stageWidth > stage.stageHeight) { // paisagem
				
				var tamanho:Number = stage.stageHeight / 7;
				var intervalo:Number = ((2 * (stage.stageHeight / 7)) / 6);
				
				this._btCancel.width = this._btCancel.height = tamanho;
				this._btOK.width = this._btOK.height = tamanho;
				
				this._btCancel.x = stage.stageWidth - 10 - this._btCancel.width;
				this._btCancel.y = stage.stageHeight - intervalo - this._btCancel.height;
				this._btOK.x = stage.stageWidth - 10 - this._btOK.width;
				this._btOK.y = this._btCancel.y - intervalo - this._btOK.height;			
				this._webview.viewPort = new Rectangle(10, 10, (stage.stageWidth - 30 - this._btCancel.width), (stage.stageHeight - 20));
				this._webview.stage = this.stage;
				
			} else { // retrato
				
				this._btOK.width = stage.stageWidth / btscala;
				this._btOK.scaleY = this._btOK.scaleX;
				this._btOK.x = stage.stageWidth / 20;
				this._btOK.y = stage.stageHeight - _btOK.height - stage.stageHeight / 40;
				
				//botão cancelar
				this._btCancel.width = stage.stageWidth / btscala;
				this._btCancel.scaleY = this._btCancel.scaleX;
				this._btCancel.x = stage.stageWidth - _btCancel.width - this.stage.stageWidth / 20;
				this._btCancel.y = stage.stageHeight - this._btCancel.height - stage.stageHeight / 40;
				
				// webview
				this._webview.viewPort = new Rectangle(10, 10, (stage.stageWidth - 20), (stage.stageHeight - (this._btCancel.height + this._btCancel.height / 1.5)));
				this._webview.stage = this.stage;
			}
		}
		
		/**
		 * A tela foi removida da área visível.
		 */
		private function onNoStage(evt:Event):void
		{
			this._webview.stage = null;
		}
		
		/**
		 * Clique no botão OK.
		 */
		private function onOK(evt:MouseEvent):void
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