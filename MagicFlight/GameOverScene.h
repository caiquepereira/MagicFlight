//
//  GameOverScene.h
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/17/15.
//
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

@property (nonatomic) int highestScore;
@property (nonatomic) int matchScore;
@property (nonatomic) BOOL playerBrokeScore;

- (instancetype)initWithSize:(CGSize)size
               andHighestScore: (int) highestScore
                      andScore: (int) matchScore
               andBrokeScore: (BOOL) brokeScore
             andSoundEnabled: (BOOL) soundEnabled;
@end
