package
{
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.app.OddtownClient;
	import com.oddtown.app.menu.StartMenu;
	import com.oddtown.client.GameClient;
	import com.oddtown.client.MenuClient;
	import com.oddtown.engine.OddConfig;

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	import org.osflash.signals.natives.NativeSignal;

	[SWF(width="1070", height="790", frameRate="25", backgroundColor="#000000")]
	/**
	 * Main Application File for Welcome to Oddtown.
	 *
	 * This class loads and places and handles cleanup for the:
	 * - Logo Bumpers
	 * - Start Menu
	 * - Oddtown Game
	 *
	 * @author dean
	 *
	 */
	public class Oddtown extends Sprite
	{
		/* Layout Template */
		// constants:
		// private properties:
		// public properties:
		// constructor:
		// public getter/setters:
		// public methods:
		// private methods:

		private var onStage:NativeSignal;
		private var bumper:MovieClip;
		private var fsm:FrameScriptManager;
		private var startMenu:MenuClient;
		private var oddtownClient:GameClient;


		private var loader:ClassLoader;

		public function Oddtown()
		{
			onStage = new NativeSignal(this,Event.ADDED_TO_STAGE, Event);
			onStage.addOnce(onStaged);
			OddConfig.stageWidth = 1070;
			OddConfig.stageHeight = 790;
		}

		private function onStaged(e:Event):void
		{
			onStage=null;
			// can try different scale modes to get the effect we want.
//			this.stage.scaleMode = StageScaleMode.SHOW_ALL;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			init();
			//load();
		}

		private function load():void
		{
			loader = new ClassLoader();
			loader.addEventListener(ClassLoader.LOAD_ERROR,loadErrorHandler);
			loader.addEventListener(ClassLoader.CLASS_LOADED,classLoadedHandler);
			loader.load("../SOURCE/libs/Pages_1_12_22.swc");
		}

		private function loadErrorHandler(e:Event):void {
			trace(e.type);
			throw new IllegalOperationError("Cannot load the specified file.");
		}

		private function classLoadedHandler(e:Event):void {
			init();
		}

		private function init():void
		{
			bekahBumper();
//			createStartMenu();
//			playGame();
		}

		private function dreamfedBumper():void
		{
			bumper = new DreamfedBumper() as MovieClip;
			fsm = new FrameScriptManager(bumper);
			fsm.setFrameScript(bumper.totalFrames,
				function():void {
					bumper.stop();
					removeChild(bumper);
					bumper=null;
					fsm=null;
					bratsBumper();
				}
			);
			bumper.x = OddConfig.stageWidth*.5 - bumper.width*.5;
			bumper.y = OddConfig.stageHeight*.5 - bumper.height*.5;

			addChild(bumper);
		}

		private function bratsBumper():void
		{
			trace("brat")
			bumper = new BratLogo() as MovieClip;
			fsm = new FrameScriptManager(bumper);
			fsm.setFrameScript(bumper.totalFrames,
				function():void {
					bumper.stop();
					removeChild(bumper);
					bumper=null;
					fsm=null;
					createStartMenu();
				}
			);
			bumper.x = OddConfig.stageWidth*.5 - bumper.width*.5;
			bumper.y = OddConfig.stageHeight*.5 - bumper.height*.5;

			addChild(bumper);
		}

		private function bekahBumper():void
		{
			trace("bekah logo")
			bumper = new crowStudio() as MovieClip;
			fsm = new FrameScriptManager(bumper);
			fsm.setFrameScript(bumper.totalFrames,
				function():void {
					bumper.stop();
					removeChild(bumper);
					bumper=null;
					fsm=null;
					dreamfedBumper()
				}
			);
			bumper.x = OddConfig.stageWidth*.5 - bumper.width*.5;
			bumper.y = OddConfig.stageHeight*.5 - bumper.height*.5;

			addChild(bumper);
		}

		private function createStartMenu():void
		{
			startMenu = new StartMenu();
			startMenu.playClicked.addOnce(onPlayClicked);
			startMenu.loadClicked.addOnce(onLoadClicked);
			startMenu.creditsClicked.addOnce(onCreditsClicked);
			addChild(startMenu);
		}

		private function onLoadClicked():void
		{

		}

		private function onCreditsClicked():void
		{

		}

		private function onPlayClicked():void
		{
			removeChild( startMenu );
			startMenu.destroy();
			startMenu = null;
			playGame();
		}

		/**
		 * Start Game Here
		 */
		private var clientMask:Shape;
		private function playGame():void
		{
			oddtownClient = new OddtownClient();
			oddtownClient.exitedToMenu.addOnce(onExitedToMenu);
			oddtownClient.beatGame.addOnce(onBeatGame);
			oddtownClient.lostGame.addOnce(onLostGame);
			clientMask = new Shape();
			clientMask.graphics.beginFill(0x555555); //whatever color, doesn't matter for a mask.
			clientMask.graphics.drawRect(0, 0, 1070, 790);
			clientMask.graphics.endFill();
			addChild(oddtownClient);
			addChild(clientMask);
			oddtownClient.mask = clientMask;
		}

		private function destroyGame():void
		{
			oddtownClient.lostGame.removeAll();
			oddtownClient.beatGame.removeAll();
			oddtownClient.exitedToMenu.removeAll();
			oddtownClient.mask=null;
			removeChild(clientMask);
			removeChild(oddtownClient);
			oddtownClient.destroy();
			oddtownClient=null;
			clientMask=null;
		}

		private function onExitedToMenu():void
		{
			destroyGame();
			createStartMenu();
		}

		private function onBeatGame():void
		{
			trace("You won!");
			onExitedToMenu();
		}

		private function onLostGame():void
		{
			trace("You lost!");
			onExitedToMenu();
		}
	}
}
import flash.display.Loader;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

class ClassLoader extends EventDispatcher {
	public static var CLASS_LOADED:String = "classLoaded";
	public static var LOAD_ERROR:String = "loadError";
	private var loader:Loader;
	private var swfLib:String;
	private var request:URLRequest;
	private var loadedClass:Class;

	public function ClassLoader() {

		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
	}

	public function load(lib:String):void {
		swfLib = lib;
		request = new URLRequest(swfLib);
		var context:LoaderContext = new LoaderContext();
		context.applicationDomain=ApplicationDomain.currentDomain;
		loader.load(request,context);
	}

	public function getClass(className:String):Class {
		try {
			return loader.contentLoaderInfo.applicationDomain.getDefinition(className)  as  Class;
		} catch (e:Error) {
			throw new IllegalOperationError(className + " definition not found in " + swfLib);
		}
		return null;
	}

	private function completeHandler(e:Event):void {
		dispatchEvent(new Event(ClassLoader.CLASS_LOADED));
	}

	private function ioErrorHandler(e:Event):void {
		dispatchEvent(new Event(ClassLoader.LOAD_ERROR));
	}

	private function securityErrorHandler(e:Event):void {
		dispatchEvent(new Event(ClassLoader.LOAD_ERROR));
	}
}