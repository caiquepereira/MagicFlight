//
//  horizontalSwipeGestureToLeft.m
//  MagicFlight
//
//  Created by Ruyther Parente Da Costa on 4/17/15.
//
//

#import "HorizontalSwipeGestureToLeft.h"

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX   20

@implementation HorizontalSwipeGestureToLeft

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
    
    if(positionInScene.x > lastPosition.x)
    {
        [self setState:UIGestureRecognizerStateFailed];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *aTouch = [touches anyObject];
    CGPoint currentTouchPosition = [aTouch locationInView:self.view];
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(_startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabs(self.startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
    {
        // If touch appears to be a swipe
        if (self.startTouchPosition.x > currentTouchPosition.x)
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
