package com.deanverleger.utils
{
	import flash.utils.Dictionary;
	
	import com.deanverleger.core.IDestroyable;

	public class DictionaryUtils
	{
		public static function emptyDictionary(dict:Dictionary,destroy:Boolean=false):void
		{
			for(var k:String in dict)
			{
				if(destroy)
					if(IDestroyable(dict[k]))
						IDestroyable(dict[k]).destroy();
				dict[k]=null;
				delete dict[k];
			}
		}
	}
}