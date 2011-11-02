package com.dVyper.utils {
//package com.dVyper.utils {
//http://fatal-exception.co.uk/blog/?p=121#more-121
	//
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	//
	public class dPanel {
		//
		private static var Background:Shape = new Shape();
		private static var currentYPos:int = 4;
		private static var textFields:Array = new Array();
		private static var firstTrace:Boolean = true;
		private static var bgColour:int;
		private static var myMaxLines:int;
		private static var myPanel:Sprite = new Sprite();
		private static var myTextField:TextField;
		private static var myTextColour:int;
		private static var myTimer:Timer;
		private static var myTransitionKey:int;
		private static var onStage:Boolean = false;
		private static var stage:Stage;
		//
		public static function init(stageReference:Stage, transitionKey:int = 96, colour:int = 0x000000, Alpha:Number = 0.8):void {
			if (stageReference == null) return;
			stage = stageReference;
			myTransitionKey = transitionKey;
			stage.addEventListener(KeyboardEvent.KEY_UP, doTransition);
			bgColour = colour;
			Background.alpha = Alpha;
			myPanel.addChild(Background);
			myTimer = new Timer(50);
			stage.addEventListener(Event.RESIZE, resizeDebugWindow)
		}
		public static function addSection(myName:String, colour:int = 0xFFFFFF):void {
			if (stage == null) return;
			var myTF:TextField = new TextField();
			myTF.textColor = colour;
			myTF.name = myName;
			myTF.x = 2;
			myTF.y = currentYPos;
			myTF.height = 18;
			myTF.width = stage.stageWidth-8;
			myTF.border = true;
			myTF.borderColor = colour;
			myTF.defaultTextFormat = new TextFormat("Verdana", 12, colour);
			myPanel.addChild(myTF);
			currentYPos = currentYPos+22;
			textFields.push(myTF);
			updateBackground();
		}
		private static function updateBackground():void {
			Background.graphics.clear();
			Background.graphics.beginFill(bgColour);
			Background.graphics.drawRect(0, 0, stage.stageWidth, currentYPos+1);
			Background.graphics.endFill();
			myPanel.y = 0-Background.height;
		}
		private static function doTransition(event:KeyboardEvent):void {
			if (event.charCode == myTransitionKey) {
				if (onStage) {
					myTimer.removeEventListener(TimerEvent.TIMER, moveIn);
					myTimer.addEventListener(TimerEvent.TIMER, moveOut);
					onStage = false
				} else {
					myTimer.removeEventListener(TimerEvent.TIMER, moveOut);
					myTimer.addEventListener(TimerEvent.TIMER, moveIn);
					onStage = true
				}
				myTimer.start();
			}
		}
		private static function moveIn(event:TimerEvent):void {
			stage.addChild(myPanel);
			if (myPanel.y < 0) {
				myPanel.y = Math.ceil(myPanel.y*0.7);
			} else {
				myTimer.stop();
				myTimer.removeEventListener(TimerEvent.TIMER, moveIn);
			}

		}
		private static function moveOut(event:TimerEvent):void {
			if (myPanel.y > 0-myPanel.height) {
				myPanel.y = -1*Math.ceil(myPanel.height-((myPanel.height-(myPanel.y*-1))*0.7));
			} else {
				stage.removeChild(myPanel);
				myTimer.stop();
				myTimer.removeEventListener(TimerEvent.TIMER, moveOut);
			}
		}
		private static function resizeDebugWindow(event:Event):void {
			myPanel.width = stage.stageWidth;
		}
		public static function update(sectionName:String, myValue:*):void {
			if (stage == null) return;
			for (var n:int=0; n<textFields.length; n++) {
				if (textFields[n].name == sectionName) {
					textFields[n].text = textFields[n].name+" : "+myValue;
					return;
				}
			}
		}
	}
}