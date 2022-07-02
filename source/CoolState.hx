package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import Controls.KeyboardScheme;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class CoolState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var Jamsybob:FlxSprite;
	var Crystal:FlxSprite;
	var MinusClub:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var fun:Int;

	var options:Array<String> = ['story mode', 'freeplay', 'extras', 'options'];

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var curSelected:Int = 0;

	var camFollow:FlxObject;
	
	var funneTween:FlxTween;

	override public function create()
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "\\assets\\replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "\\assets\\replays");
		#end

		fun = FlxG.random.int(0, 999);
		if(fun == 1)
		{
			LoadingState.loadAndSwitchState(new SusState());
		}

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		#if desktop
		DiscordClient.initialize();
		#end

		super.create();

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end
			
		FlxG.save.bind('funkin', 'ninjamuffin99');

		SaveDataHandler.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
		
	}

	var logoBl:FlxSprite;
	var magenta:FlxSprite;
	var properBG:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var bg:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(-1, 0), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.42, FlxG.height * 4.2));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(1, 0),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.42, FlxG.height * 4.2));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(150);
		persistentUpdate = true;

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		properBG = new FlxSprite(-80).loadGraphic(MainMenuState.randomizeBG());
		properBG.scrollFactor.set();
		properBG.setGraphicSize(Std.int(properBG.width * 1.1));
		properBG.updateHitbox();
		properBG.screenCenter();
		//properBG.visible = false;
		properBG.antialiasing = true;
		properBG.color = 0xFFFDE871;
		add(properBG);

		magenta = new FlxSprite(-80).loadGraphic(properBG.graphic);
		magenta.scrollFactor.set();
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		for (i in 0...options.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
			menuItem.animation.addByPrefix('idle', options[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', options[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.x += 375;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			menuItem.antialiasing = true;
			menuItem.scale.set(0.5, 0.5);
			menuItem.visible = true;
			//menuItem.alpha = 0;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		logoBl = new FlxSprite(15, -25);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "MoldyGH\nMissingTextureMan101\nRapparep\nKrisspo\nTheBuilder\nCyndaquilDAC\nT5mpler\nErizur", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		Jamsybob = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('pfp credits/Jamsybob'));
		add(Jamsybob);
		Jamsybob.visible = false;
		Jamsybob.updateHitbox();
		Jamsybob.screenCenter(X);
		Jamsybob.antialiasing = true;

		Crystal = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('pfp credits/crystal'));
		add(Crystal);
		Crystal.visible = false;
		Crystal.updateHitbox();
		Crystal.screenCenter(X);
		Crystal.antialiasing = true;

		MinusClub = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('pfp credits/minus club or hg'));
		add(MinusClub);
		MinusClub.visible = false;
		MinusClub.updateHitbox();
		MinusClub.screenCenter(X);
		MinusClub.antialiasing = true;//minus club or hg

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	var selectedSomethin:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = options[curSelected];
							switch (daChoice)
							{
								case 'story mode':
									FlxG.switchState(new StoryMenuState());
									trace("Story Menu Selected");
								case 'freeplay':
									FlxG.switchState(new FreeplayState());
									trace("Freeplay Menu Selected");
								case 'options':
									FlxG.switchState(new OptionsMenu());
								case 'extras':
									FlxG.switchState(new ExtrasMenuState());
								case 'ost':
									FlxG.switchState(new MusicPlayerState());
								case 'credits':
									FlxG.switchState(new CreditsMenuState());
							}
						});
					}
				});
				
			}
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:FlxText = new FlxText(0, 0, FlxG.width, textArray[i], 48);
			money.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:FlxText = new FlxText(0, 0, FlxG.width, text, 48);
		coolText.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	function deleteOneCoolText()
	{
		credGroup.remove(textGroup.members[0], true);
		textGroup.remove(textGroup.members[0], true);
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 2:
			    createCoolText(['Cool mod made by:']);
			case 3:
			    deleteCoolText();
				createCoolText(['Jamsybob']);
				Jamsybob.visible = true;
			case 4:
				deleteCoolText();
				createCoolText(['Minusclub/HG Master']);
				Jamsybob.visible = false;
				MinusClub.visible = true;
			case 5:
				deleteCoolText();
				createCoolText(['and our Developers']);//early title screen thing will fix later
				MinusClub.visible = false;
			case 6:
				deleteCoolText();
			case 7:
				createCoolText(['Supernovae by ArchWk\nAnd\nGlitch by The Boneyard']);
			case 8:
				deleteCoolText();
				createCoolText(['Warped reality by Crystyl']);
				Crystal.visible = true;
			case 9:
				deleteCoolText();
				Crystal.visible = false;
				ngSpr.visible = false;
			case 10:
				createCoolText([curWacky[0]]);
			case 11:
				addMoreText(curWacky[1]);//this shit wacky
			case 12:
				deleteCoolText();
			case 13:
				addMoreText("Friday Night Funkin'");
			case 14:
				addMoreText('VS. Dave and Bambi Extended');
			case 15:
				addMoreText('wooooo');
			/*case 15:
				deleteCoolText();*/
			case 16:
				skipIntro();
				deleteCoolText();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(Jamsybob);
			remove(MinusClub);
			remove(Crystal);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
			camFollow.setPosition(1240, 250.5);
		
		firstStart = false;
		FlxG.camera.follow(camFollow, null, 0.06);
		logoBl.screenCenter();
		logoBl.x += 240;
		logoBl.y -= camFollow.y - 80;
		titleText.x += 550;
		titleText.y += 250;
		logoBl.scale.set(0.75, 0.75);
		blackScreen.visible = false;
		trace(blackScreen);
		bg.visible = false;
		selectedSomethin = false;
		menuItems.forEach(function(menuItem:FlxSprite)
		{
		    remove(menuItem);
		    add(menuItem);
		});
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;	
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			funneTween.cancel;
			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(1240, spr.getGraphicMidpoint().y);
				//logoBl.y = camFollow.y - 400;
				funneTween = FlxTween.tween(logoBl,{y: camFollow.y - 400}, 0.06);
			}

			spr.updateHitbox();
		});
	}
}
