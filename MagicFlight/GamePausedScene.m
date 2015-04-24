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
    SKSpriteNode* playButton;
    SKSpriteNode* menuButton;
    
    GameScene* gameScene;
}

- (instancetype)initWithSize:(CGSize)size andGameScene: (GameScene*) previousGameScene{
    if(self = [super initWithSize:size]){
        gameScene = previousGameScene;
        
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"windowBackground"];
        [backgroundImage setSize:CGSizeMake(self.size.width, self.size.height)];
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:backgroundImage];
        
        
        playButton = [self makePlayButton];
        [self addChild:playButton];
        
        menuButton = [self makeMenuButton];
        [self addChild:menuButton];
        
    }
    
    return self;
}

- (SKSpriteNode*) makePlayButton{
    
    SKSpriteNode* playNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    
    playNode.name = @"playButton";
    
    [playNode setScale:0.2];
    playNode.position = CGPointMake(self.size.width/2,self.size.height/2);
    
    return playNode;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";
    
    [menuNode setScale:0.2];
    menuNode.position = CGPointMake(self.size.width/2,self.size.height/2 - playButton.size.height - 8);
    
    return menuNode;
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
    
    if ([node.name isEqualToString:@"menuButton"]) {
        if ([node.name isEqualToString:@"menuButton"]) {
            SKAction * goMenu = [SKAction runBlock:^{
                GameMenuScene * myScene = [[GameMenuScene alloc] initWithSize:self.size];
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                [self.view presentScene:myScene transition: reveal];
            }];
            
            [menuButton runAction:goMenu];
        }
    }
}


@end
