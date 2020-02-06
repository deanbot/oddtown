package com.oddtown.engine.command
{
	import com.deanverleger.core.IDestroyable;
	import com.oddtown.engine.OddtownEngine;

	public class ChangeToPageCommand implements IDestroyable
	{
		private var engine:OddtownEngine;
		public function ChangeToPageCommand(eng:OddtownEngine)
		{
			this.engine = eng;
		}
		
		public function execute(id:uint=NaN,flag:String="",antiFlag:String=""):void
		{
			this.engine.changeToPage(id,flag,antiFlag);
		}
		
		public function destroy():void
		{
			engine=null;
		}
	}
}