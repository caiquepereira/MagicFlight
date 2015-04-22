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
@property (nonatomic) int lastScoreLbl;

- (instancetype)initWithSize:(CGSize)size
            WithHighestScore: (int) score
               WithLastScore: (int) lastScore;

@end
