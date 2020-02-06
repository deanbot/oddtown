package com.oddtown.app.panel
{
	import com.greensock.TweenLite;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.app.ui.UIInterface;
	import com.oddtown.engine.DisplayLink;
	import com.oddtown.engine.PanelImp;
	
	public class Imp_Pg23_Pan1 extends PanelImp
	{
		public function Imp_Pg23_Pan1()
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
			UIInterface.hideHud();
		}
		
		private function goToNextPage():void
		{
			_asset.stop();
			try {
				var page:Pg23=DisplayLink.oddDisplay.getChildAt(0) as Pg23;
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