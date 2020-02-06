package com.oddtown.engine
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.AssetUtils;
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.DictionaryUtils;
	import com.oddtown.engine.command.GetPageCommand;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.casalib.util.DisplayObjectUtil;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	/**
	 * Page Builder Class and Manager Class 
	 * @author dean
	 * 
	 */
	public class PageManager implements IDestroyable
	{
	// constants:
	// private properties:
		private var oddDisplay:Sprite;
		private var _getPageCommand:GetPageCommand;
		private var _pageBuilt:Signal;
		private var pageAsset:Sprite;
		private var oPage:OddPage;
		private var pageStaged:NativeSignal;
	// public properties:
	// constructor:
		public function PageManager(oDisplay:Sprite)
		{
			oddDisplay = oDisplay;
			_pageBuilt = new Signal();
		}
	
	// public getter/setters:
		
		public function get pageBuilt():Signal
		{
			return _pageBuilt;
		}
		
		public function set getPageCommand(command:GetPageCommand):void
		{
			_getPageCommand = command;
		}
		
	// public methods:
		public function buildPage(id:uint):void
		{
			trace("Building Page");
			if(!_getPageCommand)
				return;
			oPage=_getPageCommand.execute(id);
			var panelSet:Array;
			var oPanel:OddPanel;
			var panel:MovieClip;
			var hide:Boolean;
			var panelID:String;
			if(oPage.className!='')
			{
				pageAsset=AssetUtils.getAssetInstance(oPage.className) as Sprite;
				if(pageAsset.getChildAt(0) is DisplayObjectContainer)
					DisplayObjectContainer(pageAsset.getChildAt(0)).mouseEnabled=false;
				// loop through panels: stop and hide
				for(var i:uint=0; i<oPage.panelCount; i++)
				{
					panelSet=oPage.panels[i];
					for(var p:uint=0; p<panelSet.length; p++)
					{
						oPanel=panelSet[p];
						panelID=PanelIDUtils.getPanelID(oPanel.order,oPanel.tree);
						panel=MovieClip(pageAsset[panelID]);
						if(panel)
						{
							hide=true;
							panel.stop();
							if(oPanel.remainsVisible)
								if(OddFlags.getFlag(OddFlags.FLAG_TYPE_VIEWED,PanelIDUtils.getPanelViewedID(oPage.pageOrder,oPanel.order,oPanel.tree)))
									hide=false;
							if(hide)
								ClipUtils.hide(panel);
						}
						else
						{
							trace("Something went wrong. Can't find the panel asset: "+PanelIDUtils.getPanelID(oPanel.order,oPanel.tree));
						}
					}
				}
			}
			else
			{
				trace("Something went wrong. Can't find the page asset");
				pageAsset=new Sprite();
			}
			ClipUtils.hide(pageAsset);
			pageStaged=new NativeSignal(pageAsset,Event.ADDED_TO_STAGE,Event);
			pageStaged.addOnce(onPageStaged);
			oddDisplay.addChildAt(pageAsset,0);
		}
		
		private function onPageStaged(e:Event):void
		{
			trace("Page Asset added to stage");
			pageAsset.visible=true;
			_pageBuilt.dispatch();
		}
		
		public function destroyPage():void
		{
			if(oddDisplay)
				DisplayObjectUtil.removeAllChildren(oddDisplay);
			pageAsset=null;
		}
		
		public function destroy():void
		{
			trace("Destroy Page Manager");
			if(_getPageCommand)
				_getPageCommand.destroy();
			if(pageStaged)
				pageStaged.removeAll();
			pageStaged=null;
			_getPageCommand=null;
			if(pageAsset)
			{
				if(oddDisplay)
				{
					if(oddDisplay.contains(pageAsset))
						oddDisplay.removeChild(pageAsset);
				}
				pageAsset=null;
			}
			if(oddDisplay)
			{
				if(oddDisplay.numChildren>0)
					oddDisplay.removeChildAt(0);
				oddDisplay=null;
			}
			_pageBuilt.removeAll();
			_pageBuilt=null;
		}
	}
}