package com.deanverleger.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class ClipUtils
	{
		public static function stopClips(... rest):void
		{
			for(var i:uint = 0; i < rest.length; i++)
				MovieClip(rest[i]).stop();
		}
		
		/**
		 * Not Visible 
		 * @param dispObjects
		 * 
		 */
		public static function hide( ... dispObjects ):void
		{
			for(var i:uint = 0; i < dispObjects.length; i++)
			{
				DisplayObject(dispObjects[i]).alpha = 0;
				DisplayObject(dispObjects[i]).visible = false;
			}
		}
		
		public static function show( ... dispObjects ):void
		{
			for(var i:uint = 0; i < dispObjects.length; i++)
			{
				DisplayObject(dispObjects[i]).alpha = 1;
				DisplayObject(dispObjects[i]).visible = true;
			}
		}
		
		/**
		 * Visible but Hidden 
		 * @param dispObjects
		 * 
		 */
		public static function makeInvisible( ... dispObjects ):void
		{
			for(var i:uint = 0; i < dispObjects.length; i++)
			{
				DisplayObject(dispObjects[i]).alpha = 0;
				DisplayObject(dispObjects[i]).visible = true;
			}
		}
	}
}