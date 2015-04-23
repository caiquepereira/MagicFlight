//
//  GameMenuScene.m
//  MagicFlight
//
//  Created by Pedro Nascimento on 4/17/15.
//
//

#import "GameMenuScene.h"
#import "GameScene.h"
#import "GameMenuSceneViewController.h"

@implementation GameMenuScene
{
    SKSpriteNode* playButton;
    SKSpriteNode* gameCenterButton;
    NSString *leaderboardIdentifier;

    GameMenuSceneViewController *menuViewController;
}

- (instancetype)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        playButton = [self makeMenuButton];
        [self addChild:playButton];
        
        gameCenterButton = [self makeGameCenterButton];
        [self addChild:gameCenterButton];
        
        
        leaderboardIdentifier=@"Best_Score_Of_The_App";
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
        SKAction * startGame =
        [SKAction runBlock:^{ GameScene * myScene =
            [[GameScene alloc] initWithSize:self.size]; SKTransition *reveal =
            [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal]; }];
        
        [playButton runAction:startGame];
    }
    
    if ([node.name isEqualToString:@"gameCenterButton"]) {
        menuViewController = [[GameMenuSceneViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:menuViewController
                                                                                                 animated:YES completion:nil];
    }
}
    
    
    
    - (SKSpriteNode*) makeGameCenterButton{
        
        SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
        
        menuNode.name = @"gameCenterButton";
        
        [menuNode setScale:0.2];
        menuNode.position = CGPointMake(self.size.width*4/5,self.size.height/5);
        
        return menuNode;
    }
    





@end
