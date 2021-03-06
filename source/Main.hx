	package;

	import flixel.FlxGame;
	import flixel.FlxState;
	import openfl.Assets;
	import openfl.Lib;
	import openfl.display.FPS;
	import openfl.display.Sprite;
	import openfl.events.Event;
	import openfl.text.TextFormat;
	import openfl.text.TextField;

	class Main extends Sprite
	{
		var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
		var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
		var initialState:Class<FlxState> = CoolState; // The FlxState the game starts with.
		var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
		var framerate:Int = 140; // How many frames per second the game should run at.
		var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
		var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
		public static var memoryCounter:MemoryCounter;
		public static var fpsFuckerIMeanCounterJeezus:FPS;

		public static var bside:Bool = false;

		public static var noteCount:Int = 0;

		// You can pretty much ignore everything from here on - your code should go in your states.

		public static function main():Void
		{
			Lib.current.addChild(new Main());
		}

		public function new()
		{
			super();

			if (stage != null)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(?E:Event):Void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}

			setupGame();
		}

		private function setupGame():Void
		{
			var stageWidth:Int = Lib.current.stage.stageWidth;
			var stageHeight:Int = Lib.current.stage.stageHeight;

			if (zoom == -1)
			{
				var ratioX:Float = stageWidth / gameWidth;
				var ratioY:Float = stageHeight / gameHeight;
				zoom = Math.min(ratioX, ratioY);
				gameWidth = Math.ceil(stageWidth / zoom);
				gameHeight = Math.ceil(stageHeight / zoom);
			}

			#if !debug
			initialState = CoolState;
			#end

			addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

			var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

			#if web
			var str1:String = "HTML CRAP";
			var vHandler = new VideoHandler();
			vHandler.init1();
			vHandler.video.name = str1;
			addChild(vHandler.video);
			vHandler.init2();
			GlobalVideo.setVid(vHandler);
			vHandler.source(ourSource);
			#elseif desktop
			var str1:String = "WEBM SHIT"; 
			var webmHandle = new WebmHandler();
			webmHandle.source(ourSource);
			webmHandle.makePlayer();
			webmHandle.webm.name = str1;
			addChild(webmHandle.webm);
			GlobalVideo.setWebm(webmHandle);
			#end

			#if !mobile
			fpsFuckerIMeanCounterJeezus = new FPS(10, 3, 0xFFFFFF);
			fpsFuckerIMeanCounterJeezus.defaultTextFormat = new TextFormat("Comic Sans MS Bold", 8, 0xFFFFFF, true);
			addChild(fpsFuckerIMeanCounterJeezus);
		
			memoryCounter = new MemoryCounter(10, 3, 0xffffff);
			memoryCounter.defaultTextFormat = new TextFormat("Comic Sans MS Bold", 8, 0xFFFFFF, true);
			addChild(memoryCounter);
			#end
		}
	}
