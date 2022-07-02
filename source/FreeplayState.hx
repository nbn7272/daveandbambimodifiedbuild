package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flash.system.System;
#if desktop
import Discord.DiscordClient;
#end
#if windows
import sys.io.File;
import sys.io.Process;
#end
using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var text:FlxText;
	var augh:Bool = false;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
	var magenta:FlxSprite;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var texts:Array<FlxText> = new Array<FlxText>();

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var AllPossibleSongs:Array<String> = ["Dave", "Joke", "Extra", 'Base', 'Extended'];

	var moreDifficultySongs:Array<String> = ["House", "Insanity", "Polygonized", "Bonus-Song", "Furiosity", "Very-Screwed", "Unfairness"]; //SEXERT
	var singleDifficultySongs:Array<String> = ["Splitathon", "Phonophobia", "Thearchy", "Scopomania", "Torture", "Terminatizing", "Delirium", "Hellbreaker two", "Reality-Breaking", "Leave-This-Place", "Warped-Reality"];
	var twoDifficultySongs:Array<String> = ["Green", "Septuagint", "Universe-breaker"];

	var deezonediff:Array<String> = ['Opposition', 'Hellbreaker', 'Thearchy', 'Scopomania', 'Phonophobia', 'Torture'];

	private var CurrentPack:Int = 0;

	var canMove:Bool = true;

	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [
    	0xFFca1f6f, // GF
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI RETARD
		0xFF00FFFF //SPLIT THE THONNNNN
    ];

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		if (FlxG.save.data.hellbreakerdone)
		{
		AllPossibleSongs = ["Dave", "Joke", "Extra", 'Base', 'Extended', 'hellbreaker'];
		}

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);

		magenta = new FlxSprite().loadGraphic(bg.graphic);
		magenta.scrollFactor.set();
		//magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		CurrentSongIcon = new FlxSprite(0,0).loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		CurrentSongIcon.centerOffsets(false);
		CurrentSongIcon.x = (FlxG.width / 2) - 256;
		CurrentSongIcon.y = (FlxG.height / 2) - 256;
		CurrentSongIcon.antialiasing = true;

		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.x = (FlxG.width / 2) - 162;
		Highscore.load();
		add(NameAlpha);

		add(CurrentSongIcon);

		super.create();
	}

	public function LoadProperPack()
	{
		switch (AllPossibleSongs[CurrentPack].toLowerCase())
		{
			case 'base':
				addWeek(['Tutorial'], 0, ['gf']);
			case 'dave':
				addWeek(['House', 'Insanity', 'Polygonized'], 1, ['dave', 'dave', 'dave-angey']);
				addWeek(['Bonus-Song'], 1,['dave']);
				addWeek(['Blocked','Corn-Theft','Maze',], 2, ['bambi']);
				addWeek(['Splitathon'], 3,['the-duo']);
			case 'joke':
				addWeek(['Supernovae', 'Glitch'], 2, ['bambi-stupid']);
				if (FlxG.save.data.cheatingFound)
					addWeek(['Cheating'], 2, ['bambi-3d']);
				addWeek(['Cheating-high-pitched'], 2, ['bambi-helium']);
				if(FlxG.save.data.unfairnessFound)
					addWeek(['Unfairness'], 2, ['bambi-unfair']);
				addWeek(['Unfairness-high-pitched'], 2, ['unfair-helium']);
				//addWeek(['Hellbreaker'], 2, ['hell']);
			case 'extra':
				addWeek(['Mealie'], 2, ['bambi-loser']);
				addWeek(['Furiosity', 'Old-Insanity'], 1, ['dave-angey', 'dave-old']);
				addWeek(['Old-Corn-Theft', 'Old-Maze'], 2, ['bambi-farmer-beta', 'bambi-farmer-beta']);
				//addWeek(['Opposition', 'Hellbreaker', 'Thearchy', 'Scopomania', 'Phonophobia'], 2, ['face']);
			case 'extended':
				addWeek(['Disruption', 'Applecore', 'Very-Screwed'], 2, ['bambi-piss-3d', 'bandu', 'bambi-angey']);
				addWeek(['Septuagint', 'Delirium', 'Reality-Breaking'], 2, ['septuagint', 'conbi', 'bambi-angey']);
				addWeek(['Torture', 'Leave-This-Place', 'Warped-Reality', 'Opposition', 'Phonophobia', 'Hellbreaker', 'Thearchy', 'Scopomania', 'Green', 'Terminatizing'], 69, ['bambi-unfair','evacuate this premises','bambi-phono','GREEN','bambi-phono','hell','GREEN','scopomania','GREEN','terminatizing']);
		// rearanged this shit and added proper icons
		     case 'hellbreaker':
				addWeek(['Hellbreaker', 'Hellbreaker two'], 69, ['hell', 'hell remaster']);
				if (FlxG.save.data.universebreakerREAL) addWeek(['Universe-breaker'], 69, ['breaker of universes']);
		}
	}


	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
		{
			CurrentPack = AllPossibleSongs.length - 1;
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
		}
		NameAlpha.destroy();
		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.x = (FlxG.width / 2) - 164;
		add(NameAlpha);
		if (AllPossibleSongs[CurrentPack].toLowerCase() == "hellbreaker") NameAlpha.x -= 275;
		CurrentSongIcon.loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		if (FlxG.save.data.firstfoundhell && FlxG.save.data.hellbreakerdone && AllPossibleSongs[CurrentPack].toLowerCase() == "hellbreaker")
		{
		FlxG.camera.shake(0.0075, 0.6);
		CurrentSongIcon.alpha = 0;
		NameAlpha.alpha = 0;
		canMove = false;//:flushed:

		FlxTween.tween(CurrentSongIcon, {alpha: 1}, 0.6, {type: ONESHOT,
			            onComplete: function(tween:FlxTween) {
						FlxG.camera.flash(FlxColor.WHITE, 1);
						canMove = true;//prevents changing and making cutscene go weird
				        }
			            });

		FlxTween.tween(NameAlpha, {alpha: 1}, 0.6, {type: ONESHOT});
		FlxG.save.data.firstfoundhell = false;// a neat little cutscene :)
		}
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (augh)
		{
		 if (FlxG.keys.justPressed.Y)
		 {
		  FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);

			for (icon in iconArray)
		   {
		    if (icon != iconArray[curSelected]) 
			    FlxTween.tween(icon, {alpha: 0}, 1.1, {type: ONESHOT,
			            onComplete: function(tween:FlxTween) {
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			            trace(poop);

			            PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			            PlayState.isStoryMode = false;
			            PlayState.storyDifficulty = curDifficulty;
						PlayState.replaying = true;

			            ChartingState.usedCharter = false;

			            PlayState.storyWeek = songs[curSelected].week;
			            LoadingState.loadAndSwitchState(new CharacterSelectState());
				        }
			            });
			}
		 }
		 else if (FlxG.keys.justPressed.N)
		 {
		 remove(text);
		 for (text in texts)
				{
				remove(text);
				}
		 }
		}

		if (!InMainFreeplayState) 
		{
			if (controls.LEFT_P && canMove)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P && canMove)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack)
			{
				loadingPack = true;
				LoadProperPack();
				FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.3);
				FlxTween.tween(NameAlpha, {alpha: 0}, 0.3);
				new FlxTimer().start(0.5, function(Dumbshit:FlxTimer)
				{
					CurrentSongIcon.visible = false;
					NameAlpha.visible = false;
					GoToActualFreeplay();
					InMainFreeplayState = true;
					loadingPack = false;
				});
			}
			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}	
		
			return;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP && canMove)
		{
			changeSelection(-1);
		}
		if (downP && canMove)
		{
			changeSelection(1);
		}
		if (controls.LEFT_P && canMove)
			changeDiff(-1);
		if (controls.RIGHT_P && canMove)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new FreeplayState());
		}

		if (accepted)
		{
		    FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);
			canMove = false; //fixed this minusclub
		if (FlxG.keys.pressed.CONTROL)
		{
			for (icon in iconArray)
		   {
		    if (icon != iconArray[curSelected]) 
			    FlxTween.tween(icon, {alpha: 0}, 1.1, {type: ONESHOT,
			            onComplete: function(tween:FlxTween) {
						
				        }
			            });
			}
			 FlxTween.tween(iconArray[curSelected], {alpha: 1}, 1.1, {type: ONESHOT,
			            onComplete: function(tween:FlxTween) {
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			            trace(poop);

			            PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			            PlayState.isStoryMode = false;
			            PlayState.storyDifficulty = curDifficulty;

			            ChartingState.usedCharter = false;

			            PlayState.storyWeek = songs[curSelected].week;
			            PlayState.characteroverride = "bf";
		                PlayState.formoverride = "bf";
		                PlayState.curmult = [1,1,1,1];
		                LoadingState.loadAndSwitchState(new PlayState());
				        }
			            });
		}
		else
			{
			for (icon in iconArray)
		   {
		    if (icon != iconArray[curSelected]) 
			    FlxTween.tween(icon, {alpha: 0}, 1.1, {type: ONESHOT,
			            onComplete: function(tween:FlxTween) {
						
				        }
			            });
			}
			 FlxTween.tween(iconArray[curSelected], {alpha: 1}, 1.1, {type: ONESHOT,
			            onComplete: function(tween:FlxTween) {
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			            trace(poop);

			            PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			            PlayState.isStoryMode = false;
			            PlayState.storyDifficulty = curDifficulty;

			            ChartingState.usedCharter = false;

			            PlayState.storyWeek = songs[curSelected].week;
			           
		                LoadingState.loadAndSwitchState(new CharacterSelectState());
				        }
			            });
			}
		}
		
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		if (!moreDifficultySongs.contains(songs[curSelected].songName) && !twoDifficultySongs.contains(songs[curSelected].songName))// add your song name to the string titled "moreDifficultySongs" and the engine will add unnerfed difficulty for you!
		{
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		}
		else if(twoDifficultySongs.contains(songs[curSelected].songName))// same here
		{
		if (curDifficulty < 1)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 1;
		}
		else// me when the
		{
			if (curDifficulty < 0)
				curDifficulty = 3;
			if (curDifficulty > 3)
				curDifficulty = 0;
		}

		if (singleDifficultySongs.contains(songs[curSelected].songName))
		{
			curDifficulty = 1;
		}
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		updateDifficultyText();


		if (sys.FileSystem.exists('assets/replays/replay of ' + songs[curSelected].songName + '.txt'))
		        {
				text = new FlxText(400, 400, 400, "Replay found for song. Play? Y/N", 32);
		        text.screenCenter();
		        text.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		        augh = true;
				remove(text);//prevents them from stacking
				add(text);
				texts.push(text);
				}
		else
		        {
				augh = false;
				remove(text);
				for (text in texts)
				{
				remove(text);
				}
				}
		
	}

	function updateDifficultyText()
	{
		var stupidBitch = curChar;
		if(stupidBitch.toLowerCase() == 'bf-pixel')
		{
			stupidBitch = 'bf';
		}
		switch (songs[curSelected].week)
		{
			case 3:
				diffText.text = 'FINALE' + " - " + stupidBitch.toUpperCase();
				diffText.color = FlxColor.WHITE;
			default:
				switch (curDifficulty)
				{
					case 0:
						diffText.text = "EASY" + " - " + stupidBitch.toUpperCase();
						diffText.color = FlxColor.WHITE;
					case 1:
						diffText.text = 'NORMAL' + " - " + stupidBitch.toUpperCase();
						diffText.color = FlxColor.WHITE;
					case 2:
					    if (songs[curSelected].songName != 'Green')
						{
						diffText.text = "HARD" + " - " + stupidBitch.toUpperCase();
						diffText.color = FlxColor.WHITE;
						}
						if (songs[curSelected].songName == 'Green' || songs[curSelected].songName == 'Septuagint')
						{
						diffText.text = "INSANE" + " - " + stupidBitch.toUpperCase();
						diffText.color = 0xFF00FF00;
						}
					case 3:
					    if (songs[curSelected].songName == 'Very-Screwed')
						{
						diffText.text = "EXTREME" + " - " + stupidBitch.toUpperCase();
						diffText.color = 0x00DF0101;
						}
						else if (songs[curSelected].songName == 'Green')
						{
						diffText.text = "INSANE" + " - " + stupidBitch.toUpperCase();
						diffText.color = 0x00B40404;
						}
						else if (songs[curSelected].songName == 'Unfairness')
						{
						diffText.text = "B-Side" + " - " + stupidBitch.toUpperCase();
						}
						else
						{
						diffText.text = "LEGACY" + " - " + stupidBitch.toUpperCase();
						diffText.color = FlxColor.WHITE;
						}
				}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

			changeDiff();

		if (singleDifficultySongs.contains(songs[curSelected].songName))
		{
			curDifficulty = 1;
		}

		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		updateDifficultyText();

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (icon in 0...iconArray.length)
		{
			iconArray[icon].alpha = 0.6;
			switch (iconArray[icon].animation.name)
		    {
		        case "GREEN":
			        iconArray[icon].scale.set(1.2, 1.2);
		        default:
			        iconArray[icon].scale.set(1, 1);		
		    }
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		switch (songs[curSelected].songName)
		{
		    case "Leave-This-Place":
			     FlxTween.color(bg, 0.5, bg.color, 0xFF46FF81);
		    case "Terminatizing":
			     FlxTween.color(bg, 0.75, bg.color, 0xFF3C3C3C);
		    case "Green":
			     FlxTween.color(bg, 0.75, bg.color, 0xFF00FF00);
			case "Scopomania":
			     FlxTween.color(bg, 0.75, bg.color, 0xFF64302D);
			case "Thearchy":
			     FlxTween.color(bg, 0.75, bg.color, 0xFFE6E6E6);
			case "Hellbreaker" | "Hellbreaker 2" | "Universe-breaker":
			     FlxTween.color(bg, 0.625, bg.color, 0xFF3C3C3C);
			case "Phonophobia":
			     FlxTween.color(bg, 0.5, bg.color, 0xFFE6E6E6);
			case "Opposition":
			     FlxTween.color(bg, 0.5, bg.color, 0xFF0000C8);
		    default:
		        FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
		}

		if (!moreDifficultySongs.contains(songs[curSelected].songName) && !twoDifficultySongs.contains(songs[curSelected].songName))// add your song name to the string titled "moreDifficultySongs" and the engine will add unnerfed difficulty for you!
		{
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		}
		else if (twoDifficultySongs.contains(songs[curSelected].songName))// same here
		{
		if (curDifficulty < 1)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 1;
		}
		else if (!singleDifficultySongs.contains(songs[curSelected].songName)) // me when the
		{
			if (curDifficulty < 0)
				curDifficulty = 3;
			if (curDifficulty > 3)
				curDifficulty = 0;
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
