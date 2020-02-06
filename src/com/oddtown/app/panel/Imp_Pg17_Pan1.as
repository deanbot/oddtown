package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.DisplayLink;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	import flash.events.MouseEvent;
	
	public class Imp_Pg17_Pan1 extends PanelImp
	{
		private static const ID:String="Imp_Pg17_Pan1";
		private static const FLAG_TUTORIAL:String="p17 saw tutorial";

		private var panel:Pg17_Pan1;
		public function Imp_Pg17_Pan1()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void
		{
			panel=Pg17_Pan1(_asset);
			ClipUtils.hide(panel.tutorial);
		}
		
		override protected function panelSetup():void
		{
			if(!panel)
				panel=Pg17_Pan1(_asset);
			if(!sawTutorial)
			{
				panel.tutorial.visible=true;
				TweenLite.to(panel.tutorial,.5,{alpha:1,onComplete:tutorialVisible});
			}
		}
		
		override protected function panelCleanupEx():void
		{
			if(panel)
			{
				TweenLite.killTweensOf(panel.tutorial);
			}
			
			SignalUtils.clearIntObjectSets(ID);
			panel=null;
		}
		
		private function tutorialVisible():void
		{
			//todo if over trigger hover
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,clickedTutorial,panel.tutorial.click);
		}
		
		private function setTutorialInvisible():void { 
			panel.tutorial.visible=false; 
			changePanel.dispatch(2);
		}
		
		private function clickedTutorial(e:MouseEvent):void
		{
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon();
			sawTutorial=true;
			TweenLite.to(panel.tutorial,.5,{alpha:0,onComplete:setTutorialInvisible});
		}
		
		private function get sawTutorial():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_TUTORIAL);
		}
		
		private function set sawTutorial(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_TUTORIAL);
		}
	}
}