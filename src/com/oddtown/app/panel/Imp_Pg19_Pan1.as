package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Imp_Pg19_Pan1 extends PanelImp
	{
		private static const ID:String="Imp_Pg19_Pan1";
		private static const FLAG_CACTUS_DROP:String="Cactus Drop";
		private static const FLAG_CACTUS_CATCH:String="Cactus Catch";
		private var panel:Pg19_Pan1;
		private var guageFSM:FrameScriptManager;
		private var active:Boolean;
		
		public function Imp_Pg19_Pan1()
		{
			super();
		}
		
		override protected function panelSetup():void
		{
			panel=Pg19_Pan1(_asset);
			fsm=new FrameScriptManager(_asset);
			fsm.setFrameScript("guage", fallFinished);
			_asset.play();
			active=true;
		}
		
		private function fallFinished():void
		{
			if(!active)
				return;
			ClipUtils.stopClips(_asset,panel.guage,panel.guage.counter);
			ClipUtils.makeInvisible(panel.tutorial,panel.guage);
			TweenLite.to(panel.guage,.3,{alpha:1});
			TweenLite.to(panel.tutorial,.3,{alpha:1,onComplete:tutorialPopUp,delay:1});
		}
		
		private function tutorialPopUp():void
		{
			if(!active)
				return;
			SignalUtils.hookUpIntObjectSets(ID+"_tut",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,hideTutorial,panel.tutorial.click);
		}
		
		private var once:Boolean=true;
		private function hideTutorial(e:MouseEvent):void
		{
			if(once)
			{
				once=false;
				SignalUtils.clearIntObjectSets(ID+"_tut");
				MouseIconHandler.showArrowIcon();
				TweenLite.to(panel.tutorial,.5,{alpha:0,onComplete:startTimer});
			}
		}
			
		private function startTimer():void
		{
			once=true;
			ClipUtils.hide(panel.tutorial);
			guageFSM=new FrameScriptManager(panel.guage.counter);
			guageFSM.setFrameScript(panel.guage.counter.totalFrames, guageTimer);
			SignalUtils.hookUpIntObjectSets(ID+"_guage",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,clickedGauge,panel.guage.click);
			SignalUtils.hookUpDownUpSignals(ID+"_guage2",mouseDown,mouseUp,panel.guage.click);
			panel.guage.counter.play();
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			panel.guage.gotoAndStop("down");
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			panel.guage.gotoAndStop("up");	
		}
		
		private function guageTimer():void
		{
			if(!active)
				return;
			trace("oh no! you dropped it");
			setTree.dispatch("fail");
			cactusCatch=false;
			fadeGuage();
		}
		
		private function clickedGauge(e:MouseEvent):void
		{
			if(once)
			{
				once=false;
				trace("you got it!");
				setTree.dispatch("pass");
				cactusCatch=true;
				fadeGuage();
			}
		}
		
		private function fadeGuage():void
		{
			panel.guage.counter.stop();
			SignalUtils.clearIntObjectSets(ID+"_guage");
			SignalUtils.clearIntObjectSets(ID+"_guage2");
			MouseIconHandler.showArrowIcon();
			TweenLite.delayedCall(.5,checkGuageButton);
			TweenLite.to(panel.guage,1.5,{alpha:0,onComplete:onGuageFaded,delay:1});
		}
		
		private function checkGuageButton():void
		{
			if(panel.guage.currentFrameLabel=="down")
				panel.guage.gotoAndStop("up");
		}
		
		private function onGuageFaded():void
		{
			if(!active)
				return;
			ClipUtils.hide(panel.guage);
			_asset.gotoAndStop("pause");
			changePanel.dispatch(2);
		}
		
		override protected function panelCleanupEx():void
		{
			active=false;
			if(panel)
			{
				try {
					TweenLite.killTweensOf(panel.guage);
					TweenLite.killTweensOf(panel.tutorial);
					TweenLite.killDelayedCallsTo(checkGuageButton);
					TweenLite.killTweensOf(panel.guage);
				} catch(e:Error)
				{
					trace(e);
				}
			}
			SignalUtils.clearIntObjectSets(ID+"_guage");
			guageFSM=null;
			panel=null;
		}
		
		private function set cactusCatch(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CACTUS_CATCH);
			else
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CACTUS_DROP);
		}
	}
}