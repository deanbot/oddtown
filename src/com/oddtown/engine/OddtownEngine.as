package com.oddtown.engine
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.CleanupUtils;
	import com.oddtown.engine.command.ChangeToPageCommand;
	import com.oddtown.engine.command.GameCompletionCommands;
	import com.oddtown.engine.command.GetPageCommand;
	import com.oddtown.engine.command.SoundCommands;
	import com.oddtown.engine.explore.PageExplorer;
	import com.oddtown.engine.sound.OddSoundInterface;
	import com.oddtown.engine.sound.OddSounds;
	import com.oddtown.engine.sound.SoundLibrary;
	import com.oddtown.engine.status.StatusObserver;
	import com.oddtown.engine.status.StatusSubject;
	import com.oddtown.engine.status.StatusTranslationUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	import org.osflash.signals.Signal;

	/**
	 * Engine Singleton. Don't instantiate directly, use getInstance for a reference.
	 * @author dean
	 * 
	 */
	public class OddtownEngine implements StatusSubject, StatusObserver, IDestroyable
	{
	// constants:
		public static const STATUS_TYPE_ENGINE:uint = 0;
		public static const STATUS_TYPE_PLAY:uint = 1;
		public static const ENGINE_STATUS_OFF:uint = 0;
		public static const ENGINE_STATUS_WAITING:uint = 1;
		public static const ENGINE_STATUS_BUSY:uint = 2;
		public static const PLAY_STATUS_OFF:uint = 0; // default
		public static const PLAY_STATUS_PAUSED:uint = 1; // game paused
		public static const PLAY_STATUS_PLAYING_PANEL:uint = 2; // playing a standard panel
		public static const PLAY_STATUS_EXPLORING_PANEL:uint = 3 // in an exploratory panel
		public static const PLAY_STATUS_PAGE_NAVIGATION:uint = 4; // at zoomed out, can view panel or change page
		public static const PLAY_STATUS_ZOOMING_PANEL:uint = 5; // in process of viewing panel, viewing panel, or going back to zoomed out
		public static const PLAY_STATUS_CHANGING_PAGE:uint=6;
		public static const PLAY_STATUS_GAME_OVER:uint=7;
		public static const COMMAND_TYPE_NEXT_PAGE:uint = 0;
		public static const COMMAND_TYPE_PREV_PAGE:uint = 1;
		public static const COMMAND_TYPE_HAS_NEXT:uint=2;
		public static const COMMAND_TYPE_HAS_PREV:uint=3;
		
	// private properties:
		private static var _instance:OddtownEngine;
		private var currentPage:uint = 0;
		private var currentPanel:uint = 0;
		private var _oddDisplay:Sprite;
		private var engineStatus:uint = 0;
		private var playStatus:uint = 0;
		private var engineStatusSubscribers:Array;
		private var playStatusSubscribers:Array;
		private var oddLibrary:OddLibrary;
		private var pageLibrary:PageLibrary;
		private var pageManager:PageManager;
		private var pageExplorer:PageExplorer;
		private var nextPage:uint;
		private var parseStack:Array;
		private var soundLibrary:SoundLibrary;
		private var oddSounds:OddSounds;
		private var _beatGame:Signal;
		private var _lostGame:Signal;
		private var _exitedToMenu:Signal;
		private var lost:Boolean;
		private var exit:Boolean;
	// public properties:
	// constructor:
		public function OddtownEngine(key:EngineKey) 
		{ 
			engineStatusSubscribers = new Array();
			playStatusSubscribers = new Array();
			engineStatus = playStatus = nextPage = 0;
			_oddDisplay = new Sprite();
			DisplayLink.oddDisplay=_oddDisplay;
			oddLibrary=new OddLibrary(OddConfig.xmlPath);
			pageLibrary = new PageLibrary();
			soundLibrary=new SoundLibrary();
			oddSounds=new OddSounds();
			oddSounds.soundLibraryCommands=new SoundCommands(soundLibrary);
			pageManager = new PageManager(_oddDisplay);
			pageExplorer = new PageExplorer(_oddDisplay);
			pageManager.getPageCommand = new GetPageCommand(pageLibrary);
			pageExplorer.getPageCommand = new GetPageCommand(pageLibrary);
			_lostGame=new Signal();
			_beatGame=new Signal();
			_exitedToMenu=new Signal();
			lost=exit=false;
		}	
		
	// public getter/setters:

		public function get exitedToMenu():Signal
		{
			return _exitedToMenu;
		}

		public function get lostGame():Signal
		{
			return _lostGame;
		}

		public function get beatGame():Signal
		{
			return _beatGame;
		}

		public function get oddDisplay():DisplayObject
		{
			return _oddDisplay;
		}
		
	// public methods:
		public static function getInstance():OddtownEngine
		{
			if(OddtownEngine._instance==null)
			{
				OddtownEngine._instance=new OddtownEngine(new EngineKey());
			}
			return OddtownEngine._instance;
		}
		
		public function destroy():void
		{
			trace("destroy OddtownEngine");
			if(engineStatusSubscribers)
				engineStatusSubscribers.splice(0);
			if(playStatusSubscribers)
				playStatusSubscribers.splice(0);
			engineStatusSubscribers = null;
			playStatusSubscribers = null;
			CleanupUtils.destroy(oddSounds,pageManager,pageExplorer,oddLibrary,pageLibrary,soundLibrary);
			pageManager=null;
			pageExplorer=null;
			oddLibrary=null;
			pageLibrary=null;
			soundLibrary=null;
			oddSounds=null;
			DisplayLink.destroy();
			_oddDisplay = null;
			_instance = null;
			_lostGame.removeAll();
			_beatGame.removeAll();
			_exitedToMenu.removeAll();
			_lostGame=_beatGame=_exitedToMenu=null;
			OddFlags.destroy();
		}
		
		public function build():void
		{
			// final setup requiring engine instance
			pageExplorer.subscribeToStatus(_instance,OddtownEngine.STATUS_TYPE_PLAY);
			pageExplorer.changeToPageCommand=new ChangeToPageCommand(_instance);
			pageExplorer.gameCompletionCommands=new GameCompletionCommands(_instance);
			oddLibrary.parseComplete.addOnce(onParseComplete);
			oddLibrary.build();
		}
		
		public function hasNextPage():Boolean
		{
			var hasNext:Boolean;
			var oPage:OddPage=pageLibrary.getPage(currentPage);
			if(oPage)
				if(oPage.nextPage!=0)
					hasNext=true;
			return hasNext;
		}
		
		public function hasPrevPage():Boolean
		{
			var hasPrev:Boolean;
			var oPage:OddPage=pageLibrary.getPage(currentPage);
			if(oPage)
				if(oPage.prevPage!=0)
					hasPrev=true;
			return hasPrev;
		}
		
		public function changeToNextPage():void
		{
			if(engineStatus == ENGINE_STATUS_WAITING)
			{
				trace("change to next page command");
				var oPage:OddPage=pageLibrary.getPage(currentPage);
				var id:uint=oPage.nextPage;
				var flag:String=oPage.nextPageFlagReq;
				var antiFlag:String=oPage.nextPageAntiFlagReq;
				changeToPage(id,flag,antiFlag);
			}
		}
		
		public function changeToPrevPage():void
		{
			if(engineStatus == ENGINE_STATUS_WAITING)
			{
				trace("change to prev page command");
				var oPage:OddPage=pageLibrary.getPage(currentPage);
				var id:uint=oPage.prevPage;
				var flag:String=oPage.prevPageFlagReq;
				var antiFlag:String=oPage.prevPageAntiFlagReq;
				changeToPage(id,flag,antiFlag);
			}
		}
		
		public function changeToPage(id:uint=NaN, flag:String="", antiFlag:String=""):Boolean
		{
			var success:Boolean;
			if(engineStatus == ENGINE_STATUS_WAITING)
			{
				if(isNaN(id))
					return false;
				success=changePage(id,flag,antiFlag);
			}
			return success;
		}
		
		public function toggleFullscreen():void
		{
			var stg:Stage=_oddDisplay.stage;
			if(!stg)
				return;
			if (stg.displayState == StageDisplayState.NORMAL) {         
				stg.displayState = StageDisplayState.FULL_SCREEN;
			} else 
			{
				stg.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function subscribeToStatus(o:StatusObserver, statusType:uint):void
		{
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
			{
				if(engineStatusSubscribers.indexOf(o) == -1)
					engineStatusSubscribers.push(o);
			} else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
			{
				if(playStatusSubscribers.indexOf(o) == -1)
					playStatusSubscribers.push(o);
			}
		}
		
		public function unsubscribeFromStatus(o:StatusObserver, statusType:uint):void
		{
			var observers:Array;
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
				observers = engineStatusSubscribers;
			else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
				observers = playStatusSubscribers;
			
			for (var i:int=0; i<observers.length; i++)
			{
				if (observers[i]==o)
				{
					observers.splice(i,1);
					break;
				}
			}
		}
		
		public function update(status:uint, statusType:uint, translated:String):void
		{
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
				engineStatus = status;
			else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
				playStatus = status;
			setStatus(status,statusType);
			//trace(translated);
		}
		
		public function exitToMainMenu():void
		{
			exit=true;
			pageExplorer.transitionOutFinished.removeAll();
			pageExplorer.transitionOutFinished.addOnce(onGameFadedOut);
			pageExplorer.transitionPageOut(2);
			OddSoundInterface.stopAllSounds(1.5);
		}
		
		public function setBeatGame():void
		{
			lost=false;	
			pageExplorer.transitionOutFinished.removeAll();
			pageExplorer.transitionOutFinished.addOnce(onGameFadedOut);
			pageExplorer.transitionPageOut(4);
			OddSoundInterface.stopAllSounds(3.5);
		}
		
		public function setLostGame():void
		{
			lost=true;
			pageExplorer.transitionOutFinished.removeAll();
			pageExplorer.transitionOutFinished.addOnce(onGameFadedOut);
			pageExplorer.transitionPageOut(4);
			OddSoundInterface.stopAllSounds(3.5);
		}
		
		private function onGameFadedOut():void
		{
			pageExplorer.destroyPage();
			pageManager.destroyPage();	
			endGame();
		}
		
		private function endGame():void
		{
			trace("Game Ended");
			if(exit)
				_exitedToMenu.dispatch();
			else if(lost)
				_lostGame.dispatch();
			else
				_beatGame.dispatch();
		}
		
	// private methods:
		private function onParseComplete(id:String, pagesData:XMLList=null, soundsData:XMLList=null):void
		{	
			if(id==OddLibrary.ID)
			{
				trace("XML loaded");
				parseStack=new Array();
				if(pagesData) {
					parseStack.push(PageLibrary.ID);
					pageLibrary.parseComplete.addOnce(onParseComplete);
				} else
					trace("No Pages XML Data");
				if(soundsData) {
					parseStack.push(SoundLibrary.ID);
					soundLibrary.parseComplete.addOnce(onParseComplete);
				} else
					trace("No Sounds XML Data");
				
				if(soundsData)
					soundLibrary.build(soundsData);
				if(pagesData)
					pageLibrary.build(pagesData);
			} else if(parseStack.length>0)
			{
				trace(id+" parse complete");
				var parseIndex:int=parseStack.lastIndexOf(id);
				if(parseIndex!=-1)
					parseStack.splice(parseIndex,1);
				if(parseStack.length==0)
				{
					parseStack=null;
					play();
				}
			}
		}
		
		private function play():void
		{
			trace("xml loaded and parsed, playing game");
			nextPage=pageLibrary.firstPage;
			updatePage();
		}
		
		private function changePage(id:uint=0,flag:String="",antiFlag:String=""):Boolean
		{
			var canPass:Boolean=true;
			var success:Boolean=false;
			if(id==0)
				return false;
			if(flag||antiFlag)
			{
				if(flag)
					if(!OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,flag))
						canPass=false;
				if(antiFlag)
					if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,antiFlag))
						canPass=false;
			}
			if(canPass)
			{
				nextPage=id;
				success=updatePage();
			}
			return success;
		}
		
		/**
		 * Check if next page, transition current page out, and set up next step : destroy
		 * 
		 */
		private function updatePage():Boolean
		{
			if(nextPage == 0)
			{
				trace("Trying to call OddtownEngine.changePage without a nextPage set... What's the big idea!?");
				return false;
			}
			setStatus(ENGINE_STATUS_BUSY, STATUS_TYPE_ENGINE);
			setStatus(OddtownEngine.PLAY_STATUS_CHANGING_PAGE,STATUS_TYPE_PLAY);
			pageExplorer.transitionOutFinished.addOnce(changePageAfterFadedOut);
			pageExplorer.transitionPageOut();
			return true;
		}
		
		/**
		 * Destroy page and Build page and set up next step : transition in
		 * 
		 */
		private function changePageAfterFadedOut():void
		{
			pageExplorer.destroyPage();
			pageManager.destroyPage();
			pageManager.pageBuilt.addOnce(changePageAfterBuilt);
			pageManager.buildPage(nextPage);
		}
		
		/**
		 * Transition in page and set up next step : set engine status
		 * 
		 */
		private function changePageAfterBuilt():void
		{
			currentPage=nextPage;
			nextPage=0;
			pageExplorer.setPage(currentPage);
			pageExplorer.transitionInFinished.addOnce(changePageAfterFadedIn);
			pageExplorer.explore(pageLibrary.getPageResetTree(currentPage));
		}
		
		private function changePageAfterFadedIn():void
		{
			setStatus(ENGINE_STATUS_WAITING,STATUS_TYPE_ENGINE);
		}
		
		private function setStatus(status:uint, statusType:uint):void
		{	
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
			{
				engineStatus = status;
				notifyObserver(statusType);
			}
			else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
			{
				playStatus = status;
				notifyObserver(statusType);
			}
		}
		
		private function notifyObserver(statusType:uint):void
		{
			var status:uint;
			var observers:Array;
			
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
			{
				observers = engineStatusSubscribers;
				status = engineStatus;
			}
			else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
			{
				observers = playStatusSubscribers;
				status = playStatus;
			}
			
			var translated:String = StatusTranslationUtil.translateStatus(status, statusType);
			
			if(observers)
				for (var i:int=0; i<engineStatusSubscribers.length; i++)
					StatusObserver(observers[i]).update(status, statusType, translated);
			
			trace(translated);
		}
	}
}
class EngineKey
{
	public function EngineKey() { }
}