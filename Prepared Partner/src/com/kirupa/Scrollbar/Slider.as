package com.kirupa.Scrollbar
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * Represents the base functionality for Sliders.
     * 
     * Broadcasts 1 event:
     * -SliderEvent.CHANGE
     */
    public class Slider extends Sprite
    {
        // elements
        protected var track:Sprite;
        protected var marker:Sprite;
        
        // percentage
        protected var percentage:Number = 0;
        /**
         * The percent is represented as a value between 0 and 1.
         */
        public function get percent():Number { return percentage; }
        /**
         * The percent is represented as a value between 0 and 1.
         */
        public function set percent( p:Number ):void
        {
            percentage = Math.min( 1, Math.max( 0, p ) );
            marker.y = percentage * (track.height - marker.height);
                        
            dispatchEvent( new SliderEvent( SliderEvent.CHANGE, percentage ) );
        }
        
        /**
         * Constructor
         */
        public function Slider()
        {
            createElements();
        }
        
        // ends the sliding session
        protected function stopSliding( e:MouseEvent ):void
        {
            marker.stopDrag();
            stage.removeEventListener( MouseEvent.MOUSE_MOVE, updatePercent );
            stage.removeEventListener( MouseEvent.MOUSE_UP, stopSliding );
        }        
        // updates the data to reflect the visuals
        protected function updatePercent( e:MouseEvent ):void
        {
            e.updateAfterEvent();
            percentage = marker.y / (track.height - marker.height);
            
            dispatchEvent( new SliderEvent( SliderEvent.CHANGE, percentage ) );
        }
                
        //  Executed when the marker is pressed by the user.
        protected function markerPress( e:MouseEvent ):void
        {
            marker.startDrag( false, new Rectangle( 0, 0, 0, track.height - marker.height ) );
            stage.addEventListener( MouseEvent.MOUSE_MOVE, updatePercent );
            stage.addEventListener( MouseEvent.MOUSE_UP, stopSliding );
        } 
        
        /**
         * Creates and initializes the marker/track elements.
         */
        protected function createElements():void
        {
            track = new Sprite();
            marker = new Sprite();
            
            track.graphics.beginFill( 0xCCCCCC, 1 );
            track.graphics.drawRect(0, 0, 10, 580);
            track.graphics.endFill();
            
            marker.graphics.beginFill( 0x333333, 1 );
            marker.graphics.drawRect(0, 0, 10, 15);
            marker.graphics.endFill();
            
            marker.addEventListener( MouseEvent.MOUSE_DOWN, markerPress );
            
            addChild( track );
            addChild( marker );
        }
    }
}