package com.oddtown.engine
{
	public class PanelIDUtils
	{
		public static function getPanelID(order:uint,tree:String=''):String
		{
			var panID:String='pan'+order;
			panID+=(tree=='')?'':'_'+tree;
			return panID;
		}
		public static function getPanelViewedID(pageOrder:uint,panelOrder:uint,tree:String=''):String
		{
			return "pg_"+pageOrder+"_"+getPanelID(panelOrder,tree);
		}
	}
}