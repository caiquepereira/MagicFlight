//
//  GamePausedScene.h
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/20/15.
//
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface GamePausedScene : SKScene

- (GamePausedScene*)initWithSize:(CGSize)size andGameScene: (GameScene*) previousGameScene;

@end
