//
//  GameTutorialScene.h
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 20/05/15.
//
//

#import <SpriteKit/SpriteKit.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>


@interface GameTutorialScene : SKScene

-(instancetype)initWithSize:(CGSize)size andSound:(BOOL)soundEnabled andTimesPlayed:(int)timesPlayedGame;

@end
