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
    
    GameScene *gameScene;
    BOOL playSound;
}

- (instancetype)initWithSize:(CGSize)size
                andGameScene:(GameScene *) previousGameScene{
    if(self = [super initWithSize:size]){
        width = self.size.width;
        height = self.size.height;
        
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
        
        inactiveSoundButton = [self makeAudioIconInactive];
        [self addChild:inactiveSoundButton];
        
    }
    
    return self;
}

- (SKSpriteNode*) makePlayButton{
    
    SKSpriteNode* playNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    
    playNode.name = @"playButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [playNode setScale:0.2];
        playNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [playNode setScale:0.2];
        playNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [playNode setScale:0.2];
        playNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [playNode setScale:0.2];
        playNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [playNode setScale:0.2];
        playNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    }
    
    return playNode;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode *menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    }
    
    return menuNode;
}

- (SKSpriteNode*) makeRetryButton{
    
    SKSpriteNode *menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton"];
    
    menuNode.name = @"retryButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 100);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 100);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 110);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 100);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 100);
    }
    
    return menuNode;
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
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 220);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [audioActiveNode setScale:0.2];
        audioActiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    
    return audioActiveNode;
}

- (SKSpriteNode *)makeAudioIconInactive {
    
    SKSpriteNode *audioInactiveNode = [SKSpriteNode spriteNodeWithImageNamed:@"audioInactive"];
    
    audioInactiveNode.name = @"audioInactive";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 220);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [audioInactiveNode setScale:0.2];
        audioInactiveNode.position = CGPointMake(self.size.width/2,self.size.height/2 - retryButton.size.height - 8);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [audioInactiveNode setScale:0.2];
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
            
            [gameScene resumeBackgroundMusic];
        }];
        
        [playButton runAction:resumeGame];
    }
    
    if ([node.name isEqualToString:@"retryButton"]) {
        SKAction * resumeGame = [SKAction runBlock:^{
            GameScene * myScene = [[GameScene alloc]initWithSize:self.size andSound: gameScene.playSounds];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            
            [gameScene stopBackgroundMusic];
        }];
        
        [playButton runAction:resumeGame];
    }
    
    if ([node.name isEqualToString:@"menuButton"]) {
        if ([node.name isEqualToString:@"menuButton"]) {
            SKAction * goMenu = [SKAction runBlock:^{
                GameMenuScene * myScene = [[GameMenuScene alloc] initWithSize:self.size andSoundEnabled: gameScene.playSounds];
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                [self.view presentScene:myScene transition: reveal];
            }];
            
            [menuButton runAction:goMenu];
        }
    }
    
    if ([node.name isEqualToString:@"audioActive"] || [node.name isEqualToString:@"audioInactive"]) {
        SKAction *soundControl = [SKAction runBlock:^{
            
        }];
        
        [self runAction:soundControl];
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
        [self addChild: audioControl];
        playSound = YES;
        
    }
}

@end
