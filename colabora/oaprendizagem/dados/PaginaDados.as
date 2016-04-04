package colabora.oaprendizagem.dados 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class PaginaDados 
	{
		
		public var imagens:Vector.<ImagemDados> = new Vector.<ImagemDados>();
		
		public var baloes:Vector.<BalaoDados> = new Vector.<BalaoDados>();
		
		public function PaginaDados(objeto:Object = null) 
		{
			if (objeto != null) {
				for (var i:int = 0; i < objeto.imagens.length; i++) {
					this.imagens.push(new ImagemDados(objeto.imagens[i]));
				}
				for (i = 0; i < objeto.baloes.length; i++) {
					this.baloes.push(new BalaoDados(objeto.baloes[i]));
				}
			}
		}
		
	}

}