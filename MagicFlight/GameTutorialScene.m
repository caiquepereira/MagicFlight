//
//  GameTutorialScene.m
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 20/05/15.
//
//

#import "GameTutorialScene.h"

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
    
    return self;
}

- (SKSpriteNode *)makeBackground {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    
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
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [backgroundNode setScale:2.2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    
    return backgroundNode;
}


@end
