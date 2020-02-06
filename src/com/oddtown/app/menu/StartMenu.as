package com.oddtown.app.menu
{
	
	import com.deanverleger.utils.AssetUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.client.MenuClient;
	import com.oddtown.engine.sound.OddSounds;
	import com.oddtown.engine.sound.SoundInstruction;
	import com.oddtown.engine.sound.SoundInstructionObject;
	import com.oddtown.engine.sound.SoundObjectType;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.net.*;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class StartMenu extends MenuClient
	{
		private static const ID:String="Start Menu";
		private var mPlayClicked:NativeSignal;
		private var mCreditsClicked:NativeSignal;
		private var mControlsClicked:NativeSignal;
		private var mBackClicked:NativeSignal;
		
		private var menu:mainMenu;
		private var credits:Credits;
		private var controls:Controls;
		private var promo:Promo;
		
		private var clipHolder:MovieClip;
		
					
		private var sounds:Array = [ MU_Menu ];
		
		public function StartMenu()
		{
			trace("start menu created");
			//initialize variables	
			
			super();
		}
		
		private var oddSounds:OddSounds;
		private var music:Sound;
		override protected function onStaged(e:Event):void
		{
			trace("added start menu components");
			//add graphics and connect click events
			
			menu=new mainMenu();
			addChild(menu);
			MouseIconHandler.initialize();
			oddSounds=new OddSounds();
			music = AssetUtils.getAssetInstance("MU_Menu") as Sound;
			oddSounds.playSingleSound("menuMusic",music,1);
			
			SignalUtils.hookUpIntObjectSets(ID+"_main_btns",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onMainBtnClicked, 
				menu.playBtn, menu.creditsBtn, menu.controlsBtn, menu.promosBtn
			);
			
		}
		
		override protected function destroyEx():void
		{
			trace("start menu destroyed");
			oddSounds.destroy();
			oddSounds=null;
			SignalUtils.clearIntObjectSets(ID+"_main_btns");
			SignalUtils.clearIntObjectSets(ID+"_sub");
			credits=null;
			controls=null;
			clipHolder=null;
			//clean up, remove graphics
			removeChild(menu)
			menu=null;
			MouseIconHandler.destroy();
		}
		
		private function onMainBtnClicked(e:MouseEvent):void
		{
			MouseIconHandler.showArrowIcon();
			switch(e.target)
			{
				case menu.playBtn:
					oddSounds.fadeSingleSound("menuMusic",0,.45);
					TweenLite.to(menu,.5,{alpha:0,onComplete:playClicked.dispatch});
					break;
				case menu.creditsBtn:
					credits=new Credits();
					addChild(credits);
					SignalUtils.hookUpIntObjectSets(ID+"_sub",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onBackClicked, credits.backBtn);
					break;
				case menu.controlsBtn:
					controls=new Controls();
					addChild(controls);
					SignalUtils.hookUpIntObjectSets(ID+"_sub",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onBackClicked, controls.backBtn);
					break;
				case menu.promosBtn:
					promo=new Promo();
					addChild(promo);
					//SignalUtils.hookUpIntObjectSets(ID+"_sub",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,onBackClicked, promo.backBtn);
					SignalUtils.hookUpIntObjectSets(ID+"_sub",MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,loadWebsite, promo.backBtn, promo.oddTownUrl, promo.dreamFed, promo.strangerDreams, promo.brat, promo.bekahA, promo.bekahB, promo.steph);
			
					break;
				
				
			}
		}
		
		
		
		private function onBackClicked(e:MouseEvent):void
		{
//			trace("test")
			SignalUtils.clearIntObjectSets(ID+"_sub");
			clipHolder = MovieClip(e.currentTarget);
			TweenLite.to(clipHolder.parent,.5,{alpha:0,onComplete:removeScreen});
			//creditsClicked.dispatch();	
		}
		
		private function removeScreen():void{
			removeChild(clipHolder.parent)
		}
		
		private function removePromo():void{
			removeChild(promo)
		}
		
		
		//this will load a website in a browser
		private function loadWebsite(e:MouseEvent):void{
			
			var myURL:URLRequest;
			switch(e.target) {
				case promo.oddTownUrl:
					myURL= new URLRequest("https://www.facebook.com/WelcomeToOddTown");
					navigateToURL(myURL, "_blank");
					break;
				case promo.oddTownEmail:
					myURL= new URLRequest("Welcome.to.ODD.Town@gmail.com");
					break;
				case promo.strangerDreams:
					myURL= new URLRequest("http://strangerdreams.net/");
					navigateToURL(myURL, "_blank");
					break;
				case promo.dreamFed:
					myURL= new URLRequest("http://www.dreamfed.net/");
					navigateToURL(myURL, "_blank");
					break;
				case promo.brat:
					myURL= new URLRequest("http://bratchan.deviantart.com/");
					navigateToURL(myURL, "_blank");
					break;
				case promo.steph:
					myURL= new URLRequest("https://www.facebook.com/reincarnationrpg");
					navigateToURL(myURL, "_blank");
					break;
				case promo.bekahB:
					myURL= new URLRequest("http://bekcrowmer.artworkfolio.com/");
					navigateToURL(myURL, "_blank");
					break;
				case promo.bekahA:
					myURL= new URLRequest("http://exiledchaos.deviantart.com/");
					navigateToURL(myURL, "_blank");
					break;
				case promo.backBtn:
					SignalUtils.clearIntObjectSets(ID+"_sub");
					TweenLite.to(promo,.5,{alpha:0,onComplete:removePromo});
					trace("asdasd")
					break;
			}
			
			
		}
		
	}//end of class
}