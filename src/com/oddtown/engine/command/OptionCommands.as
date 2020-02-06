package com.oddtown.engine.command
{
	import com.deanverleger.core.IDestroyable;
	import com.oddtown.engine.OddtownEngine;

	public class OptionCommands implements IDestroyable
	{
		private var engine:OddtownEngine;
		public function OptionCommands(eng:OddtownEngine)
		{
			engine=eng;
		}

		public function exitToMainMenu():void
		{
			engine.exitToMainMenu();
		}
		
		public function toggleFullscreen():void
		{
			engine.toggleFullscreen();
		}
		
		public function destroy():void
		{
			engine=null;
		}
	}
}