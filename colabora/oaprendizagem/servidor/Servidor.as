package colabora.oaprendizagem.servidor 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import com.adobe.crypto.MD5;
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Servidor 
	{
		
		// VARIAVEIS
		private var _loader:URLLoader;			// conexão para troca de texto com o servidor
		private var _request:URLRequest;		// requisição para o servidor
		private var _loading:Boolean;			// o servidor está em comunicação?
		private var _retorno:Function;			// função para chamar ao final do acesso
		private var _file:File;					// arquivo para upload
		
		public function Servidor() 
		{
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			this._request = new URLRequest(ObjetoAprendizagem.urlServidor + 'index.php');
			this._request.method = 'POST';
			
			this._loading = false;
		}
		
		// SOMENTE LEITURA
		
		/**
		 * O servidor está em comunicação?
		 */
		public function get loading():Boolean {
			return (this._loading);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Chama uma ação do servidor.
		 * @param	acao	ação a ser chamada
		 * @param	dados	informações a serem enviadas
		 * @param	retorno	função a ser chamada após o recebimento de dados (deve receber um parâmetro URLVariables)
		 * @param	forcar	forçar a chamada mesmo que outra comunicação esteja acontecendo
		 * @return	TRUE caso a chamada possa ser feita (usuário logado, nenhuma outra conexão em andamento) 
		 */
		public function chamar(acao:String, dados:URLVariables, retorno:Function = null, forcar:Boolean = false):Boolean {
			if (!this._loading || forcar) {
				if (ObjetoAprendizagem.usuario.logado) {
					this._retorno = retorno;
					dados['r'] = ObjetoAprendizagem.codigo + '/' + acao;
					dados['uid'] = ObjetoAprendizagem.usuario.id;
					dados['ulg'] = ObjetoAprendizagem.usuario.login;
					dados['key'] = MD5.hash(ObjetoAprendizagem.usuario.chave + dados['r'] + dados['ulg']);
					dados['app'] = ObjetoAprendizagem.codigo;
					this._request.data = dados;
					this._loading = true;
					this._loader.load(this._request);
					this.clearFile();
					return(true);
				} else {
					return (false);
				}
			} else {
				return (false);
			}
		}
		
		/**
		 * Envia um arquivo para o servidor.
		 * @param	acao	ação a ser chamada
		 * @param	arquivo	arquivo a ser enviado
		 * @param	dados	informações a serem enviadas
		 * @param	retorno	função a ser chamada após o recebimento de dados (deve receber um parâmetro URLVariables)
		 * @param	forcar	forçar a chamada mesmo que outra comunicação esteja acontecendo
		 * @return	TRUE caso a chamada possa ser feita (usuário logado, nenhuma outra conexão em andamento) 
		 */
		public function upload(acao:String, arquivo:File, dados:URLVariables, retorno:Function = null, forcar:Boolean = false):Boolean {
			if (!this._loading || forcar) {
				if (ObjetoAprendizagem.usuario.logado && arquivo.exists) {
					this._retorno = retorno;
					dados['r'] = ObjetoAprendizagem.codigo + '/' + acao;
					dados['uid'] = ObjetoAprendizagem.usuario.id;
					dados['ulg'] = ObjetoAprendizagem.usuario.login;
					dados['key'] = MD5.hash(ObjetoAprendizagem.usuario.chave + dados['r'] + dados['ulg']);
					dados['app'] = ObjetoAprendizagem.codigo;
					dados['upfile'] = 'Filedata';
					
					this._request.data = dados;
					this._loading = true;
					this.clearFile();
					
					//this._loader.load(this._request);
					
					this._file = arquivo;
					this._file.addEventListener(Event.COMPLETE, onFile);
					this._file.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
					this._file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileError);
					this._file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onFileData);
					this._file.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
					this._file.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPStatus);
					this._file.upload(this._request);
					
					return(true);
				} else {
					return (false);
				}
			} else {
				return (false);
			}
		}
		
		/**
		 * Libera recursos usados pelo objeto.
		 */
		public function dispose():void {
			this._loader.removeEventListener(Event.COMPLETE, onComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			this._loader = null;
			this._request = null;
			this._retorno = null;
			this.clearFile();
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Remove a referência atual a arquivos para envio.
		 */
		private function clearFile():void {
			if (this._file != null) {
				if (this._file.hasEventListener(Event.COMPLETE)) {
					try {
						this._file.removeEventListener(Event.COMPLETE, onFile);
					} catch (e:Error) { }
					try {
						this._file.removeEventListener(IOErrorEvent.IO_ERROR, onFileError);
					} catch (e:Error) { }
					try {
						this._file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileError);
					} catch (e:Error) { }
				}
			}
			this._file = null;
		}
		
		/**
		 * Dados recebidos do servidor.
		 */
		private function onComplete(evt:Event):void {
			
			trace('retorno:', this._loader.data);
			
			var ok:Boolean = true;
			try {
				var dados:URLVariables = new URLVariables(String(this._loader.data));
			} catch (e:Error) {
				ok = false;
			}
			this._loading = false;
			if (ok) {
				if (this._retorno != null) {
					if (dados['erro'] != null) {
						this._retorno(dados);
					} else {
						this._retorno(new URLVariables('erro=-3'));
					}
				}
			} else {
				if (this._retorno != null) this._retorno(new URLVariables('erro=-3'));
			}
		}
		
		/**
		 * Erro na comunicação com o servidor.
		 */
		private function onError(evt:Event):void {
			this._loading = false;
			if (this._retorno != null) this._retorno(new URLVariables('erro=-1'));
		}
		
		/**
		 * Arquivo enviado com sucesso.
		 */
		private function onFile(evt:Event):void {
			this._loading = false;
			this.clearFile();
			if (this._retorno != null) this._retorno(new URLVariables('erro=0'));
		}
		
		/**
		 * Erro no envio de arquivo.
		 */
		private function onFileError(evt:Event):void {
			this._loading = false;
			this.clearFile();
			if (this._retorno != null) this._retorno(new URLVariables('erro=-6'));
		}
		
		private function onFileData(evt:DataEvent):void {
			trace ('file data', evt.data);
		}
		
		private function onHTTPStatus(evt:HTTPStatusEvent):void {
			trace ('http', evt.type, JSON.stringify(evt));
		}
		
	}

}