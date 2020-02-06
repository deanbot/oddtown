package com.oddtown.engine.command
{
	import com.deanverleger.core.IDestroyable;
	import com.oddtown.engine.OddtownEngine;

	public class GameCompletionCommands implements IDestroyable
	{
		private var engine:OddtownEngine;
		public function GameCompletionCommands(eng:OddtownEngine)
		{
			engine=eng;
		}
		
		public function beatGame():void
		{
			engine.setBeatGame();
		}
		
		public function lostGame():void
		{
			engine.setLostGame();
		}
		
		public function destroy():void
		{
			engine=null;
		}
	}
}