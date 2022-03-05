package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var display:String;
	public final function getDisplay():String
	{
		return display;
	}

	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Key Bindings";
	}
}

class GhostTappingOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping " + (!FlxG.save.data.newInput ? "off" : "on");
	}
}

class DownscrollOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class AccuracyOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class EyesoresOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Eyesores " + (!FlxG.save.data.eyesores ? "off" : "on");
	}
}

class NoteClickOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Click " + (!FlxG.save.data.donoteclick ? "off" : "on");
	}
}

class FreeplayCutscenesOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.freeplayCuts = !FlxG.save.data.freeplayCuts;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Freeplay Cutscene " + (!FlxG.save.data.freeplayCuts ? "off" : "on");
	}
}

class InmortalOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.immortal = !FlxG.save.data.immortal;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Inmortal " + (!FlxG.save.data.immortal ? "off" : "on");
	}
}

class ModchartOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.modchart = !FlxG.save.data.modchart;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Modchart " + (!FlxG.save.data.modchart ? "off" : "on");
	}
}
