package com.oddtown.engine
{
	import com.deanverleger.utils.DictionaryUtils;
	
	import flash.utils.Dictionary;

	public class OddFlags
	{
		public static const FLAG_TYPE_VIEWED:String="viewed";
		public static const FLAG_TYPE_FLAG:String="flag";
		private static var initialized:Boolean;
		private static var flags:Dictionary
		
		public static function setFlag(type:String,id:String):void
		{
			if(!initialized)
				init();
			(flags[type] as Dictionary)[id]=id;
		}
		
		public static function unsetFlag(type:String,id:String):void
		{
			if(!initialized)
				init();
			if(getFlag(type,id))
			{
				(flags[type] as Dictionary)[id]=null;
				delete (flags[type] as Dictionary)[id];
			}
		}
		
		public static function getFlag(type:String,id:String):Boolean
		{
			if(!initialized)
				init();
			return !( (flags[type] as Dictionary)[id] === undefined);
		}
		
		public static function destroy():void
		{
			if(initialized)
			{
				DictionaryUtils.emptyDictionary(flags[FLAG_TYPE_VIEWED]);
				DictionaryUtils.emptyDictionary(flags[FLAG_TYPE_FLAG]);
				DictionaryUtils.emptyDictionary(flags);
				flags=null;
				initialized=false;
			}
		}
		
		private static function init():void
		{
			if(!flags)
			{
				flags=new Dictionary(true);
				flags[FLAG_TYPE_VIEWED]=new Dictionary(true);
				flags[FLAG_TYPE_FLAG]=new Dictionary(true);
				initialized=true;
			}
		}
	}
}