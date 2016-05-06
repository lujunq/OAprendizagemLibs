package colabora.display 
{
	import art.ciclope.display.QRCodeDisplay;
	import art.ciclope.net.HTTPServer;
	import colabora.qrcode.QrCodeReader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Compartilhamento extends Sprite
	{
		
		/**
		 * Último arquivo baixado pela tela de compartilhamento.
		 */
		public var download:File;
		
		/**
		 * Mostrar qr code na tela?
		 */
		public var mostrarQR:Boolean = true;
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;					// fundo da tela
		private var _qrreader:QrCodeReader;		// leitor de qrcode
		private var _qrdisplay:QRCodeDisplay;	// exibição de qrcode
		private var _texto:TextField;			// sobre a leitura de qr code
		private var _btsobre:Sprite;			// botão para explicações
		private var _btscan:Sprite;				// botão para iniciar a leitura de qrcode
		private var _btvoltar:Sprite;			// botão para fechar tela de compartilhamento
		private var _loader:URLLoader;			// para download de arquivo
		private var _msgerro:Sprite;			// mensagem de erro
		private var _msgok:Sprite;				// mensagem ok
		private var _msgaguarde:Sprite;			// mensagem aguarde
		private var _servidor:HTTPServer;		// servidor web para compartilhamento
		private var _pastaWeb:File;				// pasta para o servidor web
		
		public function Compartilhamento(btscan:Sprite, btfechar:Sprite, btvoltar:Sprite, btsobre:Sprite, textoSobre:String, msgerro:Sprite, msgok:Sprite, msgaguarde:Sprite, corBG:int = 0, corTexto:int = 0xFFFFFF) 
		{
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(corBG);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// leitura do qrcode
			this._qrreader = new QrCodeReader(100, 100, this.verificaQR, btfechar);
			this._qrreader.addEventListener(Event.CLOSE, onReaderClose);
			
			// exibição do qrcode
			this._qrdisplay = new QRCodeDisplay();
			this._qrdisplay.setCode('Colabora');
			this.addChild(this._qrdisplay);
			
			// texto
			this._texto = new TextField();
			this._texto.defaultTextFormat = new TextFormat('_sans', 20, corTexto);
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this._texto.selectable = false;
			this._texto.htmlText = textoSobre;
			this._texto.visible = false;
			this.addChild(this._texto);
			
			// botão sobre
			this._btsobre = btsobre;
			this.addChild(this._btsobre);
			this._btsobre.addEventListener(MouseEvent.CLICK, onSobre);
			
			// iniciar leitura de qrcode
			this._btscan = btscan;
			this.addChild(this._btscan);
			this._btscan.addEventListener(MouseEvent.CLICK, onScan);
			
			// voltar
			this._btvoltar = btvoltar;
			this.addChild(this._btvoltar);
			this._btvoltar.addEventListener(MouseEvent.CLICK, onVoltar);
			
			// mensagens
			this._msgerro = msgerro;
			this._msgerro.visible = false;
			this.addChild(this._msgerro);
			this._msgok = msgok;
			this._msgok.visible = false;
			this.addChild(this._msgok);
			this._msgaguarde = msgaguarde;
			this._msgaguarde.visible = false;
			this.addChild(this._msgaguarde);
			this._msgerro.addEventListener(MouseEvent.CLICK, onMsgErro);
			this._msgok.addEventListener(MouseEvent.CLICK, onMsgOk);
			
			// ajustando à tela
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// preparando downloads
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError);
			
			// servidor web
			this._servidor = new HTTPServer();
			this._servidor.setMimeType('.data', 'application/zip');
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Inicia o servidor web para compartilhamento de um arquivo.
		 * @param	arquivo	referência para o arquivo a ser compartilhado
		 * @return	TRUE se o arquivo existir e o compartilhamento for iniciado
		 */
		public function iniciaURL(arquivo:File):Boolean
		{
			if (arquivo.exists) {
				this._pastaWeb = File.createTempDirectory();
				arquivo.copyTo(this._pastaWeb.resolvePath('upload.data'), true);
				this._servidor.start(8090, this._pastaWeb);
				this.iniciaCompartilhamento(this._servidor.ipv4Address + '/upload.data');
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Finaliza o servidor de compartilhamento de um arquivo.
		 */
		public function finalizaURL():void
		{
			if (this._pastaWeb != null) {
				if (this._pastaWeb.isDirectory) {
					this._pastaWeb.deleteDirectory(true);
				}
			}
			this._pastaWeb = null;
			this._servidor.stop();
		}
		
		/**
		 * Inicia o ocmpartilhamento de um arquivo.
		 * @param	url	link para o arquivo
		 */
		public function iniciaCompartilhamento(url:String):void
		{
			this.mostrarQR = true;
			this._qrdisplay.setCode(url);
			this._texto.visible = false;
			this._qrdisplay.visible = true;
			this._btscan.visible = true;
			this._btsobre.visible = true;
			this._btvoltar.visible = true;
			this._msgaguarde.visible = false;
			this._msgerro.visible = false;
			this._msgok.visible = false;
			try { this.removeChild(this._qrreader); } catch (e:Error) { }
			this._qrreader.close(false);
		}
		
		/**
		 * Inicia a tela para a leitura de qrcode apenas.
		 */
		public function iniciaLeitura():void
		{
			this.mostrarQR = false;
			this._texto.visible = false;
			this._qrdisplay.visible = false;
			this._btscan.visible = true;
			this._btsobre.visible = true;
			this._btvoltar.visible = true;
			this._msgaguarde.visible = false;
			this._msgerro.visible = false;
			this._msgok.visible = false;
			try { this.removeChild(this._qrreader); } catch (e:Error) { }
			this._qrreader.close(false);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * O stage ficou disponível.
		 */
		private function onStage(evt:Event):void
		{
			// ajustando o fundo
			this._bg.x = this._bg.y = 0;
			this._bg.width = this.stage.width;
			this._bg.height = this.stage.height;
			
			// ajustando leitor de qrcode
			this._qrreader.resize(stage.stageWidth, stage.stageHeight);
			
			// ajustando exibição do qrcode e botões
			var intervalo:Number;
			if (stage.stageWidth > stage.stageHeight) { // posição paisagem
				// exibição do qrcode
				this._qrdisplay.height = this._qrdisplay.width = (stage.stageHeight * 4 / 5) - 15;
				this._qrdisplay.x = (stage.stageWidth - this._qrdisplay.width) / 2;
				this._qrdisplay.y = 5;
				// botão de leitura e ajuda
				this._btscan.height = this._btsobre.height = stage.stageHeight / 5;
				this._btscan.y = this._btsobre.y = this._qrdisplay.y + this._qrdisplay.height + 5;
				this._btscan.scaleX = this._btscan.scaleY;
				this._btsobre.scaleX = this._btsobre.scaleY;
				// ajuste de botões
				while ((this._btscan.width + this._btsobre.width + 15) > (this.stage.stageWidth)) {
					this._btscan.height--;
					this._btsobre.height = this._btscan.height;
					this._btscan.scaleX = this._btscan.scaleY;
					this._btsobre.scaleX = this._btsobre.scaleY;
				}
				// posicionando botões
				this._btscan.x = (stage.stageWidth / 2) - this._btscan.width - 2;
				this._btsobre.x = (stage.stageWidth / 2) + 2;
				// ajustando botão voltar
				this._btvoltar.width = this._btvoltar.height = this.stage.stageWidth / 10;
				this._btvoltar.x = this.stage.stageWidth - this._btvoltar.width - 5;
				this._btvoltar.y = 5;
				// mensagens
				this._msgaguarde.height = stage.stageHeight * 4 / 5;
				this._msgaguarde.scaleX = this._msgaguarde.scaleY;
				if (this._msgaguarde.width > stage.stageWidth) {
					this._msgaguarde.width = stage.stageWidth - 10;
					this._msgaguarde.scaleY = this._msgaguarde.scaleX;
				}
				this._msgaguarde.x = (stage.stageWidth - this._msgaguarde.width) / 2;
				this._msgaguarde.y = (stage.stageHeight - this._msgaguarde.height) / 2;
				this._msgerro.height = stage.stageHeight * 4 / 5;
				this._msgerro.scaleX = this._msgerro.scaleY;
				if (this._msgerro.width > stage.stageWidth) {
					this._msgerro.width = stage.stageWidth - 10;
					this._msgerro.scaleY = this._msgerro.scaleX;
				}
				this._msgerro.x = (stage.stageWidth - this._msgerro.width) / 2;
				this._msgerro.y = (stage.stageHeight - this._msgerro.height) / 2;
				this._msgok.height = stage.stageHeight * 4 / 5;
				this._msgok.scaleX = this._msgok.scaleY;
				if (this._msgok.width > stage.stageWidth) {
					this._msgok.width = stage.stageWidth - 10;
					this._msgok.scaleY = this._msgok.scaleX;
				}
				this._msgok.x = (stage.stageWidth - this._msgok.width) / 2;
				this._msgok.y = (stage.stageHeight - this._msgok.height) / 2;
			} else { // posição retrato
				// exibição do qrcode
				this._qrdisplay.width = this._qrdisplay.height = stage.stageWidth;
				this._qrdisplay.x = (stage.stageWidth - this._qrdisplay.width) / 2;
				this._qrdisplay.y = (stage.stageHeight - this._qrdisplay.height) / 2;
				// botão de leitura
				this._btscan.height = this._btsobre.height = stage.stageHeight / 10;
				this._btscan.scaleX = this._btscan.scaleY;
				this._btsobre.scaleX = this._btsobre.scaleY;
				this._btscan.y = stage.stageHeight - this._btscan.height - 5;
				this._btsobre.y = stage.stageHeight - this._btsobre.height - 5;
				// ajuste de botões
				while ((this._btscan.width + this._btsobre.width + 15) > (this.stage.stageWidth)) {
					this._btscan.height--;
					this._btsobre.height = this._btscan.height;
					this._btscan.scaleX = this._btscan.scaleY;
					this._btsobre.scaleX = this._btsobre.scaleY;
				}
				// posicionando botões
				intervalo = (this.stage.stageWidth - this._btscan.width - this._btsobre.width) / 3;
				this._btscan.x = intervalo;
				this._btsobre.x = this._btscan.x + this._btscan.width + intervalo;
				// ajustando botão voltar
				this._btvoltar.width = this._btvoltar.height = this.stage.stageWidth / 5;
				this._btvoltar.x = this.stage.stageWidth - this._btvoltar.width - 5;
				this._btvoltar.y = 5;
				// mensagens
				this._msgaguarde.width = stage.stageWidth - 10;
				this._msgaguarde.scaleY = this._msgaguarde.scaleX;
				this._msgaguarde.x = (stage.stageWidth - this._msgaguarde.width) / 2;
				this._msgaguarde.y = (stage.stageHeight - this._msgaguarde.height) / 2;
				this._msgerro.width = stage.stageWidth - 10;
				this._msgerro.scaleY = this._msgerro.scaleX;
				this._msgerro.x = (stage.stageWidth - this._msgerro.width) / 2;
				this._msgerro.y = (stage.stageHeight - this._msgerro.height) / 2;
				this._msgok.width = stage.stageWidth - 10;
				this._msgok.scaleY = this._msgok.scaleX;
				this._msgok.x = (stage.stageWidth - this._msgok.width) / 2;
				this._msgok.y = (stage.stageHeight - this._msgok.height) / 2;
			}
			
			// texto
			this._texto.x = 10;
			this._texto.y = 10;
			this._texto.width = stage.stageWidth - 25 - this._btvoltar.width;
			this._texto.height = stage.stageHeight - 20;
			
			// mostrar qr code?
			if (this.mostrarQR) {
				this._qrdisplay.visible = true;
			} else {
				this._qrdisplay.visible = false;
				this._btscan.y = (stage.stageHeight - this._btscan.height) / 2;
				this._btsobre.y = (stage.stageHeight - this._btsobre.height) / 2;
			}
		}
		
		/**
		 * Verificando uma URL para download.
		 * @param	texto	link para verificar
		 */
		private function verificaQR(texto:String):void
		{
			this._loader.load(new URLRequest(texto));
			this._qrreader.close();
			this._texto.visible = false;
			this._qrdisplay.visible = false;
			this._btscan.visible = false;
			this._btsobre.visible = false;
			this._btvoltar.visible = false;
			this._msgaguarde.visible = true;
		}
		
		/**
		 * Fechando o leitor de qr code.
		 */
		private function onReaderClose(evt:Event):void
		{
			this._texto.visible = false;
			this._qrdisplay.visible = this.mostrarQR;
			this._btscan.visible = true;
			this._btsobre.visible = true;
			this._btvoltar.visible = true;
			this.removeChild(this._qrreader);
		}
		
		/**
		 * Iniciando leitura de qr code.
		 */
		private function onScan(evt:MouseEvent):void
		{
			this._texto.visible = false;
			this._qrdisplay.visible = false;
			this._btscan.visible = false;
			this._btsobre.visible = false;
			this._btvoltar.visible = false;
			this._qrreader.startReading();
			this.addChild(this._qrreader);
		}
		
		/**
		 * Mostrando informações sobre compartilhamento.
		 */
		private function onSobre(evt:MouseEvent):void
		{
			this._texto.visible = true;
			this._qrdisplay.visible = false;
			this._btscan.visible = false;
			this._btsobre.visible = false;
		}
		
		/**
		 * Fechar a tela de compartilhamento.
		 */
		private function onVoltar(evt:MouseEvent):void
		{
			if (this._texto.visible) {
				this._texto.visible = false;
				this._qrdisplay.visible = true;
				this._btscan.visible = true;
				this._btsobre.visible = true;
			} else {
				this.finalizaURL();
				parent.removeChild(this);
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		/**
		 * Toque na mensagem de erro.
		 */
		private function onMsgErro(evt:MouseEvent):void
		{
			this._msgerro.visible = false;
			this._qrdisplay.visible = true;
			this._btscan.visible = true;
			this._btsobre.visible = true;
			this._btvoltar.visible = true;
		}
		
		/**
		 * Toque na mensagem de ok.
		 */
		private function onMsgOk(evt:MouseEvent):void
		{
			
		}
		
		/**
		 * Erro verificando um link de download.
		 */
		private function onLoaderError(evt:Event):void
		{
			this._msgaguarde.visible = false;
			this._msgerro.visible = true;
		}
		
		/**
		 * Arquivo baixado com sucesso.
		 */
		private function onLoaderComplete(evt:Event):void
		{
			// referência para o arquivo baixado
			this.download = File.createTempDirectory().resolvePath('download.data');
			// gravando dados no arquivo
			var stream:FileStream = new FileStream();
			stream.open(this.download, FileMode.WRITE);
			stream.writeBytes(this._loader.data as ByteArray);
			stream.close();
			// avisando sobre o download
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			// display?
			this._msgaguarde.visible = false;
			this._msgok.visible = true;
		}
	}

}