package
{
	import colabora.oaprendizagem.servidor.Servidor;
	import colabora.oaprendizagem.servidor.Usuario;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLVariables;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// definindo propriedades do objeto de aprendizagem
			ObjetoAprendizagem.nome = 'Narrativas visuais';
			ObjetoAprendizagem.codigo = 'narvisuais';
			ObjetoAprendizagem.urlServidor = 'http://localhost/oaprendizagem/web/';
			
			// preparando servidor
			ObjetoAprendizagem.servidor = new Servidor();
			
			// verificando o usuário
			ObjetoAprendizagem.usuario = new Usuario(stage.stageWidth, stage.stageHeight);
			
			if (!ObjetoAprendizagem.usuario.logado) {
				trace ('usuário não identificado');
				this.addChild(ObjetoAprendizagem.usuario);
				ObjetoAprendizagem.usuario.abrirLogin();
			} else {
				trace ('usuário logado:', ObjetoAprendizagem.usuario.nome);
				if (ObjetoAprendizagem.servidor.chamar('check', new URLVariables(), retornoCheck)) {
					trace ('chamando ação check');
				} else {
					trace ('não foi possível chamar a ação check');
				}
			}
		}
		
		private function retornoCheck(dados:URLVariables):void {
			trace ('check recebido. erro =', dados['erro']);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}