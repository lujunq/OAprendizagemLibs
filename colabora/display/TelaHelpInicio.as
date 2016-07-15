package colabora.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaHelpInicio extends Sprite 
	{
		
		public function TelaHelpInicio(gr:Bitmap) 
		{
			super();
			this.addChild(gr);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			if (this.stage) {
				this.parent.removeChild(this);
			}
		}
		
	}

}