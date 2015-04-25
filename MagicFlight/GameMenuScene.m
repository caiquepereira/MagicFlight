//
//  GameMenuScene.m
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/17/15.
//
//


#import <AVFoundation/AVFoundation.h>
#import "GameMenuScene.h"
#import "GameScene.h"
#import "GameMenuSceneViewController.h"

@implementation GameMenuScene {
    SKSpriteNode *startButton;
    SKSpriteNode *logo;
    SKSpriteNode *audioControl;
    AVAudioPlayer *musicPlayer;
    SKSpriteNode *gameCenterButton;
    NSString *leaderboardIdentifier;
    
    GameMenuSceneViewController *menuViewController;
    
    BOOL playSound;
}

- (instancetype)initWithSize:(CGSize)size
             andSoundEnabled:(BOOL)soundEnabled{
    
    if(self = [super initWithSize:size]){
        playSound = soundEnabled;
        
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"startScreen"];
        [backgroundImage setSize:CGSizeMake(self.size.width, self.size.height)];
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        [self addChild:backgroundImage];
        
        startButton = [self makeStartButton];
        [self addChild:startButton];
        
        logo = [self makeLogo];
        [self addChild:logo];
        
        if (playSound){
            audioControl = [self makeAudioIconActived];
            [self addChild:audioControl];
            [self playBackgroundMusic:@"menuMusic" ofType:@"mp3"];
        } else {
            audioControl = [self makeAudioIconInactive];
            [self addChild:audioControl];
        }
        
        gameCenterButton = [self makeGameCenterButton];
        [self addChild:gameCenterButton];
        
        leaderboardIdentifier=@"Best_Score_Of_The_App";
        
    }
    return self;
}

- (SKSpriteNode *) makeStartButton {
    
    SKSpriteNode *startNode = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
    
    startNode.name = @"startButton";
    startNode.zPosition = 2;
    
    [startNode setScale:0.5];
    startNode.position = CGPointMake(self.size.width/2, logo.position.y + 100);
    
    return startNode;
}

- (SKSpriteNode *) makeLogo {
    
    SKSpriteNode *logoNode = [SKSpriteNode spriteNodeWithImageNamed:@"LOGO"];
    
    logoNode.name = @"logo";
    
    [logoNode setScale:0.5];
    logoNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 80);
    
    return logoNode;
}

- (SKSpriteNode *) makeGameCenterButton {
    
    SKSpriteNode *gameCenterNode = [SKSpriteNode spriteNodeWithImageNamed:@"gameCenterButton"];
    
    gameCenterNode.name = @"gameCenterButton";
    
    [gameCenterNode setScale:0.28];
    gameCenterNode.position = CGPointMake(startButton.size.width + logo.size.height/2, startButton.size.height + 20);
    
    return gameCenterNode;
}

- (SKSpriteNode *) makeAudioIconActived {
    
    SKSpriteNode *audioActiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioActive"];
    
    audioActiveNode.name = @"audioActive";
    audioActiveNode.zPosition = 2;
    
    [audioActiveNode setScale:1];
    audioActiveNode.position = CGPointMake(startButton.size.width - 140, startButton.size.height + 20);
    
    return audioActiveNode;
}

- (SKSpriteNode *) makeAudioIconInactive {
    
    SKSpriteNode *audioInactiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioInactive"];
    
    audioInactiveNode.name = @"audioInactive";
    
    [audioInactiveNode setScale:1.6];
    audioInactiveNode.position = CGPointMake(startButton.size.width - 150, startButton.size.height + 20);
    
    return audioInactiveNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"startButton"]) {
        SKAction *startGame = [SKAction runBlock:^{
            GameScene * myScene = [[GameScene alloc] initWithSize:self.size andSound:playSound];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self stopBackgroundMusic];
            [self.view presentScene:myScene transition: reveal];
        }];
        
        [startButton runAction:startGame];
    }
    
    if ([node.name isEqualToString:@"gameCenterButton"] && [GKLocalPlayer localPlayer].authenticated) {
        menuViewController = [[GameMenuSceneViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:menuViewController
                                                                                                 animated:YES completion:nil];
    }else if ([node.name isEqualToString:@"gameCenterButton"] && [GKLocalPlayer localPlayer].authenticated == NO){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"You are not logged in Game Center."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    
    if ([node.name isEqualToString:@"audioActive"] || [node.name isEqualToString:@"audioInactive"]) {
        SKAction *soundControl = [SKAction runBlock:^{
            [self soundControl];
        }];
        
        [self runAction:soundControl];
    }
}

- (void) soundControl{
    if(playSound){
        [audioControl removeFromParent];
        audioControl = [self makeAudioIconInactive];
        [self addChild: audioControl];
        [self stopBackgroundMusic];
        playSound = NO;
        
    } else {
        [audioControl removeFromParent];
        audioControl = [self makeAudioIconActived];
        [self addChild: audioControl];        
        [self playBackgroundMusic:@"menuMusic" ofType:@"mp3"];
        playSound = YES;
    
    }
}

-(void)stopBackgroundMusic {
    [musicPlayer stop];
}

-(void)playBackgroundMusic: (NSString *)fileName ofType:(NSString *)type {
    if ([musicPlayer isPlaying]) {
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    musicPlayer.numberOfLoops = -1;
    [musicPlayer play];
}

@end
