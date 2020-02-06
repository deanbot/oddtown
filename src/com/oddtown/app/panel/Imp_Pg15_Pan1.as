package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.app.ui.UIInterface;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class Imp_Pg15_Pan1 extends PanelImp
	{
		private static const ID:String="Pg15_Pan1";
		private var panel:Pg15_Pan1;
		public function Imp_Pg15_Pan1()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean{ return true; }
		
		override public function panelPrep():void { 
			panel=Pg15_Pan1(_asset);
			ClipUtils.makeInvisible(panel.cabinet);
			ClipUtils.hide(panel.words1,panel.words2);
			if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders"))
				ClipUtils.hide(panel.folders);
		}
		
		override protected function panelSetup():void
		{
			if(!panel)
				panel=Pg15_Pan1(_asset);
			if(!OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders"))
			{
				// show words 2
				ClipUtils.makeInvisible(panel.words2);
				TweenLite.to(panel.words2,.5,{alpha:1,onComplete:onPopupComplete,onCompleteParams:[2]});
			} else
				hookUp();
		}
		
		private function hookUp():void
		{
			MouseIconHandler.showArrowIcon();
			//todo if mouse over button trigger mouse over
			if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders"))
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onClick,panel.cabinet);
			else
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onClick,panel.folders,panel.cabinet);
			
			ClipUtils.hide(panel.words1,panel.words2);
		}
		
		override protected function panelCleanupEx():void
		{
			if(panel)
			{
				TweenLite.killTweensOf(panel.words2);
				TweenLite.killTweensOf(panel.words1);
			}
			
			if(panelClick)
				panelClick.removeAll();
			panelClick=null;
			SignalUtils.clearIntObjectSets(ID);	
			MouseIconHandler.showArrowIcon();
			panel=null;
		}
		
		private var panelClick:NativeSignal;
		private function onPopupComplete(popup:uint=0):void
		{
			panelClick=new NativeSignal(panel,MouseEvent.CLICK,MouseEvent);
			MouseIconHandler.showHoverIcon();
			if(popup==2)
				panelClick.addOnce(clearPopup2);
			else if(popup==1)
				panelClick.addOnce(clearPopup1);
		}
		
		private function clearPopup1(e:MouseEvent):void
		{
			TweenLite.to(panel.words1,.3,{alpha:0,onComplete:hookUp});
			panelClick=null;
		}
		
		private function clearPopup2(e:MouseEvent):void
		{
			TweenLite.to(panel.words2,.3,{alpha:0,onComplete:hookUp});
			panelClick=null;
		}
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				case panel.folders:
					OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders");
					signalPageEndReached(16);
					break;
				case panel.cabinet:
					if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders"))
						signalPageEndReached(17);
					else {
						ClipUtils.makeInvisible(panel.words1);
						SignalUtils.clearIntObjectSets(ID);
						MouseIconHandler.showArrowIcon();
						TweenLite.to(panel.words1,.5,{alpha:1,onComplete:onPopupComplete,onCompleteParams:[1]});
					}
					break;
			}
		}
	}
}