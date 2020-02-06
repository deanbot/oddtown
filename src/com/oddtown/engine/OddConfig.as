package com.oddtown.engine
{
	import com.deanverleger.utils.DictionaryUtils;
	
	import flash.utils.Dictionary;

	public class OddConfig
	{
		// private constants:
		private static const XML_PATH:String="xml path";
		private static const IMPLEMENTATION_PANEL_PACKAGE:String="implementation panel package";
		private static const STAGE_WIDTH:String="stage-width";
		private static const STAGE_HEIGHT:String="stage-height";
		private static const PAGE_ZOOM_OUT_TIME:String="pg zoom out time";
		private static const PAGE_ZOOM_IN_TIME:String="pg zoom in time";
		private static const PAGE_ZOOM_GUTTER:String="pg zoom gutter";
		private static const PAGE_TRANSITION_FADE_TIME:String="pg trans fade time";
		private static const PANEL_FADE_TIME:String="pn fade time";
		private static const PANEL_TRANSITION_TIME:String="pn move to time";
		private static const DEFAULT_PANEL_DELAY_TIME:String="def panal delay time";
		private static const GLOBAL_VOLUME:String = "globalVolume";
		private static const UI_VOLUME_OFFSET:String = "uiVolumeOffset";
		private static const MUSIC_VOLUME_OFFSET:String = "musicVolumeOffset";
		private static const AMBIENT_VOLUME_OFFSET:String = "ambientVolumeOffset";
		
		// private properties:
		private static var CONFIG:Dictionary = new Dictionary(true);
		
		public static function set pageTransitionFadeTime(time:Number):void
		{
			CONFIG[PAGE_TRANSITION_FADE_TIME]=time;
		}
		
		public static function get pageTransitionFadeTime():Number
		{
			return CONFIG[PAGE_TRANSITION_FADE_TIME]||.5;
		}
		
		public static function set panelFadeTime(time:Number):void
		{
			CONFIG[PANEL_FADE_TIME]=time;
		}
		
		public static function get panelFadeTime():Number
		{
			return CONFIG[PANEL_FADE_TIME]||.3;
		}
		
		public static function set panelTransitionTime(time:Number):void
		{
			CONFIG[PANEL_TRANSITION_TIME]=time;
		}
		
		public static function get panelTransitionTime():Number
		{
			return CONFIG[PANEL_TRANSITION_TIME]||1;
		}
		
		public static function set defaultPanelDelayTime(time:Number):void
		{
			CONFIG[DEFAULT_PANEL_DELAY_TIME]=time;
		}
		
		public static function get defaultPanelDelayTime():Number
		{
			return CONFIG[DEFAULT_PANEL_DELAY_TIME]||2;
		}
		
		/**
		 * Set the global volume level used for sounds
		 * 
		 * @param vol the volume level of the global volume. Must be between 0 and 1.
		 * 
		 */
		public static function set globalVolume( vol:Number ):void
		{
			if ( vol > 1 || vol < 0 )
				throw Error("Volume must be between 0 and 1");
			CONFIG[GLOBAL_VOLUME] =  vol;
		}
		
		/**
		 * @return the global volume level for sounds
		 */
		public static function get globalVolume():Number
		{
			return CONFIG[GLOBAL_VOLUME];
		}
		
		/**
		 * Set the UI Volume offset that is used to get the uiVolume as a product of uiVolumeOffset and globalVolume
		 * @param volOffset the number to multiply the global volume by return the uiVolume. Must be between 0 and 1.
		 * 
		 */
		public static function set uiVolumeOffset( volOffset:Number ):void
		{
			if ( volOffset > 1 || volOffset < 0 )
				throw Error("Volume Offset must be between 0 and 1");
			CONFIG[UI_VOLUME_OFFSET] = volOffset;
		}
		
		/**
		 * @return the volume offset coefficent, used to calculate the uiVolume
		 * 
		 */
		public static function get uiVolumeOffset():Number
		{
			return CONFIG[UI_VOLUME_OFFSET] as Number;
		}
		
		public static function set musicVolumeOffset( vol:Number ):void
		{
			CONFIG[MUSIC_VOLUME_OFFSET] = vol;	
		}
		
		public static function get musicVolumeOffset():Number
		{
			return CONFIG[MUSIC_VOLUME_OFFSET] as Number;
		}
		
		public static function set ambientVolumeOffset( vol:Number ):void
		{
			CONFIG[AMBIENT_VOLUME_OFFSET] = vol;
		}
		
		public static function get ambientVolumeOffset():Number
		{
			return CONFIG[AMBIENT_VOLUME_OFFSET] as Number;
		}
		
		/*public static function set(:):void
		{
			
		}
		
		public static function get():
		{
			return	
		}*/
		
		
		public static function set xmlPath(path:String):void
		{
			CONFIG[XML_PATH]=path;
		}
		
		public static function get xmlPath():String
		{
			return CONFIG[XML_PATH];
		}
		
		public static function set impPanelPackage(pkg:String):void
		{
			CONFIG[IMPLEMENTATION_PANEL_PACKAGE]=pkg;
		}
		
		public static function get impPanelPackage():String
		{
			return CONFIG[IMPLEMENTATION_PANEL_PACKAGE]||"com.oddtown.app.panel";
		}
		
		public static function set stageWidth(width:Number):void
		{
			CONFIG[STAGE_WIDTH]=width;
		}
		
		public static function get stageWidth():Number
		{
			return CONFIG[STAGE_WIDTH];
		}

		public static function set stageHeight(height:Number):void
		{
			CONFIG[STAGE_HEIGHT]=height;
		}
		
		public static function get stageHeight():Number
		{
			return CONFIG[STAGE_HEIGHT];
		}
		
		public static function set pageZoomOutTime(time:Number):void
		{
			CONFIG[PAGE_ZOOM_OUT_TIME]=time;
		}
		
		public static function get pageZoomOutTime():Number
		{
			return CONFIG[PAGE_ZOOM_OUT_TIME]||1.5;
		}
		
		public static function set pageZoomInTime(time:Number):void
		{
			CONFIG[PAGE_ZOOM_IN_TIME]=time;
		}
		
		public static function get pageZoomInTime():Number
		{
			return CONFIG[PAGE_ZOOM_IN_TIME]||1;
		}
		
		public static function set pageZoomGutter(gutter:Number):void
		{
			CONFIG[PAGE_ZOOM_GUTTER]=gutter;
		}
		
		public static function get pageZoomGutter():Number
		{
			return CONFIG[PAGE_ZOOM_GUTTER]||30;	
		}
		
		public static function destroy():void
		{
			DictionaryUtils.emptyDictionary(CONFIG);
		}
	}
}