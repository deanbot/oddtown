package com.oddtown.app.panel
{
	import com.greensock.TweenLite;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.engine.PanelImp;
	
	public class Imp_Pg20_Pan4 extends PanelImp
	{
		//camera
		private static const ID:String = "Imp_Pg20_Pan4";
		private var panel:Pg20_Pan4;
		private var active:Boolean;
		
		public function Imp_Pg20_Pan4()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void { _asset.gotoAndStop(0); }
		
		override protected function panelCleanupEx():void
		{
			active=false;
			TweenLite.killDelayedCallsTo(change);
		}
		
		override protected function panelSetup():void
		{
			active=true;
			fsm=new FrameScriptManager(_asset);
			fsm.setFrameScript(_asset.totalFrames,onEnd);
			_asset.play();
		}
		
		private function onEnd():void
		{
			_asset.stop();
			TweenLite.delayedCall(1,change);
		}
		
		private function change():void
		{
			if(active)
				changePanel.dispatch(2);
		}
	}
}