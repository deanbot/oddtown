package com.oddtown.client
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.DictionaryUtils;
	import com.oddtown.engine.OddtownEngine;
	import com.oddtown.engine.command.OptionCommands;
	import com.oddtown.engine.command.PageNavigationCommands;
	import com.oddtown.engine.status.StatusObserver;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class UIClient extends Sprite implements StatusObserver, IDestroyable
	{
		private var staged:NativeSignal;
		protected var engineStatus:uint;
		protected var playStatus:uint;
		protected var _pageNavigationCommands:PageNavigationCommands;
		protected var _optionCommands:OptionCommands;
		
		public function UIClient()
		{
			staged = new NativeSignal(this,Event.ADDED_TO_STAGE,Event);
			staged.addOnce(onStaged);
			super();
		}
		
		public function set optionCommands(value:OptionCommands):void
		{
			_optionCommands = value;
		}

		public function get oddtownUI():DisplayObject
		{
			return this;
		}
		
		public function set pageNavigationCommands(cmds:PageNavigationCommands):void
		{
			_pageNavigationCommands=cmds;
		}
		
		public final function destroy():void
		{
			trace("Destroy UI");
			destroyEx()
			staged=null;
			if(_pageNavigationCommands)
				_pageNavigationCommands.destroy();
			if(_optionCommands)
				_optionCommands.destroy();
			_optionCommands=null;
			_pageNavigationCommands=null;
		}
		
		/**
		 * Override in child class. DO NOT CALL US. WE'LL CALL YOU.
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

		/**
		 * Override in child class. Example below.
		 * 
		 */
		public function update(status:uint, statusType:uint, translated:String):void
		{
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
				engineStatus = status;
			else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
				playStatus = status;
			
			trace(translated);
		}
	}
}