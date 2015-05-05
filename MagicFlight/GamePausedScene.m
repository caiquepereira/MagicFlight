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
    SKLabelNode *pauseLabel;
    CGFloat width;
    CGFloat height;
    
    GameScene *gameScene;
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
        
    }
    
    return self;
}

- (SKSpriteNode*) makePlayButton{
    
    SKSpriteNode* playNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    
    playNode.name = @"playButton";
    
    [playNode setScale:0.5];
    playNode.position = CGPointMake(self.size.width/2,self.size.height/2);
    
    return playNode;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";
    
    [menuNode setScale:0.5];
    menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    
    return menuNode;
}

- (SKSpriteNode*) makeRetryButton{
    
    SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton"];
    
    menuNode.name = @"retryButton";
    
    [menuNode setScale:0.5];
    menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 + playButton.size.height + 100);
    
    return menuNode;
}

- (SKLabelNode *) makePauseLabel{
    SKLabelNode *pauseLabelNode = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    pauseLabelNode.name = @"pauseLabel";
    pauseLabelNode.text = @"Paused!";
    pauseLabelNode.fontSize = 50;
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [pauseLabelNode setScale:1];
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 60);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [pauseLabelNode setScale:0.2];
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 150);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [pauseLabelNode setScale:0.2];
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 150);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [pauseLabelNode setScale:0.2];
        pauseLabelNode.position = CGPointMake(self.size.width/2, self.size.height - 150);
    }
    
    return pauseLabelNode;
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
}


@end
