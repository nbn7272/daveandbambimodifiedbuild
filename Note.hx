package;

import flixel.math.FlxRandom;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var finishedGenerating:Bool = false;
	public var noteData:Int = 0;
	public var noteStyle:String = "normal";
	public var noteType:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var coolBot:Bool = false;
	public var mania:Int = 0;
	public var isAlive:Bool = true;
	public var isAlt:Bool = false;
	public var prevNote:Note;
	public var LocalScrollSpeed:Float = 1;
	public var resetAnim:Float = 0;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;


	public var noteScore:Float = 1;

	public static var swagWidth:Float;
	public static var noteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;

	public var MyStrum:FlxSprite;

	private var InPlayState:Bool = false;

	public static var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair', 'bambi-helium', 'unfair-helium', 'SEAL', 'bambi-phono', 'hell', 'OPPOSITION', 'thearchy', 'GREEN', 'scopomania', 'bambi-piss-3d', 'bandu', 'unfair-junker'];
	
	public static var scales:Array<Float> = [0.7, 0.6, 0.46];

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal") //had to add a new variable to this because FNF dumb
	{
	    swagWidth = 160 * 0.7; 
		noteScale = 0.7;
	    mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 90 * 0.7;
			noteScale = 0.46;
			mania = 2;
		}
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime + FlxG.save.data.offset;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

		switch (noteStyle)
		{
		    case "normal":
			    noteType = 0;
			case "phone":
			    noteType = 1; //here you can see which one which and uses number (int) because yes
			case "corn":
			    noteType = 2;
		}

		var daStage:String = PlayState.curStage;
		if ((CharactersWith3D.contains(PlayState.SONG.player2) && !musthit) || ((CharactersWith3D.contains(PlayState.SONG.player1) && musthit)) || ((CharactersWith3D.contains(PlayState.SONG.player2) || CharactersWith3D.contains(PlayState.SONG.player1)) && (this.strumTime / 50) % 20 > 10))
		{
				frames = Paths.getSparrowAtlas('NOTE_assets_3D');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('whiteScroll', 'white0');
				animation.addByPrefix('yellowScroll', 'yellow0');
				animation.addByPrefix('violetScroll', 'violet0');
				animation.addByPrefix('blackScroll', 'black0');
				animation.addByPrefix('darkScroll', 'dark0');


				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('whiteholdend', 'white hold end');
				animation.addByPrefix('yellowholdend', 'yellow hold end');
				animation.addByPrefix('violetholdend', 'violet hold end');
				animation.addByPrefix('blackholdend', 'black hold end');
				animation.addByPrefix('darkholdend', 'dark hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				animation.addByPrefix('whitehold', 'white hold piece');
				animation.addByPrefix('yellowhold', 'yellow hold piece');
				animation.addByPrefix('violethold', 'violet hold piece');
				animation.addByPrefix('blackhold', 'black hold piece');
				animation.addByPrefix('darkhold', 'dark hold piece');

				animation.addByPrefix('phone', 'phone');
				animation.addByPrefix('corn', 'corn');

				if (noteStyle == "phone" || noteType == 1)
				{
				frames = Paths.getSparrowAtlas('NOTE_phone');
				animation.addByPrefix('phonegreenScroll', 'green0');
				animation.addByPrefix('phoneredScroll', 'red0');
				animation.addByPrefix('phoneblueScroll', 'blue0');
				animation.addByPrefix('phonepurpleScroll', 'purple0');

				animation.addByPrefix('phonepurplehold', 'purple hold piece');
				animation.addByPrefix('phonegreenhold', 'green hold piece');
				animation.addByPrefix('phoneredhold', 'red hold piece');
				animation.addByPrefix('phonebluehold', 'blue hold piece');

				animation.addByPrefix('phonepurpleholdend', 'pruple end hold');
				animation.addByPrefix('phonegreenholdend', 'green hold end');
				animation.addByPrefix('phoneredholdend', 'red hold end');
				animation.addByPrefix('phoneblueholdend', 'blue hold end');
				}
				if (noteStyle == "corn" || noteType == 2)
				{
				frames = Paths.getSparrowAtlas('NOTE_corn');
				animation.addByPrefix('cornScroll', 'green0');

				animation.addByPrefix('cornhold', 'green hold piece');

				animation.addByPrefix('cornholdend', 'green hold end');
				}
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}
		else
		{
				frames = Paths.getSparrowAtlas('NOTE_assets');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('whiteScroll', 'white0');
				animation.addByPrefix('yellowScroll', 'yellow0');
				animation.addByPrefix('violetScroll', 'violet0');
				animation.addByPrefix('blackScroll', 'black0');
				animation.addByPrefix('darkScroll', 'dark0');


				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('whiteholdend', 'white hold end');
				animation.addByPrefix('yellowholdend', 'yellow hold end');
				animation.addByPrefix('violetholdend', 'violet hold end');
				animation.addByPrefix('blackholdend', 'black hold end');
				animation.addByPrefix('darkholdend', 'dark hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				animation.addByPrefix('whitehold', 'white hold piece');
				animation.addByPrefix('yellowhold', 'yellow hold piece');
				animation.addByPrefix('violethold', 'violet hold piece');
				animation.addByPrefix('blackhold', 'black hold piece');
				animation.addByPrefix('darkhold', 'dark hold piece');

				animation.addByPrefix('phone', 'phone');
				animation.addByPrefix('corn', 'corn');

				if (noteStyle == "phone" || noteType == 1)
				{
				frames = Paths.getSparrowAtlas('NOTE_phone');
				animation.addByPrefix('phonegreenScroll', 'green0');
				animation.addByPrefix('phoneredScroll', 'red0');
				animation.addByPrefix('phoneblueScroll', 'blue0');
				animation.addByPrefix('phonepurpleScroll', 'purple0');

				animation.addByPrefix('phonepurplehold', 'purple hold piece');
				animation.addByPrefix('phonegreenhold', 'green hold piece');
				animation.addByPrefix('phoneredhold', 'red hold piece');
				animation.addByPrefix('phonebluehold', 'blue hold piece');

				animation.addByPrefix('phonepurpleholdend', 'pruple end hold');
				animation.addByPrefix('phonegreenholdend', 'green hold end');
				animation.addByPrefix('phoneredholdend', 'red hold end');
				animation.addByPrefix('phoneblueholdend', 'blue hold end');
				}
				if (noteStyle == "corn" || noteType == 2)
				{
				frames = Paths.getSparrowAtlas('NOTE_corn');
				animation.addByPrefix('cornScroll', 'green0');

				animation.addByPrefix('cornhold', 'green hold piece');

				animation.addByPrefix('cornholdend', 'green hold end');
				}
				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}
		noteStyle = this.noteStyle;
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];

		x += swagWidth * noteData;
		animation.play(frameN[noteData] + 'Scroll');
		if (noteStyle == "phone") animation.play("phone" + (mania == 0 ? frameN[noteData] : (mania == 1 ? frameN[1] : frameN[2])) + 'Scroll');
		if (noteStyle == "corn") animation.play("cornScroll");
		notetolookfor = noteData;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case /*'cheating' | */'cheating-high-pitched':
				switch (noteData)
				{
					case 0:
						x += swagWidth * 3;
						notetolookfor = 3;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 1;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 0;
						notetolookfor = 0;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('redScroll');
				}
				flipY = (Math.round(Math.random()) == 0); //fuck you
				flipX = (Math.round(Math.random()) == 1);
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				if (Type.getClassName(Type.getClass(FlxG.state)).contains("PlayState"))
				{
					var state:PlayState = cast(FlxG.state,PlayState);
					InPlayState = true;
					if (isAlt)
					{
					state.poopStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
									x = spr.x;
									angle = spr.angle;
									MyStrum = spr;
								}
							});
					}
					if (musthit)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								angle = spr.angle;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.dadStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
									x = spr.x;
									angle = spr.angle;
									MyStrum = spr;
								}
							});
					}
				}
		}

		/*if (PlayState.SONG.song.toLowerCase() == 'unfairness')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0,30) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(1,3);
			}
		}*/
		if (PlayState.SONG.song.toLowerCase() == 'unfairness-high-pitched')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0,5) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(1,3);
			}
		}
		

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			animation.play(frameN[noteData] + 'holdend');
			if (noteStyle == "corn") animation.play('cornholdend');

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				if (noteStyle == "corn") prevNote.animation.play("cornhold");
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (noteStyle == "phone" && !isSustainNote) animation.play("phone");
		if (noteStyle == "corn" && !isSustainNote) animation.play("corn");
		
		if (MyStrum != null && !isAlt)
		{
			if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			if (noteData == 1) x = MyStrum.x + (isSustainNote ? width : 0); // offset for up and down arrow so it doesn't bug me
		}
		else
		{
			if (InPlayState && !isAlt)
			{
				var state:PlayState = cast(FlxG.state,PlayState);
				if (mustPress)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.dadStrums.forEach(function(spr:FlxSprite)
							{
								if (spr.ID == notetolookfor)
								{
									x = spr.x;
									MyStrum = spr;
								}
							});
					}
			}
		}
		
		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit && isAlive)
				tooLate = true;
			if (strumTime <= Conductor.songPosition && PlayState.botplay && noteType != 1)//lol bot go brr
				{
				coolBot = true;
				}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
			
		}
	}
	function updateConfirmOffset() { //
		centerOffsets();
		offset.x -= 13;
		offset.y -= 13;
	}
}
