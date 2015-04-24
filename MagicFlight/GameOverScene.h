//
//  GameOverScene.h
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/17/15.
//
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

@property (nonatomic) int scoreLbl;

- (instancetype)initWithSize:(CGSize)size
             andHighestScore: (int) score;

@end
