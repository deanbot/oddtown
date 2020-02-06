package com.oddtown.engine.status
{
	public interface StatusObserver
	{
		function update(status:uint, statusType:uint, translated:String):void;
	}
}