package;

import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
import Shaders.PulseEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flash.system.System;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42; //FISH ENGINE ??!?!?!?!?Ç

	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var mania:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9];

	public var camBeatSnap:Int = 4;
	public var danceBeatSnap:Int = 2;
	public var dadDanceSnap:Int = 2;

	public var badaiTime:Bool = false;

	public var idleAlt:Bool = false;

	var lol:Bool = true;
	var bruh:Bool = true;
	var what:Bool = true;
	var e:Bool = true;
	var ok:Bool = true;
    var poFromAmogus:Bool = false;
	var TeleTummy:Bool = true;

	public static var ratio:Array<Float> = [3, 7.6, 3.28, 2398, 42378.6874362, 58456834.6483568];

	public static var altSong:SwagSong;

	public static var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness'];
	public static var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	var howManyPlayerNotes:Int = 0;
	var howManyEnemyNotes:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:FlxSprite;
	public var fuckThisDumbassVariable:FlxSprite;
	public var curbg2:FlxSprite;
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var songPercent:Float = 0;

	var songLength:Float = 0;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair', 'bambi-helium', 'unfair-helium', 'SEAL', 'bambi-phono', 'hell', 'OPPOSITION', 'thearchy', 'GREEN'];
	var funnyFloatyBoys2:Array<String> = ['dave-corrupt', 'dave-corrupt-2', 'dave-corrupt-3', 'dave-corrupt-4', 'dave-corrupt-5', 'dave-corrupt-6', 'dave-corrupt-7'];
	var funnyFloatyAppleCore:Array<String> = ['bandu', 'bambi-piss-3d', 'unfair-junker']; //junk 1

	var elpepe:Array<String> = ['dave-angey', 'bambi-3d', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair', 'bambi-helium', 'unfair-helium', 'SEAL', 'bambi-phono', 'hell', 'OPPOSITION', 'thearchy', 'GREEN', 'bandu', 'bambi-piss-3d', 'unfair-junker', 'bambi-angey']; //junk 1
	
	var hypertone:Array<String> = ['opposition', 'phonophobia', 'hellbreaker'];//lol
	var cheese:String;

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	private var vocals:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	private var swagger:Character;
	private var littleIdiot:Character;

	private var daveExpressionSplitathon:Character;

	private var notes:FlxTypedGroup<Note>;
	private var altNotes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	private var altUnspawnNotes:Array<Note> = [];
	public var unspawnThing:Bool = false;
	public var unspawnThing2:Bool = false;

	public var altUnspawnThing:Bool = false;
	public var altUnspawnThing2:Bool = false;

	private var strumLine:FlxSprite;
	private var altStrumLine:FlxSprite;
	private var curSection:Int = 0;

	var bruh1:FlxSprite;
	var bruh2:FlxSprite;
	var bruh3:FlxSprite;
	var bruh4:FlxSprite;

	private var camFollow:FlxObject;

	private var camFollowFART:FlxPoint;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<StrumNote>;

	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;
	public var poopStrums:FlxTypedGroup<StrumNote>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public var barCombo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var accuracyString:String = "0.00";
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	public static var amogus:Int = 0;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var notestuffs:Array<String> = (SONG.mania == 0 ? ['LEFT', 'DOWN', 'UP', 'RIGHT'] : (SONG.mania == 1 ? ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'] : ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT']));
	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	var timeTxt:FlxText;

	var timeName:FlxText;

	var scoreTxtTween:FlxTween;

	var timeTxtTween:FlxTween;

	var timeNameTween:FlxTween;

	var GFScared:Bool = false;

	public static var campaignScore:Int = 0;

	private var updateTime:Bool = true;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var warningNeverDone:Bool = false;

	public var thing:FlxSprite = new FlxSprite(0, 250);
	public var splitathonExpressionAdded:Bool = false;

	public var crazyBatch:String = "shutdown /r /t 120";

	public var backgroundSprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var normalDaveBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var canFloat:Bool = true;

	var nightColor:FlxColor = 0xFF878787;

	public static var botplay:Bool = false;
	public static var totalBot:Bool = false;
	var swag:Bool = false;
	var swag2:Bool = false;
	var swag3:Bool = false;
	var swag4:Bool = false;
	var swag5:Bool = false;
	var swag6:Bool = false;
	var swag7:Bool = false;
	var swag8:Bool = false;
	var canMove:Bool = false;

	var scaryBG:FlxSprite;
	var showScary:Bool = false;

	var swagBG:FlxSprite;
	var unswagBG:FlxSprite;

	var creditsWatermark:FlxText;
	var kadeEngineWatermark:FlxText;

	var poop:StupidDumbSprite;

	override public function create()
	{
	    cheese = SONG.song.toLowerCase();
		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;
		var downscrollSongs:Array<String> = ['unfairness', 'unfairness-high-pitched', 'hellbreaker', 'phonophobia', 'opposition'];
		
		//if (downscrollSongs.contains(cheese)) FlxG.save.data.downscroll = true;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'dave' | 'dave-old':
				iconRPC = 'icon_dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao' | 'bambi-farmer-beta':
				iconRPC = 'icon_bambi';
			default:
				iconRPC = 'icon_none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'icon_both';
		}

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay Mode: ";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		var e = Std.int(SONG.bpm / 4);
		Conductor.AAA(e);

		mania = SONG.mania;

		theFunne = theFunne && SONG.song.toLowerCase() != 'unfairness';

		//theFunne = theFunne && SONG.song.toLowerCase() != 'unfairnes-high-pitched';//boom done lol

		var crazyNumber:Int;
		crazyNumber = FlxG.random.int(0, 4);
		switch (crazyNumber)
		{
			case 0:
				trace("secret dick message ???");
			case 1:
				trace("welcome baldis basics crap");
			case 2:
				trace("Hi, song genie here. You're playing " + SONG.song + ", right?");
			case 3:
				eatShit("this song doesnt have dialogue idiot. if you want this retarded trace function to call itself then why dont you play a song with ACTUAL dialogue? jesus fuck");
			case 4:
				trace("suck my balls");
		}

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey, you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'house':
				dialogue = CoolUtil.coolTextFile(Paths.txt('house/houseDialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('insanity/insanityDialogue'));
			case 'furiosity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('furiosity/furiosityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('polygonized/polyDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('supernovae/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('glitch/glitchDialogue'));
			case 'blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('blocked/retardedDialogue'));
			case 'corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('corn-theft/cornDialogue'));
			case 'cheating':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cheating/cheaterDialogue'));
			case 'unfairness':
				dialogue = CoolUtil.coolTextFile(Paths.txt('unfairness/unfairDialogue'));
			case 'maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('maze/mazeDialogue'));
			case 'splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogue'));
		}

		backgroundSprites = createBackgroundSprites(SONG.song.toLowerCase());
		if (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'furiosity')
		{
			normalDaveBG = createBackgroundSprites('glitch');
			for (bgSprite in normalDaveBG)
			{
				bgSprite.alpha = 0;
			}
		}
		var gfVersion:String = 'gf';

		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		var charoffsetx:Float = 0;
		var charoffsety:Float = 0;
		if (formoverride == "bf-pixel"
			&& (SONG.song != "Tutorial" && SONG.song != "Roses" && SONG.song != "Thorns" && SONG.song != "Senpai"))
		{
			gfVersion = 'gf-pixel';
			charoffsetx += 300;
			charoffsety += 300;
		}
		if(formoverride == "bf-christmas")
		{
			gfVersion = 'gf-christmas';
		}
		gf = new Character(400 + charoffsetx, 130 + charoffsety, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel" || formoverride == "bf-christmas") && SONG.song != "Tutorial")
		{
			gf.visible = false;
		}
		else if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode)
		{
			gf.visible = false;
		}

		dad = new Character(100, 100, SONG.player2);
		switch (SONG.song.toLowerCase())
		{
			case 'applecore':
				dadmirror = new Character(dad.x, dad.y, dad.curCharacter);
			default:
				dadmirror = new Character(100, 100, "dave-angey");
			
		}
		
		

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "tristan" | 'tristan-beta':
				dad.y += 325;
				dad.x += 100;
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				{
					dad.y += 160;
					dad.x += 250;
				}
			case 'dave-old':
				{
					dad.y += 270;
					dad.x += 150;
				}
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				{
					dad.y += 0;
					dad.x += 150;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
				}
			case 'bambi-3d':
				{
					dad.y += 100;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);
				}
			case 'bambi-unfair':
				{
					dad.y += 100;
					camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 50);
				}
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				{
					dad.y += 400;
				}
			case 'bambi-new' | 'bambi-farmer-beta':
				{
					dad.y += 450;
					dad.x += 200;
				}
			case 'bambi-splitathon':
				{
					dad.x += 175;
					dad.y += 400;
				}
			case 'bambi-angey':
				dad.y += 450;
				dad.x += 100;
            case 'hell':
			    dad.scale.set(1.5, 1.5);
				dad.y -= 450;
				dad.x -= 100;
				gf.visible = false;
			case 'scopomania':
			    dad.scale.set(1.5, 1.5);
				gf.visible = false;
			case 'GREEN':
				gf.visible = false;
			case 'OPPOSITION':
				dad.x -= 400;
		}


		dadmirror.y += 0;
		dadmirror.x += 150;

		dadmirror.visible = false;

		if (formoverride == "none" || formoverride == "bf")
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, formoverride);
		}

		switch (boyfriend.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				boyfriend.y = 100 + 325;
				boyfriendOldIcon = 'tristan-beta';
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				boyfriend.y = 100 + 160;
				boyfriendOldIcon = 'dave-old';
			case 'dave-old':
				boyfriend.y = 100 + 270;
				boyfriendOldIcon = 'dave';
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				boyfriend.y = 100;
				switch(boyfriend.curCharacter)
				{
					case 'dave-angey':
						boyfriendOldIcon = 'dave-annoyed-3d';
					case 'dave-annoyed-3d':
						boyfriendOldIcon = 'dave-3d-standing-bruh-what';
					case 'dave-3d-standing-bruh-what':
						boyfriendOldIcon = 'dave-old';
				}
			case 'bambi-3d':
				boyfriend.y = 100 + 350;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-unfair':
				boyfriend.y = 100 + 575;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-new' | 'bambi-farmer-beta':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-splitathon':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-angey':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
		}

		if(darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
		{
			dad.color = nightColor;
			gf.color = nightColor;
			boyfriend.color = nightColor;
		}

		if(sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		add(gf);

		add(dad);
		add(boyfriend);
		add(dadmirror);
		
		if (swagger != null) add(swagger);

		if(SONG.song.toLowerCase() == "unfairness" || SONG.song.toLowerCase() == 'unfairness-high-pitched')
		{
			health = 2;
		}

		if(dad.curCharacter == 'bambi-piss-3d')
		{
			dadDanceSnap = 1;
		}
		if(boyfriend.curCharacter == 'bambi-piss-3d')
		{
			danceBeatSnap = 1;
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (SONG.song.toLowerCase() == 'applecore') {
			altStrumLine = new FlxSprite(0, -100);
		}

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		/*if (FlxG.save.data.downscroll)
			altStrumLine.y = FlxG.height - 120;*/

		var showTime:Bool = true;
		timeTxt = new FlxText(42 + (FlxG.width / 2) - 278, 9, 400, SONG.song + "", 16);
		timeTxt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(FlxG.save.data.downscroll) timeTxt.y = FlxG.height - 44;

		add(timeTxt);

		var showTime:Bool = true;
		timeName = new FlxText(42 + (FlxG.width / 2) - 336, 9, 400, SONG.song + "-", 16);
		timeName.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeName.scrollFactor.set();
		timeName.alpha = 0;
		timeName.borderSize = 2;
		timeName.visible = showTime;
		if(FlxG.save.data.downscroll) timeName.y = FlxG.height - 44;

		//add(timeName);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumNote>();

		dadStrums = new FlxTypedGroup<StrumNote>();
		
		poopStrums = new FlxTypedGroup<StrumNote>(); //BRO I FORGOT ABT THIS ONE I THING IT WORKS NOW. IT WORKS!!!!

		/*if(darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized") //doesnt work :sob:
			{
				strumLineNotes.color = 0xFF878787;
				dadStrums.color = 0xFF878787;
				playerStrums.color = 0xFF878787;
			}
		else
			{
				strumLineNotes.color = FlxColor.WHITE;
				dadStrums.color = FlxColor.WHITE;
				playerStrums.color = FlxColor.WHITE;
			}*/

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		if (hypertone.contains(cheese))
		{
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 3);
		}
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = 'Original Song made by ArchWk!';
			case 'glitch':
				credits = 'Original Song made by DeadShadow and PixelGH!';
			case 'mealie':
				credits = 'Original Song made by Alexander Cooper 19!';
			case 'unfairness':
				credits = "Ghost tapping is forced off! Screw you!";
			case 'unfairness-high-pitched':
				credits = "Haha funny pitch but impossible";
			case 'cheating' | 'disruption':
				credits = 'Screw you!';
			case 'cheating-high-pitched':
				credits = 'Haha da funny pitch';
			case 'very-screwed':
				credits = 'YOU FUCKING LIAR MOLDY!!';
			case 'green':
				credits = "YOU'RE DOOMED HAHA FUCK YOU.";
			default:
				credits = '';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4, textYPos, 0, SONG.song + " " + (curSong.toLowerCase() != 'splitathon' ? (storyDifficulty == 3 && SONG.song.toLowerCase() != "very-screwed" ? "Legacy" : storyDifficulty == 3 && SONG.song.toLowerCase() == "very-screwed" ? "EXTREME" : storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "" : "Easy") : "Finale"), 16);
		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		add(kadeEngineWatermark);

		creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
		creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		creditsWatermark.scrollFactor.set();
		creditsWatermark.borderSize = 1.25;
		creditsWatermark.alpha = 0.65;
		add(creditsWatermark);
		timeTxt.cameras = [camHUD];
		timeName.cameras = [camHUD];
		creditsWatermark.cameras = [camHUD];

		switch (curSong.toLowerCase())
		{
			case 'splitathon':
			    preload('dave/dave_sheet');
			    preload('dave/dave_sheet-2.0');
			    preload('dave/dave_old');
			    preload('dave/wtf is an oatmeal');
			    preload('dave/bambi update dave');
				preload('splitathon/Bambi_WaitWhatNow');
				preload('splitathon/Bambi_ChillingWithTheCorn');
			case 'insanity':
				preload('dave/redsky');
				preload('dave/redsky_insanity');
			case 'polygonized':
			    preload('dave/fuck2');
				preload('dave/fuck3');
				preload('dave/fuck4');
				preload('dave/fuck5');
				preload('dave/fuck6');
				preload('dave/fuck7');
				preload('dave/fuck8');
				preload('dave/fuck9');
			case 'cheating':
			    preload('dave/bambi_angy2');
			    preload('dave/bambi_angy3');
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;
		add(scoreTxt);

		iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		if(iconP1.animation.getByName(boyfriend.curCharacter) == null)
							iconP1.animation.play('bf');
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if(iconP2.animation.getByName(dad.curCharacter) == null)
							iconP2.animation.play('dave');
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;
		if (curSong.toLowerCase() == 'phonophobia') swag2 = true;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode || FlxG.save.data.freeplayCuts)
		{
			switch (curSong.toLowerCase())
			{
				case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'glitch' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'cheating' | 'unfairness':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}
			if (SONG.song.toLowerCase() == 'phonophobia') {
				dadStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
					case 1:
					   spr.y -= 25;
					case 2:
					   spr.y -= 50;
					case 3:
					   spr.y -= 75;
					}
				});
			}

		super.create();
	}
	function createBackgroundSprites(song:String):FlxTypedGroup<FlxSprite>
	{
		var sprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
		switch (song)
		{
			case 'house' | 'insanity' | 'supernovae' | 'old-insanity':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;

				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;
				
				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-200, -125).loadGraphic(Paths.image('dave/gate'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;
				
				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;
				if (SONG.song.toLowerCase() == 'insanity')
				{
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky_insanity'));
					bg.alpha = 0.75;
					bg.active = true;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
					testshader.waveAmplitude = 0.1;
					testshader.waveFrequency = 5;
					testshader.waveSpeed = 2;
					bg.shader = testshader.shader;
					curbg = bg;
				}
			case 'blocked' | 'corn-theft' | 'maze' | 'old-corn-theft' | 'old-maze' | 'mealie' | 'splitathon':
				defaultCamZoom = 0.9;

				switch (SONG.song.toLowerCase())
				{
					case 'splitathon' | 'mealie':
						curStage = 'bambiFarmNight';
					case 'maze' | 'old-maze':
						curStage = 'bambiFarmSunset';
					default:
						curStage = 'bambiFarm';
				}
	
				var skyType:String = curStage == 'bambiFarmNight' ? 'dave/sky_night' : 'dave/sky';
				if(curStage == 'bambiFarmSunset')
				{
					skyType = 'dave/sky_sunset';
				}
	
				var bg:FlxSprite = new FlxSprite(-700, 0).loadGraphic(Paths.image(skyType));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				sprites.add(bg);

				fuckThisDumbassVariable = new FlxSprite(-700, 0).loadGraphic(Paths.image('bambi/invisible'));
	
				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('bambi/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;
				sprites.add(hills);
	
				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('bambi/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;
				sprites.add(farm);
				
				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('bambi/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;
				sprites.add(foreground);
				
				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;
				sprites.add(cornSet);
				
				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;
				sprites.add(cornSet2);
				
				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('bambi/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;
				sprites.add(fence);
	
				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('bambi/Sign'));
				sign.antialiasing = true;
				sign.active = false;
				sprites.add(sign);

				if (curStage == 'bambiFarmNight')
				{
					hills.color = nightColor;
					farm.color = nightColor;
					foreground.color = nightColor;
					cornSet.color = nightColor;
					cornSet2.color = nightColor;
					fence.color = nightColor;
					sign.color = nightColor;
				}

				if (curStage == 'bambiFarmSunset')
				{
					hills.color = sunsetColor;
					farm.color = sunsetColor;
					foreground.color = sunsetColor;
					cornSet.color = sunsetColor;
					cornSet2.color = sunsetColor;
					fence.color = sunsetColor;
					sign.color = sunsetColor;
				}
				
				add(bg);
				add(hills);
				add(farm);
				add(foreground);
				add(cornSet);
				add(cornSet2);
				add(fence);
				add(sign);
	
				UsingNewCam = true;

		        bruh1 = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky'));
			    bruh1.antialiasing = true;
			    bruh1.scrollFactor.set(0.9, 0.9);
			    bruh1.active = false;
			    bruh1.visible = false;
				sprites.add(bruh1);
			    add(bruh1);

			    bruh2 = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills'));
			    bruh2.setGraphicSize(Std.int(bruh2.width * 1.25));
			    bruh2.updateHitbox();
			    bruh2.antialiasing = true;
			    bruh2.scrollFactor.set(1, 1);
			    bruh2.active = false;
			    bruh2.visible = false;
				sprites.add(bruh2);
			    add(bruh2);

			    bruh3 = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate'));
			    bruh3.setGraphicSize(Std.int(bruh3.width * 1.2));
			    bruh3.updateHitbox();
			    bruh3.antialiasing = true;
			    bruh3.scrollFactor.set(0.925, 0.925);
			    bruh3.x += 25;
			    bruh3.active = false;
			    bruh3.visible = false;
				sprites.add(bruh3);
			    add(bruh3);

			    bruh4 = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass'));
			    bruh4.setGraphicSize(Std.int(bruh4.width * 1.2));
			    bruh4.updateHitbox();
			    bruh4.antialiasing = true;
			    bruh4.scrollFactor.set(0.9, 0.9);
			    bruh4.active = false;
			    bruh4.visible = false;
				sprites.add(bruh4);
			    add(bruh4);
			case 'bonus-song' | 'glitch' | 'secret':
				defaultCamZoom = 0.9;
				curStage = 'daveHouse_night';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.75, 0.75);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = true;
				stageHills.scrollFactor.set(0.8, 0.8);
				stageHills.active = false;

				sprites.add(stageHills);
				add(stageHills);
	
				var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = true;
				gate.scrollFactor.set(0.9, 0.9);
				gate.active = false;

				sprites.add(gate);
				add(gate);
	
				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);

				UsingNewCam = true;
			case 'polygonized' | 'furiosity' | 'cheating' | 'unfairness' | 'cheating-high-pitched' | 'unfairness-high-pitched' | 'torture' | 'disruption' | 'very-screwed':
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky'));
				bg.active = true;
				var bg2:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky'));
				bg2.active = true;
				bg2.visible = false;
	
				switch (SONG.song.toLowerCase())
				{
					case 'cheating' | 'cheating-high-pitched':
						bg.loadGraphic(Paths.image('dave/cheater'));
						curStage = 'unfairness';
					case 'unfairness' | 'unfairness-high-pitched':
						bg.loadGraphic(Paths.image('dave/scarybg'));
						defaultCamZoom = 0.9;
						curStage = 'cheating';
					case 'torture':
						bg.loadGraphic(Paths.image('dave/scary too much'));
						defaultCamZoom = 0.7;
						curStage = 'cheating';
					case 'disruption':
						gfSpeed = 2;
						bg.loadGraphic(Paths.image('dave/disruptor'));
						curStage = 'disrupt';
					case 'very-screwed':
						bg.loadGraphic(Paths.image('dave/farmland'));
						defaultCamZoom = 0.9;
						curStage = 'FUCKYOU';
						
					default:
						bg.loadGraphic(Paths.image('dave/redsky'));
						curStage = 'daveEvilHouse';
				}
				
				sprites.add(bg);
				add(bg);
				
				if (SONG.song.toLowerCase() == 'disruption')
				{
				poop = new StupidDumbSprite(-100, -100, 'lol');
								poop.makeGraphic(Std.int(1280 * 1.4), Std.int(720 * 1.4), FlxColor.BLACK);
								poop.scrollFactor.set(0, 0);
								sprites.add(poop);
								add(poop);
				}
				// below code assumes shaders are always enabled which is FART!!
				// i wouldnt consider this an eyesore though
				if (SONG.song.toLowerCase() != "torture")
				{
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				}
				if (SONG.song.toLowerCase() != "torture") curbg = bg;
				curbg2 = bg2;
				if (SONG.song.toLowerCase() == 'furiosity' || SONG.song.toLowerCase() == 'unfairness')
				{
					UsingNewCam = true;
				}
			case 'hellbreaker':
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bambi/hellBg'));
				bg.active = true;
				sprites.add(bg);
				add(bg);
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			case 'opposition':
			    curStage = 'shit';
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bambi/OPPOSITION files/bg'));
				bg.active = true;
				sprites.add(bg);
				add(bg);
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			case 'thearchy':
			    curStage = 'ono';
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bambi/bruh'));
				bg.active = true;
				sprites.add(bg);
				add(bg);
			case 'phonophobia':
			    curStage = 'w';
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bambi/white'));
				bg.active = true;
				sprites.add(bg);
				add(bg);
			case 'scopomania':
				gfSpeed = 5;
			    curStage = 'black';
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bambi/EYEbg'));
				bg.active = true;
				sprites.add(bg);
				add(bg);
			case 'green':
				gfSpeed = 5;
			    curStage = 'black';
				defaultCamZoom = 0.6;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bambi/OPPOSITION files/theFunny3'));
				bg.active = true;
				sprites.add(bg);
				add(bg);			
			case 'applecore':
				defaultCamZoom = 0.5;
				curStage = 'POOP';
				swagger = new Character(-300, 100 - 900 - 400, 'bambi-piss-3d');
				altSong = Song.loadFromJson('alt-notes', 'applecore');

				scaryBG = new FlxSprite(-350, -375).loadGraphic(Paths.image('bandu/yeah'));
				scaryBG.scale.set(2, 2);
				var testshader3:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader3.waveAmplitude = 0.25;
				testshader3.waveFrequency = 10;
				testshader3.waveSpeed = 3;
				scaryBG.shader = testshader3.shader;
				scaryBG.alpha = 0.65;
				sprites.add(scaryBG);
				add(scaryBG);
				scaryBG.active = false;

				swagBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('bandu/hi'));
				//swagBG.scrollFactor.set(0, 0);
				swagBG.scale.set(1.75, 1.75);
				//swagBG.updateHitbox();
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 1;
				testshader.waveSpeed = 2;
				swagBG.shader = testshader.shader;
				sprites.add(swagBG);
				add(swagBG);
				curbg = swagBG;

				unswagBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('bandu/poop'));
				unswagBG.scale.set(1.75, 1.75);
				var testshader2:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader2.waveAmplitude = 0.1;
				testshader2.waveFrequency = 5;
				testshader2.waveSpeed = 2;
				unswagBG.shader = testshader2.shader;
				sprites.add(unswagBG);
				add(unswagBG);
				unswagBG.active = unswagBG.visible = false;

				littleIdiot = new Character(200, -175, 'unfair-junker');
				add(littleIdiot);
				littleIdiot.visible = false;
				poipInMahPahntsIsGud = false;

				whatthe = new FlxTypedGroup<FlxSprite>();
				add(whatthe);

				for (i in 0...2) {
					var pizza = new FlxSprite(FlxG.random.int(100, 1000), FlxG.random.int(100, 500));
					pizza.frames = Paths.getSparrowAtlas('bandu/pizza');
					pizza.animation.addByPrefix('idle', 'p', 12, true); // https://m.gjcdn.net/game-thumbnail/500/652229-crop175_110_1130_647-stnkjdtv-v4.jpg
					pizza.animation.play('idle');
					pizza.ID = i;
					pizza.visible = false;
					pizza.antialiasing = false;
					wow2.push([pizza.x, pizza.y, FlxG.random.int(400, 1200), FlxG.random.int(500, 700), i]);
					gasw2.push(FlxG.random.int(800, 1200));
					whatthe.add(pizza);
				}
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				sprites.add(stageCurtains);
				add(stageCurtains);

		}
		return sprites;

		
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		var startSpeed:Float = 1;

		if (SONG.song.toLowerCase() == 'disruption') {
			startSpeed = 0.5; // WHATN THE JUNK!!!
		}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;	

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle', true);

			if (dad.curCharacter == 'bandu') {
				// SO THEIR ANIMATIONS DONT START OFF-SYNCED
				dad.playAnim('singUP');
				dadmirror.playAnim('singUP');
				dad.dance();
				dadmirror.dance();
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 4:
			}
			trace(swagCounter);
			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;
		
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		vocals.play();
		if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode && storyWeek != 10)
		{
			FlxG.sound.music.volume = 0;
		}
		if (SONG.song.toLowerCase() == 'disruption') FlxG.sound.music.volume = 1; // WEIRD BUG!!! WTF!!!

		songLength = FlxG.sound.music.length;

		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeName, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
	}

	var debugNum:Int = 0;
	var isFunnySong = false;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
		    var mn:Int = keyAmmo[mania];
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % mn);
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;
				if (curSong == 'Supernovae')
				{
				gottaHitNote = !gottaHitNote;
				}

				if (songNotes[1] >= mn && curSong != 'Supernovae')
				{
					gottaHitNote = !section.mustHitSection;
				}
				if (songNotes[1] >= mn && curSong == 'Supernovae')
				{
					gottaHitNote = section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
				//notes.add(swagNote); //srry a lot of lag

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
					notes.add(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}

			}
			daBeats += 1;
		}

		if (altSong != null) {
			altNotes = new FlxTypedGroup<Note>();
			isFunnySong = true;
			daBeats = 0;
			for (section in altSong.notes) {
				for (noteJunk in section.sectionNotes) {
					var swagNote:Note = new Note(noteJunk[0], Std.int(noteJunk[1] % keyAmmo[mania]), null, false, false, noteJunk[3]); //junk 5
					swagNote.isAlt = true;

					altUnspawnNotes.push(swagNote);
					altNotes.add(swagNote);

					swagNote.mustPress = false;
					swagNote.x -= 250;
				}
			}
			altUnspawnNotes.sort(sortByShit);
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	/*function top10momentsthatminusclubwasfunnyasfuck(joe:Note):Void //minusclub write this
	{
		return; //basically nothing :blush:
	}*/

	var arrowJunks:Array<Array<Float>> = []; //junk 6

	private function generateStaticArrows(player:Int):Void
	{   
		for (i in 0...keyAmmo[mania])
		{
			// FlxG.log.add(i);
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, i);

			if (elpepe.contains(dad.curCharacter) && player == 0 || dad.curCharacter == 'scopomania' && player == 0 || elpepe.contains(boyfriend.curCharacter) && player == 1)
			{
					switch (dad.curCharacter)
					{
						case 'bambi-angey': //idc
							babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_JUNK');
						default:
							babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_3D');
					}
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

					var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					var pPre:Array<String> = ['left', 'down', 'up', 'right'];
					switch (mania)
					{
						case 1:
							nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
							pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
						case 2:
							nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
							pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
							babyArrow.x -= 30;
					}
					babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
					babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);		
			}
			else
			{
				switch (curStage)
				{
					default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

					var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					var pPre:Array<String> = ['left', 'down', 'up', 'right'];
					switch (mania)
					{
						case 1:
							nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
							pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
						case 2:
							nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
							pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
							babyArrow.x -= 30;
					}
					babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
					babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
				}
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			//canMove = true;

			if (isFunnySong || SONG.song.toLowerCase() == 'disruption')
			arrowJunks.push([babyArrow.x, babyArrow.y]); //junk 7

			//babyArrow.resetTrueCoords();
	
		}
		if (SONG.song.toLowerCase() == 'applecore') {
			swagThings = new FlxTypedGroup<StrumNote>();

			for (i in 0...keyAmmo[mania])
			{
				// FlxG.log.add(i);
				var babyArrow:StrumNote = new StrumNote(0, altStrumLine.y, i);

				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_3D');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

				var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				var pPre:Array<String> = ['left', 'down', 'up', 'right'];
				switch (mania)
				{
					case 1:
						nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
						pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
					case 2:
						nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
						pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
						babyArrow.x -= 30;
				}
				babyArrow.x += Note.swagWidth * i;
				babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
				babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
				babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);		

				babyArrow.updateHitbox();

				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				babyArrow.y -= 1000;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

				babyArrow.ID = i;

				poopStrums.add(babyArrow);

				babyArrow.playAnim('static');
				babyArrow.x += 50;
				babyArrow.x -= 250;

				arrowJunks.push([babyArrow.x, babyArrow.y + 1000]); //junk 8
				var hi = new StrumNote(0, babyArrow.y, i);
				//hi.ID = i;
				swagThings.add(hi);
			}

			add(poopStrums);
			/*poopStrums.forEach(function(spr:StrumNote){
				spr.alpha = 0;
			});*/

			add(altNotes);
		}
	}

	private var swagThings:FlxTypedGroup<StrumNote>;

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") |",
				"Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			if (startTimer.finished)
				{
					#if desktop
					DiscordClient.changePresence(detailsText
						+ " "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC, true,
						FlxG.sound.music.length
						- Conductor.songPosition);
					#end
				}
				else
				{
					#if desktop
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
					#end
				}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
	private var nomorespin:Bool = false;
	private var banduJunk:Float = 0; //junk 9
	private var dadFront:Bool = false;
	private var hasJunked:Bool = false; //junk 10
	private var wtfThing:Bool = false;
	private var orbit:Bool = true;
	private var poipInMahPahntsIsGud:Bool = true;
	private var unfairPart:Bool = false;
	private var noteJunksPlayer:Array<Float> = [0, 0, 0, 0]; //junk 11
	private var noteJunksDad:Array<Float> = [0, 0, 0, 0]; //junk 12
	private var whatthe:FlxTypedGroup<FlxSprite>;
	private var wow2:Array<Array<Float>> = [];
	private var gasw2:Array<Float> = [];
	private var poiping:Bool = true;
	private var canPoip:Bool = true;
	private var lanceyLovesWow2:Array<Bool> = [false, false];
	private var whatDidRubyJustSay:Int = 0;

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		banduJunk += elapsed * 2.5;
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				if (SONG.song.toLowerCase() == 'hellbreaker') shad.uTime.value[0] += elapsed * FlxG.random.float(0.1, 3);
				if (SONG.song.toLowerCase() != 'hellbreaker') shad.uTime.value[0] += elapsed;
			}
		}
		if (dad.animation.finished && dad.curCharacter == 'bambi-helium' && dad.holdTimer <= 0 || dad.animation.finished && dad.curCharacter == 'hell') dad.dance();
		//if (SONG.song.toLowerCase() == 'unfairness' && health > 0.5 || SONG.song.toLowerCase() == 'unfairness-high-pitched' && health > 0.5) health -= 0.004;
		if (botplay) accuracyString = "funny botplay mode";
		playerStrums.forEach(function(spr:StrumNote)
				{
					/*if (spr.animation.curAnim.name == 'confirm')
			        {
				        spr.centerOffsets();
				        spr.offset.x -= 13;
				        spr.offset.y -= 13;
			       }
			       else
				        spr.centerOffsets();*/
				});
		if (SONG.song.toLowerCase() == 'applecore') {

			if (poiping) {
				whatthe.forEach(function(spr:FlxSprite){
					spr.x += Math.abs(Math.sin(elapsed)) * gasw2[spr.ID];
					if (spr.x > 3000 && !lanceyLovesWow2[spr.ID]) {
						lanceyLovesWow2[spr.ID] = true;
						trace('whattttt ${spr.ID}');
						whatDidRubyJustSay++;
					}
				});
				if (whatDidRubyJustSay >= 2) poiping = false;
			}
			else if (canPoip) {
				trace("ON TO THE POIPIGN!!!");
				canPoip = false;
				lanceyLovesWow2 = [false, false];
				whatDidRubyJustSay = 0;
				new FlxTimer().start(FlxG.random.float(3, 6.3), function(tmr:FlxTimer){
					whatthe.forEach(function(spr:FlxSprite){
						spr.visible = true;
						spr.x = FlxG.random.int(-2000, -3000);
						gasw2[spr.ID] = FlxG.random.int(600, 1200);
						if (spr.ID == 1) {
							trace("POIPING...");
							poiping = true;
							canPoip = true;
						}
					});
				});
			}

			whatthe.forEach(function(spr:FlxSprite){
				var daCoords = wow2[spr.ID];

				daCoords[4] == 1 ? 
				spr.y = Math.cos(elapsedtime + spr.ID) * daCoords[3] + daCoords[1]: 
				spr.y = Math.sin(elapsedtime) * daCoords[3] + daCoords[1];

				spr.y += 45;

				var dontLookAtAmongUs:Float = Math.sin(elapsedtime * 1.5) * 0.05 + 0.95;

				spr.scale.set(dontLookAtAmongUs - 0.15, dontLookAtAmongUs - 0.15);

				if (dad.POOP) spr.angle += (Math.sin(elapsed * 2) * 0.5 + 0.5) * spr.ID == 1 ? 0.65 : -0.65;
			});

			playerStrums.forEach(function(spr:StrumNote){
				noteJunksPlayer[spr.ID] = spr.y; //junk 13
			});
			dadStrums.forEach(function(spr:StrumNote){
				noteJunksDad[spr.ID] = spr.y; //14, i am not going to fucking count more.
			});
			if (unfairPart) {
				var num:Float = 1;
				if (mania == 1) num = 1.5;
				if (mania == 2) num = 2.25;
				playerStrums.forEach(function(spr:StrumNote)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID)) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
				});
				dadStrums.forEach(function(spr:StrumNote)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
				});
			}
			if (SONG.notes[Math.floor(curStep / 16)] != null) {
				if (SONG.notes[Math.floor(curStep / 16)].altAnim && !unfairPart) {
					var krunkThing = 60;
					if (mania == 1) krunkThing = 50;
					if (mania == 2) krunkThing = 40;
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = arrowJunks[spr.ID + keyAmmo[mania] * 2][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID + keyAmmo[mania] * 2][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
	
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / keyAmmo[mania];
	
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
			
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});

					poopStrums.forEach(function(spr:StrumNote)
					{
						spr.x = arrowJunks[spr.ID + keyAmmo[mania]][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = swagThings.members[spr.ID].y + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
	
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / keyAmmo[mania];
	
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
			
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});

					notes.forEachAlive(function(spr:Note){
							//spr.x = arrowJunks[spr.noteData + keyAmmo[mania] * 2][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;

							if (!spr.isSustainNote && spr.mustPress) {
		
								spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / keyAmmo[mania];

								spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
						
								spr.scale.x += 0.2;
								spr.scale.y += 0.2;
			
								spr.scale.x *= 1.5;
								spr.scale.y *= 1.5;
							}
					});
					altNotes.forEachAlive(function(spr:Note){
						spr.x = arrowJunks[(spr.noteData % keyAmmo[mania]) + keyAmmo[mania]][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
						#if debug
						if (FlxG.keys.justPressed.SPACE) {
							trace(arrowJunks[(spr.noteData % keyAmmo[mania]) + keyAmmo[mania]][0]);
							trace(spr.noteData);
							trace(spr.x == arrowJunks[(spr.noteData % keyAmmo[mania]) + keyAmmo[mania]][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing);
						}
						#end

						if (!spr.isSustainNote) {
		
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / keyAmmo[mania];

							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
					
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
			
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
						}
					});
				}
			}

			
		}

		

		//welcome to 3d sinning avenue
		if(funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat || funnyFloatyBoys2.contains(dad.curCharacter.toLowerCase()) && canFloat || SONG.song.startsWith('Cheating'))
		{
			dad.y += (Math.sin(elapsedtime) * 0.6);
		}
		if(SONG.song.startsWith('Hell'))
		{
			boyfriend.y -= (Math.sin(elapsedtime * 0.25) * 0.6);
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.6);
		}
		



		if (funnyFloatyAppleCore.contains(dad.curCharacter.toLowerCase()) && canFloat && orbit)
		{
			switch(dad.curCharacter) {
				case 'bandu':
					dad.x = boyfriend.getMidpoint().x + Math.sin(banduJunk) * 500 - (dad.width / 2);
					dad.y += (Math.sin(elapsedtime) * 0.2);
					dadmirror.setPosition(dad.x, dad.y);

					/*
					var deezScale =	(
						!dadFront ?
						Math.sqrt(
					boyfriend.getMidpoint().distanceTo(dad.getMidpoint()) / 500 * 0.5):
					Math.sqrt(
					(500 - boyfriend.getMidpoint().distanceTo(dad.getMidpoint())) / 500 * 0.5 + 0.5));
					dad.scale.set(deezScale, deezScale);
					dadmirror.scale.set(deezScale, deezScale);
					*/

					if ((Math.sin(banduJunk) >= 0.95 || Math.sin(banduJunk) <= -0.95) && !hasJunked){
						dadFront = !dadFront;
						hasJunked = true;
					}
					if (hasJunked && !(Math.sin(banduJunk) >= 0.95 || Math.sin(banduJunk) <= -0.95)) hasJunked = false;

					dadmirror.visible = dadFront;
					dad.visible = !dadFront;
				default:
					dad.y += (Math.sin(elapsedtime) * 0.6);
			}
		}
		if (funnyFloatyAppleCore.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.6);
		}
		if (funnyFloatyAppleCore.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.6);
		}

		if (littleIdiot != null)
		{
			if (funnyFloatyAppleCore.contains(littleIdiot.curCharacter.toLowerCase()) && canFloat && poipInMahPahntsIsGud)
			{
				littleIdiot.y += (Math.sin(elapsedtime) * 0.75);
				littleIdiot.x = 200 + Math.sin(elapsedtime) * 425;
			}
		}
		if (swagger != null)
		{
			if (funnyFloatyAppleCore.contains(swagger.curCharacter.toLowerCase()) && canFloat)
			{
				swagger.y += (Math.sin(elapsedtime) * 0.6);
			}
		}
		if(funnyFloatyAppleCore.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.6);
		}
		/*if(funnyFloatyAppleCore.contains(dadmirror.curCharacter.toLowerCase()))
		{
			dadmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/
		if(funnyFloatyAppleCore.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.6);
		}

		if (SONG.song.toLowerCase() == 'cheating' || SONG.song.toLowerCase() == 'cheating-high-pitched') // fuck you
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				/*spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;*/
				spr.angle += 40;
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				/*spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;*/
				spr.angle -= 40;
			});
			for(note in notes)
			{
				if(note.mustPress)
				{
					if (!note.isSustainNote)
						note.angle = playerStrums.members[note.noteData].angle;
				}
				else
				{
					if (!note.isSustainNote)
						note.angle = dadStrums.members[note.noteData].angle;
				}
			}
		}

		if (SONG.song.toLowerCase() == 'house')
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{

			});
			dadStrums.forEach(function(spr:FlxSprite)
			{

			});
		}
		if (SONG.song.toLowerCase() == 'disruption')poop.alpha = Math.sin(elapsedtime) / 2.5 + 0.4;
		if (SONG.song.toLowerCase() == 'disruption') // deez all day
		{
			var krunkThing = 60;
			if (mania == 1) krunkThing = 50;
			if (mania == 2) krunkThing = 47;
			if (mania == 3) krunkThing = 40;

			//oop.alpha = Math.sin(elapsedtime) / 2.5 + 0.4;

			playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = arrowJunks[spr.ID + keyAmmo[mania]][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
					spr.y = arrowJunks[spr.ID + keyAmmo[mania]][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
	
					spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / keyAmmo[mania];
	
					spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
	
					spr.scale.x += 0.2;
					spr.scale.y += 0.2;
	
					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				});
			dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
					spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
					
					spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / keyAmmo[mania];
	
					spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
	
					spr.scale.x += 0.2;
					spr.scale.y += 0.2;
	
					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				});
	
			notes.forEachAlive(function(spr:Note){
					if (spr.mustPress) {
						spr.x = arrowJunks[spr.noteData + keyAmmo[mania]][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.noteData + keyAmmo[mania]][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / keyAmmo[mania];
	
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					}
				else {
						spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;
	
						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / keyAmmo[mania];
	
						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / (keyAmmo[mania] / 2));
	
						spr.scale.x += 0.2;
						spr.scale.y += 0.2;
	
						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					}
				});
		}

		/*if (SONG.song.toLowerCase() == 'hellbreaker')
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
			    if (spr.ID == 0) spr.x += Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
				if (spr.ID == 0) spr.x -= Math.sin(elapsedtime * 0.5) * 1.5;
				if (spr.ID == 0) spr.angle += 0.5 * (0.5 * 4);//to stop the left arrow from staying still

				if (spr.ID == 3) spr.x -= Math.sin(elapsedtime * 3) * (spr.ID == 3 ? 1 : 1.5);// nice spin bro

				if (spr.ID != 0) spr.x += Math.sin(elapsedtime * spr.ID) * ((spr.ID % 2) == 0 ? 1 : -1);
				if (spr.ID != 0 && spr.ID != 3) spr.x -= Math.sin(elapsedtime * 3) * (spr.ID == 1 ? 2 : 1.2);
				if (spr.ID != 0) spr.angle += 0.5 * (spr.ID * 4);
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == 0) spr.x -= Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
				if (spr.ID == 0) spr.x += Math.sin(elapsedtime * 0.5) * 1.5;
				if (spr.ID == 0) spr.angle += 0.5 * (0.5 * 4);//to stop the left arrow from staying still

				if (spr.ID == 3) spr.x += Math.sin(elapsedtime * 3) * (spr.ID == 3 ? 1 : 1.5);// nice spin bro

				if (spr.ID != 0) spr.x -= Math.sin(elapsedtime * spr.ID) * ((spr.ID % 2) == 0 ? 1 : -1);
				if (spr.ID != 0 && spr.ID != 3) spr.x += Math.sin(elapsedtime * 3) * (spr.ID == 1 ? 2 : 1.2);
				if (spr.ID == 3) spr.x += Math.sin(elapsedtime * 3) * (spr.ID == 3 ? 1 : 1.5);
				if (spr.ID != 0) spr.angle += 0.5 * (spr.ID * 4);
			});
		}*/

		if (SONG.song.toLowerCase() == 'opposition') // no
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime * 4 + (spr.ID)) * FlxG.random.int(500, 520));
					spr.x += 500;
					spr.y -= -Math.sin(elapsedtime * 2) * 1.6;
					if (!swag)
					{
					swag = true;
					spr.y -= 400;
					}
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime * 4 + (spr.ID )) * 2) * FlxG.random.int(500, 520));
					spr.x += 500;
					spr.y -= -Math.sin(elapsedtime * 2) * 1.6;
					if (!swag2)
					{
					swag2 = true;
					spr.y -= 400;
					}
				});
			}
		if (SONG.song.toLowerCase() == 'thearchy') // no
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime * 4 + (spr.ID)) * FlxG.random.int(500, 520));
					spr.x += 500;
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime * 4 + (spr.ID )) * 2) * FlxG.random.int(500, 520));
					spr.x += 500;
				});
			}

		if (SONG.song.toLowerCase() == 'phonophobia' && curBeat > 10) // no
			{
				dadStrums.forEach(function(spr:FlxSprite)
				{
					if (!swag) spr.y += 1;
					if (!swag) strumLine.y += 1;
					if (spr.y < 50)
					{
					swag2 = true;
					swag = false;
					}
					if (!swag2) spr.y -= 1;
					if (!swag2) strumLine.y -= 1;// most of the code is here because it measures height whereas playerstrums just detects a variable and changes the y lol
					if (spr.y > FlxG.height - 50)
					{
					swag = true;
					swag2 = false;
					}
				});
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (!swag) spr.y += 1;
					if (!swag2) spr.y -= 1;
				});
			}

		if (SONG.song.toLowerCase() == 'unfairness' || SONG.song.toLowerCase() == 'unfairness-high-pitched') // fuck you
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID)) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
				});
			}

		if (SONG.song.toLowerCase() == 'torture') // fuck you
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID * 1.5)) * 150);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID * 1.5)) * 150);
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime * 2) + (spr.ID * 1.5)) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime * 2) + (spr.ID * 1.5)) * 300);
				});
			}
		
		if (SONG.song.toLowerCase() == 'very-screwed')
        {
            playerStrums.forEach(function(spr:FlxSprite)
                {
                    switch (spr.ID)
                    {
                        case 0:
                            spr.x -= Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x += Math.sin(elapsedtime * 0.5) * 0.1;
                        case 1:
                            spr.x += Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x -= Math.sin(elapsedtime * 0.5) * 0.1;
                        case 2:
                            spr.x -= Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x += Math.sin(elapsedtime * 0.5) * 0.1;
                        case 3:
                            spr.x += Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x -= Math.sin(elapsedtime * 0.5) * 0.1;
                    }
                });
            dadStrums.forEach(function(spr:FlxSprite)
                {
                    spr.alpha = 0.5;
                    switch (spr.ID)
                    {
                        case 0:
                            spr.x += Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x -= Math.sin(elapsedtime * 0.5) * 0.1;
                        case 1:
                            spr.x -= Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x += Math.sin(elapsedtime * 0.5) * 0.1;
                        case 2:
                            spr.x += Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x -= Math.sin(elapsedtime * 0.5) * 0.1;
                        case 3:
                            spr.x -= Math.sin(elapsedtime * 0.5) * ((spr.ID % 2) == 0 ? 1 : -1);
                            spr.x += Math.sin(elapsedtime * 0.5) * 0.1;
                    }
                });
			for (funneNote in notes)
			   {
			       if (!funneNote.mustPress)
			       {
			           funneNote.alpha = 0.5;
			       }
			   }
		}
			
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.015, 0.015);
		}
		screenshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == boyfriendOldIcon)
			{
				var isBF:Bool = formoverride == 'bf' || formoverride == 'none';
				iconP1.animation.play(isBF ? SONG.player1 : formoverride);
			}
			else
			{
				iconP1.animation.play(boyfriendOldIcon);
			}
		}

		super.update(elapsed);

		if (FlxG.save.data.accuracyDisplay)
		{
		    if (!botplay) accuracyString = truncateFloat(accuracy, 2) + "%";
			scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + accuracyString + " | Combo:" + barCombo;
		}
		else
		{
			scoreTxt.text = "";
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			switch (curSong.toLowerCase())
			{
				
				case 'unfairness':
					/*FlxG.switchState(new YouCheatedSomeoneIsComing());
					FlxG.save.data.phonoFound = true;*/
					PlayState.SONG = Song.loadFromJson("opposition", "opposition");
				    FlxG.switchState(new PlayState());

				case 'opposition':
					PlayState.SONG = Song.loadFromJson("phonophobia", "phonophobia");
				    FlxG.switchState(new PlayState());

				case 'phonophobia':
					PlayState.SONG = Song.loadFromJson("hellbreaker", "hellbreaker");
				    FlxG.switchState(new PlayState());

				case 'hellbreaker':
					PlayState.SONG = Song.loadFromJson("thearchy", "thearchy");
				    FlxG.switchState(new PlayState());

                case 'thearchy':
					PlayState.SONG = Song.loadFromJson("scopomania", "scopomania");
				    FlxG.switchState(new PlayState());

				case 'scopomania':
					PlayState.SONG = Song.loadFromJson("green", "green");
				    FlxG.switchState(new PlayState());

				default:
					// FIXES THE GAME FREEZING WHEN PRESSING 7 AND DYING AT THE SAME TIME
					persistentUpdate = false;
					paused = true;
					//

					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}
		if (FlxG.keys.justPressed.NINE)
		{
			switch (curSong.toLowerCase())
			{
				case 'scopomania':
					PlayState.SONG = Song.loadFromJson("green-insane", "green");
				    FlxG.switchState(new PlayState());

				default:
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}


		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)),Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2 && !hypertone.contains(cheese))
			health = 2;

		if (health > 3 && hypertone.contains(cheese))
			health = 3;

		if (healthBar.percent < 25)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 75)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.TWO)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}

			if(updateTime) 
				{
					var curTime:Float = Conductor.songPosition;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;
					
					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}

		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong.toLowerCase() == 'furiosity')
		{
			switch (curBeat)
			{
				case 127:
					camZooming = true;
				case 159:
					camZooming = false;
				case 191:
					camZooming = true;
				case 223:
					camZooming = false;
			}
		}

		if (health <= 0)
		{
			if(!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			if(shakeCam)
			{
				FlxG.save.data.unlockedcharacters[7] = true;
			}

			if (!shakeCam)
			{
				if(!perfectMode)
				{
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
						.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

						#if desktop
						DiscordClient.changePresence("GAME OVER -- "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC);
						#end
				}
			}
			else
			{
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if(!perfectMode)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
							.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

							#if desktop
							DiscordClient.changePresence("GAME OVER -- "
							+ SONG.song
							+ " ("
							+ storyDifficultyText
							+ ") ",
							"\nAcc: "
							+ truncateFloat(accuracy, 2)
							+ "% | Score: "
							+ songScore
							+ " | Misses: "
							+ misses, iconRPC);
							#end
					}
				}
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
		unspawnThing = false;
		if (unspawnNotes[0] != null)
		{
			/*if (unspawnNotes[0].strumTime - Conductor.songPosition < 150000)
			{*/
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
				unspawnThing = true;
			//}
			if (unspawnNotes[1] != null && unspawnThing)
		    {
			    var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
				unspawnThing2 = true;
		    }
			if (unspawnNotes[2] != null && unspawnThing2)
		    {
			    var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
		    }
			if (unspawnNotes[3] != null && unspawnThing2)
		    {
			    var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
		    }
		}
		altUnspawnThing = false;
		if (altUnspawnNotes[0] != null)
		{
			/*if (altUnspawnNotes[0].strumTime - Conductor.songPosition < (SONG.song.toLowerCase() == 'unfairness' ? 15000 : 1500))
			{*/
				var dunceNote:Note = altUnspawnNotes[0];
				altNotes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = altUnspawnNotes.indexOf(dunceNote);
				altUnspawnNotes.splice(index, 1);
				altUnspawnThing = true;
			//}
			if (altUnspawnNotes[1] != null && altUnspawnThing)
		    {
			    var dunceNote:Note = altUnspawnNotes[0];
				altNotes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = altUnspawnNotes.indexOf(dunceNote);
				altUnspawnNotes.splice(index, 1);
				altUnspawnThing2 = true;
		    }
			if (altUnspawnNotes[2] != null && altUnspawnThing2)
		    {
			    var dunceNote:Note = altUnspawnNotes[0];
				altNotes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = altUnspawnNotes.indexOf(dunceNote);
				altUnspawnNotes.splice(index, 1);		
		    }
			if (altUnspawnNotes[3] != null && altUnspawnThing2)
		    {
			    var dunceNote:Note = altUnspawnNotes[0];
				altNotes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = altUnspawnNotes.indexOf(dunceNote);
				altUnspawnNotes.splice(index, 1);
		    }
		}
		if (generatedMusic && !totalBot)
		{
			if (isFunnySong) {
				altNotes.forEachAlive(function(daNote:Note)
				{
					if (daNote.y > FlxG.height * 2)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					if (daNote.MyStrum != null)
						{
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						}
					else{
					daNote.y = (altStrumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal((SONG.speed + 1) * 1, 2)));
					}
					if (daNote.wasGoodHit)
					{
						swagger.playAnim('sing' + notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]], true);
						swagger.holdTimer = 0;
						
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);

						health -=  0.013 / 2.65;

						var time:Float = 0.15;
						if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
							time += 0.15;
						}
						poopStrums.forEach(function(sprite:StrumNote)
						{
							if (Math.abs(Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]) == sprite.ID)
							{
								sprite.playAnim('confirm', true);
								sprite.resetAnim = time;
								/*if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									sprite.centerOffsets();
									sprite.offset.x -= 13;
									sprite.offset.y -= 13;
								}
								else
								{
									sprite.centerOffsets();
								}
								sprite.animation.finishCallback = function(name:String)
								{
									sprite.animation.play('static',true);
									sprite.centerOffsets();
								}*/	
							}
						});

						if (SONG.needsVoices)
							vocals.volume = 1;

						daNote.kill();
						altNotes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			notes.forEach(function(daNote:Note)
			{
			if (SONG.notes[Math.floor(curStep / 16)] != null && !SONG.notes[Math.floor(curStep / 16)].altAnim && SONG.song.toLowerCase() != "disruption" && !daNote.isSustainNote)
			{
			daNote.scale.set(Note.scales[mania], Note.scales[mania]);
			}
				if (daNote.y > FlxG.height)
				{
					daNote.visible = false;
					daNote.active = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
				if (daNote.coolBot)
				{
				goodNoteHit(daNote);
				} 
				if (!daNote.mustPress && daNote.wasGoodHit && daNote.noteType != 1)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.01;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							if (SONG.song.toLowerCase() == "cheating" || SONG.song.toLowerCase() == 'unfairness')
							{
								healthtolower = 0.005;
							}
							else if (SONG.song.toLowerCase() == "cheating-high-pitched")
							{
								healthtolower = 0.005;
							}
							else
							{
							    altAnim = '-alt';
							}
					}

					//'LEFT', 'DOWN', 'UP', 'RIGHT'
					var fuckingDumbassBullshitFuckYou:String;
					fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]];
					if(dad.nativelyPlayable)
					{
						switch(notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					if(dad.curCharacter == 'bambi-unfair' || dad.curCharacter == 'bambi-3d'  || dad.curCharacter == 'bambi-helium' || SONG.song.toLowerCase() == 'cheating' || dad.curCharacter == 'bambi-piss-3d')
					{
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);
					}
					(SONG.song.toLowerCase() == 'applecore' && !SONG.notes[Math.floor(curStep / 16)].altAnim && !wtfThing && dad.POOP) ? { // hi
						if (littleIdiot != null) littleIdiot.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true); 
						littleIdiot.holdTimer = 0;}: {
							dad.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
							dadmirror.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
							dad.holdTimer = 0;
							dadmirror.holdTimer = 0;
						}

					var time:Float = 0.15;
					if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
					}
					StrumPlayAnim(true, Std.int(Math.abs(daNote.noteData)) % keyAmmo[mania], time);
						/*dadStrums.forEach(function(sprite:StrumNote)
							{
								if (Math.abs(daNote.noteData) == sprite.ID && lol == true)
								{
									sprite.playAnim('confirm', true);
									/*if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
										sprite.centerOffsets();
										sprite.offset.x -= 13;
										sprite.offset.y -= 13;
									}
									else
									{
										sprite.centerOffsets();
									}*/
									/*sprite.animation.finishCallback = function(name:String)
									{
										sprite.playAnim('static',true);
										sprite.centerOffsets();
									}
		
								}
							});*/
					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{					
							case 'disruption':
								if (FlxG.save.data.immortal)
									health += 0;
								else
									health -= healthtolower / 2;
							case 'applecore':
								if (FlxG.save.data.immortal)
									health += 0;
								else
									if (unfairPart) health -= (healthtolower / 12);
							case 'cheating' | 'cheating-high-pitched':
								if (FlxG.save.data.immortal)
									health += 0;
								else
									health -= healthtolower;
							case 'hellbreaker':
								if (FlxG.save.data.immortal)
									health += 0;
								else
									if (health > healthtolower) health -= healthtolower;
							case 'unfairness' | 'unfairness-high-pitched' | 'torture':
								if (FlxG.save.data.immortal)
									health += 0;
								else
									health -= (healthtolower / 1.75);
					}
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				switch (SONG.song.toLowerCase())
				{
					case 'applecore':
						if (unfairPart)
						{
						    if (daNote.MyStrum != null)
						    {
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						    }
						    else
							{
							daNote.y = ((daNote.mustPress ? noteJunksPlayer[daNote.noteData] : noteJunksDad[daNote.noteData])- (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(1 * daNote.LocalScrollSpeed, 2))); // couldnt figure out this stupid mystrum thing
						    }
						}
						else
						{
						    if (daNote.MyStrum != null)
						    {
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						    }
						    else
							{
							if (FlxG.save.data.downscroll)
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * 1, 2)));
							else
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * 1, 2)));
						    }
							
						}
					default:
						if (daNote.MyStrum != null)
						{
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						}

					case 'no'://original code lol
						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
				}

				
				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var strumliney = daNote.MyStrum != null ? daNote.MyStrum.y : strumLine.y;

				if (SONG.song.toLowerCase() == 'applecore') {
					if (unfairPart) strumliney = daNote.MyStrum != null ? daNote.MyStrum.y : strumLine.y;
					else strumliney = strumLine.y;
				}

				//if (daNote.tooLate || daNote.y >= strumliney + 106 && FlxG.save.data.downscroll)
				if (((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumliney + 106 && FlxG.save.data.downscroll) && SONG.song.toLowerCase() != 'applecore') 
					|| (SONG.song.toLowerCase() == 'applecore' && unfairPart && daNote.y >= strumliney + 106) 
					|| (SONG.song.toLowerCase() == 'applecore' && !unfairPart && (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumliney + 106 && FlxG.save.data.downscroll)))
				{
				     /*if (botplay == true)
						{
						goodNoteHit(daNote);
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
						}*/
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
						daNote.isAlive = false;
					}
					else
					{
						if(daNote.mustPress && daNote.finishedGenerating && daNote.noteType != 1)
						{
						    if (daNote.noteType == 2)
							{
								if(FlxG.save.data.immortal)
									health += 0;
								else
									health = -1;
							}
							if(FlxG.save.data.immortal)
							{
								health += 0;
							}
							else
							{
								noteMiss(daNote.noteData);
								health -= 0.075;
								vocals.volume = 0;
							}		
						}
						else if(daNote.mustPress && daNote.finishedGenerating)
						{
						daNote.wasGoodHit = true;
						}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		if (generatedMusic && totalBot)//in progress thing to reduce lag when using botplay because hypertone songs laggy lol
		{
		if (!UsingNewCam)
		{
			if (PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					ZoomCam(true);
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(670, 450);
				}
			}
		}
		if (isFunnySong) {
				altNotes.forEachAlive(function(daNote:Note)
				{
					if (daNote.y > FlxG.height * 2)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					if (daNote.MyStrum != null)
						{
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						}
					else{
					daNote.y = (altStrumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal((SONG.speed + 1) * 1, 2)));
					}
					if (daNote.wasGoodHit)
					{
						swagger.playAnim('sing' + notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]], true);
						swagger.holdTimer = 0;
						
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);

						if(FlxG.save.data.immortal)
							health +=  0;
						else
							health -=  0.013 / 2.65;

						var time:Float = 0.15;
						if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
							time += 0.15;
						}
						poopStrums.forEach(function(sprite:StrumNote)
						{
							if (Math.abs(Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]) == sprite.ID)
							{
								sprite.playAnim('confirm', true);
								sprite.resetAnim = time;
								/*if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									sprite.centerOffsets();
									sprite.offset.x -= 13;
									sprite.offset.y -= 13;
								}
								else
								{
									sprite.centerOffsets();
								}
								sprite.animation.finishCallback = function(name:String)
								{
									sprite.playAnimstatic',true);
									sprite.centerOffsets();
								}*/	
							}
						});

						if (SONG.needsVoices)
							vocals.volume = 1;

						daNote.kill();
						altNotes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
		notes.forEach(function(daNote:Note)
			{
			if (SONG.notes[Math.floor(curStep / 16)] != null && !SONG.notes[Math.floor(curStep / 16)].altAnim && SONG.song.toLowerCase() != "disruption" && !daNote.isSustainNote)
			{
			daNote.scale.set(Note.scales[mania], Note.scales[mania] * (daNote.isSustainNote ? 4 : 1));
			}
			if (daNote.y > FlxG.height)
				{
					daNote.active = false;
				}
				else
				{
					daNote.active = true;
				}
				if (daNote.coolBot)
				{
				if (!daNote.isSustainNote)
			    {
			    combo += 1;
				barCombo += 1;
				songScore += 350;
			    }
			else
			{
				totalNotesHit += 1;
			}
				if (daNote.isSustainNote)
				health += 0.004;
			else
				health += 0.025;

				var direction:String;
				direction = notestuffs[daNote.noteData];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[daNote.noteData])
					{
						case 'LEFT':
							direction = 'RIGHT';
						case 'RIGHT':
							direction = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + direction, true);
						playerStrums.forEach(function(sprite:StrumNote)
							{
								if (Math.abs(daNote.noteData) == sprite.ID && lol == true)
								{
									sprite.playAnim('confirm', true);
									sprite.animation.finishCallback = function(name:String)
									{
										sprite.playAnim('static',true);
									}
		
								}
							});
                daNote.wasGoodHit = true;
				notes.remove(daNote, true);
				daNote.destroy();
				} 
				if (!daNote.mustPress && daNote.wasGoodHit && daNote.noteType != 1)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;
					var altAnim:String = "";
					var healthtolower:Float = 0.026;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							    altAnim = '-alt';
					}
					var direction:String;
					direction = notestuffs[daNote.noteData];
					if(dad.nativelyPlayable)
					{
						switch(notestuffs[Math.round(Math.abs(daNote.noteData)) % keyAmmo[mania]])
						{
							case 'LEFT':
								direction = 'RIGHT';
							case 'RIGHT':
								direction = 'LEFT';
						}
					}
					dad.playAnim('sing' + direction + altAnim, true);
					dadmirror.playAnim('sing' + direction + altAnim, true);
					(SONG.song.toLowerCase() == 'applecore' && !SONG.notes[Math.floor(curStep / 16)].altAnim && !wtfThing && dad.POOP) ? { // hi
						if (littleIdiot != null) littleIdiot.playAnim('sing' + direction + altAnim, true); 
						littleIdiot.holdTimer = 0;}: {
							dad.playAnim('sing' + direction + altAnim, true);
							dadmirror.playAnim('sing' + direction + altAnim, true);
							dad.holdTimer = 0;
							dadmirror.holdTimer = 0;
						}
						dadStrums.forEach(function(sprite:StrumNote)
							{
								if (Math.abs(daNote.noteData) == sprite.ID && lol == true)
								{
									sprite.playAnim('confirm', true);
									sprite.animation.finishCallback = function(name:String)
									{
										sprite.playAnim('static',true);
									}
		
								}
							});
					if (health > healthtolower) health -= healthtolower / 2;
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					notes.remove(daNote, true);
					daNote.destroy();
				}
						if (daNote.MyStrum != null)
						{
							if (FlxG.save.data.downscroll)
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
							else
								daNote.y = (daNote.MyStrum.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene && !totalBot)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		#if debug
		if (FlxG.keys.justPressed.TWO)
		{
			BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
			BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
			add(BAMBICUTSCENEICONHURHURHUR);
			BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
			BAMBICUTSCENEICONHURHURHUR.x = -100;
			FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
			new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
		}
		#end
		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			health = fuckThisDumbassVariable.alpha + 0.75;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
			if (BAMBICUTSCENEICONHURHURHUR.y > FlxG.height)
			{
			updatevels = false;
			remove(BAMBICUTSCENEICONHURHURHUR);
			BAMBICUTSCENEICONHURHURHUR = null;
			}
		}
	}

	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.animation.play("bambi", true);
		BAMBICUTSCENEICONHURHURHUR.animation.play(SONG.player2, true, false, 1);
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
	}

	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (focusondad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);


			switch (dad.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					camFollow.y = dad.getMidpoint().y;
				case 'bandu':
					dad.POOP ? {
					!SONG.notes[Math.floor(curStep / 16)].altAnim ? {
					camFollow.setPosition(littleIdiot.getMidpoint().x, littleIdiot.getMidpoint().y - 300);
					defaultCamZoom = 0.35;
					} :
						camFollow.setPosition(swagger.getMidpoint().x + 150, swagger.getMidpoint().y - 100);
				} :
					camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				tweenCamIn();
			}
		}


		if (!focusondad)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			if (SONG.song.toLowerCase() == 'applecore') defaultCamZoom = 0.5;

			switch(boyfriend.curCharacter)
			{
				case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
					camFollow.y = boyfriend.getMidpoint().y;
				case 'bambi-3d' | 'bambi-unfair' | 'bambi-piss-3d':
					camFollow.y = boyfriend.getMidpoint().y - 350;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}

	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{ 
			FlxG.switchState(new FreeplayState());
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		updateTime = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			trace("score is valid");
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
				|| characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		if (curSong.toLowerCase() == 'bonus-song')
		{
			FlxG.save.data.unlockedcharacters[3] = true;
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			var completedSongs:Array<String> = [];
			var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon'];
			var allSongsCompleted:Bool = true;
			if (FlxG.save.data.songsCompleted == null)
			{
				FlxG.save.data.songsCompleted = new Array<String>();
			}
			completedSongs = FlxG.save.data.songsCompleted;
			completedSongs.push(storyPlaylist[0]);
			for (i in 0...mustCompleteSongs.length)
			{
				if (!completedSongs.contains(mustCompleteSongs[i]))
				{
					allSongsCompleted = false;
					break;
				}
			}
			if (allSongsCompleted && !FlxG.save.data.unlockedcharacters[6])
			{
				FlxG.save.data.unlockedcharacters[6] = true;
			}
			FlxG.save.data.songsCompleted = completedSongs;
			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'polygonized':
						FlxG.save.data.tristanProgress = "unlocked";
						if (health >= 0.1)
						{
							FlxG.save.data.unlockedcharacters[2] = true;
							if (storyDifficulty == 3)
							{
								FlxG.save.data.unlockedcharacters[5] = true;
							}
							FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
						}
						else if (health < 0.1)
						{
							FlxG.save.data.unlockedcharacters[4] = true;
							FlxG.switchState(new EndingState('vomit_ending', 'badEnding'));
						}
						else
						{
							FlxG.switchState(new EndingState('badEnding', 'badEnding'));
						}
					case 'maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.switchState(new StoryMenuState());
						};
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new StoryMenuState());
				}
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore,
						storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{	
				switch (SONG.song.toLowerCase())
				{
					case 'insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						schoolIntro(doof, false);
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
						marcello.flipX = true;
						add(marcello);
						marcello.antialiasing = true;
						marcello.color = 0xFF878787;
						dad.visible = false;
						boyfriend.stunned = true;
						marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
						marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
						FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
						boyfriend.playAnim('hit', true);
						STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
						new FlxTimer().start(5.5, THROWPHONEMARCELLO);

					default:
						nextSong();
				}
			}
		}
		else
		{
			if(FlxG.save.data.freeplayCuts)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
						marcello.flipX = true;
						add(marcello);
						marcello.antialiasing = true;
						marcello.color = 0xFF878787;
						dad.visible = false;
						boyfriend.stunned = true;
						marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
						marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
						FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
						boyfriend.playAnim('hit', true);
						STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
						new FlxTimer().start(5.5, THROWPHONEMARCELLO);
					case 'insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						schoolIntro(doof, false);
					case 'maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new FreeplayState());
				}
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
			
		}
	}

	function ughWhyDoesThisHaveToFuckingExist() 
	{
		FlxG.switchState(new FreeplayState());
	}

	var endingSong:Bool = false;

	function nextSong()
	{
		var difficulty:String = "";

		if (storyDifficulty == 0)
			difficulty = '-easy';

		if (storyDifficulty == 2)
			difficulty = '-hard';

		if (storyDifficulty == 3)
			difficulty = '-unnerf';

		trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();
		
		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				LoadingState.loadAndSwitchState(new VideoState('assets/videos/mazeecutscenee.webm', new PlayState()), false);
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	private function popUpScore(strumtime:Float, notedata:Int):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2 && botplay == false)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2 && botplay == false)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45 && botplay == false)
		{
			daRating = 'bad';
			score = -1000;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25 && botplay == false)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}
		switch (notedata)
		{
			case 2:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[2], 0), Int);
			case 3:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[1], 0), Int);
			case 1:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[3], 0), Int);
			case 0:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[0], 0), Int);
		}

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			if(scoreTxtTween != null) 
			{
				scoreTxtTween.cancel();
			}

			scoreTxt.scale.x = 1.1;
			scoreTxt.scale.y = 1.1;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				//if (combo >= 10 || combo == 0) we having the score >:(
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
						tween.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						tween.destroy();
					},
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
					tween.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	    var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		var l1Hold:Bool = false;
		var uHold:Bool = false;
		var r1Hold:Bool = false;
		var l2Hold:Bool = false;
		var dHold:Bool = false;
		var r2Hold:Bool = false;

		var n0Hold:Bool = false;
		var n1Hold:Bool = false;
		var n2Hold:Bool = false;
		var n3Hold:Bool = false;
		var n4Hold:Bool = false;
		var n5Hold:Bool = false;
		var n6Hold:Bool = false;
		var n7Hold:Bool = false;
		var n8Hold:Bool = false;

	private function keyShit():Void
	{
	    var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var l1 = controls.L1;
		var u = controls.U1;
		var r1 = controls.R1;
		var l2 = controls.L2;
		var d = controls.D1;
		var r2 = controls.R2;

		var l1P = controls.L1_P;
		var uP = controls.U1_P;
		var r1P = controls.R1_P;
		var l2P = controls.L2_P;
		var dP = controls.D1_P;
		var r2P = controls.R2_P;

		var l1R = controls.L1_R;
		var uR = controls.U1_R;
		var r1R = controls.R1_R;
		var l2R = controls.L2_R;
		var dR = controls.D1_R;
		var r2R = controls.R2_R;


		var n0 = controls.N0;
		var n1 = controls.N1;
		var n2 = controls.N2;
		var n3 = controls.N3;
		var n4 = controls.N4;
		var n5 = controls.N5;
		var n6 = controls.N6;
		var n7 = controls.N7;
		var n8 = controls.N8;

		var n0P = controls.N0_P;
		var n1P = controls.N1_P;
		var n2P = controls.N2_P;
		var n3P = controls.N3_P;
		var n4P = controls.N4_P;
		var n5P = controls.N5_P;
		var n6P = controls.N6_P;
		var n7P = controls.N7_P;
		var n8P = controls.N8_P;

		var n0R = controls.N0_R;
		var n1R = controls.N1_R;
		var n2R = controls.N2_R;
		var n3R = controls.N3_R;
		var n4R = controls.N4_R;
		var n5R = controls.N5_R;
		var n6R = controls.N6_R;
		var n7R = controls.N7_R;
		var n8R = controls.N8_R;

		var ex1 = false;

		var controlArray:Array<Bool>;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		var ankey = (upP || rightP || downP || leftP);
		if (mania == 1)
		{ 
			ankey = (l1P || uP || r1P || l2P || dP || r2P);
			controlArray = [l1P, uP, r1P, l2P, dP, r2P];
		}
		else if (mania == 2)
		{
			ankey = (n0P || n1P || n2P || n3P || n4P || n5P || n6P || n7P || n8P);
			controlArray = [n0P, n1P, n2P, n3P, n4P, n5P, n6P, n7P, n8P];
		}
		
		// FlxG.watch.addQuick('asdfa', upP);
		if (ankey && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{

					possibleNotes.push(daNote);
				}
			});

			possibleNotes.sort((a, b) -> Std.int(a.noteData - b.noteData)); //sorting twice is necessary as far as i know
			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int {
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode/* || botplay == true*/)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes) 
				{
					if (controlArray[note.noteData % keyAmmo[mania]])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % keyAmmo[mania]) == (lasthitnote % keyAmmo[mania]))
							{
								continue; //the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}
				
				if (daNote.wasGoodHit)
				{
				    if (botplay == false)
					{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
					}
					else
					{
			        daNote.kill();
				    notes.remove(daNote, true);
					daNote.destroy();  
					}
				}
			}
			else if (!theFunne)
			{
				badNoteCheck(null);
			}
		}
		var condition = ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && generatedMusic);
			if (mania == 1)
			{
				condition = ((l1 || u || r1 || l2 || d || r2) && generatedMusic || (l1Hold || uHold || r1Hold || l2Hold || dHold || r2Hold) && generatedMusic);
			}
			else if (mania == 2)
			{
				condition = ((n0 || n1 || n2 || n3 || n4 || n5 || n6 || n7 || n8) && generatedMusic || (n0Hold || n1Hold || n2Hold || n3Hold || n4Hold || n5Hold || n6Hold || n7Hold || n8Hold) && generatedMusic);
			}
			if (condition)
			{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					if (mania == 0)
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 2:
									if (up || upHold)
										goodNoteHit(daNote);
								case 3:
									if (right || rightHold)
										goodNoteHit(daNote);
								case 1:
									if (down || downHold)
										goodNoteHit(daNote);
								case 0:
									if (left || leftHold)
										goodNoteHit(daNote);
							}
						}
						else if (mania == 1)
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 0:
									if (l1 || l1Hold)
										goodNoteHit(daNote);
								case 1:
									if (u || uHold)
										goodNoteHit(daNote);
								case 2:
									if (r1 || r1Hold)
										goodNoteHit(daNote);
								case 3:
									if (l2 || l2Hold)
										goodNoteHit(daNote);
								case 4:
									if (d || dHold)
										goodNoteHit(daNote);
								case 5:
									if (r2 || r2Hold)
										goodNoteHit(daNote);
							}
						}
						else
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 0: if (n0 || n0Hold) goodNoteHit(daNote);
								case 1: if (n1 || n1Hold) goodNoteHit(daNote);
								case 2: if (n2 || n2Hold) goodNoteHit(daNote);
								case 3: if (n3 || n3Hold) goodNoteHit(daNote);
								case 4: if (n4 || n4Hold) goodNoteHit(daNote);
								case 5: if (n5 || n5Hold) goodNoteHit(daNote);
								case 6: if (n6 || n6Hold) goodNoteHit(daNote);
								case 7: if (n7 || n7Hold) goodNoteHit(daNote);
								case 8: if (n8 || n8Hold) goodNoteHit(daNote);
							}
						}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left && !botplay || botplay  && boyfriend.animation.curAnim.finished)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}
		if (!totalBot)
		{
			playerStrums.forEach(function(spr:StrumNote)
			{
				if (mania == 0)
				{
					switch (spr.ID)
					{
						case 2:
							if (upP && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
								trace('play');
							}
							if (upR)
							{
								spr.playAnim('static');
							}
						case 3:
							if (rightP && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (rightR)
							{
								spr.playAnim('static');
							}
						case 1:
							if (downP && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (downR)
							{
								spr.playAnim('static');
							}
						case 0:
							if (leftP && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (leftR)
							{
								spr.playAnim('static');
							}
					}
				}
				else if (mania == 1)
				{
					switch (spr.ID)
					{
						case 0:
							if (l1P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
								trace('play');
							}
							if (l1R)
							{
								spr.playAnim('static');
							}
						case 1:
							if (uP && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (uR)
							{
								spr.playAnim('static');
							}
						case 2:
							if (r1P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (r1R)
							{
								spr.playAnim('static');
							}
						case 3:
							if (l2P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (l2R)
							{
								spr.playAnim('static');
							}
						case 4:
							if (dP && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (dR)
							{
								spr.playAnim('static');
							}
						case 5:
							if (r2P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (r2R)
							{
								spr.playAnim('static');
							}
					}
				}
				else if (mania == 2)
				{
					switch (spr.ID)
					{
						case 0:
							if (n0P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n0R) spr.playAnim('static');
						case 1:
							if (n1P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n1R) spr.playAnim('static');
						case 2:
							if (n2P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n2R) spr.playAnim('static');
						case 3:
							if (n3P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n3R) spr.playAnim('static');
						case 4:
							if (n4P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n4R) spr.playAnim('static');
						case 5:
							if (n5P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n5R) spr.playAnim('static');
						case 6:
							if (n6P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n6R) spr.playAnim('static');
						case 7:
							if (n7P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n7R) spr.playAnim('static');
						case 8:
							if (n8P && spr.animation.curAnim.name != 'confirm')
							{
								spr.playAnim('pressed');
							}
							if (n8R) spr.playAnim('static');
					}
				}

				/* if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school') && (SONG.song.toLowerCase() != 'disability'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else if (SONG.song.toLowerCase() != 'disability')
					spr.centerOffsets();
				else
					spr.smartCenterOffsets(); */
			});
		}
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			if(FlxG.save.data.immortal)
				health += 0;
			else
				health -= 0.04;

			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			barCombo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (boyfriend.animation.getByName("singLEFTmiss") != null)
			{
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % keyAmmo[mania]])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if(note.mustPress && note.finishedGenerating && note.noteType != 1)
			{
				noteMiss(note.noteData);
			}
			return;
		}
		//	WAIT YOU FORGOT ABOUT THIS ONE 
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var l1P = controls.L1_P;
		var uP = controls.U1_P;
		var r1P = controls.R1_P;
		var l2P = controls.L2_P;
		var dP = controls.D1_P;
		var r2P = controls.R2_P;

		var n0P = controls.N0_P;
		var n1P = controls.N1_P;
		var n2P = controls.N2_P;
		var n3P = controls.N3_P;
		var n4P = controls.N4_P;
		var n5P = controls.N5_P;
		var n6P = controls.N6_P;
		var n7P = controls.N7_P;
		var n8P = controls.N8_P;
		
		if (mania == 0)
		{
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
		}
		else if (mania == 1)
		{
			if (l1P)
				noteMiss(0);
			else if (uP)
				noteMiss(1);
			else if (r1P)
				noteMiss(2);
			else if (l2P)
				noteMiss(3);
			else if (dP)
				noteMiss(4);
			else if (r2P)
				noteMiss(5);
		}
		else
		{
			if (n0P) noteMiss(0);
			if (n1P) noteMiss(1);
			if (n2P) noteMiss(2);
			if (n3P) noteMiss(3);
			if (n4P) noteMiss(4);
			if (n5P) noteMiss(5);
			if (n6P) noteMiss(6);
			if (n7P) noteMiss(7);
			if (n8P) noteMiss(8);
		}
		updateAccuracy();
	}

	function updateAccuracy()
	{
		if (misses > 0)
			fc = false;
		else
			fc = true;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			if(FlxG.save.data.immortal)
				health =/*well well well*/ 0;
			else
				badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit && note.noteType != 1)
		{
			if (!note.isSustainNote)
			{
			    combo += 1;//this used to be after pop up score was called causing the counter to be one off lol
				if (!botplay) popUpScore(note.strumTime, note.noteData);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				barCombo += 1;
				if (botplay) songScore += 350;
			}
			else
				totalNotesHit += 1;

			if (note.isSustainNote)
				health += 0.004;
			else
				health += 0.025;

			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				if (curSong.toLowerCase() == 'splitathon' && curStep >= 1344 && curStep < 2880)
		        {
				boyfriend.color = FlxColor.WHITE;
		        }
				else
				{
				boyfriend.color = nightColor;
				}
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}

			//'LEFT', 'DOWN', 'UP', 'RIGHT'
			var fuckingDumbassBullshitFuckYou:String;
			fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(note.noteData)) % keyAmmo[mania]];
			if(!boyfriend.nativelyPlayable)
			{
				switch(notestuffs[Math.round(Math.abs(note.noteData)) % keyAmmo[mania]])
				{
					case 'LEFT':
						fuckingDumbassBullshitFuckYou = 'RIGHT';
					case 'RIGHT':
						fuckingDumbassBullshitFuckYou = 'LEFT';
				}
			}
			boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			if (UsingNewCam)
			{
				ZoomCam(false);
			}
			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
			        /*if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			        {
				        spr.centerOffsets();
				        spr.offset.x -= 13;
				        spr.offset.y -= 13;
			       }
			       else
				        spr.centerOffsets();*/
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
		else if (!note.wasGoodHit && note.noteType == 1)
		{
		noteMiss(note.noteData);
		note.kill();
		notes.remove(note, true);
		note.destroy();
		updateAccuracy();
		}
	}


	override function stepHit()
	{
		super.stepHit();
		if (SONG.needsVoices)
		{
		    if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		    {
			    resyncVocals();
		    }
		}

		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				switch (curStep)
				{
			    case 1344:
				    lol = false;
				    remove(dad);
		            dad = new Character(350, 120, 'dave-too-old');
		            add(dad);
					iconP2.animation.play('dave-too-old');
					dad.color = FlxColor.WHITE;
					boyfriend.color = FlxColor.WHITE;
					gf.color = FlxColor.WHITE;
					FlxG.camera.flash(FlxColor.WHITE, 1);
					bruh1.visible = true;
					bruh2.visible = true;
					bruh3.visible = true;
					bruh4.visible = true;
				case 1600:
				    remove(dad);
		            dad = new Character(350, 120, 'dave-older');
		            add(dad);
					iconP2.animation.play('dave-older');
				case 1856:
				    remove(dad);
		            dad = new Character(250, 375, 'dave-old');
		            add(dad);
					iconP2.animation.play('dave-old');
				case 2112:
			    	lol = true;
				    remove(dad);
		            dad = new Character(350, 400, 'dave from v2');
		            add(dad);
					iconP2.animation.play('dave');
				case 2368:
				    remove(dad);
		            dad = new Character(350, 260, 'dave');
		            add(dad);
					iconP2.animation.play('dave');
				case 2878:
				    addSplitathonChar("dave-splitathon");
					iconP2.animation.play('dave-splitathon');
					dad.color = 0xFF878787;
					boyfriend.color = 0xFF878787;
					gf.color = 0xFF878787;
					FlxG.camera.flash(FlxColor.WHITE, 1);
					bruh1.visible = false;
					bruh2.visible = false;
					bruh3.visible = false;
					bruh4.visible = false;
					case 4736:
						dad.canDance = false;
						dad.playAnim('scared', true);
					case 4800:
					    health = 2;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('what');
						addSplitathonChar("bambi-splitathon");
						if (BAMBICUTSCENEICONHURHURHUR == null)
						{
							BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
							BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
							add(BAMBICUTSCENEICONHURHURHUR);
							BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
							BAMBICUTSCENEICONHURHURHUR.x = -100;
							FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
							new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
							new FlxTimer().start(0.3, funnyTweenHealth);
						}
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-what', -100, 550);
						addSplitathonChar("dave-splitathon");
						iconP2.animation.play("dave", true);
					case 6080:
					fuckThisDumbassVariable.alpha = 1;
					health = 2;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitterThonDave('happy');
						addSplitathonChar("bambi-splitathon");
						//iconP2.animation.play("bambi", true);
						if (BAMBICUTSCENEICONHURHURHUR == null)
						{
							BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
							BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
							add(BAMBICUTSCENEICONHURHURHUR);
							BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
							BAMBICUTSCENEICONHURHURHUR.x = -100;
							FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
							new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
							new FlxTimer().start(0.3, funnyTweenHealth);
						}
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-corn', -100, 550);
						addSplitathonChar("dave-splitathon");
						iconP2.animation.play("dave", true);
				}
			case 'insanity':
				switch (curStep)
				{
					case 660 | 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.animation.play('dave-angey');
					case 664 | 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.animation.play(dad.curCharacter);
					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('dave/redsky'));
						curbg.alpha = 1;
						curbg.visible = true;
						iconP2.animation.play('dave-angey');
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;
						iconP2.animation.play(dad.curCharacter);
						dad.canDance = false;
						dad.animation.play('scared', true);
				}
		}
		/*if (SONG.song.toLowerCase() == 'hellbreaker')
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
			   spr.y = FlxG.random.int(200, FlxG.height - 200);
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.y = FlxG.random.int(200, FlxG.height - 200);
			});
		}*/
		switch (SONG.song.toLowerCase())
		{
			case 'furiosity':
				switch (curStep)
				{
					case 512 | 768:
						shakeCam = true;
					case 640 | 896:
						shakeCam = false;
					case 1305:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'polygonized':
				switch(curStep)
				{
					case 1024 | 1312 | 1424 | 1552 | 1664:
						shakeCam = true;
						camZooming = true;
					case 1152 | 1408 | 1472 | 1600 | 2048 | 2176:
						shakeCam = false;
						camZooming = false;
					case 2432:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			case 'glitch':
				switch (curStep)
				{
					case 480 | 681 | 1390 | 1445 | 1515 | 1542 | 1598 | 1655:
						shakeCam = true;
						camZooming = true;
					case 512 | 688 | 1420 | 1464 | 1540 | 1558 | 1608 | 1745:
						shakeCam = false;
						camZooming = false;
				}
			case 'cheating':
				switch (curStep)
				{
					case 72:
	                   // polyThingLol('bambi-corrupt');
					case 74:
					  //  polyThingLol('bambi-corrupt-2');
					case 76:
	                  //  polyThingLol('bambi-corrupt');
					case 78:
					  //  polyThingLol('bambi-corrupt-2');
					case 80:
					   // polyThingLol('bambi-3d');
					case 138:
					   // polyThingLol('bambi-corrupt');
					case 139:
					   // polyThingLol('bambi-corrupt-2');
					case 140:
					   // polyThingLol('bambi-corrupt');
					case 141:
					   // polyThingLol('bambi-corrupt-2');
					case 142:
					   // polyThingLol('bambi-corrupt');
					case 143:
					   // polyThingLol('bambi-corrupt-2');
					case 144:
					  //  polyThingLol('bambi-3d');  
				}
			case 'unfairness' | 'unfairness-high-pitched':
				switch (curStep)
				{
					case 320:
	                   //health += 40; 
				}
		}
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) { //UGH FINE
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}
		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if(curBeat % camBeatSnap == 0)
		{
			if(timeTxtTween != null) 
			{
				timeTxtTween.cancel();
			}

			timeTxt.scale.x = 1.1;
			timeTxt.scale.y = 1.1;
			timeTxtTween = FlxTween.tween(timeTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					timeTxtTween = null;
				}
			});
		}

		if(curBeat % camBeatSnap == 0)
		{
			if(timeNameTween != null) 
			{
				timeNameTween.cancel();
			}

			timeName.scale.x = 1.1;
			timeName.scale.y = 1.1;
			timeNameTween = FlxTween.tween(timeName.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					timeNameTween = null;
				}
			});
		}

		if (!UsingNewCam)
		{
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					ZoomCam(true);
					//if (curBeat % 4 == 0 && curSong == 'Supernovae')
				    //{
					//PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection = !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection;
				    //}
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = false;
					ZoomCam(false);
					//if (curBeat % 4 == 0 && curSong == 'Supernovae')
				   // {
					//PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection = !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection;
				   // }
				}
			}
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dad.dance();
					dadmirror.dance();
				case 'disruption':
					if (curBeat % gfSpeed == 0 && dad.holdTimer <= 0) {
						dad.dance();
						dadmirror.dance();
					}
				case 'applecore':
					if (dad.holdTimer <= 0)
						!wtfThing ? dad.dance(dad.POOP) : dad.playAnim('idle-alt', true); // i hate everything
					if (dadmirror.holdTimer <= 0)
						!wtfThing ? dadmirror.dance(dad.POOP) : dadmirror.playAnim('idle-alt', true); // sutpid
				default:
					if (dad.holdTimer <= 0)
						dad.dance();
					if (dadmirror.holdTimer <= 0)
						dadmirror.dance();
			}
		}
		if (swagger != null) {
			if (swagger.holdTimer <= 0 && curBeat % 1 == 0 && swagger.animation.finished)
				swagger.dance();
		}
		if (littleIdiot != null) {
			if (littleIdiot.animation.finished && littleIdiot.holdTimer <= 0 && curBeat % dadDanceSnap == 0) littleIdiot.dance();
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % camBeatSnap == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		switch (curSong.toLowerCase())
		{
			case 'applecore':
				switch(curBeat) {
					case 160 | 436 | 684:
						gfSpeed = 2;
					case 240:
						gfSpeed = 1;
					case 223:
						wtfThing = true;
						whatthe.forEach(function(spr:FlxSprite){
                            spr.frames = Paths.getSparrowAtlas('bandu/minion');
                            spr.animation.addByPrefix('hi', 'poip', 12, true);
                            spr.animation.play('hi');
                            trace('1');
						});
						creditsWatermark.text = 'Screw you!';
						kadeEngineWatermark.y -= 20;
						camHUD.flash(FlxColor.WHITE, 1);
						
						iconP2.animation.play("the-two-junkers", true);
						//iconRPC = 'icon_the_two_dunkers';
						dad.playAnim('NOOMYPHONES', true);
						dadmirror.playAnim('NOOMYPHONES', true);
						dad.POOP = true; // WORK WORK WOKR< WOKRMKIEPATNOLIKSEHGO:"IKSJRHDLG"H
						dadmirror.POOP = true; // :))))))))))
						new FlxTimer().start(3.5, function(deez:FlxTimer){
							swagThings.forEach(function(spr:StrumNote){
								FlxTween.tween(spr, {y: spr.y + 1000}, 1.2, {ease:FlxEase.circOut});
							});	
							FlxTween.tween(swagger, {y: swagger.y + 1000}, 1.05, {ease:FlxEase.cubeInOut});
						});
						unswagBG.active = unswagBG.visible = true;
						curbg =  unswagBG;
						swagBG.visible = swagBG.active = false;
					case 636:
						unfairPart = true;
						gfSpeed = 1;
						playerStrums.forEach(function(spr:StrumNote){
							spr.scale.set(Note.scales[mania], Note.scales[mania]);
						});
						whatthe.forEach(function(spr:FlxSprite){
							spr.alpha = 0;
						});
						gfSpeed = 1;
						wtfThing = false;
						var dumbStupid = new FlxSprite().loadGraphic(Paths.image('bandu/poop'));
						dumbStupid.scrollFactor.set();
						dumbStupid.screenCenter();
						littleIdiot.alpha = 0;
						littleIdiot.visible = true;
						add(dumbStupid);
						dumbStupid.cameras = [camHUD];
						dumbStupid.color = FlxColor.BLACK;
						creditsWatermark.text = "Ghost tapping is forced off! Screw you!";
						health = 2;
						theFunne = false;
						poopStrums.visible = false;
						FlxTween.tween(dumbStupid, {alpha: 1}, 0.2, {onComplete: function(twn:FlxTween){
							scaryBG.active = true;
							curbg = scaryBG;
							unswagBG.visible = unswagBG.active = false;
							FlxTween.tween(dumbStupid, {alpha: 0}, 1.2, {onComplete: function(twn:FlxTween){
								trace('hi'); // i actually forgot what i was going to put here
							}});
						}});
					case 231:
						vocals.volume = 1;
					case 659:
						FlxTween.tween(littleIdiot, {alpha: 1}, 1.4, {ease: FlxEase.circOut});
					case 667:
						FlxTween.tween(littleIdiot, {"scale.x": littleIdiot.scale.x + 2.1, "scale.y": littleIdiot.scale.y + 2.1}, 1.35, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween){
							iconP2.animation.play("bambi-unfair", true);
							orbit = false;
							dad.visible = dadmirror.visible = swagger.visible = false;
							var derez = new FlxSprite(dad.getMidpoint().x, dad.getMidpoint().y).loadGraphic(Paths.image('bandu/monkey_guy'));
							derez.setPosition(derez.x - derez.width / 2, derez.y - derez.height / 2);
							derez.antialiasing = false;
							add(derez);
							var deez = new FlxSprite(swagger.getMidpoint().x, swagger.getMidpoint().y).loadGraphic(Paths.image('bandu/monkey_person'));
							deez.setPosition(deez.x - deez.width / 2, deez.y - deez.height / 2);
							deez.antialiasing = false;
							add(deez);
							nomorespin = true;
							var swagsnd = new FlxSound().loadEmbedded(Paths.sound('suck'));
							swagsnd.play(true);
							var whatthejunk = new FlxSound().loadEmbedded(Paths.sound('suckEnd'));
							littleIdiot.playAnim('inhale');
							littleIdiot.animation.finishCallback = function(d:String) {
								swagsnd.stop();
								whatthejunk.play(true);
								littleIdiot.animation.finishCallback = null;
							};
							new FlxTimer().start(0.2, function(tmr:FlxTimer){
								FlxTween.tween(deez, {"scale.x": 0.1, "scale.y": 0.1, x: littleIdiot.getMidpoint().x - deez.width / 2, y: littleIdiot.getMidpoint().y - deez.width / 2 - 400}, 0.65, {ease: FlxEase.quadIn});
								FlxTween.angle(deez, 0, 360, 0.65, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) deez.kill()});

								FlxTween.tween(derez, {"scale.x": 0.1, "scale.y": 0.1, x: littleIdiot.getMidpoint().x - derez.width / 2 - 100, y: littleIdiot.getMidpoint().y - derez.width / 2 - 500}, 0.65, {ease: FlxEase.quadIn});
								FlxTween.angle(derez, 0, 360, 0.65, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) derez.kill()});

								new FlxTimer().start(1, function(tmr:FlxTimer) poipInMahPahntsIsGud = true);
							});
						}});
				}
			case 'furiosity':
				if ((curBeat >= 128 && curBeat < 160) || (curBeat >= 192 && curBeat < 224))
					{
						if (camZooming)
							{
								FlxG.camera.zoom += 0.015;
								camHUD.zoom += 0.03;
							}
					}
			case 'polygonized':
				switch (curBeat)
				{
				   /* case 96:
					    polyThingLol('dave-corrupt');
					case 100:
					    polyThingLol('dave-corrupt-2');
					case 104:
					    polyThingLol('dave-corrupt-3'); 
					case 108:
					    polyThingLol('dave-corrupt-4');
					case 112:
					    polyThingLol('dave-angey');
					case 128:
					    polyThingLol('dave-corrupt');
					case 132:
					    polyThingLol('dave-corrupt-2');
					case 136:
					    polyThingLol('dave-corrupt-3');
					case 140:
					    polyThingLol('dave-corrupt-4'); 
					case 144:
					    polyThingLol('dave-angey');
					case 192:
					    polyThingLol('dave-corrupt-5');
					case 215:
					    polyThingLol('dave-corrupt-6');
					case 216:
					    polyThingLol('dave-corrupt-5');
					case 256:
					    polyThingLol('dave-corrupt-6');
					case 272:
					    polyThingLol('dave-corrupt-7');
					case 416:
					    polyThingLol('dave-corrupt-8');*/
					case 608:
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'mealie':
				switch (curBeat)
				{
					case 1776:
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'bambi-angey', false);
						dad.color = nightColor;
						add(dad);
				}
			
		}
		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		var funny:Float = (healthBar.percent * 0.01) + 0.01;

		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
        iconP2.setGraphicSize(Std.int(iconP2.width + (50 * (2 - funny))),Std.int(iconP2.height - (25 * (2 - funny))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam)
			{
				gf.dance();
			}
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance || boyfriend.animation.curAnim.finished)
		{
			boyfriend.playAnim('idle');
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				if (curSong.toLowerCase() == 'splitathon' && curStep >= 1344 && curStep < 2880)
		        {
				boyfriend.color = FlxColor.WHITE;
		        }
				else
				{
				boyfriend.color = nightColor;
				}
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf') // fixed your stupid fucking code ninjamuffin this is literally the easiest shit to fix like come on seriously why are you so dumb
		{
			dad.playAnim('cheer', true);
			boyfriend.playAnim('hey', true);
		}
	}

	function eatShit(ass:String):Void
	{
		if (dialogue[0] == null)
		{
			trace(ass);
		}
		else
		{
			trace(dialogue[0]);
		}
	}

	public function addSplitathonChar(char:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		remove(dad);
		dad = new Character(100, 100, char);
		add(dad);
		dad.color = nightColor;
		switch (dad.curCharacter)
		{
			case 'dave-splitathon':
				{
					dad.y += 160;
					dad.x += 250;
				}
			case 'bambi-splitathon':
				{
					dad.x += 100;
					dad.y += 450;
				}
		}
		boyfriend.stunned = false;
	}
	public function polyThingLol(char:String):Void
	{
		boyfriend.stunned = true;
		remove(dad);
		dad = new Character(100, 100, char);
		add(dad);
		//dad.color = nightColor;
		switch (dad.curCharacter)
		{
			default:
			    dad.x += 150;
			    iconP2.animation.play('dave-corrupt');//icons
			case 'dave-angey':
			    dad.x += 150; 
			    iconP2.animation.play('dave-angey');
			case 'bambi-corrupt' | 'bambi-corrupt-2':
			    dad.y += 100; 
			    iconP2.animation.play('bambi-corrupt');
			case 'bambi-3d':
			    dad.y += 100; 
			    iconP2.animation.play('bambi-3d');
		}
		boyfriend.stunned = false;
	}

	//this is cuz splitathon dave expressions are now baked INTO the sprites! so cool! bonuses of this include:
	// - Not having to cache every expression
	// - Being able to reuse them for other things (ie. lookup for scared)
	public function splitterThonDave(expression:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		//stupid bullshit cuz i dont wanna bother with removing thing erighkjrehjgt
		thing.x = -9000;
		thing.y = -9000;
		if(daveExpressionSplitathon != null)
			remove(daveExpressionSplitathon);
		daveExpressionSplitathon = new Character(-100, 260, 'dave-splitathon');
		add(daveExpressionSplitathon);
		daveExpressionSplitathon.color = nightColor;
		daveExpressionSplitathon.canDance = false;
		daveExpressionSplitathon.playAnim(expression, true);
		boyfriend.stunned = false;
	}

	public function preload(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}
	
	function funnyTweenHealth(e:FlxTimer = null):Void
	{
		FlxTween.tween(fuckThisDumbassVariable, {alpha: 0}, 0.6);
	}

	public function splitathonExpression(expression:String, x:Float, y:Float):Void
	{
		if (SONG.song.toLowerCase() == 'splitathon')
		{
			if(daveExpressionSplitathon != null)
			{
				remove(daveExpressionSplitathon);
			}
			if (expression != 'lookup')
			{
				camFollow.setPosition(dad.getGraphicMidpoint().x + 100, boyfriend.getGraphicMidpoint().y + 150);
			}
			boyfriend.stunned = true;
			thing.color = nightColor;
			thing.x = x;
			thing.y = y;
			remove(dad);

			switch (expression)
			{
				case 'bambi-what':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_WaitWhatNow');
					thing.animation.addByPrefix('uhhhImConfusedWhatsHappening', 'what', 24);
					thing.animation.play('uhhhImConfusedWhatsHappening');
				case 'bambi-corn':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_ChillingWithTheCorn');
					thing.animation.addByPrefix('justGonnaChillHereEatinCorn', 'cool', 24);
					thing.animation.play('justGonnaChillHereEatinCorn');
			}
			if (!splitathonExpressionAdded)
			{
				splitathonExpressionAdded = true;
				add(thing);
			}
			thing.antialiasing = true;
			boyfriend.stunned = false;
		}
	}
}
