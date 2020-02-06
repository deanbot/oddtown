package com.oddtown.app.panel
{
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Imp_Pg20_Pan5 extends PanelImp
	{
		//bathroom
		private static const ID:String = "Imp_Pg20_Pan5";
		private static const FLAG_SAW_BATHROOM:String="Saw Bathroom";
		private var panel:Pg20_Pan5;
		private var active:Boolean;
		
		public function Imp_Pg20_Pan5()
		{
			super();
		}
		
		override protected function panelCleanupEx():void
		{
			active=false;
			fsm=null;
			_asset.gotoAndStop(0);
			panel=null;
			TweenLite.killDelayedCallsTo(delayedCall);
			SignalUtils.clearIntObjectSets(ID);
		}
		
		override protected function panelSetup():void
		{
			panel=Pg20_Pan5(_asset);
			active=true;
			//todo if over panel call hover
			MouseIconHandler.showHoverIcon();
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,goInside,panel);
		}
		
		private function goInside(e:MouseEvent):void
		{
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon(); 
			if(sawBathroom)
			{
				panel.gotoAndStop(panel.totalFrames);
				hookUpButton();
			} else
			{
				fsm=new FrameScriptManager(panel);
				fsm.setFrameScript(panel.totalFrames,hookUpButton);
				panel.gotoAndPlay("inside");
				sawBathroom=true;
			}
		}
			
		private function hookUpButton():void
		{
			panel.stop();
			//todo if over button call hover else if sawBathroom (could have skipped here) below 
//			MouseIconHandler.showArrowIcon();
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,leave,panel.btn);
		}
		
		private function leave(e:MouseEvent):void
		{
			panel.gotoAndStop(0);
			TweenLite.delayedCall(.5,delayedCall);
		}
		
		private function delayedCall():void
		{
			if(active)
				changePanel.dispatch(2);
		}
		
		private function set sawBathroom(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_SAW_BATHROOM);
		}
		
		private function get sawBathroom():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_SAW_BATHROOM);
		}
	}
}