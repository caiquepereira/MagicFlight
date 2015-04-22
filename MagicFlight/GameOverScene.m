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

@implementation GameOverScene

{
    SKSpriteNode* retryButton;
    SKSpriteNode* menuButton;
    SKLabelNode* scoreLabel;

}

- (instancetype)initWithSize:(CGSize)size
            andHighestScore: (int) score{
    if(self = [super initWithSize:size]){
        
        _scoreLbl=score;
        
        
        retryButton = [self makeRetryButton];
        [self addChild:retryButton];
        
        menuButton = [self makeMenuButton];
        [self addChild:menuButton];
        [self addChild: [self makeScoreLabel]];
        
    }
    return self;
}

- (SKSpriteNode*) makeRetryButton{
    
    SKSpriteNode* retryNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton"];
    
    retryNode.name = @"retryButton";
    
    [retryNode setScale:0.5];
    retryNode.position = CGPointMake(self.size.width/2,self.size.height/2);
    
    return retryNode;
}

- (SKSpriteNode*) makeMenuButton{
    
    SKSpriteNode* menuNode = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    
    menuNode.name = @"menuButton";
    
    [menuNode setScale:0.5];
    menuNode.position = CGPointMake(self.size.width/2,menuNode.size.height - 40);
    
    return menuNode;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retryButton"]) {
        SKAction * retry =
        [SKAction runBlock:^{ GameScene * myScene =
            [[GameScene alloc] initWithSize:self.size];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal]; }];
        
        [retryButton runAction:retry];
    }
    
    if ([node.name isEqualToString:@"menuButton"]) {
        SKAction * goMenu =
        [SKAction runBlock:^{ GameMenuScene * myScene =
            [[GameMenuScene alloc] initWithSize:self.size];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal]; }];
        
        [menuButton runAction:goMenu];
    }
}

- (SKLabelNode*) makeScoreLabel{
    
    SKLabelNode* scoreLabelNode = [SKLabelNode labelNodeWithText: @""];
    
    scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    scoreLabelNode.zPosition = 15;
    scoreLabelNode.fontColor = [UIColor whiteColor];
    scoreLabelNode.fontSize = 30;
    
    scoreLabelNode.text = [[NSString alloc]initWithFormat:@"%d",_scoreLbl];
    
    NSLog(@"Score no game over scene %d", _scoreLbl);
    return scoreLabelNode;
}



@end
