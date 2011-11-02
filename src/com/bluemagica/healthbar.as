package com.bluemagica
{
	/**
	 Created by: Bluemagica
	 Date: 19/4/2009
	 site: blog.bluemagica.com
	 
	 usage:-
	 healthbar(type,current health,maximum health,width,height, automatic, rate, full color,empty color, sprite, frames, number of bubbles);
	*/
	
	
	
	import flash.display.*;
	import flash.errors.InvalidSWFError;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	
	public class healthbar extends Sprite
	{
		private var maxHp:Number = 100;
		private var curHp:Number = 100;
		private var type:Number = 0; //0=rect,1=circle,2=sprite,3=mc
		private var auto:Number = 0; //0=not activated, 1= decrease, 2=increase, 3=both;
		private var wid:Number = 200;
		private var hig:Number = 20;
		private var rate:Number = 5;
		private var fcolor:Number;
		private var ecolor:Number;
		private var alph:int;
		private var spr:Sprite;
		private var frame:Number;
		private var life:Number;
		private var hasMC:Boolean = false;
		private var mcArr:Array = new Array();
		public var border:Number = 0x000000;

		
		private var goto:Number = 100;
		private var blink:Boolean = false;
		private var blinkCol:Boolean = false;
		private var timer:Timer;
		
		private var _textfield:TextField;
		
		public function healthbar(typ:Number=0, chp:Number=100, mhp:Number=100, w:Number=100, h:Number=20, aut:Number=0, rat:Number=1, fcol:Number=0x00cc00, ecol:Number=0xff0000, spri:Sprite=null, frm:Number=1, lif:Number=10)		
		{			
			maxHp = mhp;
			curHp = chp;
			type = typ;
			auto = aut;
			rate = rat;
			wid = w;
			hig = h;
			fcolor = fcol;
			ecolor = ecol;
			spr = spri;
			frame=frm;
			life=lif;
			goto = 0;
			timer = new Timer(100);
			blink=blinkCol=false;
			alph = 1;
			
			if(auto>3 || auto<0)
			{
				auto = 0; 
			}
			if(type>3 || type<0)
			{
				type = 0;
			}
			var format:TextFormat = new TextFormat();
			format.font    = "Tahoma";
			format.color   = 0xFFFFFF;
			format.size    = 12;
			
			_textfield = new TextField();
			_textfield.background       = false;
			_textfield.width = _textfield.height = 1;
			_textfield.autoSize = TextFieldAutoSize.CENTER;
			_textfield.defaultTextFormat = format;
			_textfield.mouseEnabled      = false;
			_textfield.selectable        = false;

			// Vertical
			if (hig > wid) {
				_textfield.x = (wid >> 1);
				_textfield.y = -(hig >> 1);
			}
			// Horizontal
			else {
				_textfield.x = (wid >> 1);
				_textfield.y = (hig >> 1);
			}
//			this.addChild(_textfield);

			this.addEventListener(Event.ENTER_FRAME,eframe,false,0,true);
			timer.addEventListener(TimerEvent.TIMER,tick);
			this.update(curHp);

			}
			
		
		private function tick(e:TimerEvent):void
		{
/*			if(blinkCol==true)
			{
				alph=0;
				blinkCol=false;
			}
			else if(blinkCol==false)
			{
				alph=1;
				blinkCol=true;
			}*/
			this.update(curHp);
		}
		
		private function eframe(e:Event):void
		{
			if(auto>0)
			{
				if(auto==1)
				{
					if((curHp-rate)>=0)
					  curHp-=rate;
					else
					  curHp=0;
				}
				else if(auto==2)
				{
					if((curHp+rate)<=maxHp)
						curHp+=rate;
					else
						curHp = maxHp;
				}
				else if(auto==3)
				{
					if(goto==0 && (curHp-rate)>=0)
						curHp-=rate;
					else if(goto==0 && (curHp-rate)<0)
					{
						curHp=0;
						goto=maxHp;
					}
					if(goto==maxHp && (curHp+rate)<=maxHp)
						curHp+=rate;
					else if(goto==maxHp && (curHp+rate)>maxHp)
					{
						curHp=maxHp;
						goto=0;
					}
				}
				this.update(curHp);
			}
			else if((curHp/maxHp*100)<=30 && blink==false)
			{
				blink = true;
				timer.start()
			}
			else if((curHp/maxHp*100)>30 && blink==true)
			{
				blink = false;
				alph=1;
				timer.stop();
			}
		}
		
		
		
		public function update(currHp:Number):void
		{
			if(currHp<0)
			{
				currHp = 0;
			}
			else if(curHp>maxHp)
			{
				currHp = maxHp;
			}
			else
			{
				curHp = currHp;
			}
			if(type==0)
			{
				this.graphics.clear();
				this.graphics.beginFill(border);
				if(wid<hig)
					this.graphics.drawRect(0,0,wid+2,-(hig+2));
				else
					this.graphics.drawRect(0,0,wid+2,hig+2);
				this.graphics.endFill();
				this.graphics.beginFill(newEcol(),alph);
				if(wid>=hig)
					this.graphics.drawRect(1,1,(wid/maxHp)*curHp,hig);
				else
					this.graphics.drawRect(1,-1,wid,-(hig/maxHp)*curHp);
				this.graphics.endFill();
				_textfield.text = Math.floor(curHp).toString();
			}
			else if(type==1)
			{
				var startAngle:Number = 90;
				var arc:Number = (360/maxHp)*curHp;
				var radius:Number = wid/2;
				var yRadius:Number = hig/2;
				var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number, ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
				if(Math.abs(arc)>360)
					arc = 360;
				segs = Math.ceil(Math.abs(arc)/45);
				segAngle = arc/segs;
				theta = -(segAngle/180)*Math.PI;
				angle = -(startAngle/180)*Math.PI;
				if (segs>0 && currHp>0)
				{
					ax = Math.cos(startAngle/180*Math.PI)*radius;
					ay = Math.sin(-startAngle/180*Math.PI)*yRadius;
					this.graphics.clear();
					this.graphics.lineStyle(1,border);
					this.graphics.beginFill(newEcol(), alph);
					this.graphics.lineTo(ax, ay);
					for (var i:Number = 0; i<segs; i++)
					{
						angle += theta;
						angleMid = angle-(theta/2);
						bx = Math.cos(angle)*radius;
						by = Math.sin(angle)*yRadius;
						cx = Math.cos(angleMid)*(radius/Math.cos(theta/2));
						cy = Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
						this.graphics.curveTo(cx, cy, bx, by);
					}
				this.graphics.lineTo(0,0);
				this.graphics.endFill();
				}
			}
			else if(type==2)
			{
				if(hasMC==false)
				{
					for(var mi:Number=0; mi<Math.round(life);mi++)
					{
					 	var tempSpr:Sprite = new Sprite();
						tempSpr.x = mi*(wid/4)*5;
						tempSpr.y = 0;
						mcArr.push(tempSpr);
						addChild(tempSpr);
					}
					hasMC = true;
				}
				var tCount:Number = Math.ceil((life*frame)/maxHp*curHp);
				for(var j:Number=0; j<mcArr.length; j++)
				{
					if(tCount>=frame)
					{
						mcArr[j].gotoAndStop(frame);
						tCount-=frame;
					}
					else if(tCount>=1)
					{
						mcArr[j].gotoAndStop(tCount);
						tCount=0;
					}
					else
						mcArr[j].gotoAndStop(1);
				 	mcArr[j].alpha=alph;
				}
			}
		}
		
		private function newEcol():Number
		{
			var r1:Number = fcolor >> 16;
			var g1:Number = (fcolor-(r1 << 16)) >> 8;
			var b1:Number = (fcolor-(r1 << 16)-(g1 << 8));
			var r2:Number = ecolor >> 16;
			var g2:Number = (ecolor-(r2 << 16)) >> 8;
			var b2:Number = (ecolor-(r2 << 16)-(g2 << 8));
			var r3:Number = r2+(r1-r2)*((curHp/maxHp*100)/100);
			var g3:Number = g2+(g1-g2)*((curHp/maxHp*100)/100);
			var b3:Number = b2 + (b1 - b2) * ((curHp / maxHp * 100) / 100);
			return (r3 << 16 | g3 << 8 | b3);
//			return('0x' + (r3 << 16 | g3 << 8 | b3).toString(16));			
		}
		
		public function getPower():Number
		{
			return curHp;
		}
		
	}
}