package com.oddtown.app.panel
{
	import com.greensock.TweenLite;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.engine.DisplayLink;
	import com.oddtown.engine.PanelImp;
	
	public class Imp_Pg13_Pan6 extends PanelImp
	{
		public function Imp_Pg13_Pan6()
		{
			super();
		}
		
		override protected function panelCleanupEx():void
		{
			fsm=null;	
		}
		
		override protected function panelSetup():void
		{
			fsm=new FrameScriptManager(_asset);
			fsm.setFrameScript(_asset.totalFrames,goToNextPage);
			_asset.play();
		}
		
		private function goToNextPage():void
		{
			_asset.stop();
			try {
				var page:Pg13=DisplayLink.oddDisplay.getChildAt(0) as Pg13;
				if(page)
				{
					trace('tweening page');
					TweenLite.to(page,1,{alpha:0,onComplete:signalPageEndReached});
				}
			} catch(e:Error) {
				trace(e);
				signalPageEndReached();
			}
		}
	}
}