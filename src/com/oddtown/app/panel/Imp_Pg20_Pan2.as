package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.app.ui.UIInterface;
	import com.oddtown.engine.DisplayLink;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Imp_Pg20_Pan2 extends PanelImp
	{
		// main
		private static const ID:String = "Imp_Pg20_Pan2";
		private static const FLAG_SAW_BATHROOM:String="Saw Bathroom";
		private static const FLAG_CACTUS_DROP:String="Cactus Drop";
		private static const FLAG_CACTUS_CATCH:String="Cactus Catch";
		private static const ORDER_CACTUS:uint=3;
		private static const ORDER_CAMERA:uint=4;
		private static const ORDER_BATHROOM:uint=5;
		private var speechBookActive:Boolean;
		private var speechChairActive:Boolean;
		
		private var active:Boolean;
		
		private var panel:Pg20_Pan2;
		
		public function Imp_Pg20_Pan2()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void 
		{
			panel=Pg20_Pan2(_asset);
			ClipUtils.hide(panel.speech_books,panel.speech_chair);
			ClipUtils.makeInvisible(panel.click_chair,panel.click_camera,panel.click_cabinet,panel.click_books,panel.click_bathroom);
			if(cactusCatched)
			{
				ClipUtils.hide(panel.click_cactus_fail);
				ClipUtils.makeInvisible(panel.click_cactus_pass);
				panel.gotoAndStop("pass");
			} 
			else 
			{
				ClipUtils.hide(panel.click_cactus_pass);
				ClipUtils.makeInvisible(panel.click_cactus_fail);
			}
		}
		
		override protected function panelSetup():void
		{
			active=true;
			try {
				var page:Pg20=(DisplayLink.oddDisplay.getChildAt(0)) as Pg20;
				ClipUtils.hide(page.pan1);
				page=null;
			} catch(e:Error) {
				trace(e);
			}
			//hide panel 1
			if(!panel)
				panel=Pg20_Pan2(_asset);
			speechBookActive=speechChairActive=false;
			hookUp();
			
			if(sawBathroom)
			{
				UIInterface.refreshArrowClicks();
				UIInterface.showArrows(false,true);
				UIInterface.nextArrowClicked.addOnce(moveForward);
			}
		}
		
		override protected function panelCleanupEx():void
		{
			active=false;
			if(panel)
			{
				TweenLite.killTweensOf(panel.speech_books);
				TweenLite.killTweensOf(panel.speech_chair);
				if(speechBookActive)
					ClipUtils.hide(panel.speech_books);
				if(speechChairActive)
					ClipUtils.hide(panel.speech_chair);
			}
			unHook();
			panel=null;
		}
		
		private function unHook():void
		{
			if(sawBathroom)
				UIInterface.hideArrows();
			SignalUtils.clearIntObjectSets(ID);
			SignalUtils.clearIntObjectSets(ID+'_cactus');
			MouseIconHandler.showArrowIcon();
		}
		
		private function hookUp():void
		{
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onItemClick,
				/*panel.click_cabinet,*/panel.click_camera,panel.click_chair,panel.click_books,panel.click_bathroom);
			if(cactusCatched)
				SignalUtils.hookUpIntObjectSets(ID+'_cactus',MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onItemClick, panel.click_cactus_pass);
			else
				SignalUtils.hookUpIntObjectSets(ID+'_cactus',MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onItemClick, panel.click_cactus_fail);
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			trace(e.target.name);
			switch(e.target)
			{
				case panel.click_chair:
					unHook();
					speechChairActive=true;
					panel.speech_chair.visible=true;
					TweenLite.to(panel.speech_chair,.5,{alpha:1,onComplete:onPopup});
					break;
				case panel.click_books:
					unHook();
					panel.speech_books.visible=true;
					speechBookActive=true;
					TweenLite.to(panel.speech_books,.5,{alpha:1,onComplete:onPopup});
					break;
				case panel.click_camera:
					unHook();
					changePanel.dispatch(ORDER_CAMERA);
					break;
				case panel.click_cactus_fail:
				case panel.click_cactus_pass:
					unHook();
					changePanel.dispatch(ORDER_CACTUS);
					break;
				case panel.click_cabinet:
					break;
				case panel.click_bathroom:
					unHook();
					changePanel.dispatch(ORDER_BATHROOM);
					break;
			}
		}
		
		private function onPopup():void
		{
			//todo if over panel call hover icon
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,hideSpeech,panel);
		}
		
		private function hideSpeech(e:MouseEvent):void
		{
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon();
			if(speechBookActive)
			{
				speechBookActive=false;
				TweenLite.to(panel.speech_books,.3,{alpha:0,onComplete:onSpeechHidden});
			}
			if(speechChairActive)
			{
				TweenLite.to(panel.speech_chair,.3,{alpha:0,onComplete:onSpeechHidden});
				speechChairActive=false;
			}
		}
			
		private function onSpeechHidden():void
		{
			if(active)
			{
				ClipUtils.hide(panel.speech_books,panel.speech_chair);
				hookUp();
			}
		}
		
		private function get cactusCatched():Boolean { 
			var result:Boolean;
			var catched:Boolean=OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CACTUS_CATCH);
			var dropped:Boolean=OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CACTUS_DROP);
			if(catched)
				result=true;
			else if(dropped)
				result=false;
			else {
				//default to true
				result=true;
			}
			return result;
		}
		
		private function moveForward():void
		{
			signalPageEndReached();
		}
		
		private function get sawBathroom():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_SAW_BATHROOM);
		}
	}
}