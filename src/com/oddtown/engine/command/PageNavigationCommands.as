package com.oddtown.engine.command
{
	import com.deanverleger.core.IDestroyable;
	import com.oddtown.engine.OddtownEngine;

	public class PageNavigationCommands implements IDestroyable
	{
		private var engine:OddtownEngine;
		public function PageNavigationCommands(eng:OddtownEngine)
		{
			engine=eng;
		}
		
		public function get hasNextPage():Boolean
		{
			return engine.hasNextPage();
		}
		
		public function get hasPrevPage():Boolean
		{
			return engine.hasPrevPage();
		}
		
		public function nextPage():void
		{
			this.engine.changeToNextPage();
		}
		
		public function prevPage():void
		{
			this.engine.changeToPrevPage();
		}
		
		public function destroy():void
		{
			engine=null;
		}
	}
}