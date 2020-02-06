package com.oddtown.engine
{
	public class OddPanel
	{
		private var _order:uint;		
		private var _impClass:String;
		private var _next:uint=0;
		private var _autoProgress:Boolean=true;
		private var _tree:String='';
		private var _pageX:Number;
		private var _pageY:Number;
		private var _delay:Number;
		private var _hasCoords:Boolean;
		private var _parent:OddPage;
		private var _remainsVisible:Boolean;
		private var _soundInstructionKey:String;
		public function OddPanel(order:uint,impClass:String='',pageX:Number=NaN,pageY:Number=NaN,next:uint=0,tree:String='',autoProgress:Boolean=true,soundInstructionKey:String='',
								 remainsVisible:Boolean=false,delay:Number=NaN)
		{
			_order=order;
			_impClass=impClass;
			_next=next;
			_tree=tree;
			_autoProgress=autoProgress;
			_pageX=pageX;
			_pageY=pageY;
			_remainsVisible=remainsVisible;
			_delay=delay;
			_soundInstructionKey=soundInstructionKey;
			if(!isNaN(pageX) && !isNaN(pageY))
				_hasCoords=true;
		}
		
		public function get soundInstructionKey():String
		{
			return _soundInstructionKey;
		}

		public function get remainsVisible():Boolean
		{
			return _remainsVisible;
		}

		public function get parent():OddPage
		{
			return _parent;
		}

		public function set parent(value:OddPage):void
		{
			_parent = value;
		}

		public function get hasCoords():Boolean
		{
			return _hasCoords;
		}

		public function get pageY():Number
		{
			return _pageY;
		}

		public function get pageX():Number
		{
			return _pageX;
		}

		public function get delay():Number
		{
			return _delay;
		}

		public function get order():uint
		{
			return _order;
		}

		public function get impClass():String
		{
			return _impClass;
		}

		public function get next():uint
		{
			return _next;
		}

		public function get autoProgress():Boolean
		{
			return _autoProgress;
		}

		public function get tree():String
		{
			return _tree;
		}
	}
}