package colabora.oaprendizagem.dados 
{
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ProjetoDados 
	{
		
		public var titulo:String = '';
		
		public var tags:String = '';
		
		public var id:String = '';
		
		public var paginas:Vector.<PaginaDados> = new Vector.<PaginaDados>();
		
		public function ProjetoDados() 
		{
			//this.paginas.push(new PaginaDados());
			//this.paginas.push(new PaginaDados());
		}
		
		public function parse(strdados:String):Boolean {
			var retorno:Boolean = false;
			var dados:Object;
			try {
				dados = JSON.parse(strdados);
				retorno = true;
			} catch (e:Error) {
				// nada
			}
			
			//'{"titulo":"","id":"","tags":"","paginas":[{"imagens":[{"y":0,"x":50}],"baloes":[{"y":0,"x":0}]},{"imagens":[{"y":0,"x":70}],"baloes":[{"y":0,"x":0}]}]}';
			
			if (retorno) {
				this.titulo = dados.titulo;
				this.tags = dados.tags;
				this.id = dados.id;
				for (var i:int = 0; i < dados.paginas.length; i++) {
					
					
					
					this.paginas.push(new PaginaDados(dados.paginas[i]));
				}
			}
			
			return (retorno);
		}
		
	}

}