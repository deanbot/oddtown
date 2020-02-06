package com.oddtown.app
{
	import com.oddtown.app.panel.Imp_Pg13_Pan6;
	import com.oddtown.app.panel.Imp_Pg15_Pan1;
	import com.oddtown.app.panel.Imp_Pg16_Pan1;
	import com.oddtown.app.panel.Imp_Pg16_Pan3;
	import com.oddtown.app.panel.Imp_Pg16_Pan5;
	import com.oddtown.app.panel.Imp_Pg17_Pan1;
	import com.oddtown.app.panel.Imp_Pg17_Pan2;
	import com.oddtown.app.panel.Imp_Pg19_Pan1;
	import com.oddtown.app.panel.Imp_Pg20_Pan2;
	import com.oddtown.app.panel.Imp_Pg20_Pan3;
	import com.oddtown.app.panel.Imp_Pg20_Pan4;
	import com.oddtown.app.panel.Imp_Pg20_Pan5;
	import com.oddtown.app.panel.Imp_Pg21_Pan1;
	import com.oddtown.app.panel.Imp_Pg21_Pan3;
	import com.oddtown.app.panel.Imp_Pg23_Pan1;
	import com.oddtown.app.panel.Imp_Pg7_Pan1;
	import com.oddtown.app.ui.OddtownUI;
	import com.oddtown.client.GameClient;
	import com.oddtown.client.UIClient;
	import com.oddtown.engine.OddConfig;
	import com.oddtown.engine.OddtownEngine;
	import com.oddtown.engine.command.OptionCommands;
	import com.oddtown.engine.command.PageNavigationCommands;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class OddtownClient extends GameClient
	{
		private var engine:OddtownEngine;
		private var ui:UIClient;
		private var uiComp:DisplayObject;
		private var oddComp:DisplayObject;
		
		/* Test Assets */
		//private var pageAssets:Array = [ Test_Pg1, Test_Pg2, Test_Pg3 ];
		//private var customPanels:Array = [ Test_Imp_Pg2_Pan1, Test_Imp_Pg2_Pan4, Test_Imp_Pg3_Pan1 ];
		//private var musicAndSounds:Array = [ Test_Jazz1, Test_Eerie, Test_ClocksLoop, Test_Suspense ];
		 
		/* Final Assets */
		private var pageAssets:Array = [ Pg1, Pg2, Pg3, Pg4, Pg5, Pg6, Pg7, Pg8, Pg9, Pg10, Pg11, Pg12, Pg13, Pg14, Pg15, Pg16, Pg17, Pg18, Pg19, Pg20, Pg21, Pg22, Pg23, FinalCredits ];
//		private var pageAssets:Array = [  Pg8 ];
		private var customPanels:Array = [ Imp_Pg13_Pan6, Imp_Pg7_Pan1, Imp_Pg15_Pan1, Imp_Pg16_Pan1, Imp_Pg16_Pan3, Imp_Pg16_Pan5, Imp_Pg17_Pan1, Imp_Pg17_Pan2, Imp_Pg19_Pan1, Imp_Pg20_Pan2, Imp_Pg20_Pan3, Imp_Pg20_Pan4, Imp_Pg20_Pan5, Imp_Pg21_Pan1, Imp_Pg21_Pan3, Imp_Pg23_Pan1];
		
		/*
			AM_Writing, AM_GlassBreak,
		*/
		private var musicAndSounds:Array = [ 
			MU_Overall, MU_StainedGlass, MU_CactusFall, MU_CactusFail, MU_Credits, MU_GusGoesOut,
			AM_Clock, AM_PaperFlutter, AM_HandSlam, AM_SlidingPaper, AM_Sigh, AM_GlassFall
		];
		
		public function OddtownClient()
		{
			super();
			/* Edit Settings Here */
			OddConfig.xmlPath="libs/OddtownFinal.xml";
			//test package
			OddConfig.impPanelPackage="com.oddtown.app.panel";
			//final package
			/*OddConfig.impPanelPackage="com.oddtown.app.panel";*/
			OddConfig.stageWidth=1070;
			OddConfig.stageHeight=790;
			OddConfig.pageZoomGutter=30
			OddConfig.pageZoomOutTime=1.5;
			OddConfig.pageZoomInTime=1;
			OddConfig.pageTransitionFadeTime=.5;
			OddConfig.panelFadeTime=.3;
			OddConfig.panelTransitionTime=1;
			OddConfig.defaultPanelDelayTime=2;
			OddConfig.globalVolume = 1;
			OddConfig.uiVolumeOffset = 1;
			OddConfig.musicVolumeOffset = .5;
			OddConfig.ambientVolumeOffset = .8;
			
			engine = OddtownEngine.getInstance();
			ui = OddtownUI.getInstance();
			ui.pageNavigationCommands=new PageNavigationCommands(engine);
			ui.optionCommands=new OptionCommands(engine);
			engine.subscribeToStatus(ui,OddtownEngine.STATUS_TYPE_ENGINE);
			engine.subscribeToStatus(ui,OddtownEngine.STATUS_TYPE_PLAY);
			engine.beatGame.addOnce(beatGame.dispatch);
			engine.lostGame.addOnce(lostGame.dispatch);
			engine.exitedToMenu.addOnce(exitedToMenu.dispatch);
			uiComp = ui.oddtownUI;
			oddComp = engine.oddDisplay;
		}

		override protected function onStaged(e:Event):void
		{
			trace("client added to stage");
			addChild(oddComp);
			addChild(uiComp);
			engine.build();
		}
		
		override protected function destroyEx():void
		{
			removeChild(uiComp);
			removeChild(oddComp);
			uiComp = oddComp = null;
			ui.destroy();
			engine.destroy();
			
			ui = null;
			engine = null;
			OddConfig.destroy();
			trace("client destroyed");
		}
	}
}