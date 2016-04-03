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
	public class Listagem extends AreaWeb
	{
		
		// VARIÁVEIS PÚBLICAS
		
		/**
		 * Função a ser chamada para mostrar um conteúdo - deve receber um único parâmetro string, o ID do conteúdo a mostrar.
		 */
		public var fMostrar:Function;
		
		// VARIÁVEIS PRIVADAS
		
		// url para listagem
		private var _url:String;
		
		public function Listagem(w:int = 160, h:int = 90) 
		{
			super(w, h);
			this._wview.setCallback('listar', onListar);	// atualizando listagem
			this._wview.setCallback('mostrar', onMostrar);	// exibindo um conteúdo selecionado
			
			// preparando a url de listagem
			this._url = ObjetoAprendizagem.urlServidor + 'index.php?r=' + ObjetoAprendizagem.codigo + '/listar';
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Chama uma lisgaem de conteúdo.
		 * @param	busca	critérios de busca separados por vírgula
		 * @param	porPagina	número de resultados por página
		 * @param	paginaInicial	número da página inicial a ser mostrada
		 * @return	TRUE se a área de listagem está visível e disponível para mostrar
		 */
		public function listar(busca:String = '', porPagina:int = 20, paginaInicial:int = 0):Boolean {
			if (this.stage == null) {
				return (false);
			} else {
				if (busca == '') {
					
					trace ('chamar', this._url + '&l=' + porPagina + '&p=' + paginaInicial + '&i=' + ObjetoAprendizagem.usuario.instituicao);
					
					this._wview.loadURL(this._url + '&l=' + porPagina + '&p=' + paginaInicial + '&i=' + ObjetoAprendizagem.usuario.instituicao);
				} else {
					this._wview.loadURL(this._url + '&l=' + porPagina + '&p=' + paginaInicial + '&i=' + ObjetoAprendizagem.usuario.instituicao + '&b=' + encodeURI(busca));
				}
				return (true);
			}
		}
		
		/**
		 * Libera recursos usados pelo objeto.
		 */
		override public function dispose():void
		{
			this._url = null;
			super.dispose();
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Atualizando a listagem de conteúdo.
		 * @param	data	informações sobre a nova listagem
		 */
		private function onListar(data:Object):void
		{
			var b:String = '';
			var i:String = '';
			var l:String = '';
			var p:String = '';
			if (data['b'] != null) b = String(data['b']);
			if (data['i'] != null) i = String(data['i']);
			if (data['l'] != null) l = String(data['l']);
			if (data['p'] != null) p = String(data['p']);
			this._wview.loadURL(this._url + '&l=' + l + '&p=' + p + '&i=' + i + '&b=' + encodeURI(b));
		}
		
		/**
		 * Chama a função de exibição de um conteúdo.
		 * @param	data	informações sobre o conteúdo a abrir
		 */
		private function onMostrar(data:Object):void
		{
			if ((this.fMostrar != null) && (data['id'] != null)) {
				this.fMostrar(String(data['id']));
			}
		}
		
	}

}