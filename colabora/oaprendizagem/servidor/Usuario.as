package colabora.oaprendizagem.servidor 
{
	import art.ciclope.data.PersistentData;
	import flash.events.Event;
	import flash.net.URLVariables;
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Usuario extends AreaWeb
	{
		
		// VARIÁVEIS
		private var _data:PersistentData;		// dados do usuário gravados
		
		public function Usuario(w:int = 160, h:int = 90) 
		{
			super(w, h);
			this._wview.setCallback('login', onLogin);
			this._wview.setCallback('usercreated', onUserCreated);
			
			// verificando dados gravados
			this._data = new PersistentData('oaprendizagem', (ObjetoAprendizagem.codigo + '-usuario'), true);
		}
		
		// VALORES SOMENTE LEITURA
		
		/**
		 * O usuário está logado?
		 */
		public function get logado():Boolean
		{
			return (this._data.getValue('logado') == 'true');
		}
		
		/**
		 * Nome do usuário atual.
		 */
		public function get nome():String
		{
			if (this.logado) return (this._data.getValue('nome'));
				else return ('');
		}
		
		/**
		 * Login do usuário atual.
		 */
		public function get login():String
		{
			if (this.logado) return (this._data.getValue('login'));
				else return ('');
		}
		
		/**
		 * Id do usuário atual.
		 */
		public function get id():String
		{
			if (this.logado) return (this._data.getValue('id'));
				else return ('');
		}
		
		/**
		 * Chave da conta do usuário atual.
		 */
		public function get chave():String
		{
			if (this.logado) return (this._data.getValue('chave'));
				else return ('');
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Abrir a tela de login.
		 * @param	resposta	função para ser chamada ao completar o login (deve receber um parâmetro URLVariables)
		 */
		public function abrirLogin(resposta:Function = null):void
		{
			this._wview.loadURL(ObjetoAprendizagem.urlServidor + '?r=user/show-login');
			this._resposta = resposta;
		}

		/**
		 * Abrir a tela de criação de usuário.
		 * @param	resposta	função para ser chamada ao completar a criação de usuário (deve receber um parâmetro URLVariables)
		 */
		public function abrirCriacao(resposta:Function = null):void
		{
			this._wview.loadURL(ObjetoAprendizagem.urlServidor + '?r=user/create-user');
			this._resposta = resposta;
		}
		
		/**
		 * Desconectando o usuário atual.
		 */
		public function logout():void
		{
			// removendo valores guardados
			this._data.clearValue('login');
			this._data.clearValue('chave');
			this._data.clearValue('nome');
			this._data.clearValue('id');
			this._data.clearValue('logado');
			this._data.save();
		}
		
		/**
		 * Libera recursos usados pelo objeto.
		 */
		override public function dispose():void
		{
			this._data.dispose();
			this._data = null;
			super.dispose();
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * O usuário completou o login.
		 */
		private function onLogin(data:Object):void
		{
			// recuperando valores recebidos do servidor
			this._data.setValue('login', String(data['login']));
			this._data.setValue('chave', String(data['chave']));
			this._data.setValue('nome', String(data['nome']));
			this._data.setValue('id', String(data['id']));
			this._data.setValue('logado', 'true');
			this._data.save();
			// avisando
			if (this._resposta != null) this._resposta(new URLVariables('erro=0'));
		}
		
		/**
		 * Uma conta de usuário foi criada.
		 */
		private function onUserCreated(data:Object):void
		{
			// recuperando valores recebidos do servidor
			this._data.setValue('login', String(data['login']));
			this._data.setValue('chave', String(data['chave']));
			this._data.setValue('nome', String(data['nome']));
			this._data.setValue('id', String(data['id']));
			this._data.setValue('logado', 'true');
			this._data.save();
			// avisando
			if (this._resposta != null) this._resposta(new URLVariables('erro=0'));
		}
		
	}

}