package com.oddtown.engine
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.DictionaryUtils;
	
	import flash.utils.Dictionary;

	public class OddPage implements IDestroyable
	{
		private var _panels:Array;
		private var _className:String;
		private var _pageOrder:uint;
		private var _resetTree:Boolean;
		private var _prevPage:uint;
		private var _nextPage:uint;
		private var _soundInstructionKey:String;
		private var _endPage:Boolean;
		private var _prevPageFlagReq:String;
		private var _prevPageAntiFlagReq:String;
		private var _nextPageFlagReq:String;
		private var _nextPageAntiFlagReq:String;
		public function OddPage(className:String,pageOrder:uint,resetTree:Boolean=true,prevPage:uint=0,nextPage:uint=0,soundInstructionKey:String="",
								endPage:Boolean=false,prevFlagReq:String="",prevAntiFlagReq:String="",nextFlagReq:String="",nextAntiFlagReq:String="")
		{
			_className=className;
			_pageOrder=pageOrder;
			_resetTree=resetTree;
			_prevPage=prevPage;
			_nextPage=nextPage;
			_soundInstructionKey=soundInstructionKey;
			_endPage=endPage;
			_prevPageFlagReq=prevFlagReq;
			_prevPageAntiFlagReq=prevAntiFlagReq;
			_nextPageFlagReq=nextFlagReq;
			_nextPageAntiFlagReq=nextAntiFlagReq;
		}

		public function get soundInstructionKey():String
		{
			return _soundInstructionKey;
		}

		public function set panels(value:Array):void
		{
			_panels = value;
		}

		public function get endPage():Boolean
		{
			return _endPage;
		}

		public function get nextPage():uint
		{
			return _nextPage;
		}

		public function get nextPageAntiFlagReq():String
		{
			return _nextPageAntiFlagReq;
		}

		public function get nextPageFlagReq():String
		{
			return _nextPageFlagReq;
		}

		public function get prevPageAntiFlagReq():String
		{
			return _prevPageAntiFlagReq;
		}

		public function get prevPageFlagReq():String
		{
			return _prevPageFlagReq;
		}

		public function get prevPage():uint
		{
			return _prevPage;
		}

		public function get resetTree():Boolean
		{
			return _resetTree;
		}

		public function get pageOrder():uint
		{
			return _pageOrder;
		}

		public function get className():String
		{
			return _className;
		}

		public function get panelCount():uint
		{
			return _panels.length;
		}

		public function get panels():Array
		{
			return _panels;
		}
		
		public function getPanel(order:uint, tree:String=''):OddPanel
		{
			var panel:OddPanel;
			if(tree=='')
				panel=_panels[order-1][0];
			else
			{
				var panelCount:uint = _panels[order-1].length;
				if(panelCount>1)
				{
					for(var i:uint=0;i<panelCount;i++)
					{
						if(OddPanel(panels[order-1][i]).tree==tree)
						{
							panel=OddPanel(panels[order-1][i]);
							break;
						}
					}
				}
			}
			return panel;
		}

		public function destroy():void
		{
			if(!_panels)
				return;
			for(var i:uint=0; i<_panels.length; i++)
			{
				_panels[i].splice(0);
				_panels[i]=null;
			}
			_panels.splice(0);
			_panels=null;
		}
	}
}