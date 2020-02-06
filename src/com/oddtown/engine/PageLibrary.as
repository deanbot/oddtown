package com.oddtown.engine
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.DictionaryUtils;
	
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * Manages page/panel data classes, parses xml, and provides methods for retreiving data 
	 * @author dean
	 * 
	 */
	public class PageLibrary implements IDestroyable
	{
	// constants:
		public static const ID:String = "PageLibrary";
	// private properties:
		private var _parseComplete:Signal;
		private var _pages:Dictionary;
		private var _firstPage:uint;
	// public properties:
	// constructor:
		public function PageLibrary()
		{
			_parseComplete=new Signal(String);
		}
		
	// public getter/setters:
		public function get firstPage():uint
		{
			return _firstPage;
		}

		public function get parseComplete():Signal
		{
			return _parseComplete;
		}
		
	// public methods:
		public function build(data:XMLList):void
		{
			trace("parsing page data");
			_firstPage=1;
			var oPage:OddPage;
			var oPanel:OddPanel;
			var pageClassName:String;
			var impClass:String;
			var pageOrder:uint;
			var panOrder:uint;
			var tree:String;
			var autoProgress:Boolean;
			var next:uint;
			var numLinearPanels:uint;
			var curOrder:uint;
			var resetTree:Boolean;
			var remainsVisible:Boolean;
			var delay:Number;
			var panels:Array;
			var pageX:Number;
			var pageY:Number;
			var prevPage:uint;
			var nextPage:uint;
			var endPage:Boolean;
			var prevFlagReq:String;
			var prevAntiFlagReq:String;
			var nextFlagReq:String;
			var nextAntiFlagReq:String;
			var soundInstructionKey:String;
			_pages=new Dictionary(true);
			_firstPage=(data.hasOwnProperty("@firstPage"))?uint(data.@firstPage):_firstPage;
			for each( var page:XML in data.page)
			{
				panels=new Array();
				curOrder=0;
				numLinearPanels=0;
				pageClassName=String(page.@className);
				pageOrder=uint(page.@order);
				resetTree=(String(page.@resetTree)=='false')?false:true;
				endPage=(String(page.@endPage)=='true')?true:false;
				prevPage=uint(page.@prevPage);
				nextPage=uint(page.@nextPage);
				prevFlagReq=String(page.@prevPageFlagReq);
				prevAntiFlagReq=String(page.@prevPageAntiFlagReq);
				nextFlagReq=String(page.@nextPageFlagReq);
				nextAntiFlagReq=String(page.@nextPageAntiFlagReq);
				soundInstructionKey=String(page.@soundInstructionKey);
				oPage=new OddPage(pageClassName,pageOrder,resetTree,prevPage,nextPage,soundInstructionKey,endPage,prevFlagReq,prevAntiFlagReq,nextFlagReq,nextAntiFlagReq);
				soundInstructionKey='';
				for each( var panel:XML in page.panel )
				{
					panOrder=uint(panel.@order);
					if(panOrder!=curOrder)
					{
						curOrder=panOrder;
						panels.push(new Array());
						numLinearPanels++;
					}
					impClass=String(panel.@impClass);
					next=(uint(panel.@next))?uint(panel.@next):0;
					tree=(String(panel.@tree))?String(panel.@tree):'';
					autoProgress=(String(panel.@autoProgress)=='false')?false:true;
					remainsVisible=(String(panel.@remainsVisible)=='true')?true:false;
					delay=(panel.hasOwnProperty("@delay"))?Number(panel.@delay):NaN;
					
					pageX=(panel.hasOwnProperty("@pageX"))?Number(panel.@pageX):NaN;
					pageY=(panel.hasOwnProperty("@pageY"))?Number(panel.@pageY):NaN;
					soundInstructionKey=String(panel.@soundInstructionKey);
					oPanel=new OddPanel(panOrder,impClass,pageX,pageY,next,tree,autoProgress,soundInstructionKey,remainsVisible,delay);
					oPanel.parent=oPage;
					panels[curOrder-1].push(oPanel);
				}
				oPage.panels=panels;
				_pages[oPage.pageOrder]=oPage;
			}
			_parseComplete.dispatch(ID);
		}
		
		public function getPageResetTree(id:uint):Boolean
		{
			var resetTree:Boolean=true;
			var oPage:OddPage=getPage(id);
			return oPage.resetTree;
		}
		
		public function getPage(id:uint):OddPage
		{
			var oPage:OddPage = OddPage(_pages[id]);
			return oPage;
		}
		
		public function destroy():void
		{
			trace("Destroy PageLibrary");
			_parseComplete.removeAll();
			_parseComplete=null;
			DictionaryUtils.emptyDictionary(_pages,true);
			_pages=null;
		}
		
	// private methods:

	}
}