package com.oddtown.engine.command
{
	import com.deanverleger.core.IDestroyable;
	import com.oddtown.engine.OddPage;
	import com.oddtown.engine.PageLibrary;

	public class GetPageCommand implements IDestroyable
	{
		private var pageLibrary:PageLibrary;
		public function GetPageCommand(lib:PageLibrary)
		{
			this.pageLibrary=lib;
		}

		public function execute(id:uint):OddPage
		{
			return this.pageLibrary.getPage(id);
		}
		
		public function destroy():void
		{
			pageLibrary=null;
		}
	}
}