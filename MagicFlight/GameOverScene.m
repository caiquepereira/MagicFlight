//
//  GameOverScene.m
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/17/15.
//
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "GameMenuScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation GameOverScene

{
    SKSpriteNode* retryButton;
    SKSpriteNode* menuButton;
    SKLabelNode* scoreLabel;
    AVAudioPlayer *musicPlayer;
    BOOL playSounds;
    
}

- (instancetype)initWithSize:(CGSize)size
             andHighestScore: (int) highestScore
                    andScore: (int) matchScore
               andBrokeScore: (BOOL) brokeScore
             andSoundEnabled: (BOOL) soundEnabled{
    
    if(self = [super initWithSize:size]){
        _playerBrokeScore=brokeScore;
        playSounds = soundEnabled;
        
        [self setHighestScore:highestScore];
        [self setMatchScore:matchScore];
        
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"windowBackground"];
        [backgroundImage setSize:CGSizeMake(self.size.width, self.size.height)];
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:backgroundImage];
       
        retryButton = [self makeRetryButton];
        [self addChild:retryButton];
        
        menuButton = [self makeMenuButton];
        [self addChild:menuButton];
        
        [self makeScoreLabel];
        
        if(soundEnabled){
            [self playBackgroundMusic:@"gameOverMusic" ofType:@"mp3"];
        }
    
    }
    
    return self;
}

- (SKSpriteNode*) makeRetryButton{
    
    SKSpriteNode* retryNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton"];
    
    retryNode.name = @"retryButton";
    
    [retryNode setScale:0.4];
    retryNode.position = CGPointMake(self.size.width/2,self.size.height/2);
    
    return retryNode;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";
    
    [menuNode setScale:0.6];
    menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    
    return menuNode;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retryButton"]) {
        SKAction * retry =
        [SKAction runBlock:^{
            GameScene * myScene = [[GameScene alloc] initWithSize:self.size andSound:playSounds];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            [self stopBackgroundMusic];
        }];
        
        [retryButton runAction:retry];
    }
    
    if ([node.name isEqualToString:@"menuButton"]) {
        SKAction * goMenu =
        [SKAction runBlock:^{
            GameMenuScene * myScene = [[GameMenuScene alloc] initWithSize:self.size andSoundEnabled:playSounds];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            [self stopBackgroundMusic];
        }];
        
        [menuButton runAction:goMenu];
    }
}

- (void) makeScoreLabel{
    
    SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    gameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 240);
    gameOverLabel.zPosition = 15;
    gameOverLabel.color = [UIColor whiteColor];
    gameOverLabel.fontSize = 30;
    gameOverLabel.text = @"Game Over!";
    [self addChild:gameOverLabel];
    
    SKLabelNode* newHighScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    newHighScoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 190);
    newHighScoreLabel.zPosition = 15;
    newHighScoreLabel.color = [UIColor whiteColor];
    newHighScoreLabel.fontSize = 30;
    newHighScoreLabel.text = _playerBrokeScore ? [NSString stringWithFormat:@"New HighScore!"] :
                                                   [NSString stringWithFormat:@"Your Score: %d",[self matchScore]];
    
    [self addChild:newHighScoreLabel];
    
    SKLabelNode* scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 140);
    scoreLabelNode.zPosition = 15;
    scoreLabelNode.fontColor = [UIColor whiteColor];
    scoreLabelNode.fontSize = 30;
    scoreLabelNode.text = [[NSString alloc]initWithFormat:@"HighScore: %d",[self highestScore]];
    
    [self addChild:scoreLabelNode];
}

-(void)stopBackgroundMusic {
    [musicPlayer stop];
}

-(void)playBackgroundMusic: (NSString *)fileName ofType:(NSString *) type {
    if ([musicPlayer isPlaying]) {
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    musicPlayer.numberOfLoops = -1;
    [musicPlayer play];
}
@end