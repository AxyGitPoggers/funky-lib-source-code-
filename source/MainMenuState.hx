package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var storymode:FlxSprite;
	var donatebutton:FlxSprite;
	var optionsbutton:FlxSprite;
	var freeplaybutton:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100, -200).loadGraphic(Paths.image('menu/BG2', 'librarian'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 0.725));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-100, -200).loadGraphic(Paths.image('menu/BG base', 'librarian'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 0.725));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFF8F7582;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
        //pogger buttons
        storymode = new FlxSprite(450, 50);
		storymode.frames = Paths.getSparrowAtlas('menu/MenuANI', 'librarian');
		storymode.setGraphicSize(Std.int(storymode.width * 0.7));
		storymode.animation.addByPrefix('idle', "Story0", 24);
		storymode.animation.addByPrefix('selected', "Story select", 24);
		storymode.animation.addByPrefix('pressed', "StoryP", 24);
		storymode.animation.play('idle');
		menuItems.add(storymode);
		storymode.scrollFactor.set();
		storymode.antialiasing = true;

		freeplaybutton = new FlxSprite(370, 540);
		freeplaybutton.frames = Paths.getSparrowAtlas('menu/MenuANI', 'librarian');
		freeplaybutton.setGraphicSize(Std.int(freeplaybutton.width * 0.7));
		freeplaybutton.animation.addByPrefix('idle', "Freeplay0", 24);
		freeplaybutton.animation.addByPrefix('selected', "Freeplay select", 24);
		freeplaybutton.animation.addByPrefix('pressed', "FreeplayP", 24);
		freeplaybutton.animation.play('idle');
		menuItems.add(freeplaybutton);
		freeplaybutton.scrollFactor.set();
		freeplaybutton.antialiasing = true;

		optionsbutton = new FlxSprite(800, 150);
		optionsbutton.setGraphicSize(Std.int(optionsbutton.width * 0.6));
		optionsbutton.frames = Paths.getSparrowAtlas('menu/MenuANI', 'librarian');
		optionsbutton.animation.addByPrefix('idle', "Opt0", 24);
		optionsbutton.animation.addByPrefix('selected', "Opt select", 24);
		optionsbutton.animation.addByPrefix('pressed', "OptP", 24);
		optionsbutton.animation.play('idle');
		menuItems.add(optionsbutton);
		optionsbutton.scrollFactor.set();
		optionsbutton.antialiasing = true;

		donatebutton = new FlxSprite(100, 220);
		donatebutton.frames = Paths.getSparrowAtlas('menu/MenuANI', 'librarian');
		donatebutton.setGraphicSize(Std.int(donatebutton.width * 0.7));
		donatebutton.animation.addByPrefix('idle', "MONEZZ0", 24);
		donatebutton.animation.addByPrefix('selected', "MONEZZ select", 24);
		donatebutton.animation.addByPrefix('pressed', "MONEZZP", 24);
		donatebutton.animation.play('idle');
		menuItems.add(donatebutton);
		donatebutton.scrollFactor.set();
		donatebutton.antialiasing = true;

		var cross:FlxSprite = new FlxSprite(-230, -210).loadGraphic(Paths.image('menu/Cross', 'librarian'));
		cross.updateHitbox();
		cross.setGraphicSize(Std.int(cross.width * 0.7));
		cross.antialiasing = true;
		add(cross);

		var border:FlxSprite = new FlxSprite(-965, -540).loadGraphic(Paths.image('menu/Screen border', 'librarian'));
		border.updateHitbox();
		border.setGraphicSize(Std.int(border.width * 0.67));
		border.antialiasing = true;
		add(border);

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.P)
			{
				FlxG.sound.play(Paths.sound('amogus'));
			}
			if (controls.UP_P)
			{
				//Story Menu
				FlxG.sound.play(Paths.sound('scrollMenu'));
				storymode.animation.play('selected');

				optionsbutton.animation.play('idle');
				freeplaybutton.animation.play('idle');
				donatebutton.animation.play('idle');

				trace("Story Menu Selected");

				/*if (FlxG.save.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new StoryMenuState());
					});*/
			}	

			if (controls.RIGHT_P)
			{
				//Options Menu
				FlxG.sound.play(Paths.sound('scrollMenu'));
				optionsbutton.animation.play('selected');

				freeplaybutton.animation.play('idle');
				storymode.animation.play('idle');
				donatebutton.animation.play('idle');

				/*if (FlxG.save.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new OptionsMenu());
					});
                */
				trace("Option Menu Selected");
			}

			if (controls.DOWN_P)
			{
				//Freeplay Menu
				FlxG.sound.play(Paths.sound('scrollMenu'));
				freeplaybutton.animation.play('selected');

				optionsbutton.animation.play('idle');
				storymode.animation.play('idle');
				donatebutton.animation.play('idle');

				/*if (FlxG.save.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new FreeplayState());
					});
                */
				trace("Freeplay Menu Selected");
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				donatebutton.animation.play('selected');

				optionsbutton.animation.play('idle');
				freeplaybutton.animation.play('idle');
				storymode.animation.play('idle');
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (donatebutton.animation.curAnim.name == 'selected')
				{
					//link
					fancyOpenURL("https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game");
				}
				else
				{
					selectedSomethin = true;

					if (storymode.animation.curAnim.name == 'selected')
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						storymode.animation.play('pressed');

						if (FlxG.save.data.flashing)
							FlxFlicker.flicker(magenta, 1.1, 0.15, false);
			
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new StoryMenuState());
							});
					}

					if (freeplaybutton.animation.curAnim.name == 'selected')
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						freeplaybutton.animation.play('pressed');

						if (FlxG.save.data.flashing)
							FlxFlicker.flicker(magenta, 1.1, 0.15, false);
			
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new FreeplayState());
							});
					}

					if (optionsbutton.animation.curAnim.name == 'selected')
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						optionsbutton.animation.play('pressed');

						if (FlxG.save.data.flashing)
							FlxFlicker.flicker(magenta, 1.1, 0.15, false);
			
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new OptionsMenu());
							});
					}	
					
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
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

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

				trace("Option Menu Selected");
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

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
