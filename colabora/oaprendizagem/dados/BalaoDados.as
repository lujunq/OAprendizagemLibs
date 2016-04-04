package colabora.oaprendizagem.dados 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class BalaoDados 
	{
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public function BalaoDados(objeto:Object = null) 
		{
			if (objeto != null) {
				x = objeto.x;
				y = objeto.y;
			}
		}
		
	}

}