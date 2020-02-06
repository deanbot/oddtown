package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Imp_Pg24_Pan1 extends PanelImp
	{
		private static const ID:String="Imp_Pg24_Pan1";
		private var panel:Pg23_Pan1;
		public function Imp_Pg24_Pan1()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		override public function panelPrep():void {
			panel=Pg23_Pan1(_asset);
			ClipUtils.makeInvisible(panel.topClick,panel.middleClick,panel.bottomClick);
			ClipUtils.hide(panel.chao,panel.mason);
		}
		
		override protected function panelSetup():void
		{
			if(!panel)
				panel=Pg23_Pan1(_asset);
			SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,handleClick,
				panel.middleClick,panel.topClick,panel.bottomClick);
		}
		
		override protected function panelCleanupEx():void
		{
			SignalUtils.clearIntObjectSets(ID);
			panel=null;
		}
		
		private function handleClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				case panel.topClick:
				case panel.bottomClick:
				case panel.middleClick:
					SignalUtils.clearIntObjectSets(ID);
					//TweenLite.
			}
		}
	}
}