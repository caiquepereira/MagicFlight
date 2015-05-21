//
//  GameTutorialScene.m
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 20/05/15.
//
//

#import "GameTutorialScene.h"
#import <UIKit/UIKit.h>

@implementation GameTutorialScene{
    CGFloat width;
    CGFloat height;
    SKSpriteNode *background;

    
}




-(instancetype)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        width = self.size.width;
        height = self.size.height;
        
        background = [self makeBackground];
        [self addChild:background];
        
    }
    

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(metodoTAl)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    
    return self;
}

- (SKSpriteNode *)makeBackground {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"tutorialpagina1"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [backgroundNode setScale:0.34];
        //backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
        backgroundNode.position = CGPointMake(self.frame.size.width-205, self.frame.size.height-360);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [backgroundNode setScale:1.0];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    

    
    return backgroundNode;
}


-(void)metodoTAl{
    NSLog(@"Swipe deu certo");
}

@end
