package colabora.oaprendizagem.servidor 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
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
		private var _loader:URLLoader;
		private var _request:URLRequest;
		private var _loading:Boolean;			// o servidor está em comunicação?
		private var _retorno:Function;			// função para chamar ao final do acesso
		
		public function Servidor() 
		{
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, onComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			this._request = new URLRequest(ObjetoAprendizagem.urlServidor);
			this._request.method = 'GET';
			
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
					this._request.data = dados;
					this._loading = true;
					this._loader.load(this._request);
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
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Dados recebidos do servidor.
		 */
		private function onComplete(evt:Event):void {
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
		
	}

}