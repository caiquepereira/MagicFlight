//
//  GameTutorialScene.h
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 20/05/15.
//
//

#import <SpriteKit/SpriteKit.h>

@interface GameTutorialScene : SKScene

-(instancetype)initWithSize:(CGSize)size andSound:(BOOL)soundEnabled andTimesPlayed:(int)timesPlayedGame;

@end
