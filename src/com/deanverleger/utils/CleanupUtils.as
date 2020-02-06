package com.deanverleger.utils
{
	import com.deanverleger.core.IDestroyable;

	public class CleanupUtils
	{
		public static function destroy(... rest):void
		{
			for(var i:uint = 0; i < rest.length; i++)
				IDestroyable(rest[i]).destroy();
		}
	}
}