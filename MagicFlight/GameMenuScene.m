//
//  GameMenuScene.m
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/17/15.
//
//

#import "GameMenuScene.h"
#import "GameScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation GameMenuScene
{
    SKSpriteNode* playButton;
    AVAudioPlayer *musicPlayer;
}

- (instancetype)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        playButton = [self makeMenuButton];
        [self addChild:playButton];
        
        [self playBackgroundMusic:@"menuMusic" ofType:@"mp3"];
        
    }
    return self;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    
    menuNode.name = @"playButton";
    
    [menuNode setScale:0.5];
    menuNode.position = CGPointMake(self.size.width/2,self.size.height/2);
    
    return menuNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"playButton"]) {
        SKAction * startGame = [SKAction runBlock:^{
            GameScene * myScene = [[GameScene alloc] initWithSize:self.size];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self stopBackgroundMusic];
            [self.view presentScene:myScene transition: reveal];
        }];
        
        [playButton runAction:startGame];
    }
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
