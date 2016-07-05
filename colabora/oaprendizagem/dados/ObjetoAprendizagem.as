package colabora.oaprendizagem.dados 
{
	import colabora.display.AreaImagens;
	import colabora.display.Compartilhamento;
	import colabora.display.TelaMensagemStage;
	import colabora.oaprendizagem.servidor.Usuario;
	import colabora.oaprendizagem.servidor.Servidor;
	import flash.filesystem.File;
	
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
		
		/**
		 * Copia o projeto de exemplo para o usuário caso ele não exista.
		 * @param	nome	o nome da pasta do projeto de exemplo
		 */
		public static function copiaExemplo(nome:String):void
		{
			// conferindo se já existe o projeto de exemplo
			var pastaEx:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + nome);
			if (!pastaEx.isDirectory) {
				// copiar o projeto de exemplo
				var origem:File = File.applicationDirectory.resolvePath('exemplo/' + nome);
				origem.copyToAsync(pastaEx, true);
			}
		}
		
	}

}