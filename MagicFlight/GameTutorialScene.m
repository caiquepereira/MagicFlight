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
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [backgroundNode setScale:0.34];
        backgroundNode.position = CGPointMake(self.frame.size.width-205, self.frame.size.height-360);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [backgroundNode setScale:1.0];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    

    return backgroundNode;
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
    SKSpriteNode *pagina2Node = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2"];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [pagina2Node setScale:2];
        pagina2Node.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [pagina2Node setScale:2];
        pagina2Node.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [pagina2Node setScale:2];
        pagina2Node.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [pagina2Node setScale:0.34];
        pagina2Node.position = CGPointMake(self.frame.size.width-205, self.frame.size.height-360);
    }
    //ipad
    else if (width == 768 && height == 1024) {
        [pagina2Node setScale:1.0];
        pagina2Node.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }

    return pagina2Node;
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
