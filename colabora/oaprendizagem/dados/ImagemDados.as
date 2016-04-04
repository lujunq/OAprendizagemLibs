package colabora.oaprendizagem.dados 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ImagemDados 
	{
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public function ImagemDados(objeto:Object = null) 
		{
			if (objeto != null) {
				x = objeto.x;
				y = objeto.y;
			}
		}
		
	}

}