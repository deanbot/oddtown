package com.oddtown.app.panel.test
{
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	
	public class Test_Imp_Pg2_Pan4 extends PanelImp
	{
		private static const ID:String = "Test_Imp_Pg2_Pan4";
		private static const TIME_NAV_FADE_IN:Number=2;
		private var panel:Test_Pg2_Pan4;
		private var panelSet:InteractiveObjectSignalSet;
		private var doorOpen:Boolean;
		public function Test_Imp_Pg2_Pan4()
		{
			super();
		}
		
		override protected function panelSetup():void
		{
			panel=Test_Pg2_Pan4(_asset);
			panelSet=new InteractiveObjectSignalSet(panel);
			panelSet.click.add(openDoor);
		}
		
		override protected function panelCleanupEx():void
		{
			SignalUtils.destroy();
			panel.gotoAndStop("Closed");
			panel=null;
			panelSet.removeAll();
			panelSet=null;
			doorOpen=false;
		}
		
		private function openDoor(e:MouseEvent):void
		{
			if(doorOpen)
			{
				panelSet.removeAll();
				panel.gotoAndStop("Bathroom");
				TweenLite.to(panel.bathroomNav, TIME_NAV_FADE_IN, { alpha:1,onComplete:hookUpNav });
			} else 
			{
				panel.gotoAndStop("Open");
				doorOpen=true;
			}
		}
		
		private function hookUpNav():void
		{
			switch(panel.currentFrameLabel) {
				case "Bathroom":
					//turn button
					SignalUtils.hookUpIntObjectSets(ID+'_Bathroom_Turn',rollOver,rollOut,turn,panel.bathroomNav.turn);
					//leave button
					SignalUtils.hookUpIntObjectSets(ID+'_Bathroom_Leave',rollOver,rollOut,leave,panel.bathroomNav.back);
					break;
				case "Tub":
					//turn button
					SignalUtils.hookUpIntObjectSets(ID+'_Tub_Turn',rollOver,rollOut,turn,panel.tubNav.turn);
					//leave button
					SignalUtils.hookUpIntObjectSets(ID+'_Tub_Leave',rollOver,rollOut,leave,panel.tubNav.back);
					break;
			}
		}
		
		private function unHookNav():void
		{
			switch(panel.currentFrameLabel) {
				case "Bathroom":
					SignalUtils.clearIntObjectSets(ID+'_Bathroom_Turn');
					SignalUtils.clearIntObjectSets(ID+'_Bathroom_Leave');
					break;
				case "Tub":
					SignalUtils.clearIntObjectSets(ID+'_Tub_Turn');
					SignalUtils.clearIntObjectSets(ID+'_Tub_Leave');
					break;
			}
		}
		
		private function leave(e:MouseEvent):void
		{
			panel.gotoAndStop("Open");
			TweenLite.delayedCall(.5,changePanel.dispatch,[1]);
		}
		
		private function turn(e:MouseEvent):void
		{
			switch(panel.currentFrameLabel) {
				case "Bathroom":
					panel.bathroomNav.alpha=0;
					unHookNav();
					panel.gotoAndStop("Tub");
					OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,'Tub Discovered');
					TweenLite.to(panel.tubNav, TIME_NAV_FADE_IN, { alpha:1,onComplete:hookUpNav });
					break;
				case "Tub":
					panel.tubNav.alpha=0;
					unHookNav();
					panel.gotoAndStop("Bathroom");
					TweenLite.to(panel.bathroomNav, TIME_NAV_FADE_IN, { alpha:1,onComplete:hookUpNav });
					break;
			}
		}
		
		private function rollOver(e:MouseEvent):void
		{
			MouseIconHandler.showHoverIcon();
		}
		
		private function rollOut(e:MouseEvent):void
		{
			MouseIconHandler.showArrowIcon();
		}
	}
}