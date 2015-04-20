//
//  VerticalSwipeGestureDown.m
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 18/04/15.
//
//

#import "VerticalSwipeGestureDown.h"

@implementation VerticalSwipeGestureDown

#define HORIZ_SWIPE_DRAG_MIN  20
#define VERT_SWIPE_DRAG_MAX   15

- (id)initWithCoder:(NSCoder *)init
{
    //No multiTouch in screen
    [self.view setMultipleTouchEnabled:NO];
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    // startTouchPosition is a property
    self.startTouchPosition = [touch locationInView:self.view];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touch = [touches anyObject];
    
    //Catching the current and last position of the touch in screen
    CGPoint positionInScene = [touch locationInView:self.view];
    CGPoint lastPosition = [touch previousLocationInView:self.view];
    
    if(positionInScene.y < lastPosition.y)
    {
        [self setState:UIGestureRecognizerStateFailed];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:self.view];
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(_startTouchPosition.y - currentTouchPosition.y) >= HORIZ_SWIPE_DRAG_MIN &&
        fabs(self.startTouchPosition.x - currentTouchPosition.x) <= VERT_SWIPE_DRAG_MAX)
    {
        // If touch appears to be a swipe
        if (self.startTouchPosition.y < currentTouchPosition.y)
        {
            [self setState:UIGestureRecognizerStateRecognized];
        }
    }
    else
    {
        [self setState:UIGestureRecognizerStateFailed];
    }
    
    self.startTouchPosition = CGPointZero;
}

@end
