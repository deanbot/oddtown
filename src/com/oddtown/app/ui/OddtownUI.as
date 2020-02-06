package com.oddtown.app.ui
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.DictionaryUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.client.UIClient;
	import com.oddtown.engine.OddConfig;
	import com.oddtown.engine.OddtownEngine;
	import com.oddtown.engine.status.StatusObserver;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	
	public class OddtownUI extends UIClient
	{
	// constants:
		private static const ID:String="UI";
		private static const ARROW_FADE_IN:Number=.3;
	// private properties:
		private var btnNext:MovieClip;
		private var btnPrev:MovieClip;
		private var mNextSet:InteractiveObjectSignalSet;
		private var mPrevSet:InteractiveObjectSignalSet;
		private static var _instance:OddtownUI;
		private var manualArrowCall:Boolean;
		private var arrowsVisible:Boolean;
		private var manualNextArrowClicked:Signal;
		private var manualPrevArrowClicked:Signal;
		private var hud:HUD;
		private var optionsHeight:Number;
		private var hudActive:Boolean;
		private var optionsActive:Boolean;
		private var busy:Boolean;
		
	// public properties:
	// constructor:
		public function OddtownUI(key:UIKey)
		{
			super();
			manualArrowCall=arrowsVisible=false;
			manualNextArrowClicked=new Signal();
			manualPrevArrowClicked=new Signal();
			MouseIconHandler.initialize();
			hudActive=optionsActive=busy=false;
		}
		
		public static function getInstance():OddtownUI
		{
			if(OddtownUI._instance==null)
			{
				OddtownUI._instance=new OddtownUI(new UIKey());
			}
			return OddtownUI._instance;
		}
		
	// public getter/setters:
	// public methods:
		override public function update(status:uint, statusType:uint, translated:String):void
		{
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
				updateEngineStatus(status);
			else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
				updatePlayStatus(status);	
			
			//trace(translated);
		}
		
	// private methods:
		override protected function onStaged(e:Event):void
		{
			UIInterface.initialize(_instance,manualPrevArrowClicked,manualNextArrowClicked);
			btnNext = new UINextArrow();
			btnPrev = new UINextArrow();
			btnPrev.scaleX = -1;
			btnPrev.x = 10 + btnPrev.width;
			btnNext.x = OddConfig.stageWidth - btnNext.width - 10;
			btnPrev.y = btnNext.y = OddConfig.stageHeight - btnPrev.height - 10;
			//			btnNext.buttonMode = btnPrev.buttonMode = true;
			mPrevSet = new InteractiveObjectSignalSet(btnPrev)
			mNextSet = new InteractiveObjectSignalSet(btnNext);
			hud=new HUD();
			optionsHeight=hud.options.height;
			hud.options.y=-optionsHeight;
			ClipUtils.stopClips(hud.options.quit);
			ClipUtils.makeInvisible(hud);
			ClipUtils.hide(btnPrev,btnNext);
			addChild(btnPrev);
			addChild(btnNext);
			addChild(hud);
		}
		
		override protected function destroyEx():void
		{
			TweenLite.killDelayedCallsTo(onArrowsHidden);
			if(btnNext&&btnPrev)
			{
				TweenLite.killTweensOf(btnNext);
				TweenLite.killTweensOf(btnPrev);
			}
			if(hud)
			{
				TweenLite.killTweensOf(hud.options);
				TweenLite.killTweensOf(hud);
			}
			SignalUtils.clearIntObjectSets(ID+"_options");
			SignalUtils.clearIntObjectSets(ID+"_options2");
			SignalUtils.clearIntObjectSets(ID+"_hud");
			mPrevSet.removeAll();
			mNextSet.removeAll();
			manualNextArrowClicked.removeAll();
			manualPrevArrowClicked.removeAll();
			manualNextArrowClicked=manualPrevArrowClicked=null;
			mPrevSet=mNextSet=null;
			removeChild(btnNext);
			removeChild(btnPrev);
			removeChild(hud);
			hud=null;
			btnNext = btnPrev = null;
			_instance=null;
		}
		
		internal function showArrows(manual:Boolean=false,showPrev:Boolean=false,showNext:Boolean=false):void
		{
			if(manualArrowCall||arrowsVisible)
				return;
			if(manual)
				manualArrowCall=true;
			arrowsVisible=true;
			if((!manual&&_pageNavigationCommands.hasPrevPage)||(manual&&showPrev))
			{
				mPrevSet.click.addOnce(onPrevClicked);
				mPrevSet.mouseOver.add(onRollOver);
				mPrevSet.mouseOut.add(onRollOut);
				ClipUtils.makeInvisible(btnPrev);
				TweenLite.to(btnPrev,ARROW_FADE_IN,{alpha:1});
			}
			if((!manual&&_pageNavigationCommands.hasNextPage)||(manual&&showNext))
			{
				mNextSet.click.addOnce(onNextClicked);
				mNextSet.mouseOver.add(onRollOver);
				mNextSet.mouseOut.add(onRollOut);
				ClipUtils.makeInvisible(btnNext);
				TweenLite.to(btnNext,ARROW_FADE_IN,{alpha:1});
			}
			//todo if mouse over button trigger mouse over
		}
		
		internal function hideArrows():void
		{
			if(arrowsVisible)
			{
				arrowsVisible=manualArrowCall=false;
				mPrevSet.removeAll();
				mNextSet.removeAll();
				if(btnNext.visible&&btnNext.alpha==1)
					TweenLite.to(btnNext,ARROW_FADE_IN,{alpha:0});
				if(btnPrev.visible&&btnPrev.alpha==1)
					TweenLite.to(btnPrev,ARROW_FADE_IN,{alhpa:0});
				TweenLite.delayedCall(ARROW_FADE_IN,onArrowsHidden);
			}
		}
		
		
		
		internal function refreshArrowClicks():void
		{
			if(!arrowsVisible)
				return;
			if(mPrevSet.numListeners>0)
				mPrevSet.click.addOnce(onPrevClicked);
			if(mNextSet.numListeners>0)
				mNextSet.click.addOnce(onNextClicked);
		}
		
		internal function showHud():void
		{
			if(hudActive)
				return;
			hudActive=true;
			ClipUtils.makeInvisible(hud);
			TweenLite.to(hud,.3,{alpha:1});
			SignalUtils.hookUpIntObjectSets(ID+"_hud",onRollOver,onRollOut,onOptionsClick,hud.hudOptions);
		}
		
		internal function hideHud():void
		{
			if(!hudActive)
				return;
			hudActive=false;
			SignalUtils.clearIntObjectSets(ID+"_hud");
			TweenLite.to(hud,.3,{alpha:0});
		}
		
		private function toggleOptions(force:Boolean=false):void
		{
			if(busy)
				if(!force)
					return;
			busy=true;
			MouseIconHandler.showArrowIcon();
			if(optionsActive) 
			{
				hud.options.quit.gotoAndStop(1);
				SignalUtils.clearIntObjectSets(ID+"_options");
				SignalUtils.clearIntObjectSets(ID+"_options2");
				TweenLite.to(hud.options,.5,{y:-optionsHeight,alpha:0,onComplete:optionsToggled,onCompleteParams:[false]});
			}
			else
			{
				SignalUtils.clearIntObjectSets(ID+"_hud");
				hud.options.alpha=0;
				TweenLite.to(hud.options,.5,{y:0,alpha:1,onComplete:optionsToggled,onCompleteParams:[true]});
			}
		}
		
		private function onArrowsHidden():void
		{
			if(btnPrev&&btnNext)
				ClipUtils.hide(btnPrev,btnNext);
		}
			
		private function optionsToggled(active:Boolean):void
		{
			busy=false;
			optionsActive=active;
			if(active)
			{
				SignalUtils.hookUpIntObjectSets(ID+"_options",onRollOver,onRollOut,onOptionsClick,hud.options.exitMenu,hud.options.toggleFullscreen);
				SignalUtils.hookUpIntObjectSets(ID+"_options2",onButtonRollOver,onButtonRollOut,onOptionsClick,hud.options.quit.click);
			} else
			{
				SignalUtils.hookUpIntObjectSets(ID+"_hud",onRollOver,onRollOut,onOptionsClick,hud.hudOptions);
			}
		}
		
		private function onButtonRollOver(e:MouseEvent):void
		{
			if(busy)
				return;
			MouseIconHandler.showHoverIcon();
			MovieClip(e.target.parent).gotoAndStop(2);
		}
		
		private function onButtonRollOut(e:MouseEvent):void
		{
			if(busy)
				return;
			MouseIconHandler.showArrowIcon();
			MovieClip(e.target.parent).gotoAndStop(1);
		}
		
		private function onOptionsClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				case hud.options.quit.click:
					exitToMainMenu();
					break;
				case hud.options.exitMenu:
					toggleOptions();
					break;
				case hud.options.toggleFullscreen:
					toggleFullscreen();
					break;
				case hud.hudOptions:
					toggleOptions();
					break;
			}
		}
		
		private function toggleFullscreen():void
		{
			if(busy)
				return;
			_optionCommands.toggleFullscreen();
		}
		
		private function exitToMainMenu():void
		{
			if(busy)
				return;
			busy=true;
			toggleOptions(true);
			SignalUtils.clearIntObjectSets(ID+"_options");
			SignalUtils.clearIntObjectSets(ID+"_options2");
			hideArrows();
			hideHud();
			_optionCommands.exitToMainMenu();
		}
		
		private function updatePlayStatus(status:uint):void
		{
			playStatus = status;
			if(playStatus == OddtownEngine.PLAY_STATUS_PAGE_NAVIGATION)
				showArrows();
			else
				hideArrows();
			switch(playStatus)
			{
				case OddtownEngine.PLAY_STATUS_GAME_OVER:
				case OddtownEngine.PLAY_STATUS_OFF:
					hideHud();
					break
				default:
					showHud();
			}
		}
		
		private function updateEngineStatus(status:uint):void
		{
			engineStatus = status;
		}
		
		private function onPrevClicked(e:MouseEvent):void
		{
			if(busy)
				return;
			if(!manualArrowCall)
				_pageNavigationCommands.prevPage();
			else
				manualPrevArrowClicked.dispatch();
			MouseIconHandler.showArrowIcon();
		}
		
		private function onNextClicked(e:MouseEvent):void
		{
			if(busy)
				return;
			if(!manualArrowCall)
				_pageNavigationCommands.nextPage();
			else
				manualNextArrowClicked.dispatch();
			MouseIconHandler.showArrowIcon();
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			if(busy)
				return;
			MouseIconHandler.showHoverIcon();
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			if(busy)
				return;
			MouseIconHandler.showArrowIcon();
		}
	}
}
class UIKey {
	public function UIKey() { }
}