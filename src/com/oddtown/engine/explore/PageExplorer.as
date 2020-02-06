package com.oddtown.engine.explore
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.AssetUtils;
	import com.deanverleger.utils.CleanupUtils;
	import com.deanverleger.utils.DictionaryUtils;
	import com.greensock.TweenLite;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.plugins.TweenPlugin;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.OddConfig;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.OddPage;
	import com.oddtown.engine.OddPanel;
	import com.oddtown.engine.OddtownEngine;
	import com.oddtown.engine.PanelIDUtils;
	import com.oddtown.engine.PanelImp;
	import com.oddtown.engine.command.ChangeToPageCommand;
	import com.oddtown.engine.command.GameCompletionCommands;
	import com.oddtown.engine.command.GetPageCommand;
	import com.oddtown.engine.sound.OddSoundInterface;
	import com.oddtown.engine.status.StatusObserver;
	import com.oddtown.engine.status.StatusSubject;
	import com.oddtown.engine.status.StatusTranslationUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.casalib.util.DisplayObjectUtil;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;
	
	import uk.co.soulwire.gui.SimpleGUI;

	/**
	 * Controls all display needs including movement, transitions, etc. 
	 * @author dean
	 * 
	 */
	public class PageExplorer implements StatusSubject, IDestroyable
	{
	// constants:
		
	// private properties:
		private var oddDisplay:Sprite;
		private var _gameCompletionCommands:GameCompletionCommands;
		private var _getPageCommand:GetPageCommand;
		private var _changeToPageCommand:ChangeToPageCommand;
		private var _transitionInFinished:Signal;
		private var _transitionOutFinished:Signal;
		private var _tree:String;
		private var _newTree:String;
		private var _status:uint;
		private var _subscribers:Array;
		private var _oPage:OddPage;
		private var _curPage:uint;
		private var _curPanel:uint;
		private var _panels:Dictionary;
		private var _prePauseStatus:uint;
		private var _moveToNextTime:Number;
		private var moveToComplete:Signal;
		private var pageSet:InteractiveObjectSignalSet;
		private var fullWidth:Number;
		private var fullHeight:Number;
		private var _currentSoundInstructionKey:String="";
		
	// public properties:
	// constructor:
		public function PageExplorer(oDisplay:Sprite)
		{
			oddDisplay = oDisplay;
			_transitionInFinished=new Signal();
			_transitionOutFinished=new Signal();
			_subscribers=new Array();
			_panels=new Dictionary(true);
			moveToComplete=new Signal();
			_currentSoundInstructionKey='';
		}
		
	// public getter/setters:

		public function set gameCompletionCommands(command:GameCompletionCommands):void
		{
			_gameCompletionCommands = command;
		}

		public function set changeToPageCommand(command:ChangeToPageCommand):void
		{
			_changeToPageCommand=command;
		}

		public function get tree():String
		{
			return _tree;
		}

		public function get currentPanel():uint
		{
			return _curPanel;
		}

		public function get transitionInFinished():Signal
		{
			return _transitionInFinished;
		}
		
		public function get transitionOutFinished():Signal
		{
			return _transitionOutFinished;
		}
		
		public function set getPageCommand(command:GetPageCommand):void
		{
			_getPageCommand = command;
		}
		
		private var gui:GUI;
		private var devGUI:SimpleGUI;
		public function setPage(id:uint):void
		{
			if(_curPage==id)
				return;
			if(oddDisplay.numChildren==0)
				return;
			if(_oPage)
				_oPage=null;
			trace("Set page: " + id);
			_oPage=_getPageCommand.execute(id);
			_curPage=id;
			var panelSet:Array;
			var oPanel:OddPanel;
			var panTree:String;
			var panelImp:PanelImp;
			var panelAsset:MovieClip;
			var pageAsset:Sprite = Sprite(oddDisplay.getChildAt(0));
			for(var i:uint=0; i<_oPage.panels.length; i++)
			{
				panelSet=_oPage.panels[i];
				for(var p:uint=0; p<panelSet.length; p++)
				{
					oPanel=panelSet[p];
					if(oPanel.impClass=='')
						panelImp = new PanelImp();
					else
						panelImp = AssetUtils.getAssetInstance(OddConfig.impPanelPackage+'.'+oPanel.impClass) as PanelImp;
					panelImp.data=oPanel;
					panelAsset=MovieClip(pageAsset[PanelIDUtils.getPanelID(oPanel.order,oPanel.tree)]);
					if(!panelAsset)
					{
						trace("Something went wrong. Can't find the panel asset");
						panelAsset=new MovieClip();
					}
					panelImp.asset=panelAsset;
					if(panelImp.hasPrepStep)
						panelImp.panelPrep();
					_panels[PanelIDUtils.getPanelID(oPanel.order,oPanel.tree)]=panelImp;
				}
			}
			
			/* DEVELOPMENT */
			/*if(devGUI)
				devGUI=null;
			if(gui)
				gui.destroy();
			gui = new GUI(pageAsset);
			oddDisplay.addChild(gui);
			devGUI = new SimpleGUI(gui,"Oddtown Development","C");
			devGUI.addGroup();
			devGUI.addStepper("page.x", -100, 100);
			devGUI.addStepper("page.y", -1000, 500);
			devGUI.addColumn("Page Options");
			devGUI.addSlider("page.x", -100, 100, {label:"Page X", width:400});
			devGUI.addSlider("page.y", -1000, 500, {label:"Page Y", width:400});
			devGUI.addColumn("Explore Commands");
			devGUI.addButton("Move Complete",{callback:moveToComplete.dispatch});
//			devGUI.addSlider("page.scaleX", -2, 1, {callback:updateScale});
//			devGUI.addSlider("page.z", 0, 300);
			devGUI.addColumn("Instructions:");
			devGUI.addLabel("Press 'C' to toggle GUI");
			devGUI.addLabel("Press 'S' to copy setup code to clipboard");
			devGUI.show();*/
		}
		
		public function destroyPage():void
		{
			if(!oddDisplay)
				return;
			if(oddDisplay.numChildren==0)
				return;
			if(oddDisplay)
			{
				var pageAsset:Sprite = Sprite(oddDisplay.getChildAt(0));
				if(pageAsset)
					TweenLite.killTweensOf(pageAsset);
			}
			if(_panels)
			{
				var panelImp:PanelImp=PanelImp(_panels[curPanelID]);
				if(panelImp)
					panelImp.stop();
			}
			_oPage=null;
			DictionaryUtils.emptyDictionary(_panels,true);
			moveToComplete.removeAll();
			if(devGUI)
				devGUI=null;
			if(gui)
			{
				if(oddDisplay.contains(gui))
					oddDisplay.removeChild(gui);
				DisplayObjectUtil.removeAllChildren(gui);
				gui.destroy();
				gui=null;
			}
		}
		
		private function updateScale():void {
			var pageAsset:Sprite = Sprite(oddDisplay.getChildAt(0));
			pageAsset.scaleY=pageAsset.scaleX;
		}
		
		/**
		 * "Explore" comic page, starting from a hidden comic page
		 * @param resetTree
		 * @param reset
		 * 
		 */
		public function explore(resetTree:Boolean=true,reset:Boolean=true):void
		{
			// check for status?
			if(reset) {
				_curPanel=1;
				_moveToNextTime=0;
			} 
			if(resetTree||_tree==null)
				_tree='';
			if(_status!=OddtownEngine.PLAY_STATUS_EXPLORING_PANEL)
				setStatus(OddtownEngine.PLAY_STATUS_EXPLORING_PANEL);
			if(reset)
			{
				var panelImp:PanelImp=PanelImp(_panels[PanelIDUtils.getPanelID(_curPanel,_tree)]);
				var oPanel:OddPanel=panelImp.data;
				showPanel(_curPanel,_tree,0);
				moveTo(_curPanel,_tree,0);
				//updateSounds(_curPanel,_tree);
				if(oPanel.hasCoords)
					_transitionInFinished.addOnce(play);
				transitionPageIn();
			} else
				changeToCurentPanel();
		}
		
		public function transitionPageOut(time:Number=NaN):void
		{
			if(!oddDisplay)
				return;
			
			
			if(oddDisplay.numChildren>0)
			{
				if(isNaN(time))
					time=OddConfig.pageTransitionFadeTime;
				if(pageSet)
					pageSet.removeAll();
				
				if(_panels)
				{
					var panelImp:PanelImp=PanelImp(_panels[curPanelID]);
					if(panelImp)
					{
						panelImp.stop();
						panelImp.panelCleanup();
					}
				}
				var pageAsset:Sprite = Sprite(oddDisplay.getChildAt(0));
				if(pageAsset)
				{
					TweenLite.killTweensOf(pageAsset);
					if(pageAsset.alpha!=0) {
						TweenLite.to(pageAsset, time, {alpha:0, onComplete:transOutCompleted});
					} else {
						trace("no need to tween");
						transOutCompleted();
					}
						
				}
				else
					TweenLite.to(DisplayObject(oddDisplay.getChildAt(0)), time, {alpha:0, onComplete:transOutCompleted});
			} else
				_transitionOutFinished.dispatch();
		}
		
		public function destroy():void
		{
			trace("Destroy PageExplorer");
			if(_panels)
			{
				DictionaryUtils.emptyDictionary(_panels,true);
			}
			CleanupUtils.destroy(_gameCompletionCommands,_getPageCommand,_changeToPageCommand);
			_gameCompletionCommands=null;
			_getPageCommand = null;
			_changeToPageCommand=null;
			oddDisplay=null;
			_transitionInFinished.removeAll();
			_transitionOutFinished.removeAll();
			moveToComplete.removeAll();
			_transitionInFinished=_transitionOutFinished=moveToComplete=null;
			_subscribers.slice(0);
			_subscribers=null;
			if(pageSet)
				pageSet.removeAll();
			pageSet=null;
			_currentSoundInstructionKey='';
		}
		
		public function subscribeToStatus(o:StatusObserver, statusType:uint):void
		{
			_subscribers.push(o);
		}
		
		public function unsubscribeFromStatus(o:StatusObserver, statusType:uint):void
		{
			for (var i:int=0; i<_subscribers.length; i++)
			{
				if (_subscribers[i]==o)
				{
					_subscribers.splice(i,1);
					break;
				}
			}
		}
		
	// private methods:
		private function changeToCurentPanel():void
		{
			showPanel(_curPanel,_tree);
			moveToComplete.addOnce(play);
			moveTo(_curPanel,_tree);
			if(OddSoundInterface.isPlaying)
				manageSoundTransitions(_curPanel,_tree);
		}
		
		private function moveTo(panelOrder:uint,tree:String,time:Number=NaN):void
		{
			if(!oddDisplay)
				return;
			if(oddDisplay.numChildren==0)
				return;
			if(isNaN(time))
				time=OddConfig.panelTransitionTime;
			var page:Sprite = Sprite(oddDisplay.getChildAt(0));
			var panelImp:PanelImp=PanelImp(_panels[PanelIDUtils.getPanelID(panelOrder,tree)]);
			var oPanel:OddPanel=panelImp.data;
			var panel:MovieClip = panelImp.asset;
			if(!page||!panel)
				return;
			if(panelOrder==0)
				return;
			if(oPanel.hasCoords)
			{
				trace("Moving to panel " + panelOrder + " " + tree);
				TweenLite.to(page,time,{x:oPanel.pageX,y:oPanel.pageY, onComplete:moveToComplete.dispatch});
			} else {
				trace("Panel has no coordinates. Grab your coordinates and press \"Move Complete\" to pretend the page moved.");
			}
		}
		
		private function showPanel(panelOrder:uint,tree:String,time:Number=NaN):void
		{
			if(isNaN(time))
				time=OddConfig.panelFadeTime;
			var panelID:String=PanelIDUtils.getPanelID(panelOrder,tree);
			var panelImp:PanelImp=PanelImp(_panels[panelID]);
			var panel:MovieClip=panelImp.asset;
			panel.visible=true;
			TweenLite.to(panel,time,{alpha:1});
			OddFlags.setFlag(OddFlags.FLAG_TYPE_VIEWED,PanelIDUtils.getPanelViewedID(_oPage.pageOrder,panelOrder,tree));
		}
		
		private function updateSounds(panelOrder:uint,tree:String):void
		{
			var panelID:String=PanelIDUtils.getPanelID(panelOrder,tree);
			var panelImp:PanelImp=PanelImp(_panels[panelID]);
			var oPanel:OddPanel=panelImp.data;
			var soundInstructionKey:String;
			if(oPanel.soundInstructionKey)
				soundInstructionKey=oPanel.soundInstructionKey;
			else if(_oPage.soundInstructionKey)
				soundInstructionKey=_oPage.soundInstructionKey;
			if(soundInstructionKey)
			{
				_currentSoundInstructionKey=soundInstructionKey;
				OddSoundInterface.activateSoundObject(soundInstructionKey);
			} else
				_currentSoundInstructionKey="";
		}
		
		private function manageSoundTransitions(panelOrder:uint,tree:String):void
		{
			if(!_currentSoundInstructionKey)
				return;
			var panelID:String=PanelIDUtils.getPanelID(panelOrder,tree);
			var panelImp:PanelImp=PanelImp(_panels[panelID]);
			var oPanel:OddPanel=panelImp.data;
			var destSoundInstructionKey:String;
			if(oPanel.soundInstructionKey)
				destSoundInstructionKey=oPanel.soundInstructionKey;
			else if(_oPage.soundInstructionKey)
				destSoundInstructionKey=_oPage.soundInstructionKey;
			OddSoundInterface.manageSoundChannelRemoval(_currentSoundInstructionKey,destSoundInstructionKey);
		}
		
		private function play():void
		{
			trace("Playing Panel " + _curPanel);
			var panelImp:PanelImp=PanelImp(_panels[curPanelID]);
			updateSounds(_curPanel,_tree);
			if(panelImp.autoProgress)
			{
				if(panelImp.asset.totalFrames>1)
					panelImp.frameEndReached.addOnce(changePanel);
				else if(panelImp.autoProgress)
					TweenLite.delayedCall((panelImp.data.delay)?panelImp.data.delay:OddConfig.defaultPanelDelayTime,changePanel);
			}
			else
			{
				panelImp.changePanel.addOnce(changePanel);
				panelImp.pageEndReached.addOnce(changePage);
				panelImp.frameEndReached.addOnce(changePanel);
				panelImp.lostGame.addOnce(onLostGame);
			}
			panelImp.setTree.add(changeTree);
			panelImp.play();
		}
		
		private function changePanel(panelID:uint=0):void
		{
			var panelImp:PanelImp=PanelImp(_panels[curPanelID]);
			if(_newTree!='')
			{
				_tree=_newTree;
				_newTree="";
			}
			if(panelID==0)
			{
				trace("Frame end reached.");
				var next:uint = panelImp.data.next;
				if(next!=0)
				{
					_curPanel=next;
					explore(false,false);
				} else if(_curPanel>=_oPage.panelCount)
				{
					if(!_oPage.endPage)
						endOfPage();
					else
						endOfComic();
				} else {
					_curPanel++;
					explore(false,false);
				}
			} else
			{
				panelImp.panelCleanup();
				_curPanel=panelID;
				explore(false,false);
			}
		}
		
		private function changeTree(tree:String):void
		{
			_newTree=tree;
		}
		
		private function endOfPage():void
		{
			trace("End of Page Reached");
			var page:Sprite=Sprite(oddDisplay.getChildAt(0));
			var background:DisplayObject=DisplayObject(page.getChildAt(0));
			
			//set scroll rect because there might be masked areas and flash counts masked areas when calculating width and height
			page.cacheAsBitmap=true;
			page.scrollRect=new Rectangle(0,0,background.width,background.height);
			
			//loop through visible panels and set mouseChildren to false so clicks just trigger on panels and not panel children
			for (var k:Object in _panels)
			{
				if(PanelImp(_panels[k]).asset.visible)
					PanelImp(_panels[k]).asset.mouseChildren=false;
			}
			
			//flash needs time to set scroll rect
			TweenLite.delayedCall(.3,zoomOutPage);
		}
		
		private function zoomOutPage(e:MouseEvent=null):void {
			var gutter:Number=OddConfig.pageZoomGutter;
			var fitWidth:Number=OddConfig.stageWidth-gutter*2;
			var fitHeight:Number=OddConfig.stageHeight-gutter*2;
			
			var page:Sprite=Sprite(oddDisplay.getChildAt(0));
			
			var destHeight:Number=fullHeight=page.height;
			var destWidth:Number=fullWidth=page.width;
			var ratio:Number;
			
			if(destHeight>fitHeight)
			{
				ratio=fitHeight/destHeight;
				destHeight=fitHeight;
				destWidth=destWidth*ratio;
			}
			
			if(destWidth>fitWidth)
			{
				ratio=fitWidth/destWidth;
				destWidth=fitWidth;
				destHeight=destHeight*ratio;
			}
			
			var destX:Number=gutter+fitWidth*.5-destWidth*.5;
			var destY:Number=gutter+fitHeight*.5-destHeight*.5;
			TweenLite.to(page,OddConfig.pageZoomOutTime,{ 
				width:destWidth,
				height:destHeight,
				x:destX,
				y:destY,
				onComplete:zoomOutComplete
			});
		};
		
		
		private function zoomOutComplete():void
		{
			var page:Sprite=Sprite(oddDisplay.getChildAt(0));
			pageSet=new InteractiveObjectSignalSet(page);
			pageSet.click.add(onPageSet);
			pageSet.mouseOver.add(onRollOver);
			pageSet.mouseOut.add(onRollOut);
			setStatus(OddtownEngine.PLAY_STATUS_PAGE_NAVIGATION);
		}
		
		private function onPageSet(e:MouseEvent):void
		{
			if(String(e.target.name).slice(0,3)!="pan")
				return;
			var iPanel:PanelImp=_panels[MovieClip(e.target).name] as PanelImp;
			if(iPanel)
				zoomTo(iPanel);
		}
		
		private function zoomTo(iPanel:PanelImp):void
		{
			setStatus(OddtownEngine.PLAY_STATUS_ZOOMING_PANEL);
			pageSet.removeAll();
			var page:Sprite = Sprite(oddDisplay.getChildAt(0));
			var oPanel:OddPanel=iPanel.data;
			TweenLite.to(page,OddConfig.pageZoomInTime, {
					x:oPanel.pageX,
					y:oPanel.pageY,
					onComplete:zoomToComplete,
					width: fullWidth,
					height: fullHeight
			});
		}
		
		private function zoomToComplete():void
		{
			pageSet.click.addOnce(zoomOutPage);
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			// hacky way to see if it's a panel or not.
			if(String(e.target.name).slice(0,3)=="pan")
				MouseIconHandler.showHoverIcon();
//			trace(e.target + " name: " + e.target.name);
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			if(e.target.name.slice(0,3)=="pan")
				MouseIconHandler.showArrowIcon();
		}
		
		private function changePage(pageID:uint=0):void
		{
			var to:uint=pageID;
			var flag:String;
			var antiFlag:String;
			if(pageID==0||pageID==_oPage.nextPage)
			{
				if(to==0)
					to=_oPage.nextPage;
				flag=_oPage.nextPageFlagReq;
				antiFlag=_oPage.nextPageAntiFlagReq;
			} 
			else if(pageID==_oPage.prevPage) 
			{
				flag=_oPage.prevPageFlagReq;
				antiFlag=_oPage.prevPageAntiFlagReq;
			}
			if(to==0)
				return;
			var panelImp:PanelImp=PanelImp(_panels[curPanelID]);
			panelImp.panelCleanup();
			_changeToPageCommand.execute(to,flag,antiFlag);
		}
		
		private function transitionPageIn():void
		{
			if(!oddDisplay)
				return;
			if(oddDisplay.numChildren>0)
			{
				var pageAsset:Sprite = Sprite(oddDisplay.getChildAt(0));
				if(pageAsset)
					TweenLite.to(pageAsset, OddConfig.pageTransitionFadeTime, {alpha:1, onComplete:transInCompleted});
				else
					TweenLite.to(DisplayObject(oddDisplay.getChildAt(0)), OddConfig.pageTransitionFadeTime, {alpha:1, onComplete:transInCompleted});
				
				if(OddSoundInterface.isPlaying)
				{
					// check current page and first panel keys
					manageSoundTransitions(_curPanel,_tree);
				}
			}
			else
				_transitionInFinished.dispatch();
		}
		
		private function transInCompleted():void {
			trace("Page Faded In");
			_transitionInFinished.dispatch();
		};
		
		private function transOutCompleted():void {
			trace("Page Faded Out");
			_transitionOutFinished.dispatch();
		};
		
		private function endOfComic():void
		{
			setStatus(OddtownEngine.PLAY_STATUS_GAME_OVER);
			//OddSoundInterface.fadeAllSounds( then below
			_gameCompletionCommands.beatGame();
		}
		
		private function onLostGame():void
		{
			setStatus(OddtownEngine.PLAY_STATUS_GAME_OVER);
			//OddSoundInterface.fadeAllSounds( then below
			_gameCompletionCommands.lostGame();
		}
		
		private function setStatus(status:uint):void
		{	
			_status = status;
			notifySubscribers();
		}
		
		private function notifySubscribers():void
		{
			if(_subscribers)
				for (var i:int=0; i<_subscribers.length; i++)
					StatusObserver(_subscribers[i]).update(_status, OddtownEngine.STATUS_TYPE_PLAY, StatusTranslationUtil.translateStatus(_status, OddtownEngine.STATUS_TYPE_PLAY));	
		}
		
		/**
		 * Same format is used for panel instance names
		 */
		private function get curPanelID():String
		{
			return PanelIDUtils.getPanelID(_curPanel,_tree);
		}		
	}
}
import flash.display.Sprite;

class GUI extends Sprite {
	public var page:Sprite;
	
	public function GUI(pg:Sprite) {
		page=pg;
		super();
	}
	
	public function destroy():void
	{
		page=null;
	}
}