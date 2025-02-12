package substates;

import backend.Controls.Control;
import backend.Song;

import options.OptionsMenuState;

import states.PlayState;
import states.StoryMenuState;
import states.FreeplayState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public static var goToOptions:Bool = false;

	var pauseOG:Array<String> = [
		'Resume', 
		'Restart Song', 
		'Change Difficulty',
		'Modifiers',
		'Options', 
		'Exit to menu'
	];

	var modifierChoices:Array<String> = [
		"Toggle Practice Mode",
		"InstaKill on Miss",
		"HealthDrain",
		"Botplay",
		"Back"
	];

	var difficultyChoices:Array<String> = [
		'Easy', 
		'Normal', 
		'Hard', 
		'Back'
	];

	var stageSuffix:String = "";
	var daStage:String = states.PlayState.curStage;

	var menuItems:Array<String> = [];
	var curSelected:Int = 0;

	var practiceText:FlxText;
	var botplayText:FlxText;
	var instaKillText:FlxText;
	var healthDrainText:FlxText;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		menuItems = pauseOG;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				stageSuffix = '-pixel';
		}

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('pauseMusic/breakfast' + stageSuffix, 'shared'), true, true);
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		pauseMusic.volume = 0;

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var levelDeathCounter:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		levelDeathCounter.text += "Blueballed: " + PlayState.deathCounter;
		levelDeathCounter.scrollFactor.set();
		levelDeathCounter.setFormat(Paths.font('vcr.ttf'), 32);
		levelDeathCounter.updateHitbox();
		add(levelDeathCounter);

		practiceText = new FlxText(20, 79 + 32, 0, "", 32);
		practiceText.text += "PRACTICE MODE = " + (!PlayState.practiceMode ? "FALSE" : "TRUE");
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.updateHitbox();
		practiceText.x = FlxG.width - (practiceText.width + 20);
		add(practiceText);

		instaKillText = new FlxText(20, 79 + 64, 0, "", 32);
		instaKillText.text += "INSTAKILL MODE = " + (!PlayState.instaKill ? "FALSE" : "TRUE");
		instaKillText.scrollFactor.set();
		instaKillText.setFormat(Paths.font('vcr.ttf'), 32);
		instaKillText.updateHitbox();
		instaKillText.x = FlxG.width - (practiceText.width + 20);
	//	instaKillText.visible = PlayState.instaKill;
		add(instaKillText);

		botplayText = new FlxText(20, 79 + 96, 0, "", 32);
		botplayText.text += "BOTPLAY = " + (!PlayState.botplay ? "FALSE" : "TRUE");
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.font('vcr.ttf'), 32);
		botplayText.x = FlxG.width - (botplayText.width + 20);
		botplayText.updateHitbox();
	//	botplayText.visible = PlayState.botplay;
		add(botplayText);

		healthDrainText = new FlxText(20, 79 + 130, 0, "", 32);
		healthDrainText.text += "HEALTHDRAIN = " + (!PlayState.healthDrain ? "FALSE" : "TRUE");
		healthDrainText.scrollFactor.set();
		healthDrainText.setFormat(Paths.font('vcr.ttf'), 32);
		healthDrainText.x = FlxG.width - (healthDrainText.width + 20);
		healthDrainText.updateHitbox();
	//	healthDrainText.visible = PlayState.healthDrain;
		add(healthDrainText);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		levelDeathCounter.alpha = 0;

		practiceText.alpha = 0;
		instaKillText.alpha = 0;
		botplayText.alpha = 0;
		healthDrainText.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		levelDeathCounter.x = FlxG.width - (levelDeathCounter.width + 20);

		practiceText.x = FlxG.width - (practiceText.width + 20);
		instaKillText.x = FlxG.width - (instaKillText.width + 20);
		botplayText.x = FlxG.width - (botplayText.width + 20);
		healthDrainText.x = FlxG.width - (healthDrainText.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(levelDeathCounter, {alpha: 1, y: levelDeathCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		FlxTween.tween(practiceText,  {alpha: 1, y: practiceText.y + 5},  0.4,   {ease: FlxEase.quartInOut, startDelay: 0.9});
		FlxTween.tween(instaKillText, {alpha: 1, y: instaKillText.y + 5}, 0.4,   {ease: FlxEase.quartInOut, startDelay: 0.9});
		FlxTween.tween(botplayText,   {alpha: 1, y: botplayText.y + 5},   0.4,   {ease: FlxEase.quartInOut, startDelay: 0.9});
		FlxTween.tween(healthDrainText, {alpha: 1, y: healthDrainText.y + 5},   0.4,   {ease: FlxEase.quartInOut, startDelay: 0.9});
		
		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);

		if (downP)
			changeSelection(1);

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();

				case "Restart Song":
					FlxG.resetState();

				case "Change Difficulty":
					menuItems = difficultyChoices;
					regenMenu();

				case "Easy" | "Normal" | "Hard":
					PlayState.SONG = Song.loadFromJson(backend.Highscore.formatSong(PlayState.SONG.song.toLowerCase(), curSelected), PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();

				case "Modifiers":
					menuItems = modifierChoices;
					regenMenu();

				case "Toggle Practice Mode":
					PlayState.practiceMode = !PlayState.practiceMode;
					FlxG.resetState();

				case "InstaKill on Miss":
					PlayState.instaKill = !PlayState.instaKill;
					FlxG.resetState();

				case "Botplay":
					PlayState.botplay = !PlayState.botplay;
					FlxG.resetState();

				case "HealthDrain":
					PlayState.healthDrain = !PlayState.healthDrain;
					FlxG.resetState();

				case "Options":
					OptionsMenuState.fromFreeplay = true;
					FlxG.switchState(new options.OptionsMenuState());

				case "Exit to menu":
					PlayState.seenCutscene = false;
					PlayState.deathCounter = 0;
					if (PlayState.isStoryMode)
						FlxG.switchState(new states.StoryMenuState());
					else
						FlxG.switchState(new states.FreeplayState());

				case "Back":
					menuItems = pauseOG;
					regenMenu();
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function skipTrans(skipTrans:Bool = false) 
	{
		FlxG.sound.music.volume = 0;

		if (skipTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}

		FlxG.resetState();
	}

	private function regenMenu()
	{
		while (grpMenuShit.members.length > 0)
		{
			grpMenuShit.remove(grpMenuShit.members[0], true);
		}
	
		for (i in 0...menuItems.length)
		{
			var menuItem:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			menuItem.isMenuItem = true;
			menuItem.targetY = i;
			grpMenuShit.add(menuItem);
		}
	
		curSelected = 0;
	
		changeSelection();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}
