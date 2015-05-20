//
//  GamePausedScene.m
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/20/15.
//
//

#import "GamePausedScene.h"
#import "GameMenuScene.h"
#import "GameScene.h"

@implementation GamePausedScene{
    SKSpriteNode *playButton;
    SKSpriteNode *menuButton;
    SKSpriteNode *retryButton;
    SKSpriteNode *audioControl;
    SKSpriteNode *activeSoundButton;
    SKSpriteNode *inactiveSoundButton;
    SKLabelNode *pauseLabel;
    CGFloat width;
    CGFloat height;
    int timesPlayed;
    
    GameScene *gameScene;
    BOOL playSound;
}

- (instancetype)initWithSize:(CGSize)size
                andGameScene:(GameScene *) previousGameScene{
    
    if(self = [super initWithSize:size]){
        width = self.size.width;
        height = self.size.height;
        
        playSound = previousGameScene.playSounds;
        
        gameScene = previousGameScene;
        
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"windowBackground"];
        [backgroundImage setSize:CGSizeMake(self.size.width, self.size.height)];
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:backgroundImage];
        
        retryButton = [self makeRetryButton];
        [self addChild:retryButton];
        
        playButton = [self makePlayButton];
        [self addChild:playButton];
        
        menuButton = [self makeMenuButton];
        [self addChild:menuButton];
        
        pauseLabel= [self makePauseLabel];
        [self addChild:pauseLabel];
        
        activeSoundButton = [self makeAudioIconActive];
        [self addChild:activeSoundButton];
        
        if (playSound){
            audioControl = [self makeAudioIconActive];
            [self addChild:audioControl];
//            [self playBackgroundMusic:@"menuMusic" ofType:@"mp3"];
        } else {
            audioControl = [self makeAudioIconInactive];
            [self addChild:audioControl];
        }
        
    }
    
    return self;
}

- (SKSpriteNode*) makeRetryButton{
    
    SKSpriteNode* retryNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton"];
    
    retryNode.name = @"retryButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [retryNode setScale:0.15];
        retryNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [retryNode setScale:0.18];
        retryNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [retryNode setScale:0.2];
        retryNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [retryNode setScale:0.22];
        retryNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [retryNode setScale:0.3];
        retryNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    
    return retryNode;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode *menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [menuNode setScale:0.15];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [menuNode setScale:0.18];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [menuNode setScale:0.22];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [menuNode setScale:0.3];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    
    return menuNode;
}

- (SKSpriteNode*) makePlayButton{
    
    SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    
    playNode.name = @"playButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [playNode setScale:0.15];
        playNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 80);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [playNode setScale:0.18];
        playNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 92);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [playNode setScale:0.2];
        playNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 110);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [playNode setScale:0.22];
        playNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 120);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [playNode setScale:0.3];
        playNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 160);
    }
    
    return playNode;
}

- (SKLabelNode *) makePauseLabel{
    SKLabelNode *pauseLabelNode = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    pauseLabelNode.name = @"pauseLabel";
    pauseLabelNode.text = @"Paused!";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        pauseLabelNode.fontSize = 50;
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 60);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        pauseLabelNode.fontSize = 50;
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 100);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        pauseLabelNode.fontSize = 80;
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 150);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        pauseLabelNode.fontSize = 100;
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 150);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        pauseLabelNode.fontSize = 100;
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 200);
    }
    
    return pauseLabelNode;
}

- (SKSpriteNode *)makeAudioIconActive {
    
    SKSpriteNode *audioActiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioActive"];
    
    audioActiveNode.name = @"audioActive";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [audioActiveNode setScale:0.15];
        audioActiveNode.position = CGPointMake(self.size.width/2, menuButton.position.y - audioActiveNode.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [audioActiveNode setScale:0.18];
        audioActiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - 185);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 220);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [audioActiveNode setScale:0.22];
        audioActiveNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 240);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [audioActiveNode setScale:0.3];
        audioActiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    
    return audioActiveNode;
}

- (SKSpriteNode *)makeAudioIconInactive {
    
    SKSpriteNode *audioInactiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioInactive"];
    
    audioInactiveNode.name = @"audioInactive";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [audioInactiveNode setScale:0.15];
        audioInactiveNode.position = CGPointMake(self.size.width/2, menuButton.position.y - audioInactiveNode.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [audioInactiveNode setScale:0.18];
        audioInactiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - 185);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 220);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [audioInactiveNode setScale:0.22];
        audioInactiveNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 240);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [audioInactiveNode setScale:0.3];
        audioInactiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    
    return audioInactiveNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"playButton"]) {
        SKAction * resumeGame = [SKAction runBlock:^{
            GameScene * myScene = gameScene;
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            
            myScene.playSounds = playSound;
            
            if (playSound){
                [gameScene resumeBackgroundMusic];
            } else {
                [gameScene stopBackgroundMusic];
            }
        }];
        
        [playButton runAction:resumeGame];
    }
    
    if ([node.name isEqualToString:@"retryButton"]) {
        SKAction * retryGame = [SKAction runBlock:^{
            GameScene * myScene = [[GameScene alloc] initWithSize:self.size andSound:playSound andTimesPlayed:timesPlayed];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            
        }];
        
        [retryButton runAction:retryGame];
    }
    
    if ([node.name isEqualToString:@"menuButton"]) {
        if ([node.name isEqualToString:@"menuButton"]) {
            SKAction * goMenu = [SKAction runBlock:^{
                GameMenuScene * myScene = [[GameMenuScene alloc] initWithSize:self.size andSoundEnabled:playSound andTimesPlayed:timesPlayed];
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                [self.view presentScene:myScene transition: reveal];
            }];
            
            [menuButton runAction:goMenu];
        }
    }
    
    if ([node.name isEqualToString:@"audioActive"] || [node.name isEqualToString:@"audioInactive"]){
        [self soundControl];
    }
    
}

- (void) soundControl{
    if(playSound){
        [audioControl removeFromParent];
        audioControl = [self makeAudioIconInactive];
        [self addChild: audioControl];
        playSound = NO;
        
    } else {
        [audioControl removeFromParent];
        audioControl = [self makeAudioIconActive];
        [self addChild: audioControl];
        playSound = YES;
    }
}

@end
