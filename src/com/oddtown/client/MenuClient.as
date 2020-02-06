package com.oddtown.client
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * Abstract Class. To be extended but not instantiated. 
	 * @author dean
	 * 
	 */
	public class MenuClient extends Sprite
	{
		private var _playClicked:Signal;
		private var _creditsClicked:Signal;
		private var _loadClicked:Signal;
		private var staged:NativeSignal;
		public function MenuClient()
		{
			_playClicked = _creditsClicked = _loadClicked = new Signal();
			staged = new NativeSignal(this,Event.ADDED_TO_STAGE, Event);
			staged.addOnce(onStaged);
			super();
		}
		
		/**
		 * Override in child class
		 * @param e
		 * 
		 */
		protected function onStaged(e:Event):void
		{
			// set up child class
		}
		
		/**
		 * Override in child class. DO NOT CALL US. WE'LL CALL YOU.
		 * 
		 */
		protected function destroyEx():void
		{
			// clean up child class
		}

		public function get playClicked():Signal
		{
			return _playClicked;
		}

		public function get creditsClicked():Signal
		{
			return _creditsClicked;
		}

		public function get loadClicked():Signal
		{
			return _loadClicked;
		}

		public final function destroy():void
		{
			destroyEx();
			_playClicked.removeAll();
			_creditsClicked.removeAll();
			_loadClicked.removeAll();
			staged = null;
			_playClicked = _creditsClicked = _loadClicked = null;
		}
	}
}