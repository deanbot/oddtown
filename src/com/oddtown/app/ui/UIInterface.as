package com.oddtown.app.ui
{
	import com.deanverleger.core.IDestroyable;
	
	import org.osflash.signals.Signal;

	public class UIInterface
	{
		private static var initialized:Boolean;
		private static var _nextArrowClicked:Signal;
		private static var _prevArrowClicked:Signal;
		private static var _ui:OddtownUI
		
		public static function get nextArrowClicked():Signal
		{
			return _nextArrowClicked;
		}
		
		public static function get prevArrowClicked():Signal
		{
			return _prevArrowClicked;
		}
		
		public static function initialize(ui:OddtownUI,prevClicked:Signal,nextClicked:Signal):void
		{
			_ui=ui;
			_nextArrowClicked=nextClicked;
			_prevArrowClicked=prevClicked;
			initialized=true;
		}
		
		public static function showArrows(showPrev:Boolean,showNext:Boolean):void
		{
			if(initialized)
				_ui.showArrows(true,showPrev,showNext);
		}
		
		public static function hideArrows():void
		{
			if(initialized)
				_ui.hideArrows();
		}
		
		public static function refreshArrowClicks():void
		{
			if(initialized)
				_ui.refreshArrowClicks();
		}
		
		public static function showHud():void
		{
			if(initialized)
				_ui.showHud();
		}
		
		public static function hideHud():void
		{
			if(initialized)
				_ui.hideHud();
		}
		
		public static function destroy():void
		{
			_ui=null;
			if(_nextArrowClicked)
				_nextArrowClicked.removeAll();
			if(_prevArrowClicked)
				_prevArrowClicked.removeAll();
			_nextArrowClicked=_prevArrowClicked=null;
		}
	}
}