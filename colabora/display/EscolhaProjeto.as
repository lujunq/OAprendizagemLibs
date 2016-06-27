package colabora.display
{
	import art.ciclope.managana.net.Webview;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class EscolhaProjeto extends Sprite
	{
		
		// VARIÁVEIS PÚBLICAS
		
		public var escolhido:Object;
		
		// VARIÁVEIS PRIVADAS
		
		private var _webview:Webview;
		private var _btOK:Sprite;
		private var _btCancel:Sprite;
		private var _btAbrir:Sprite;
		private var _btLixeira:Sprite;
		private var _btExtra:Sprite;
		private var _pastaProjetos:File;
		private var _txtTitulo:String;
		
		private var _bg:Shape;
		private var _listaPastas:Array;
		
		private var _htmlIni:String;
		private var _htmlFim:String;
		
		public function EscolhaProjeto(titulo:String, btOK:Sprite, btCancel:Sprite, btAbrir:Sprite, btLixeira:Sprite, pasta:File, corBG:int = 0x404040, corTitulo:int = 0xFFFFFF, btExtra:Sprite = null)
		{
			// recebendo valores
			this._pastaProjetos = pasta;
			this._pastaProjetos.addEventListener(FileListEvent.DIRECTORY_LISTING, onListaProjetos);
			
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// texto
			this._txtTitulo = titulo;
			
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
			this._btAbrir = btAbrir;
			this._btAbrir.addEventListener(MouseEvent.CLICK, onAbrir);
			this._btAbrir.visible = false;
			this.addChild(this._btAbrir);
			this._btLixeira = btLixeira;
			this._btLixeira.addEventListener(MouseEvent.CLICK, onLixeira);
			this._btLixeira.visible = false;
			this.addChild(this._btLixeira);
			
			// botão extra
			if (btExtra != null) {
				this._btExtra = btExtra;
				this._btExtra.addEventListener(MouseEvent.CLICK, onExtra);
				
				this.addChild(this._btExtra);
			}
			
			// recuperando textos html
			var stream:FileStream = new FileStream();
			stream.open(File.applicationDirectory.resolvePath('listaProjetosInicio.html'), FileMode.READ);
			this._htmlIni = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			stream.open(File.applicationDirectory.resolvePath('listaProjetosFim.html'), FileMode.READ);
			this._htmlFim = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			// verificando o stage
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
			
			// listagem de pastas
			this._listaPastas = new Array();
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Inicia a criação da lista de projetos.
		 * @return	TRUE se o processe de recuperação foi iniciado
		 */
		public function listar(titulo:String = ''):Boolean
		{
			if (this._pastaProjetos.isDirectory)
			{
				// atualizando título?
				if (titulo != '')
				{
					//this._titulo.text = titulo;
					this._txtTitulo = titulo;
				}
				// removendo escolhido anterior
				this.escolhido = null;
				// preparando o texto de espera
				this._webview.loadString(this._htmlIni + '<h1>' + this._txtTitulo + '</h1>Verificando projetos</h1>Verificando os projetos gravados. Por favor aguarde...<br />' + this._htmlFim);
				// recuperando lista de pastas
				this.limpaListaPastas();
				this._pastaProjetos.getDirectoryListingAsync();
				// avisando que o processamento começou
				return (true);
			}
			else
			{
				return (false);
			}
		}
		
		/**
		 * Mostra uma mensagem na área de exibição de projetos.
		 * @param	msg	a mensagem a ser exibida
		 */
		public function mostrarMensagem(msg:String):void
		{
			this._webview.loadString(this._htmlIni + msg + this._htmlFim);
		}
		
		/**
		 * Mostrar o botão abrir.
		 */
		public function mostrarAbrir():void
		{
			this._btAbrir.visible = true;
		}
		
		/**
		 * Mostrar o botão lixeira.
		 */
		public function mostrarLixeira():void
		{
			this._btLixeira.visible = true;
		}
		
		// FUNÇÕES PRIVADAS
		
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
		
		/**
		 * Clique no botão abrir.
		 */
		private function onAbrir(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.OPEN));
		}
		
		/**
		 * Clique no botão lixeira.
		 */
		private function onLixeira(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLEAR));
		}
		
		/**
		 * Clique no botão extra.
		 */
		private function onExtra(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
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
			if (stage.stageWidth > stage.stageHeight)
			{ // paisagem
				
				var tamanho:Number = stage.stageHeight / 7;
				var intervalo:Number = ((2 * (stage.stageHeight / 7)) / 6);
				
				this._btCancel.width = this._btCancel.height = tamanho;
				this._btOK.width = this._btOK.height = tamanho;
				this._btAbrir.width = this._btAbrir.height = tamanho;
				this._btLixeira.width = this._btLixeira.height = tamanho;
				
				this._btCancel.x = stage.stageWidth - 10 - this._btCancel.width;
				this._btCancel.y = stage.stageHeight - intervalo - this._btCancel.height;
				this._btOK.x = stage.stageWidth - 10 - this._btOK.width;
				this._btOK.y = this._btCancel.y - intervalo - this._btOK.height;
				this._btAbrir.x = stage.stageWidth - 10 - this._btAbrir.width;
				this._btAbrir.y = intervalo;
				this._btLixeira.x = this._btAbrir.x;
				this._btLixeira.y = this._btAbrir.y;				
				this._webview.viewPort = new Rectangle(10, 10, (stage.stageWidth - 30 - this._btCancel.width), (stage.stageHeight - 20));
				this._webview.stage = this.stage;
				
				
			}
			else
			{ 
				// retrato
				
				this._btAbrir.width = stage.stageWidth / btscala;
				this._btAbrir.scaleY = this._btAbrir.scaleX;
				this._btAbrir.y = stage.stageHeight - this._btAbrir.height - stage.stageHeight / 40;
				this._btAbrir.x = stage.stageWidth / 2 - this._btAbrir.width / 2;
				
				this._btOK.width = stage.stageWidth / btscala;
				this._btOK.scaleY = this._btOK.scaleX;
				this._btOK.x = stage.stageWidth / 20;
				this._btOK.y = stage.stageHeight - _btOK.height - stage.stageHeight / 40;
				
				//botão cancelar
				this._btCancel.width = stage.stageWidth / btscala;
				this._btCancel.scaleY = this._btCancel.scaleX;
				this._btCancel.x = stage.stageWidth - _btCancel.width - this.stage.stageWidth / 20;
				this._btCancel.y = stage.stageHeight - this._btCancel.height - stage.stageHeight / 40;
				this._btLixeira.width = stage.stageWidth / btscala;
				this._btLixeira.scaleY = this._btLixeira.scaleX;
				this._btLixeira.y = this._btCancel.y;
				this._btLixeira.x = (this.stage.stageWidth - this._btLixeira.width) / 2;
				
				
				/*this._btCancel.height = stage.stageHeight / 10;
				   this._btCancel.scaleX = this._btCancel.scaleY;
				   this._btOK.height = stage.stageHeight / 10;
				   this._btOK.scaleX = this._btOK.scaleY;
				   this._btAbrir.height = stage.stageHeight / 10;
				   this._btAbrir.scaleX = this._btAbrir.scaleY;
				   this._btLixeira.height = stage.stageHeight / 10;
				   this._btLixeira.scaleX = this._btLixeira.scaleY;
				
				   this._btCancel.x = 10;
				   this._btCancel.y = stage.stageHeight - this._btCancel.height - 5;
				   this._btOK.x = stage.stageWidth - 10 - this._btOK.width;
				   this._btOK.y = stage.stageHeight - this._btOK.height - 5;
				   this._btAbrir.x = (stage.stageWidth - this._btAbrir.width) / 2;
				   this._btAbrir.y = stage.stageHeight - this._btAbrir.height - 5;
				   this._btAbrir.visible = false;
				 */
				
				
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
		 * Limpa a lista de pastas de projetos.
		 */
		private function limpaListaPastas():void
		{
			while (this._listaPastas.length > 0) this._listaPastas.shift();
		}
		
		/**
		 * A lista de pastas de projetos foi recuperada.
		 */
		private function onListaProjetos(evt:FileListEvent):void
		{
			// recuperando a lista de projetos
			this._listaPastas = evt.files;
			
			// iniciando o HTML de saída
			var htmlText:String = this._htmlIni + '<h1>' + this._txtTitulo + '</h1>';
			
			// verificando projeto a projeto
			var total:int = 0;
			for (var i:int = 0; i < this._listaPastas.length; i++)
			{
				var projeto:File = this._listaPastas[i] as File;
				// o arquivo da lista é uma pasta?
				if (projeto.isDirectory)
				{
					// a pasta contém um arquivo "projeto.json"?
					if (projeto.resolvePath('projeto.json').exists)
					{
						// é possível recuperar o conteúdo do arquivo projeto.json como dados JSON?
						var stream:FileStream = new FileStream();
						stream.open(projeto.resolvePath('projeto.json'), FileMode.READ);
						var jsonText:String = stream.readUTFBytes(stream.bytesAvailable);
						stream.close();
						var jsonObj:Object;
						try
						{
							jsonObj = JSON.parse(jsonText);
						}
						catch (e:Error)
						{
						}
						// dados JSON recuperados?
						if (jsonObj != null)
						{
							// campos necessários encontrados?
							if ((jsonObj.id != null) && (jsonObj.titulo != null) && (jsonObj.tags != null))
							{
								// adicionar uma DIV com o projeto
								var date:Date = projeto.resolvePath('projeto.json').modificationDate;
								var dateString:String = date.date + '/' + (date.month + 1) + '/' + date.fullYear;
								htmlText += "<div onclick='onSelect(\"" + jsonObj.id + "\", \"" + jsonObj.titulo + "\");' id='" + jsonObj.id + "' name='prjdiv' class='unselect'>";
								if (jsonObj.titulo == '')
								{
									htmlText += '<b>Sem título</b> (' + dateString + ')<br />' + String(jsonObj.tags) + '<br />';
								}
								else
								{
									htmlText += '<b>' + jsonObj.titulo + '</b> (' + dateString + ')<br />' + String(jsonObj.tags) + '<br />';
								}
								if (jsonObj.tags == '') htmlText += jsonObj.tags;
								htmlText += '</div>';
							}
						}
					}
				}
			}
			
			// terminando o HTML de saída
			htmlText += this._htmlFim;
			
			// aplicando o html ao webview
			this._webview.loadString(htmlText);
		}
	}

}