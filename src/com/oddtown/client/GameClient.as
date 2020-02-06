package com.oddtown.client
{
	import com.oddtown.engine.OddConfig;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class GameClient extends Sprite
	{
		private var _exitedToMenu:Signal;
		private var _beatGame:Signal;
		private var _lostGame:Signal;
		private var staged:NativeSignal;
		public function GameClient()
		{
			_exitedToMenu = new Signal();
			_beatGame = new Signal();
			_lostGame = new Signal();
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
		
		public final function destroy():void {
			trace("Destroy Game ");
			destroyEx();
			_exitedToMenu.removeAll();
			_lostGame.removeAll();
			_beatGame.removeAll();
			staged = null;
			_exitedToMenu = _lostGame = _beatGame = null;
		}

		public function get exitedToMenu():Signal
		{
			return _exitedToMenu;
		}

		public function get lostGame():Signal
		{
			return _lostGame;
		}

		public function get beatGame():Signal
		{
			return _beatGame;
		}
	}
}