package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.DisplayLink;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	import com.oddtown.engine.sound.OddSoundInterface;
	import com.oddtown.engine.sound.SoundObjectType;
	
	import flash.events.MouseEvent;
	
	public class Imp_Pg16_Pan5 extends PanelImp
	{
		private static const ID:String="Imp_Pg16_Pan5";
		private static const FLAG_CHAO:String="flagChao";
		private static const FLAG_MASON:String="flagMason";
		private var panel:Pg16_Pan5;
		public function Imp_Pg16_Pan5()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void { 
			panel=Pg16_Pan5(asset);
			ClipUtils.makeInvisible(panel.btn);
		}
		
		override protected function panelCleanupEx():void
		{
			if(panel)
			{
				TweenLite.killTweensOf(panel.btn);
			}
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon();
			panel=null;
		}
		
		override protected function panelSetup():void
		{
			TweenLite.to(panel.btn,.5,{alpha:1,delay:1.5,onComplete:btnTweened});
		}
		
		private function btnTweened():void
		{
			//todo if mouse over button trigger mouse over
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onBtnClick,panel.btn.click);
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon();
			TweenLite.to(panel.btn,.5,{alpha:0, onComplete:onFade});
			OddSoundInterface.playSingleSoundObject("slidePaper",SoundObjectType.AMBIENT,1);
			try {
				var page:Pg16=DisplayLink.oddDisplay.getChildAt(0) as Pg16;
				if(page)
				{
					page.pan1.masonClick.visible=false;
					TweenLite.to(page.pan1.mason,1,{alpha:0,onComplete:hideFolder});
				}
			} catch(e:Error) {
				trace(e);
			}
		}
		
		private function hideFolder():void
		{
			var page:Pg16=DisplayLink.oddDisplay.getChildAt(0) as Pg16;
			if(page)
				page.pan1.mason.visible=false;
		}
		
		private function onFade():void
		{
			if(hasChao && hasMason)
				changePanel.dispatch(6);
			else
				changePanel.dispatch(1);
		}
		
		private function get hasChao():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG, FLAG_CHAO);
		}
		
		private function get hasMason():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG, FLAG_MASON);
		}
	}
}