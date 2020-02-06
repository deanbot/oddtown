package com.oddtown.engine.status
{
	public interface StatusSubject
	{
		function subscribeToStatus(o:StatusObserver, statusType:uint):void;
		function unsubscribeFromStatus(o:StatusObserver, statusType:uint):void;
	}
}