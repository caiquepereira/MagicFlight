//
//  GameScene.h
//  MagicFlight
//

//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameScene : SKScene

-(int)generateGesturesQuantity;

-(void) pauseBackgroundMusic;

-(void) resumeBackgroundMusic;

-(id)initWithSize:(CGSize)size
         andSound:(BOOL)soundEnabled;

@end
