package com.oddtown.app.panel.test
{
	import com.deanverleger.utils.SignalUtils;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Test_Imp_Pg3_Pan1 extends PanelImp
	{
		private static const ID:String="Test_Imp_Pg3_Pan1";
		private var panel:Test_Pg3_Pan1;
		private var guageFSM:FrameScriptManager;
		private var firstPause:Boolean;
		public function Test_Imp_Pg3_Pan1()
		{
			super();
		}
		
		override protected function panelSetup():void
		{
			panel=Test_Pg3_Pan1(_asset);
			fsm=new FrameScriptManager(_asset);
			fsm.setFrameScript("Pause", fallPause);
			fsm.setFrameScript("Gauge", fallFinished);
			firstPause=true;
			_asset.play();
		}
		
		private function fallPause():void
		{
			if(firstPause)
			{
				firstPause=false;
				trace("fall pause. Okay, continuing to guage");
				_asset.stop();
				_asset.play();
			}
		}
		
		private function fallFinished():void
		{
			_asset.stop();
			guageFSM=new FrameScriptManager(panel.counter);
			guageFSM.setFrameScript(panel.counter.totalFrames, guageTimer);
			SignalUtils.hookUpIntObjectSets(ID+"_guage",rollOver,rollOut,clickedGauge,panel.counter);
			panel.counter.play();
		}
		
		private function guageTimer():void
		{
			SignalUtils.clearIntObjectSets(ID+"_guage");
			trace("oh no! you dropped it");
			setTree.dispatch("fail");
			panel.counter.stop();
			_asset.stop();
			changePanel.dispatch(2);
		}
		
		override protected function panelCleanupEx():void
		{
			SignalUtils.clearIntObjectSets(ID+"_guage");
			fsm=null;
			panel=null;
		}
		
		private function rollOver(e:MouseEvent):void
		{
			MouseIconHandler.showHoverIcon();
		}
		
		private function rollOut(e:MouseEvent):void
		{
			MouseIconHandler.showArrowIcon();
		}
		
		private function clickedGauge(e:MouseEvent):void
		{
			SignalUtils.clearIntObjectSets(ID+"_guage");
			trace("you got it!");
			setTree.dispatch("pass");
			_asset.gotoAndStop("Pause");
			changePanel.dispatch(2);
		}
	}
}