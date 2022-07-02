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
	public var badNote:Bool = false;
	public var mania:Int = 0;
	public var isAlive:Bool = true;
	public var isAlt:Bool = false;
	public var is3d:Bool = false;
	public var funne:Bool = false;
	public var prevNote:Note;
	public var thisNote:Note;
	public var LocalScrollSpeed:Float = 1;
	public var resetAnim:Float = 0;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;


	public var noteScore:Float = 1;

	public var direction:Int = 0;

	public static var swagWidth:Float;
	public var swagWidthThing:Float;
	public static var noteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;

	public var MyStrum:FlxSprite;

	private var InPlayState:Bool = false;

	public static var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair', 'bambi-helium', 'unfair-helium', 'SEAL', 'bambi-phono', 'hell', 'hell remaster', 'OPPOSITION', 'thearchy', 'GREEN', 'scopomania', 'bambi-piss-3d', 'bandu', 'unfair-junker', 'septuagint', 'cryo dave', 'terminatizing', 'bamber-angy', 'conbi', 'breaker of universes'];
	
	public static var scales:Array<Float> = [0.7, 0.6, 0.46, 0.3];

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal") //had to add a new variable to this because FNF dumb
	{
	    swagWidth = 160 * 0.7; 
		swagWidthThing = 160 * 0.7; 
		noteScale = 0.7;
	    mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			swagWidthThing = 120 * 0.7;
			noteScale = 0.6;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 90 * 0.7;
			swagWidthThing = 90 * 0.7;
			noteScale = 0.46;
			mania = 2;
		}
		else if (PlayState.SONG.mania == 3)
		{
			swagWidth = 60 * 0.7;
			swagWidthThing = 60 * 0.7;
			noteScale = 0.3;
			mania = 3;
		}
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

		switch (noteStyle)
		{
		    case "normal":
			    noteType = 0;
			case "phone":
			    noteType = 1; //here you can see which one which and uses number (int) because yes
				badNote = true;
			case "corn":
			    noteType = 2;
			case "delirium":
			    noteType = 3;
		}
		if (noteType == 1)
		{
		badNote = true;
		}
		Main.noteCount += 1;
		var daStage:String = PlayState.curStage;
		
			frames = Paths.getSparrowAtlas('NOTE_assets_MAIN');
			//3d notes
			animation.addByPrefix('greenScroll3d', 'green3d');
			animation.addByPrefix('redScroll3d', 'red3d');
			animation.addByPrefix('blueScroll3d', 'blue3d');
			animation.addByPrefix('purpleScroll3d', 'purple3d');
			animation.addByPrefix('whiteScroll3d', 'white3d');
			animation.addByPrefix('yellowScroll3d', 'yellow3d');
			animation.addByPrefix('violetScroll3d', 'violet3d');
			animation.addByPrefix('blackScroll3d', 'black3d');
			animation.addByPrefix('darkScroll3d', 'dark3d');

			animation.addByPrefix('purpleholdend3d', 'pruple end hold3d');
			animation.addByPrefix('greenholdend3d', 'green hold end3d');
			animation.addByPrefix('redholdend3d', 'red hold end3d');
			animation.addByPrefix('blueholdend3d', 'blue hold end3d');
			animation.addByPrefix('whiteholdend3d', 'white hold end3d');
			animation.addByPrefix('yellowholdend3d', 'yellow hold end3d');
			animation.addByPrefix('violetholdend3d', 'violet hold end3d');
			animation.addByPrefix('blackholdend3d', 'black hold end3d');
			animation.addByPrefix('darkholdend3d', 'dark hold end3d');

			animation.addByPrefix('purplehold3d', 'purple hold piece3d');
			animation.addByPrefix('greenhold3d', 'green hold piece3d');
			animation.addByPrefix('redhold3d', 'red hold piece3d');
			animation.addByPrefix('bluehold3d', 'blue hold piece3d');
			animation.addByPrefix('whitehold3d', 'white hold piece3d');
			animation.addByPrefix('yellowhold3d', 'yellow hold piece3d');
			animation.addByPrefix('violethold3d', 'violet hold piece3d');
			animation.addByPrefix('blackhold3d', 'black hold piece3d');
			animation.addByPrefix('darkhold3d', 'dark hold piece3d3d');

			animation.addByPrefix('phone3d', 'phone3d');
			animation.addByPrefix('corn3d', 'corn3d');

			//2d notes
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

			setGraphicSize(Std.int(width * noteScale));
			updateHitbox();
			antialiasing = true;

		this.noteStyle = noteStyle;
		thisNote = this;
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
		else if (mania == 3) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark', 'purple', 'green', 'red', 'yellow', 'blue', 'dark'];

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


		if (!mustPress && CharactersWith3D.contains(PlayState.SONG.player2)) is3d = true;
		else is3d = false;

		if (mustPress && ((PlayState.formoverride != "bf") ? CharactersWith3D.contains(PlayState.formoverride) : CharactersWith3D.contains(PlayState.SONG.player1))) is3d = true;
		else is3d = false;
		
		if (isSustainNote && prevNote != null && !is3d)
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

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				//if (noteStyle == "corn") prevNote.animation.play("cornhold");
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}

		if (isSustainNote && prevNote != null && is3d)
		{
		    noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			if (mania == 3)
			{
			switch (noteData)
			{
				case 2:
					animation.play('greenholdend3d');
				case 3:
					animation.play('redholdend3d');
				case 1:
					animation.play('greenholdend3d');
				case 0:
					animation.play('purpleholdend3d');
				case 4:
				    
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
				case 10:
				case 11:
			}
			}
			
			updateHitbox();

			x -= width / 2;

			animation.play(frameN[noteData] + 'holdend3d');
			//if (noteStyle == "corn") animation.play('cornholdend3d');

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold3d');
				//if (noteStyle == "corn") prevNote.animation.play("cornhold3d");
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * PlayState.SONG.speed;
				//trace(prevNote.scale.y);
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
	    is3d = false;
	    var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];
		else if (mania == 3) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark', 'purple', 'green', 'red', 'yellow', 'blue', 'dark'];

	    if (!mustPress && CharactersWith3D.contains(PlayState.SONG.player2)) is3d = true;
		if (mustPress && ((PlayState.formoverride != "bf") ? CharactersWith3D.contains(PlayState.formoverride) : CharactersWith3D.contains(PlayState.SONG.player1))) is3d = true;
		super.update(elapsed);
		
		if (!isSustainNote && (noteStyle != "phone" || noteStyle != "corn"))
		{
		    if (!is3d) 
		    { 
		        animation.play(frameN[noteData] + 'Scroll');
		    }
		    else 
		    { 
		        animation.play(frameN[noteData] + 'Scroll3d');
		    }
		}

		
		if (noteStyle == "phone" && !isSustainNote && !is3d || noteType == 1 && !isSustainNote && !is3d) animation.play("phone");
		if (noteStyle == "corn" && !isSustainNote && !is3d || noteType == 2 && !isSustainNote && !is3d) animation.play("corn"); 

		if (noteStyle == "phone" && !isSustainNote && is3d || noteType == 1 && !isSustainNote && is3d) animation.play("phone3d");
		if (noteStyle == "corn" && !isSustainNote && is3d || noteType == 2 && !isSustainNote && is3d) animation.play("corn3d"); //note type my beloved
		
		if (mustPress && MyStrum != null)
		{
		    switch (mania)//I have finally added this for 6k and 9k
			{
			case 1:
			    if (noteData != 4) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 4) x = MyStrum.x + (isSustainNote ? width : 0); // 6k
			case 2:
			    if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 1 || noteData == 6) x = MyStrum.x + (isSustainNote ? width : 0); // 9k
			default:
			    if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 1) x = MyStrum.x + (isSustainNote ? width : 0); // offset for up and down arrow so it doesn't bug me
			}
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
								if (isSustainNote)
								{
								switch (mania)//I have finally added this for 6k and 9k
			{
			case 1:
			    if (noteData != 4) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 4) x = MyStrum.x + (isSustainNote ? width : 0); // 6k
			case 2:
			    if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 1 || noteData == 6) x = MyStrum.x + (isSustainNote ? width : 0); // 9k
			default:
			    if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 1) x = MyStrum.x + (isSustainNote ? width : 0); // offset for up and down arrow so it doesn't bug me
				}
			}
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
									if (isSustainNote)
								{
								switch (mania)//I have finally added this for 6k and 9k
			{
			case 1:
			    if (noteData != 4) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 4) x = MyStrum.x + (isSustainNote ? width : 0); // 6k
			case 2:
			    if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 1 || noteData == 6) x = MyStrum.x + (isSustainNote ? width : 0); // 9k
			default:
			    if (noteData != 1) x = MyStrum.x + (isSustainNote ? width + 4 : 0);
			    if (noteData == 1) x = MyStrum.x + (isSustainNote ? width : 0); // offset for up and down arrow so it doesn't bug me
				}
			}
								}
							});
					}
			}
			else if (InPlayState && isAlt)
			{
			    var state:PlayState = cast(FlxG.state,PlayState);
				state.poopStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.ID == notetolookfor)
					{
						x = spr.x;
						MyStrum = spr;
					}
				});
			}
		}
		
		if (mustPress && !PlayState.botplay)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
			
		}
		else if (!mustPress)
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}
		else
		{
		if (strumTime <= Conductor.songPosition && noteType != 1)//lol bot go brr
				{
				coolBot = true;
				}
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
