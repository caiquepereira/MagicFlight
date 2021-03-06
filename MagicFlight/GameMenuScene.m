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
#import "GameTutorialScene.h"


@implementation GameMenuScene {
    SKSpriteNode *startButton;
    SKSpriteNode *logo;
    SKSpriteNode *audioControl;
    AVAudioPlayer *musicPlayer;
    SKSpriteNode *gameCenterButton;
    NSString *leaderboardIdentifier;
    CGFloat width;
    CGFloat height;
    int timesPlayed;
    
    GameMenuSceneViewController *menuViewController;
    
    BOOL playSound;
}

- (instancetype)initWithSize:(CGSize)size
             andSoundEnabled:(BOOL)soundEnabled
              andTimesPlayed:(int)timesPlayedGame   {
    
    if(timesPlayed==0){
        timesPlayed=0;
    }else{
        timesPlayed=timesPlayedGame;
    }

    
    if(self = [super initWithSize:size]){
        width = self.size.width;
        height = self.size.height;
        
        playSound = soundEnabled;
        
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"startScreen"];
        [backgroundImage setSize:CGSizeMake(self.size.width, self.size.height)];
        
        //iPhone X
        if (width == 375 && height == 812) {
            [backgroundImage setSize:CGSizeMake(self.size.width+190, self.size.height)];
        }
        
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
        
        leaderboardIdentifier=@"Best_Score_Of_Magic_Flight";
        
    }
    return self;
}

- (SKSpriteNode *) makeStartButton {
    
    SKSpriteNode *startNode = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
    
    startNode.name = @"startButton";
    startNode.zPosition = 2;
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [startNode setScale:0.15];
        startNode.position = CGPointMake(self.size.width/2, logo.position.y + 80);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [startNode setScale:0.15];
        startNode.position = CGPointMake(self.size.width/2, logo.position.y + 65);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [startNode setScale:0.17];
        startNode.position = CGPointMake(self.size.width/2, logo.position.y + 80);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [startNode setScale:0.2];
        startNode.position = CGPointMake(self.size.width/2, self.size.height - 650);
    }
    //iphone X
    else if (width == 375 && height == 812) {
        [startNode setScale:0.2];
        startNode.position = CGPointMake(self.size.width/2, self.size.height - 720);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [startNode setScale:0.3];
        startNode.position = CGPointMake(self.size.width/2, logo.position.y + 130);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [startNode setScale:0.3];
        startNode.position = CGPointMake(self.size.width/2, logo.position.y + 130);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [startNode setScale:0.4];
        startNode.position = CGPointMake(self.size.width/2, logo.position.y + 130);
    }
    
    return startNode;
}

- (SKSpriteNode *) makeLogo {
    
    SKSpriteNode *logoNode = [SKSpriteNode spriteNodeWithImageNamed:@"LOGO"];
    
    logoNode.name = @"logo";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [logoNode setScale:0.355];
        logoNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 30);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [logoNode setScale:0.425];
        logoNode.position = CGPointMake(self.size.width/2 + 5, self.size.height/2 - 69);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [logoNode setScale:0.5];
        logoNode.position = CGPointMake(self.size.width/2 + 6, self.size.height/2 - 82);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [logoNode setScale:0.55];
        logoNode.position = CGPointMake(self.size.width/2 + 7, self.size.height/2 - 90);
    }
    //iphone X
    else if (width == 375 && height == 812) {
        [logoNode setScale:0.55];
        logoNode.position = CGPointMake(self.size.width/2 + 7, self.size.height/2 - 90);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [logoNode setScale:0.9];
        logoNode.position = CGPointMake(self.size.width/2 + 6, self.size.height/2 - 110);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [logoNode setScale:0.9];
        logoNode.position = CGPointMake(self.size.width/2 + 6, self.size.height/2 - 110);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [logoNode setScale:1.1];
        logoNode.position = CGPointMake(self.size.width/2 + 6, self.size.height/2 - 130);
    }

    return logoNode;
}

- (SKSpriteNode *) makeGameCenterButton {
    
    SKSpriteNode *gameCenterNode = [SKSpriteNode spriteNodeWithImageNamed:@"gameCenterButton"];
    
    gameCenterNode.name = @"gameCenterButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [gameCenterNode setScale:0.15];
        gameCenterNode.position = CGPointMake(self.size.width - 65, startButton.position.y);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [gameCenterNode setScale:0.15];
        gameCenterNode.position = CGPointMake(self.size.width - 70, startButton.position.y);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [gameCenterNode setScale:0.17];
        gameCenterNode.position = CGPointMake(self.size.width - 80, startButton.size.height - 5);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [gameCenterNode setScale:0.2];
        gameCenterNode.position = CGPointMake(self.size.width - 90, startButton.position.y);
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [gameCenterNode setScale:0.2];
        gameCenterNode.position = CGPointMake(self.size.width/4, self.size.height - 720);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [gameCenterNode setScale:0.3];
        gameCenterNode.position = CGPointMake(self.size.width/4, startButton.position.y);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [gameCenterNode setScale:0.3];
        gameCenterNode.position = CGPointMake(self.size.width/4, startButton.position.y);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [gameCenterNode setScale:0.4];
        gameCenterNode.position = CGPointMake(self.size.width/4, startButton.position.y);
    }
    
    return gameCenterNode;
}

- (SKSpriteNode *) makeAudioIconActived {
    
    SKSpriteNode *audioActiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioActive"];
    
    audioActiveNode.name = @"audioActive";
    //audioActiveNode.zPosition = 2;
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [audioActiveNode setScale:0.15];
        audioActiveNode.position = CGPointMake(startButton.size.width - 10, startButton.position.y);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [audioActiveNode setScale:0.15];
        audioActiveNode.position = CGPointMake(self.size.width - 250, startButton.position.y);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [audioActiveNode setScale:0.17];
        audioActiveNode.position = CGPointMake(self.size.width - 295, startButton.size.height - 5);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width - 330, startButton.position.y);
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/4*3, self.size.height - 720);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [audioActiveNode setScale:0.3];
        audioActiveNode.position = CGPointMake(self.size.width/4*3, startButton.position.y);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [audioActiveNode setScale:0.3];
        audioActiveNode.position = CGPointMake(self.size.width/4*3, startButton.position.y);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [audioActiveNode setScale:0.4];
        audioActiveNode.position = CGPointMake(self.size.width/4*3, startButton.position.y);
    }
    
    return audioActiveNode;
}

- (SKSpriteNode *) makeAudioIconInactive {
    
    SKSpriteNode *audioInactiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioInactive"];
    
    audioInactiveNode.name = @"audioInactive";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [audioInactiveNode setScale:0.15];
        audioInactiveNode.position = CGPointMake(startButton.size.width - 10, startButton.position.y);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [audioInactiveNode setScale:0.15];
        audioInactiveNode.position = CGPointMake(self.size.width - 250, startButton.position.y);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [audioInactiveNode setScale:0.17];
        audioInactiveNode.position = CGPointMake(self.size.width - 295, startButton.size.height - 5);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width - 330, startButton.position.y);
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width/4*3, self.size.height - 720);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [audioInactiveNode setScale:0.3];
        audioInactiveNode.position = CGPointMake(self.size.width/4*3, startButton.position.y);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [audioInactiveNode setScale:0.3];
        audioInactiveNode.position = CGPointMake(self.size.width/4*3, startButton.position.y);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [audioInactiveNode setScale:0.4];
        audioInactiveNode.position = CGPointMake(self.size.width/4*3, startButton.position.y);
    }
    
    return audioInactiveNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"startButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone x
        else if (width == 375 && height == 812) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //ipad 9.7
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //ipad 10.5
        else if (width == 834 && height == 1112) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //ipad 12.9
        else if (width == 1024 && height == 1366) {
            scaleFirst = [SKAction scaleTo:0.38 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.4 duration:0.1];
        }

        SKAction *startGame = [SKAction runBlock:^{
            
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) { // app already launched
            
                GameScene *myScene = [[GameScene alloc] initWithSize:self.size andSound:self->playSound andTimesPlayed:self->timesPlayed];
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                [self stopBackgroundMusic];
                [self.view presentScene:myScene transition: reveal];
            
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                [[NSUserDefaults standardUserDefaults] synchronize]; // This is the first launch ever
                
                GameTutorialScene *tutorialScene = [[GameTutorialScene alloc] initWithSize:self.size andSound:self->playSound andTimesPlayed:self->timesPlayed];
                SKTransition *reveal2 = [SKTransition flipHorizontalWithDuration:0.5];
                [self stopBackgroundMusic];
                [self.view presentScene:tutorialScene transition: reveal2];

            }
            

        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, startGame]];
        [startButton runAction:sequence];
    }
    
    if ([node.name isEqualToString:@"gameCenterButton"] && [GKLocalPlayer localPlayer].authenticated) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone x
        else if (width == 375 && height == 812) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //ipad 9.7
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //ipad 10.5
        else if (width == 834 && height == 1112) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //ipad 12.9
        else if (width == 1024 && height == 1366) {
            scaleFirst = [SKAction scaleTo:0.38 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.4 duration:0.1];
        }

        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd]];
        [gameCenterButton runAction:sequence];
        
        menuViewController = [[GameMenuSceneViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:menuViewController
                                                                                                 animated:YES completion:nil];
    }else if ([node.name isEqualToString:@"gameCenterButton"] && [GKLocalPlayer localPlayer].authenticated == NO){
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone x
        else if (width == 375 && height == 812) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //ipad 9.7
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //ipad 10.5
        else if (width == 834 && height == 1112) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //ipad 12.9
        else if (width == 1024 && height == 1366) {
            scaleFirst = [SKAction scaleTo:0.38 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.4 duration:0.1];
        }
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd]];
        [gameCenterButton runAction:sequence];
        
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
            SKAction *scaleFirst;
            SKAction *scaleEnd;
            
            //iphone 4s
            if (self->width == 320 && self->height == 480) {
                scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
            }
            //iphone 5 e 5s
            else if (self->width == 320 && self->height == 568) {
                scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
            }
            //iphone 6
            else if (self->width == 375 && self->height == 667) {
                scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
            }
            //iphone 6 plus
            else if (self->width == 414 && self->height == 736) {
                scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
            }
            //iphone x
            else if (self->width == 375 && self->height == 812) {
                scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
            }
            //ipad 9.7
            else if (self->width == 768 && self->height == 1024) {
                scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
            }
            //ipad 10.5
            else if (self->width == 834 && self->height == 1112) {
                scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
            }
            //ipad 12.9
            
            else if (self->width == 1024 && self->height == 1366) {
                scaleFirst = [SKAction scaleTo:0.38 duration:0.1];
                scaleEnd = [SKAction scaleTo:0.4 duration:0.1];
            }
            
            SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd]];
            [self->audioControl runAction:sequence];
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
