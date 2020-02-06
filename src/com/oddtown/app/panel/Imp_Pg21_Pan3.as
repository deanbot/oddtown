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
	
	public class Imp_Pg21_Pan3 extends PanelImp
	{
		private static const ID:String="Pg21_Pan3";
		private static const FLAG_NO_LEAVE:String="ReturnBack";
		private var panel:Pg21_Pan3;
		private var notLeaving:Boolean = false;
		
		
		public function Imp_Pg21_Pan3()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean{ return true; }
		
		override public function panelPrep():void {
			trace("preping")
			panel=Pg21_Pan3(_asset);
			//this hides hotspots
			ClipUtils.makeInvisible(panel.doorExit, panel.popUp.yesBtn, panel.popUp.noBtn);
			
			ClipUtils.hide(panel.popUp);


		}
		
		override protected function panelSetup():void
		{
			
			trace("settingUpPanel")
			//this deals with when you come BACK to panel 1
			
		
			
			
			
			if(!panel){
				panel=Pg21_Pan3(_asset);
				
			}//end of !panel
			//the first time you come it hooks it all up
			else{
				SignalUtils.hookUpIntObjectSets(ID,onMouseOver,onMouseOut,onClick, panel.popUp.yesBtn, panel.popUp.noBtn, panel.doorExit);
				
			}
			//UIInterface.showArrows(false,true);
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
		
			
			//todo if mouse over button trigger mouse ove
		
			if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"ReturnBack")){
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onClick, panel.popUp.yesBtn, panel.popUp.noBtn, panel.doorExit);
			trace("OMG WORK")
		}
			else{
			trace("HOOK up")
			
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onClick, panel.popUp.yesBtn, panel.popUp.noBtn, panel.doorExit);
			
			}
			//UIInterface.refreshArrowClicks();
			//UIInterface.nextArrowClicked.addOnce(tryLeave);
			
			ClipUtils.hide(panel.popUp);
			
			
			
		
		}
		
		override protected function panelCleanupEx():void
		{
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
			
			//panelClick=new NativeSignal(panel,MouseEvent.CLICK,MouseEvent);
			/*if(popup==2)
				panelClick.addOnce(clearPopup1);
			*/
			trace("reached on here")
			/*if(popup==1){
				panelClick.addOnce(clearPopup1);
			}*/
		
		}
		
		private function clearPopup1(e:MouseEvent):void
		{
			
			//TweenLite.to(panel.word,.3,{alpha:0,onComplete:hookUp});
			//panelClick=null;
			
		}
		
	
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.target)
			{//if board clicked words come up
				case panel.doorExit:
					trace("Board has been clicked")
					ClipUtils.makeInvisible(panel.popUp);
					//SignalUtils.clearIntObjectSets(ID);
					MouseIconHandler.showArrowIcon();
					TweenLite.to(panel.popUp,.5,{alpha:1,onComplete:null});
					
					//OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,"picked up folders");
					//signalPageEndReached(16);
					break;
				//clock panel is shown and plays
				case panel.popUp.yesBtn:
					trace("yes has been Clicked")
					signalPageEndReached(22);
					//this is driven my the XML
					//changePanel.dispatch(ORDER_CLOCK);
						
					break;
				//goes to door
				//loads a menu alows player to choose
				case panel.popUp.noBtn:
					//need to clean up
					trace("no has been clicked")
					ClipUtils.hide(panel.popUp);
					changePanel.dispatch(1);
					
					//notLeave = true;
					notLeaving= true;
					trace(notLeaving)
					
					
					break;
					
			}
		}
		
		/*
		
		private function set notLeave(val:Boolean):void
		{
			if(val)
				trace(notLeave)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_NO_LEAVE);
		}
		
		private function get notLeave():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_NO_LEAVE);
		}
		
		*/
		
		
		
	}
}