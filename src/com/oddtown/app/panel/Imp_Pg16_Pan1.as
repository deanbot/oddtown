package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Imp_Pg16_Pan1 extends PanelImp
	{
		private static const ID:String="Imp_Pg16_Pan1";
		private static const FLAG_CHAO:String="flagChao";
		private static const FLAG_MASON:String="flagMason";
		private var panel:Pg16_Pan1;
		public function Imp_Pg16_Pan1()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void {
			panel=Pg16_Pan1(_asset);
			ClipUtils.makeInvisible(panel.chaoClick,panel.masonClick);
			if(hasChao)
				ClipUtils.hide(panel.chao, panel.chaoClick);
			if(hasMason)
				ClipUtils.hide(panel.mason, panel.masonClick);
		}
		
		override protected function panelSetup():void
		{
			if(!panel)
				panel=Pg16_Pan1(_asset);
			//hide folders
//			if(panel.chao.visible && hasChao)
//				TweenLite.to(panel.chao,.5,{alpha:0});
//			if(panel.mason.visible && hasMason)
//				TweenLite.to(panel.mason,.5,{alpha:0});
			
			
			//set up listeners
			if(!hasChao && !hasMason)
				SignalUtils.hookUpIntObjectSets(ID, MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,folderClick,panel.chaoClick,panel.masonClick);
			else if(hasChao && !hasMason) 
				SignalUtils.hookUpIntObjectSets(ID, MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,folderClick,panel.masonClick);
			else if(!hasChao && hasMason)
				SignalUtils.hookUpIntObjectSets(ID, MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,folderClick,panel.chaoClick);
		}
		
		override protected function panelCleanupEx():void
		{
			SignalUtils.clearIntObjectSets(ID);
			MouseIconHandler.showArrowIcon();
			panel=null;
		}
		
		private function folderClick(e:MouseEvent):void
		{
			//SignalUtils.clearIntObjectSets(ID);
			switch(e.target)
			{
				case panel.chaoClick:
					hasChao=true;
					SignalUtils.clearIntObjectSets(ID);
					MouseIconHandler.showArrowIcon();
					changePanel.dispatch(2);
					break;
				case panel.masonClick:
					hasMason=true;
					SignalUtils.clearIntObjectSets(ID);
					MouseIconHandler.showArrowIcon();
					changePanel.dispatch(4);
					break;
			}
		}
		
		private function get hasChao():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG, FLAG_CHAO);
		}
		
		private function get hasMason():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG, FLAG_MASON);
		}
		
		private function set hasChao(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CHAO);
		}
		
		private function set hasMason(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_MASON);
		}
	}
}