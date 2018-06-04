//
//  GameTutorialScene.m
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 20/05/15.
//
//

#import "GameTutorialScene.h"
#import "GameScene.h"
#import "GameViewController.h"

@implementation GameTutorialScene{
    CGFloat width;
    CGFloat height;
    SKSpriteNode *tutorialPage;
    SKSpriteNode *nextButton;
    SKSpriteNode *backButton;
    SKSpriteNode *playButton;
    NSString * Devicelanguage;
    SKLabelNode *label1Page1;
    SKLabelNode *label2Page1;
    SKLabelNode *label1Page2;
    SKLabelNode *label2Page2;
    SKLabelNode *label3Page2;

    BOOL playSound;
    int timesPlayed;
    
}


-(instancetype)initWithSize:(CGSize)size
                   andSound:(BOOL)soundEnabled
             andTimesPlayed:(int)timesPlayedGame{
    
    if (self = [super initWithSize:size]) {
        width = self.size.width;
        height = self.size.height;
        
        tutorialPage = [self makePage1];
        [self addChild:tutorialPage];
        
        nextButton = [self makeNextButton];
        [self addChild:nextButton];
        
        backButton = [self makeBackButton];

        playButton = [self makePlayButton];

        
        label1Page1= [self makeLabel1Page1];
        [self addChild:label1Page1];
        
        label2Page1= [self makeLabel2Page1];
        [self addChild:label2Page1];
        
        label1Page2= [self makeLabel1Page2];
        
        label2Page2= [self makeLabel2Page2];
        
        label3Page2= [self makeLabel3Page2];
        
        
        playSound=soundEnabled;
        if(timesPlayed==0){
            timesPlayed=0;
        }else{
            timesPlayed=timesPlayedGame;
        }

        
//        [self verifyDeviceLanguage];
//        [self writeOnScreen]; //metodo de exemplo que verifica lingua do dispositivo
    }
    return self;
}

- (SKSpriteNode *)makePage1 {
    SKSpriteNode *page1 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [page1 setScale:0.27];
        page1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [page1 setScale:0.3];
        page1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [page1 setScale:0.32];
        page1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [page1 setScale:0.37];
        page1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        page1=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial1iPad"];
        [page1 setScale:0.55];
        page1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    

    return page1;
}

- (SKSpriteNode *)makePage2 {
    SKSpriteNode *page2 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [page2 setScale:0.27];
        page2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [page2 setScale:0.3];
        page2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [page2 setScale:0.32];
        page2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [page2 setScale:0.37];
        page2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+30);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        page2=[SKSpriteNode spriteNodeWithImageNamed:@"tutorial2iPad"];
        [page2 setScale:0.55];
        page2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    
    return page2;
}



- (SKSpriteNode *)makeNextButton {
    SKSpriteNode *nextNode = [SKSpriteNode spriteNodeWithImageNamed:@"nextButton"];
    nextNode.name=@"nextButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [nextNode setScale:0.1];
        nextNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [nextNode setScale:0.13];
        nextNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [nextNode setScale:0.15];
        nextNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [nextNode setScale:0.17];
        nextNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [nextNode setScale:0.17];
        nextNode.position = CGPointMake(18*self.frame.size.width/20, self.frame.size.height/15);
    }
    
    
    return nextNode;
}

- (SKLabelNode *) makeLabel1Page1{
    SKLabelNode *explanationNode = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    
    explanationNode.name = @"explanation1";
    explanationNode.text = @"Swipe in the right directions";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        explanationNode.fontSize = 20;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+30);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        explanationNode.fontSize = 25;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+30);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        explanationNode.fontSize = 30;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        explanationNode.fontSize = 35;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+25);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        explanationNode.fontSize = 50;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+20);
    }
    
    return explanationNode;
}


- (SKLabelNode *) makeLabel2Page1{
    SKLabelNode *explanationNode = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    
    explanationNode.name = @"explanation2";
    explanationNode.text = @"to defeat the enemies.";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        explanationNode.fontSize = 20;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+30);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        explanationNode.fontSize = 25;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+30);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        explanationNode.fontSize = 30;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        explanationNode.fontSize = 35;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+25);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        explanationNode.fontSize = 50;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+20);
    }
    
    return explanationNode;
}


- (SKLabelNode *) makeLabel1Page2{
    SKLabelNode *explanationNode = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    
    explanationNode.name = @"label1page2";
    explanationNode.text = @"When the bar gets filled,";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        explanationNode.fontSize = 20;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+30);
        explanationNode.text = @"When the bar gets filled, click the";
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        explanationNode.fontSize = 25;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+35);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        explanationNode.fontSize = 30;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        explanationNode.fontSize = 35;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+35);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        explanationNode.fontSize = 50;
        explanationNode.position = CGPointMake(self.size.width/2, 90*self.size.height/100+30);
    }
    
    return explanationNode;
}

-(SKLabelNode *) makeLabel2Page2{
    SKLabelNode *explanationNode = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    
    explanationNode.name = @"label2page2";
    explanationNode.text = @"click the power-up button to";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        explanationNode.fontSize = 20;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+30);
        explanationNode.text = @"power-up button to defeat all enemies.";
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        explanationNode.fontSize = 25;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+35);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        explanationNode.fontSize = 30;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        explanationNode.fontSize = 35;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+35);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        explanationNode.fontSize = 50;
        explanationNode.position = CGPointMake(self.size.width/2, 85*self.size.height/100+30);
    }
    
    return explanationNode;
}

-(SKLabelNode *) makeLabel3Page2{
    SKLabelNode *explanationNode = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    
    explanationNode.name = @"label3page2";
    explanationNode.text = @"defeat all enemies.";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        explanationNode.fontSize = 20;
        explanationNode.position = CGPointMake(self.size.width/2, 80*self.size.height/100+30);
        explanationNode.text = @"";
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        explanationNode.fontSize = 25;
        explanationNode.position = CGPointMake(self.size.width/2, 80*self.size.height/100+35);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        explanationNode.fontSize = 30;
        explanationNode.position = CGPointMake(self.size.width/2, 80*self.size.height/100);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        explanationNode.fontSize = 35;
        explanationNode.position = CGPointMake(self.size.width/2, 80*self.size.height/100+35);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        explanationNode.fontSize = 50;
        explanationNode.position = CGPointMake(self.size.width/2, 80*self.size.height/100+30);
    }
    
    return explanationNode;
}





- (SKSpriteNode *)makeBackButton {
    SKSpriteNode *backNode = [SKSpriteNode spriteNodeWithImageNamed:@"backButton"];
    backNode.name=@"backButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [backNode setScale:0.1];
        backNode.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [backNode setScale:0.13];
        backNode.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [backNode setScale:0.15];
        backNode.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [backNode setScale:0.17];
        backNode.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/15);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [backNode setScale:0.17];
        backNode.position = CGPointMake(2*self.frame.size.width/20, self.frame.size.height/15);
    }
    
    
    return backNode;
}


- (SKSpriteNode*) makePlayButton{
    
    SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    
    playNode.name = @"playButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [playNode setScale:0.1];
        playNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [playNode setScale:0.13];
        playNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [playNode setScale:0.15];
        playNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [playNode setScale:0.17];
        playNode.position = CGPointMake(3*self.frame.size.width/4, self.frame.size.height/15);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [playNode setScale:0.17];
        playNode.position = CGPointMake(18*self.frame.size.width/20, self.frame.size.height/15);
    }
    
    return playNode;
}





//Verifica linguagem do dispositivo e exemplo de como escrever em PT-BR

//-(void)verifyDeviceLanguage{
//
//    Devicelanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
//}
//
//-(void)writeOnScreen{
//    if([Devicelanguage isEqualToString:@"pt"]){
//        //NSLog(@"escrever em português");
//    }else{
//        //NSLog(@"escrever em inglês");
//    }
//}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"nextButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.1 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.13 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        
        SKAction * resumeGame = [SKAction runBlock:^{
            [self->tutorialPage removeFromParent];
            [self->nextButton removeFromParent];
            [self->label1Page1 removeFromParent];
            [self->label2Page1 removeFromParent];
            self->tutorialPage = [self makePage2];
            [self addChild: self->tutorialPage];
            [self addChild:self->backButton];
            [self addChild:self->label1Page2];
            [self addChild:self->label2Page2];
            [self addChild:self->label3Page2];
            [self addChild:self->playButton];
        
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, resumeGame]];
        [nextButton runAction:sequence];
        
    }
    
    
    if ([node.name isEqualToString:@"backButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.1 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.13 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //iphone X
        else if (width == 1125 && height == 2436) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        
        SKAction * resumeGame = [SKAction runBlock:^{
            [self->tutorialPage removeFromParent];
            [self->backButton removeFromParent];
            [self->label1Page2 removeFromParent];
            [self->label2Page2 removeFromParent];
            [self->label3Page2 removeFromParent];
            [self->playButton removeFromParent];
            self->tutorialPage = [self makePage1];
            [self addChild: self->tutorialPage];
            [self addChild: self->nextButton];
            [self addChild:self->label1Page1];
            [self addChild:self->label2Page1];
            
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, resumeGame]];
        [backButton runAction:sequence];
    }

    
    if ([node.name isEqualToString:@"playButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.12 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.1 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.15 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.13 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.13 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.15 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //iphone X
        else if (width == 1125 && height == 2436) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        //ipad
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.19 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.17 duration:0.1];
        }
        
        SKAction * resumeGame = [SKAction runBlock:^{
            [self->tutorialPage removeFromParent];
            [self->backButton removeFromParent];
            [self->label1Page2 removeFromParent];
            [self->label2Page2 removeFromParent];
            [self->label3Page2 removeFromParent];
            [self->playButton removeFromParent];
            
            GameScene *myScene = [[GameScene alloc] initWithSize:self.size andSound:self->playSound andTimesPlayed:self->timesPlayed];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition: reveal];
            

        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, resumeGame]];
        [playButton runAction:sequence];
    }

    
    
    
}


@end
