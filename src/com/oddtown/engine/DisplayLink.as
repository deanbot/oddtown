package com.oddtown.engine
{
	import flash.display.Sprite;

	public class DisplayLink
	{
		private static var _oddDisplay:Sprite;
		
		public static function set oddDisplay(value:Sprite):void
		{
			_oddDisplay = value;
		}

		public static function get oddDisplay():Sprite
		{
			return _oddDisplay;
		}
		
		public static function destroy():void
		{
			_oddDisplay=null;
		}
	}
}