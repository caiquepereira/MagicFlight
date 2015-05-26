//
//  GameTutorialScene.m
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 20/05/15.
//
//

#import "GameTutorialScene.h"

@implementation GameTutorialScene{
    CGFloat width;
    CGFloat height;
    SKSpriteNode *tutorialPage;
    NSString * Devicelanguage;
}




-(instancetype)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        width = self.size.width;
        height = self.size.height;
        
        tutorialPage = [self makePage1];
        [self addChild:tutorialPage];
    
        [self verifyDeviceLanguage];
        [self writeOnScreen]; //metodo de exemplo que verifica lingua do dispositivo
    }
    return self;
}

- (SKSpriteNode *)makePage1 {
    SKSpriteNode *page1 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [page1 setScale:2];
        page1.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [page1 setScale:2];
        page1.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [page1 setScale:0.32];
        page1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [page1 setScale:0.34];
        page1.position = CGPointMake(self.frame.size.width-205, self.frame.size.height-360);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [page1 setScale:1.0];
        page1.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    

    return page1;
}


- (void)didMoveToView:(SKView *)view
{
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[self view] addGestureRecognizer:recognizerLeft];
}


-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)sender
{
    [tutorialPage removeFromParent];
    tutorialPage = [self makePage2];
    [self addChild: tutorialPage];
    
}


- (SKSpriteNode *)makePage2 {
    SKSpriteNode *page2 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [page2 setScale:2];
        page2.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [page2 setScale:2];
        page2.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [page2 setScale:0.32];
        page2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [page2 setScale:0.2];
        page2.position = CGPointMake(self.frame.size.width-205, self.frame.size.height-360);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [page2 setScale:1.0];
        page2.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }

    return page2;
}

-(void)verifyDeviceLanguage{

    Devicelanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
}

-(void)writeOnScreen{
    if([Devicelanguage isEqualToString:@"pt"]){
        NSLog(@"escrever em português");
    }else{
        NSLog(@"escrever em inglês");
    }
}


@end
