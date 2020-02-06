package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Preloader extends Sprite
	{
		private var barWidth:Number=669;
		public function Preloader()
		{
			LoaderMax.activate([SWFLoader]);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onStage,false,0,true);
			//create a LoaderMax named "mainQueue" and set up onProgress, onComplete and onError listeners
		}
		
		private function onStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onStage);
			
			var loader:SWFLoader = new SWFLoader("Oddtown.swf", {onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});	
			this.container.addChild(loader.content);
			loader.load();
		}
		
		private function progressHandler(event:LoaderEvent):void {
			this.progress.mask.x = Math.ceil(event.target.progress*barWidth);
		}
		
		private function completeHandler(event:LoaderEvent):void {
			this.progress.visible=false;
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
	}
}