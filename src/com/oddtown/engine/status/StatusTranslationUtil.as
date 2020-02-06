package com.oddtown.engine.status
{
	import com.oddtown.engine.OddtownEngine;

	public class StatusTranslationUtil
	{
		public static function translateStatus(status:uint, statusType:uint):String
		{
			var translated:String=">>> [";
			if(statusType == OddtownEngine.STATUS_TYPE_ENGINE)
			{
				translated += 'Oddtown Engine Status: ';
				switch(status)
				{
					case OddtownEngine.ENGINE_STATUS_BUSY:
						translated += 'Busy';
						break;
					case OddtownEngine.ENGINE_STATUS_WAITING:
						translated += 'Waiting';
				}
			} else if (statusType == OddtownEngine.STATUS_TYPE_PLAY)
			{
				translated += 'Oddtown Play Status: ';
				switch(status)
				{
					case OddtownEngine.PLAY_STATUS_OFF:
						translated += 'Off';
						break;
					case OddtownEngine.PLAY_STATUS_PLAYING_PANEL:
						translated += 'Playing Panel';
						break;
					case OddtownEngine.PLAY_STATUS_EXPLORING_PANEL:
						translated+="Exploring Panel";
						break;
					case OddtownEngine.PLAY_STATUS_ZOOMING_PANEL:
						translated+="Zooming Panel";
						break;
					case OddtownEngine.PLAY_STATUS_PAUSED:
						translated+="Paused";
						break;
					case OddtownEngine.PLAY_STATUS_PAGE_NAVIGATION:
						translated += 'Page Navigation';
						break;
					case OddtownEngine.PLAY_STATUS_CHANGING_PAGE:
						translated += 'Changing Page';
						break;
					case OddtownEngine.PLAY_STATUS_GAME_OVER:
						translated += "Game Over";
				}
			}
			translated+="] <<<";
			return translated;
		}
	}
}