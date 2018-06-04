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
#import <Chartboost/Chartboost.h>

@implementation GameOverScene

{
    SKSpriteNode *retryButton;
    SKSpriteNode *menuButton;
    SKSpriteNode *facebookButton;
    SKSpriteNode *twitterButton;
    SKLabelNode *scoreLabel;
    AVAudioPlayer *musicPlayer;
    CGFloat width;
    CGFloat height;
    
    UIImage *highScoreScreenShoot;
    
    BOOL playSounds;
    
    int timesPlayed;
}

- (instancetype)initWithSize:(CGSize)size
             andHighestScore: (int) highestScore
                    andScore: (int) matchScore
               andBrokeScore: (BOOL) brokeScore
             andSoundEnabled: (BOOL) soundEnabled
            andTimesPlayed:(int)timesPlayedGame {
    
    timesPlayed=timesPlayedGame;
    
    if(self = [super initWithSize:size]) {
        width = self.size.width;
        height = self.size.height;
        
        _playerBrokeScore = brokeScore;
        playSounds = soundEnabled;
        
        [self setHighestScore:highestScore];
        [self setMatchScore:matchScore];
        
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"windowBackground"];
        [backgroundImage setSize:CGSizeMake(self.size.width, self.size.height)];
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:backgroundImage];
       
        facebookButton = [self makeFacebookButton];
        [self addChild:facebookButton];
        
        twitterButton = [self makeTwiterButton];
        [self addChild:twitterButton];
         
        retryButton = [self makeRetryButton];
        [self addChild:retryButton];
        
        menuButton = [self makeMenuButton];
        [self addChild:menuButton];
        
        [self makeScoreLabel];
        
        
        if(timesPlayed%3==0){
            [Chartboost showInterstitial:CBLocationHomeScreen];
        }
        
        if(soundEnabled){
            [self playBackgroundMusic:@"gameOverMusic" ofType:@"mp3"];
        }
    }
    
    return self;
}

- (SKSpriteNode *)makeFacebookButton {
    
    SKSpriteNode *facebookNode = [SKSpriteNode spriteNodeWithImageNamed:@"facebookButton"];

    facebookNode.name = @"facebookButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [facebookNode setScale:0.14];
        facebookNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 80);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [facebookNode setScale:0.18];
        facebookNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 110);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [facebookNode setScale:0.2];
        facebookNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 150);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [facebookNode setScale:0.22];
        facebookNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 170);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [facebookNode setScale:0.3];
        facebookNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 250);
    }
    
    return facebookNode;
}

- (SKSpriteNode *)makeTwiterButton {
    
    SKSpriteNode *twitterNode = [SKSpriteNode spriteNodeWithImageNamed:@"twitterButton"];
    
    twitterNode.name = @"twitterButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [twitterNode setScale:0.14];
        twitterNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 150);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [twitterNode setScale:0.18];
        twitterNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 200);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [twitterNode setScale:0.2];
        twitterNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 245);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [twitterNode setScale:0.22];
        twitterNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 280);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [twitterNode setScale:0.3];
        twitterNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 400);
    }
    
    return twitterNode;
}

- (SKSpriteNode *)makeRetryButton {
    
    SKSpriteNode *retryNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton"];
    
    retryNode.name = @"retryButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [retryNode setScale:0.14];
        retryNode.position = CGPointMake(self.size.width/2,self.size.height/2 + 65);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [retryNode setScale:0.18];
        retryNode.position = CGPointMake(self.size.width/2,self.size.height/2 + 70);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [retryNode setScale:0.2];
        retryNode.position = CGPointMake(self.size.width/2,self.size.height/2 + 40);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [retryNode setScale:0.22];
        retryNode.position = CGPointMake(self.size.width/2,self.size.height/2 + 50);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [retryNode setScale:0.3];
        retryNode.position = CGPointMake(self.size.width/2,self.size.height/2 + 50);
    }
    
    return retryNode;
}

- (SKSpriteNode *)makeMenuButton{
    
    SKSpriteNode *menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";

    //iphone 4s
    if (width == 320 && height == 480) {
        [menuNode setScale:0.14];
        menuNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 7);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [menuNode setScale:0.18];
        menuNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 20);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 55);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [menuNode setScale:0.22];
        menuNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 60);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [menuNode setScale:0.3];
        menuNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 100);
    }
    
    return menuNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retryButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.14 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.16 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.18 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        
        SKAction *retry =
        [SKAction runBlock:^{
            GameScene * myScene = [[GameScene alloc] initWithSize:self.size andSound:self->playSounds andTimesPlayed:self->timesPlayed];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            [self stopBackgroundMusic];
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, retry]];
        [retryButton runAction:sequence];
    }
    
    if ([node.name isEqualToString:@"menuButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.14 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.16 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.18 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        
        SKAction *goMenu =
        [SKAction runBlock:^{
            GameMenuScene *myScene = [[GameMenuScene alloc] initWithSize:self.size andSoundEnabled:self->playSounds andTimesPlayed:self->timesPlayed];
        
            
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            [self stopBackgroundMusic];
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, goMenu]];
        [menuButton runAction:sequence];
    }
    
    if ([node.name isEqualToString:@"facebookButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.14 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.16 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.18 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.2 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.22 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        
        [self takeScreenshoot];
        [self saveImage];
        
        SKAction *goFacebook =
        [SKAction runBlock:^{
//                NSString *postText = [NSString stringWithFormat:@"My high score in Magic Flight is: %d pts. Come beat me! Like us:", _highestScore];
//                NSDictionary *userInfoOne = [NSDictionary dictionaryWithObject:postText forKey:@"postText"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatePost" object:self userInfo:userInfoOne];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatePost" object:self];
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, goFacebook]];
        [facebookButton runAction:sequence];
    }
    
    if ([node.name isEqualToString:@"twitterButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.14 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.16 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.18 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.18 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.2 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.2 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.22 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        
        [self takeScreenshoot];
        [self saveImage];
        
        SKAction *goTwitter =
        [SKAction runBlock:^{
//                NSString *postTwitter = [NSString stringWithFormat:@"My high score in Magic Flight is: %d pts. Come beat me! Like us:", _highestScore];
//                NSDictionary *userInfoTwo = [NSDictionary dictionaryWithObject:postTwitter forKey:@"postTwitter"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateTwitter" object:self userInfo:userInfoTwo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateTwitter" object:self];
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, goTwitter]];
        [twitterButton runAction:sequence];
    }
}

- (void)makeScoreLabel{
    
    SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    gameOverLabel.zPosition = 15;
    gameOverLabel.color = [UIColor whiteColor];
    gameOverLabel.text = @"Game Over!";
    
    SKLabelNode* newHighScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    newHighScoreLabel.zPosition = 15;
    newHighScoreLabel.color = [UIColor whiteColor];
    newHighScoreLabel.text = _playerBrokeScore ? [NSString stringWithFormat:@"New HighScore!"]: [NSString stringWithFormat:@"Your Score: %d",[self matchScore]];

    SKLabelNode* scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    scoreLabelNode.zPosition = 15;
    scoreLabelNode.fontColor = [UIColor whiteColor];
    scoreLabelNode.text = [[NSString alloc]initWithFormat:@"HighScore: %d",[self highestScore]];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        gameOverLabel.fontSize = 30;
        gameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 190);
        newHighScoreLabel.fontSize = 30;
        newHighScoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 150);
        scoreLabelNode.fontSize = 30;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 110);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        gameOverLabel.fontSize = 35;
        gameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 220);
        newHighScoreLabel.fontSize = 35;
        newHighScoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 180);
        scoreLabelNode.fontSize = 35;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 140);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        gameOverLabel.fontSize = 40;
        gameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 240);
        newHighScoreLabel.fontSize = 40;
        newHighScoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 190);
        scoreLabelNode.fontSize = 40;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 140);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        gameOverLabel.fontSize = 50;
        gameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 240);
        newHighScoreLabel.fontSize = 50;
        newHighScoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 190);
        scoreLabelNode.fontSize = 50;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 140);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        gameOverLabel.fontSize = 60;
        gameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 320);
        newHighScoreLabel.fontSize = 60;
        newHighScoreLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 250);
        scoreLabelNode.fontSize = 60;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 180);
    }
    
    [self addChild:gameOverLabel];
    [self addChild:newHighScoreLabel];
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

- (void)takeScreenshoot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    highScoreScreenShoot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)saveImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    UIImage *image = highScoreScreenShoot; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [imageData writeToFile:savedImagePath atomically:NO];
}

@end
