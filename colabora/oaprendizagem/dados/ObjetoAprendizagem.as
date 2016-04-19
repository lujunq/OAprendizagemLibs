package colabora.oaprendizagem.dados 
{
	import colabora.display.AreaImagens;
	import colabora.display.Compartilhamento;
	import colabora.oaprendizagem.servidor.Usuario;
	import colabora.oaprendizagem.servidor.Servidor;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ObjetoAprendizagem 
	{
		// VARIÁVEIS ESTÁTICAS
		
		/**
		 * Nome do objeto de aprendizagem.
		 */
		public static var nome:String = '';
		
		/**
		 * Código do objeto de aprendizagem.
		 */
		public static var codigo:String = '';
		
		/**
		 * Endereço do servidor.
		 */
		public static var urlServidor:String = '';
		
		/**
		 * Referência ao usuário.
		 */
		public static var usuario:Usuario;
		
		/**
		 * Conexão com o servidor.
		 */
		public static var servidor:Servidor;
		
		/**
		 * Área de inclusão de imagens.
		 */
		public static var areaImagem:AreaImagens;
		
		/**
		 * Tela de compartilhamento.
		 */
		public static var compartilhamento:Compartilhamento;
		
		
		
		public function ObjetoAprendizagem() 
		{
			
		}
		
	}

}