package com.oddtown.app.ui
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;

	public class MouseIconHandler
	{
		private static const ICON_NEUTRAL:String="icon neutral";
		private static const ICON_HOVER:String="icon hover";
		private static const ICON_DOWN:String="icon down";
		
		private static var initialized:Boolean;
		private static var cursorLabels:Vector.<String>;
		private static var cursorLength:Number;
		public static function initialize():void
		{
			if(!initialized)
			{
				initialized=true;
				var mouseCursorData:MouseCursorData = new MouseCursorData();
				var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
				var cursors:Vector.<BitmapData> = new Vector.<BitmapData>();
				cursors.push( new CursorClick(1,1), /*new CursorHover(1,1),*/ new CursorNeutral(1,1) );
				var labels:Vector.<String> = new Vector.<String>;
				labels.push( ICON_DOWN,/* ICON_HOVER,*/ ICON_NEUTRAL);
//				cursorLabels.push( CURSOR_HAND, CURSOR_GRAB, CURSOR_EYE, CURSOR_SPEECH, CURSOR_ARROW );
				cursorLabels=labels.concat();
				cursorLength = cursors.length;
				for ( var i:uint = 0; i < cursorLength; i++ )
				{
					cursorData.push( cursors.pop() );
					mouseCursorData.data = cursorData;
					Mouse.registerCursor( labels.pop(), mouseCursorData );
					cursorData.pop();
				}
				labels = null;
				cursors = cursorData = null;
				Mouse.cursor = ICON_NEUTRAL;
			}
		}
		
		public static function showHoverIcon():void
		{
//			Mouse.cursor=ICON_HOVER;
			Mouse.cursor=ICON_DOWN;
		}
		
		public static function showArrowIcon():void
		{
			Mouse.cursor=ICON_NEUTRAL;
		}
		
		public static function showDownIcon():void
		{
			Mouse.cursor=ICON_DOWN;
		}
		
		public static function hideMouse():void
		{
			Mouse.hide();
		}
		
		public static function showMouse():void
		{
			Mouse.show();	
		}
		
		public static function destroy():void
		{
			if(initialized)
			{
				initialized=false;
				for ( var i:uint = 0; i < cursorLength; i++ )
				{
					Mouse.unregisterCursor( cursorLabels.pop() );
				}
				cursorLabels=null;
				cursorLength=NaN;
			}
		}
		
		public static function mouseOver(e:MouseEvent):void
		{
			showHoverIcon();
		}
		
		public static function mouseOut(e:MouseEvent):void
		{
			showArrowIcon();
		}
		
		public static function mouseDown(e:MouseEvent):void
		{
			showDownIcon();
		}
	}
}