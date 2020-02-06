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
	
	public class Imp_Pg21_Pan1 extends PanelImp
	{
		private static const ID:String="Pg21_Pan1";
		private var panel:Pg21_Pan1;
		
		private static const ORDER_CLOCK:uint=2;
		private static const ORDER_DOOR:uint=3;
		
		public function Imp_Pg21_Pan1()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean{ return true; }
		
		override public function panelPrep():void {
			trace("preping")
			panel=Pg21_Pan1(_asset);
			//this hides hotspots
			ClipUtils.makeInvisible(panel.board, panel.clock, panel.door);
			
			//this is to HIDE the wors till called
			ClipUtils.hide(panel.word);
		}
		
		override protected function panelSetup():void
		{
			trace("settingUpPanel");
			if(!panel)
				panel=Pg21_Pan1(_asset);
			
			ClipUtils.hide(panel.word);
			
			UIInterface.refreshArrowClicks();
			UIInterface.showArrows(true,false);
			UIInterface.prevArrowClicked.addOnce(moveBack);
			
			hookUp();
			
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			trace("Over: " + e.target.name);
			MouseIconHandler.showHoverIcon();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			trace("Out: " + e.target.name);
			MouseIconHandler.showArrowIcon();
		}
		
		private function hookUp():void
		{
			/*
			//todo if mouse over button trigger mouse over
			if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders"))
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onClick,panel.board);
			else	*/
			trace("HOOK up")
			
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onClick,panel.clock,panel.door, panel.board);
			//UIInterface.refreshArrowClicks();
			//UIInterface.nextArrowClicked.addOnce(tryLeave);
			
			
		}
		
		override protected function panelCleanupEx():void
		{
			UIInterface.prevArrowClicked.removeAll();
			if(panelClick)
				panelClick.removeAll();
			panelClick=null;
			SignalUtils.clearIntObjectSets(ID);	
			MouseIconHandler.showArrowIcon();
			panel=null;
		}
		
		private function exitPage():void
		{
			trace("exitPage");
			/*
			ClipUtils.makeInvisible(panel.words);
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon();
			TweenLite.to(panel.words,.5,{alpha:1,onComplete:onPopupComplete,onCompleteParams:[2]});
			*/
		}
		
		private var panelClick:NativeSignal;
		private function onPopupComplete(popup:uint=0):void
		{
			
			panelClick=new NativeSignal(panel,MouseEvent.CLICK,MouseEvent);
			/*if(popup==2)
				panelClick.addOnce(clearPopup1);
			*/
			trace("reached on here")
			if(popup==1){
				panelClick.addOnce(clearPopup1);
				MouseIconHandler.showHoverIcon();
			}
		
		}
		
		private function clearPopup1(e:MouseEvent):void
		{
			TweenLite.to(panel.word,.3,{alpha:0,onComplete:hookUp});
			panelClick=null;
		}
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.target)
			{//if board clicked words come up
				case panel.board:
					trace("Board has been clicked")
					ClipUtils.makeInvisible(panel.word);
					SignalUtils.clearIntObjectSets(ID);
					
					TweenLite.to(panel.word,.5,{alpha:1,onComplete:onPopupComplete,onCompleteParams:[1]});
					
					OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders");
					//signalPageEndReached(16);
					break;
				//clock panel is shown and plays
				case panel.clock:
					trace("Clock has been Clicked")
					//this is driven my the XML
					MouseIconHandler.showArrowIcon();
					UIInterface.hideArrows();
					changePanel.dispatch(ORDER_CLOCK);
					break;
				//goes to door
				//loads a menu alows player to choose
				case panel.door:
					trace("Door has been clicked")
					MouseIconHandler.showHoverIcon();
					UIInterface.hideArrows();
					changePanel.dispatch(ORDER_DOOR);
					//this will have a custom pannel as well
			}
		}
		
		private function moveBack():void
		{
			trace("moveBack")
			signalPageEndReached(20)
		}
	}
}
