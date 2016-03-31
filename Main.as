package
{
	import colabora.display.AreaImagens;
	import colabora.oaprendizagem.servidor.Servidor;
	import colabora.oaprendizagem.servidor.Usuario;
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Main extends Sprite 
	{
		
		private var _areaImagem:AreaImagens = new AreaImagens(1080, 1920);		// área para inclusão de imagens da narrativa
		private var _loader:Loader;		// para carregar imagens
		private var _idgrav:String;		// id de gravação da narrativa
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// DEFININDO PROPRIEDADES DE UM OBJETO DE APRENDIZAGEM
			ObjetoAprendizagem.nome = 'Narrativas visuais';
			ObjetoAprendizagem.codigo = 'narvisuais';
			ObjetoAprendizagem.urlServidor = 'http://localhost/oaprendizagem/web/';
			// preparando servidor
			ObjetoAprendizagem.servidor = new Servidor();
			// verificando o usuário
			ObjetoAprendizagem.usuario = new Usuario(stage.stageWidth, stage.stageHeight);
			
			
			// ABRINDO A JANELA DE LOGIN DE UM USUÁRIO
			/*
			if (!ObjetoAprendizagem.usuario.logado) {
				trace ('usuário não identificado');
				this.addChild(ObjetoAprendizagem.usuario);
				ObjetoAprendizagem.usuario.abrirLogin(this.respostaUsuario);
			} else {
				trace ('usuário logado:', ObjetoAprendizagem.usuario.nome);
			}
			*/
			
			// CRIANDO UM USUÁRIO
			/*
			this.addChild(ObjetoAprendizagem.usuario);
			ObjetoAprendizagem.usuario.abrirCriacao(this.respostaUsuario);
			*/
			
			// FAZENDO LOGOUT
			// ObjetoAprendizagem.usuario.logout();
			
			// CRIANDO ÁREA PARA IMAGENS (BALÕES, ETC)
			/*
			this.addChild(this._areaImagem);
			this._areaImagem.fitOn(stage); // ajustando a área de imagens a uma parte da tela
			// preparando para incorporar uma imagem à área
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			this._loader.load(new URLRequest('http://www.managana.art.br/wp-content/uploads/2015/10/editor4.jpg'));
			*/
			
			// COMEÇANDO A GRAVAR UMA NARRATIVA
			// primeiro: enviar informações da narrativa e recuperar o id de gravação
			var dados:URLVariables = new URLVariables();
			dados['titulo'] = 'Título da narrativa aqui';
			dados['tags'] = 'tags,separadas,por,vírgula';
			if (ObjetoAprendizagem.servidor.chamar('salvar-inicio', dados, retornoSalvarInicio)) { // retornoSalvarInicio é chamada após receber o id de gravação
				trace ('começando a salvar uma narrativa');
			} else {
				trace ('não é possível salvar a narrativa no momento');
			}
		}
		
		// recebendo informações sobre o id de gravação da narrativa atual
		private function retornoSalvarInicio(dados:URLVariables):void
		{
			if (int(dados['erro']) == 0) {
				this._idgrav = dados['id']; // o valor id de dados traz o id de gravação
				// após ter o id da gravação, podemos salvar as imagens das páginas, uma a uma
				// a gravação das imagens deve ser feita na ordem das páginas
				// como exemplo, enviando duas imagens chamadas "pagina1.jpg" e "pagina2.jpg" gravadas na pasta de documentos
				// no app, usar a função getPicture da área de imagem para criar as imagens
				var pagina:File = File.documentsDirectory.resolvePath('pagina1.jpg');
				var dados:URLVariables = new URLVariables();
				dados['id'] = this._idgrav;
				if (ObjetoAprendizagem.servidor.upload('salvar-imagem', pagina, dados, pagina1Enviada)) {
					trace ('começando envio da página 1');
				} else {
					trace ('não foi possível enviar a página 1');
				}
			} else {
				trace ('erro na criação do id de gravação: ', dados['erro'], dados['post']);
			}
		}
		
		private function pagina1Enviada(dados:URLVariables):void {
			trace ('página 1 enviada');
		}
		
		// função chamada após dados do usuário: login ou criação
		/*
		private function respostaUsuario(dados:URLVariables):void
		{
			// a variável dados recebe os seguintes campos: nome, login, chave e id (dados['nome'] = nome do usuário logado)
			// terminado o login ou a criação, esses dados são automaticamente gravados e podem ser acessados a qualquer momento:
			// ObjetoAprendizagem.usuario.nome; ObjetoAprendizagem.usuario.login; ObjetoAprendizagem.usuario.id
		}
		*/
		
		// adicionando uma imagem carregada à área de imagens
		/*
		private function onLoad(evt:Event):void {
			this._areaImagem.addChild(this._loader);
			// gravando a imagem após um clique
			stage.addEventListener(MouseEvent.CLICK, gravar);
		}
		*/
		
		// gravando o conteúdo da área de imagem como um arquivo png
		/*
		private function gravar(evt:MouseEvent):void
		{
			var imgData:ByteArray = this._areaImagem.getPicture('png');
			var file:File = File.documentsDirectory.resolvePath('imgteste.png');
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(imgData);
			stream.close();
		}
		*/
		
	}
	
}