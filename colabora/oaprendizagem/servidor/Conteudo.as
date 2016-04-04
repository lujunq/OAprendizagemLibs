package colabora.oaprendizagem.servidor 
{
	import flash.events.Event;
	import flash.net.URLVariables;
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Conteudo extends AreaWeb
	{
		
		
		// VARIÁVEIS PRIVADAS
		
		// url para listagem
		private var _url:String;
		
		public function Conteudo(w:int = 160, h:int = 90) 
		{
			super(w, h);
			
			// preparando a url de exibição
			this._url = ObjetoAprendizagem.urlServidor + 'index.php?r=' + ObjetoAprendizagem.codigo + '/mostrar';
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Exibe um conteúdo.
		 * @param	id	identificador do conteúdo a mostrar
		 * @return	TRUE se a área de exibição está visível e disponível para mostrar
		 */
		public function mostrar(id:String):Boolean {
			if (this.stage == null) {
				return (false);
			} else {
				
				trace ('mostrar', this._url + '&id=' + encodeURI(id));
				
				this._wview.loadURL(this._url + '&id=' + encodeURI(id));
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
		
	}

}