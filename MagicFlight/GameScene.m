//
//  GameScene.m
//  MagicFlight
//
//  Created by Ruyther Parente Da Costa on 4/9/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "GamePausedScene.h"
#import "GameViewController.h"
#import <AVFoundation/AVFoundation.h>

#define HUD_POSITION 15
#define PORTAL_POSITION 7
#define ENEMY_POSITION 10
#define CLOUDS_POSITION 5
#define BACKGROUND_POSITION 0

#define ENEMY_NUMBER_TO_POWER_UP 20

#define POWERUP_STAGE_MAX 5

#define HORIZ_SWIPE_DRAG_MIN_H  12
#define VERT_SWIPE_DRAG_MAX_H   20
#define HORIZ_SWIPE_DRAG_MIN_V  20
#define VERT_SWIPE_DRAG_MAX_V   15

@implementation GameScene {

    CGMutablePathRef pathToDraw;
    SKSpriteNode *mage;
    SKSpriteNode *background;
    SKSpriteNode *powerUpButton;
    SKSpriteNode *powerUpBar;
    SKShapeNode *lineNode;
    SKLabelNode *scoreLabel;
    NSMutableArray *dataToSaveInPlist;
    SKSpriteNode *pauseButton;
    NSArray *gestureNames;
    NSArray *gestureColors;
    NSArray* enemies;
    NSTimer *timer;
    CGPoint startPositionInScene;
    AVAudioPlayer *musicPlayer;
    NSArray* mageFlyingFrames;
    CGFloat width;
    CGFloat height;
    CGPoint lineMiddle;
    int auxiliarIncrement;
    int auxiliarIncrementGestureNumberInEnemy;
    int _score;
    int enemyNumber;
    int _maxGestureQtd;
    int _scoreTemporary;
    int _newHighestScore;
    float spawnEnemiesQuatity;
    float increasingEnemySpeed;
    int _powerUpStage;
    int _destroyedEnemies;
    BOOL playerBrokeScore;
    GameViewController * viewController;
    int timesPlayed;
}

-(id)initWithSize:(CGSize)size
         andSound:(BOOL)soundEnabled
        andTimesPlayed:(int)timesPlayedGame {
    
    timesPlayed=timesPlayedGame;
    timesPlayed++;
    
    if (self = [super initWithSize:size]) {
        width = self.size.width;
        height = self.size.height;
        
        _playSounds = soundEnabled;

        gestureNames = [NSArray arrayWithObjects:@"swipeToRight",
                        @"swipeToLeft",
                        @"swipeUp",
                        @"swipeDown", nil];
        
        self.backgroundColor = [SKColor whiteColor];
        self.view.ignoresSiblingOrder = YES;
        
        _maxGestureQtd = 1;
        _score = 0;
        enemyNumber = 0;
        spawnEnemiesQuatity = 4;
        increasingEnemySpeed = 6;
        _score = 0;
        _scoreTemporary = 0;
        auxiliarIncrementGestureNumberInEnemy = 0;
        _powerUpStage = 0;
        
        [self readHighestScoreFromPlist];
        
        scoreLabel = [self makeScoreLabel];
        [self addChild:scoreLabel];
        
        mage = [self makeMage];
        [self addChild:mage];
        
        [self flyingMage];
        
        background = [self makeBackground];
        [self addChild:background];
        
        pauseButton = [self makePauseButton];
        [self addChild:pauseButton];
        
        powerUpBar = [self makePowerUpBar: @"powerUp0"];
        [self addChild:powerUpBar];
        
        [self.view setMultipleTouchEnabled:NO];
        
        // Setting the timer to spawn clouds
        SKAction *waitCloud = [SKAction waitForDuration:1.2];
        SKAction *spawnCloud = [SKAction runBlock:^{
            [self spawnCloud];
        }];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[spawnCloud, waitCloud]]]];
        
        // Setting the timer to spawn enemies
        SKAction *waitEnemy = [SKAction waitForDuration:spawnEnemiesQuatity];
        SKAction *spawnEnemy = [SKAction runBlock:^{
            [self spawnEnemy];
        }];
        
        //Increasing quantity enemies on screen
        SKAction *increaseEnemyQuantity = [SKAction waitForDuration:5];
        SKAction *increaseEnemy = [SKAction runBlock:^{
            
            [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[waitEnemy, spawnEnemy]]]];
            if (self->spawnEnemiesQuatity > 0 && self->increasingEnemySpeed > 1) {
                self->spawnEnemiesQuatity -= 0.02;
                self->increasingEnemySpeed -= 0.1;
            }
            
            if (self->auxiliarIncrementGestureNumberInEnemy%12 == 0)
            {
                [self increaseGesturesQuantity];
            }
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[increaseEnemyQuantity, increaseEnemy]]]];
        
        if(_playSounds){
            [self playBackgroundMusic:@"gameMusic" ofType:@"mp3"];
        }
    }
    
    return self;
}

- (void)rightSwipe {
    [self attack: @"swipeToRight"];
}

- (void)leftSwipe {
    [self attack: @"swipeToLeft"];
}

- (void)downSwipe {
    [self attack: @"swipeDown"];
}

- (void)upSwipe {
    [self attack: @"swipeUp"];
}

- (void)creatingLine {
    lineNode = [SKShapeNode node];
    lineNode.path = pathToDraw;
    lineNode.strokeColor = [SKColor orangeColor];
    lineNode.lineWidth = 10;
    lineNode.zPosition = HUD_POSITION;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    startPositionInScene = [touch locationInNode:self];
    
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, startPositionInScene.x, startPositionInScene.y);
    
    [self creatingLine];
    
    SKNode* node = [self nodeAtPoint:startPositionInScene];
    
    if ([node.name isEqualToString:@"pauseButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.28 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.3 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.33 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.35 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.33 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.35 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.33 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.35 duration:0.1];
        }
        //iphone x
        else if (width == 375 && height == 812) {
            scaleFirst = [SKAction scaleTo:0.33 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.35 duration:0.1];
        }
        //ipad 9.7
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.48 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.5 duration:0.1];
        }
        //ipad 10.5
        else if (width == 834 && height == 1112) {
            scaleFirst = [SKAction scaleTo:0.48 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.5 duration:0.1];
        }
        //ipad 12.9
        else if (width == 1024 && height == 1366) {
            scaleFirst = [SKAction scaleTo:0.48 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.5 duration:0.1];
        }
        
        SKAction *pauseGame = [SKAction runBlock:^{
            [self pauseGame];
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, pauseGame]];
        [pauseButton runAction:sequence];
    }
    
    if ([node.name isEqualToString:@"powerUpButton"]) {
        //animation
        SKAction *scaleFirst;
        SKAction *scaleEnd;
        
        //iphone 4s
        if (width == 320 && height == 480) {
            scaleFirst = [SKAction scaleTo:0.48 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.5 duration:0.1];
        }
        //iphone 5 e 5s
        else if (width == 320 && height == 568) {
            scaleFirst = [SKAction scaleTo:0.48 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.5 duration:0.1];
        }
        //iphone 6
        else if (width == 375 && height == 667) {
            scaleFirst = [SKAction scaleTo:0.58 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.6 duration:0.1];
        }
        //iphone 6 plus
        else if (width == 414 && height == 736) {
            scaleFirst = [SKAction scaleTo:0.58 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.6 duration:0.1];
        }
        //iphone x
        else if (width == 375 && height == 812) {
            scaleFirst = [SKAction scaleTo:0.58 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.6 duration:0.1];
        }
        //ipad 9.7
        else if (width == 768 && height == 1024) {
            scaleFirst = [SKAction scaleTo:0.58 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.6 duration:0.1];
        }
        //ipad 10.5
        else if (width == 834 && height == 1112) {
            scaleFirst = [SKAction scaleTo:0.58 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.6 duration:0.1];
        }
        //ipad 12.9
        else if (width == 1024 && height == 1366) {
            scaleFirst = [SKAction scaleTo:0.58 duration:0.1];
            scaleEnd = [SKAction scaleTo:0.6 duration:0.1];
        }
        
        SKAction *usePowerUp = [SKAction runBlock:^{
            [self attack:@"destroyAll"];
            
        }];
        
        SKAction *sequence = [SKAction sequence:@[scaleFirst, scaleEnd, usePowerUp]];
        [powerUpButton runAction:sequence];
    }
    
    [self addChild:lineNode];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInNode:self];
    
    CGPathAddLineToPoint(pathToDraw, NULL, currentTouchPosition.x, currentTouchPosition.y);
    lineNode.path = pathToDraw;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInNode:self];
    
    [lineNode removeFromParent];
    CGPathCloseSubpath(pathToDraw);
    
    if (fabs(startPositionInScene.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN_H &&
        fabs(startPositionInScene.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX_H) {
        
        // If touch appears to be a swipe
        if (startPositionInScene.x < currentTouchPosition.x) {
            [self rightSwipe];
            lineMiddle.x=startPositionInScene.x-currentTouchPosition.x;
            lineMiddle.y=currentTouchPosition.y-startPositionInScene.y;
        }
    }
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(startPositionInScene.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN_H &&
        fabs(startPositionInScene.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX_H) {
        
        // If touch appears to be a swipe
        if (startPositionInScene.x > currentTouchPosition.x) {
            [self leftSwipe];
            lineMiddle.x=currentTouchPosition.x-startPositionInScene.x;
            lineMiddle.y=startPositionInScene.y-currentTouchPosition.y;
        }
    }
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(startPositionInScene.y - currentTouchPosition.y) >= HORIZ_SWIPE_DRAG_MIN_V &&
        fabs(startPositionInScene.x - currentTouchPosition.x) <= VERT_SWIPE_DRAG_MAX_V) {
        
        if (startPositionInScene.y < currentTouchPosition.y) {
            [self upSwipe];
            lineMiddle.x=currentTouchPosition.x;
            lineMiddle.y=startPositionInScene.y-currentTouchPosition.y;
            
        }
    }
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(startPositionInScene.y - currentTouchPosition.y) >= HORIZ_SWIPE_DRAG_MIN_V &&
        fabs(startPositionInScene.x - currentTouchPosition.x) <= VERT_SWIPE_DRAG_MAX_V) {
        // If touch appears to be a swipe
        if (startPositionInScene.y > currentTouchPosition.y) {
            [self downSwipe];
            lineMiddle.x=currentTouchPosition.x;
            lineMiddle.y=currentTouchPosition.y-startPositionInScene.y;
        }
    }
    
    startPositionInScene = CGPointZero;
//    [particleNode removeFromParent];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)update:(NSTimeInterval)currentTime {
    
    [self updateScore];
    [self checkCollision];
}

- (SKLabelNode *)makeScoreLabel {
    
    SKLabelNode *scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    scoreLabelNode.text = @"";
    scoreLabelNode.zPosition = HUD_POSITION;
    scoreLabelNode.fontColor = [UIColor whiteColor];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        scoreLabelNode.fontSize = 50;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        scoreLabelNode.fontSize = 50;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        scoreLabelNode.fontSize = 50;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        scoreLabelNode.fontSize = 70;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    }
    //iphone x
    else if (width == 375 && height == 812) {
        scoreLabelNode.fontSize = 70;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        scoreLabelNode.fontSize = 120;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 300);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        scoreLabelNode.fontSize = 120;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 300);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        scoreLabelNode.fontSize = 120;
        scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 300);
    }
    
    return scoreLabelNode;
}

- (SKSpriteNode *)makeMage {
    NSMutableArray *mageDragon = [NSMutableArray array];
    SKTextureAtlas *mageDragonAtlas = [SKTextureAtlas atlasNamed:@"mageImages"];
    
    long numImages = mageDragonAtlas.textureNames.count;
    for (int i=1; i <= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"mage%d", i];
        SKTexture *temp = [mageDragonAtlas textureNamed:textureName];
        [mageDragon addObject:temp];
    }
    mageFlyingFrames = mageDragon;
    
    SKTexture *temp = mageFlyingFrames[0];
    SKSpriteNode *mageNode = [SKSpriteNode spriteNodeWithTexture:temp];
    mageNode.zPosition = HUD_POSITION;
    mageNode.name = @"mage";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -300);
        [mageNode setScale:0.3];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 60) duration:4];
        [mageNode runAction:entry];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -300);
        [mageNode setScale:0.3];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 60) duration:4];
        [mageNode runAction:entry];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -300);
        [mageNode setScale:0.4];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 60) duration:4];
        [mageNode runAction:entry];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -300);
        [mageNode setScale:0.4];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 60) duration:4];
        [mageNode runAction:entry];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -300);
        [mageNode setScale:0.4];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 90) duration:4];
        [mageNode runAction:entry];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -200);
        [mageNode setScale:0.6];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 90) duration:4];
        [mageNode runAction:entry];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -200);
        [mageNode setScale:0.6];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 90) duration:4];
        [mageNode runAction:entry];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        mageNode.position = CGPointMake(self.frame.size.width/2, -200);
        [mageNode setScale:0.6];
        
        SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 90) duration:4];
        [mageNode runAction:entry];
    }
    
    return mageNode;
}

- (void) flyingMage {
    [mage runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:mageFlyingFrames
                                      timePerFrame:0.1
                                            resize:NO
                                           restore:YES]] withKey:@"flyingInPlaceMage"];
}

- (SKSpriteNode*) makePauseButton{
    SKSpriteNode* pauseNode = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
    pauseNode.name = @"pauseButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        pauseNode.position = CGPointMake(self.frame.size.width - 25, self.frame.size.height - 30);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.3];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        pauseNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 30);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.35];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        pauseNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 30);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.35];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        pauseNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 30);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.35];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        pauseNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 50);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.35];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        pauseNode.position = CGPointMake(self.frame.size.width - 40, self.frame.size.height - 40);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.5];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        pauseNode.position = CGPointMake(self.frame.size.width - 40, self.frame.size.height - 40);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.5];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        pauseNode.position = CGPointMake(self.frame.size.width - 40, self.frame.size.height - 40);
        pauseNode.zPosition = HUD_POSITION;
        [pauseNode setScale: 0.5];
    }
    
    return pauseNode;
}


- (SKSpriteNode *)makeBackground {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    
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
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [backgroundNode setScale:2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [backgroundNode setScale:2.2];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [backgroundNode setScale:2.3];
        backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [backgroundNode setScale:2.5];
        backgroundNode.position = CGPointMake(self.frame.size.width-300, self.frame.size.height);
    }
    
    return backgroundNode;
}

- (SKSpriteNode *)makePowerUpButton {
    SKSpriteNode *powerUpNode = [SKSpriteNode spriteNodeWithImageNamed:@"powerUpIcon"];
    powerUpNode.name = @"powerUpButton";
    
    //iphone 4s
    if (width == 320 && height == 480) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 25, self.frame.size.height/2 + 90);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.5];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 25, self.frame.size.height/2 + 35);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.4];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height/2 + 90);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.6];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height/2 + 110);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.6];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height/2 + 150);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.6];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 37, self.frame.size.height/2 + 200);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.6];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 33, self.frame.size.height/2 + 260);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.6];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        powerUpNode.position = CGPointMake(self.frame.size.width - 33, self.frame.size.height/2 + 380);
        powerUpNode.zPosition = HUD_POSITION;
        [powerUpNode setScale:0.6];
    }
    
    return powerUpNode;
}

- (SKSpriteNode *)makePowerUpBar: (NSString*) imageName {
    SKSpriteNode *powerUpBarNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 20, self.frame.size.height - 350);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.4];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 20, self.frame.size.height - 350);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.4];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 400);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.6];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 400);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.6];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 400);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.6];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 500);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.8];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 500);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.8];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 500);
        powerUpBarNode.zPosition = HUD_POSITION;
        [powerUpBarNode setScale:0.8];
    }
    
    return powerUpBarNode;
}

- (void)spawnCloud {
    
    NSString *imageName = [NSString stringWithFormat:@"cloud%d",arc4random_uniform(2)];
    
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    
    cloud.zPosition = CLOUDS_POSITION;
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [cloud setScale:0.3];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [cloud setScale:0.3];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [cloud setScale:0.4];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [cloud setScale:0.4];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [cloud setScale:0.4];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [cloud setScale:0.6];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [cloud setScale:0.6];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [cloud setScale:0.6];
    }
    
    CGPoint position = CGPointMake(arc4random_uniform(self.frame.size.width), self.frame.size.height);
    
    cloud.position = position;
    SKAction *move = [SKAction moveToY: -200 duration:6];
    [cloud runAction:move];
    
    [self addChild:cloud];
}

- (void)spawnEnemy {
    
    NSMutableArray *batFrames = [NSMutableArray array];
    SKTextureAtlas *batAtlas = [SKTextureAtlas atlasNamed:@"batImages"];
    
    long numImages = batAtlas.textureNames.count;
    
    for (int i=1; i <= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"bat%d", i];
        SKTexture *temp = [batAtlas textureNamed:textureName];
        [batFrames addObject:temp];
    }
    
    SKTexture *temp = batFrames[0];
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithTexture:temp];
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [enemy setScale:0.35];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [enemy setScale:0.35];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [enemy setScale:0.5];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [enemy setScale:0.5];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [enemy setScale:0.5];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [enemy setScale:0.65];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [enemy setScale:0.65];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [enemy setScale:0.65];
    }
    
    enemy.zPosition = ENEMY_POSITION;
    enemy.name = @"bat";
    
    CGPoint position = CGPointMake(arc4random_uniform(self.frame.size.width), self.frame.size.height);
    
    enemy.position = position;
    
    SKAction *move = [SKAction moveTo: mage.position duration:increasingEnemySpeed];
    [enemy runAction:move];
    
    for(int cont = 0; cont < _maxGestureQtd; cont++){
        [enemy addChild:[self makeGesture:enemy.frame]];
    }
    
    [enemy runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:batFrames
                                       timePerFrame:0.1
                                             resize:NO
                                            restore:YES]] withKey:@"flyingInPlaceBat"];
    
    [self addChild:enemy];
    auxiliarIncrement++;
}

- (void)spawnPortal: (SKSpriteNode *)enemy {
    NSMutableArray *portalFrames = [NSMutableArray array];
    SKTextureAtlas *portalAtlas = [SKTextureAtlas atlasNamed:@"portalImages"];
    
    long numImages = portalAtlas.textureNames.count;
    
    for (int i=1; i <= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"portal%d", i];
        SKTexture *temp = [portalAtlas textureNamed:textureName];
        [portalFrames addObject:temp];
    }
    
    SKTexture *temp = portalFrames[0];
    SKSpriteNode *portal = [SKSpriteNode spriteNodeWithTexture:temp];

    //iphone 4s
    if (width == 320 && height == 480) {
        [portal setScale:0.2];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [portal setScale:0.25];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [portal setScale:0.28];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [portal setScale:0.3];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [portal setScale:0.3];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [portal setScale:0.4];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [portal setScale:0.4];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [portal setScale:0.45];
    }
    
    portal.zPosition = PORTAL_POSITION;
    portal.name = @"portal";
    
    CGPoint position = CGPointMake(enemy.position.x, enemy.position.y);
    portal.position = position;
    
    SKAction *move = [SKAction moveTo: enemy.position duration:1];
    [portal runAction:[SKAction repeatActionForever:move]];
    [portal runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:portalFrames
                                       timePerFrame:0.1
                                             resize:NO
                                            restore:YES]] withKey:@"flyingInPlaceBat"];
    
    [self addChild:portal];
    [self removePortal:portal];
}

- (void)removePortal: (SKSpriteNode *)portal {
    SKAction *wait = [SKAction waitForDuration:0.1];
    SKAction *removePortal = [SKAction runBlock:^{
        
        [portal removeFromParent];
    }];
    SKAction *sequence = [SKAction sequence:@[wait, removePortal]];
    [self runAction:sequence];
}

- (SKSpriteNode *)makeGesture: (CGRect)enemySize {
    
    SKSpriteNode* gesture = [self randomGestureNode: [self generateGesturesQuantity]];
    gesture.position = CGPointMake(gesture.position.x, gesture.position.y + enemySize.size.height + 40);
    
    //iphone 4s
    if (width == 320 && height == 480) {
        [gesture setScale:0.9];
    }
    //iphone 5 e 5s
    else if (width == 320 && height == 568) {
        [gesture setScale:0.9];
    }
    //iphone 6
    else if (width == 375 && height == 667) {
        [gesture setScale:1];
    }
    //iphone 6 plus
    else if (width == 414 && height == 736) {
        [gesture setScale:1];
    }
    //iphone x
    else if (width == 375 && height == 812) {
        [gesture setScale:1];
    }
    //ipad 9.7
    else if (width == 768 && height == 1024) {
        [gesture setScale:1];
    }
    //ipad 10.5
    else if (width == 834 && height == 1112) {
        [gesture setScale:1];
    }
    //ipad 12.9
    else if (width == 1024 && height == 1366) {
        [gesture setScale:1];
    }
    
    gesture.zPosition = ENEMY_POSITION;
    
    return gesture;
}

- (SKSpriteNode *)randomGestureNode: (int)number {
    
    CGRect rect;
    rect.size.height = 200;
    rect.size.width = 200;
    
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:gestureNames[number]];
    node.name = gestureNames[number];
    
    return node;
}

- (void)updateScore {
    scoreLabel.text = [[NSString alloc]initWithFormat:@"%d",_score];
}

- (void)checkCollision {
    [self enumerateChildNodesWithName:@"bat"
                           usingBlock: ^(SKNode *node, BOOL *stop) {
                               SKSpriteNode *enemy = (SKSpriteNode *) node;
            

                               CGRect frame = CGRectMake(self->mage.frame.origin.x, self->mage.frame.origin.y, self->mage.frame.size.width, self->mage.frame.size.height*0.8);
                               
                               if (CGRectIntersectsRect(enemy.frame, frame)) {
                                   [self gameOver];
                               }
                           }];
}

- (void)attack: (NSString *)gestureType {
    
    enemies = [[NSArray alloc]initWithArray:[self objectForKeyedSubscript:@"bat"]];
    
    for (SKSpriteNode* enemy in enemies) {
        
        for (int i=1; i<=4; i++) {
            if ([[enemy children]count] == i) {
                _scoreTemporary+=10;
            }
        }
        
        if([gestureType isEqualToString:@"destroyAll"]){
            [enemy removeAllChildren];
            [powerUpButton removeFromParent];
            _powerUpStage = 0;
            _destroyedEnemies = 0;
            [self updatePowerUpBar];
            
        } else {
            [enemy removeChildrenInArray:[enemy objectForKeyedSubscript:gestureType]];
        }
        
        if ([[enemy children]count] == 0) {
            _scoreTemporary+=10;
            _score+=_scoreTemporary;
            _scoreTemporary=0;
            
            if(self.playSounds){
                [mage runAction:[SKAction playSoundFileNamed:@"spell.mp3" waitForCompletion:YES]];
            }
            
            [self spawnPortal:enemy];
            [self removeEnemy:enemy];
            
            _destroyedEnemies++;
            
            if(_destroyedEnemies >= ENEMY_NUMBER_TO_POWER_UP && _powerUpStage < POWERUP_STAGE_MAX){
                _powerUpStage++;
                _destroyedEnemies = 0;
                
                [self updatePowerUpBar];
            }
        }
    }
}

- (void)removeEnemy: (SKSpriteNode *)enemy {
    SKAction *wait = [SKAction waitForDuration:0.1];
    SKAction *removeEnemy = [SKAction runBlock:^{
        
        [enemy removeFromParent];
    }];
    SKAction *sequence = [SKAction sequence:@[wait, removeEnemy]];
    [self runAction:sequence];
}

- (void)gameOver {
    SKAction *gameOverAction = [SKAction runBlock:^{
        self->playerBrokeScore=NO;
        
        if(self->_score > self->_newHighestScore) {
            self->_newHighestScore=self->_score;
            [self saveNewHighestScoreInPlist];
            self->viewController = [[GameViewController alloc]init];
            [self->viewController reportScore:self->_score];
            self->playerBrokeScore=YES;
        }
        
        [self stopBackgroundMusic];
        GameOverScene* gameOver = [[GameOverScene alloc] initWithSize: self.size
                                                      andHighestScore: self->_newHighestScore
                                                             andScore: self->_score
                                                        andBrokeScore: self->playerBrokeScore
                                                      andSoundEnabled: self->_playSounds
                                                       andTimesPlayed:self->timesPlayed];
        
        
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        
        [self.view presentScene:gameOver transition: reveal];
    }];
    
    [self runAction:gameOverAction];
}

- (void) updatePowerUpBar{
    [powerUpBar removeFromParent];
    
    NSString* imageName = [NSString stringWithFormat:@"powerUp%d",_powerUpStage];
    
    if(_powerUpStage == POWERUP_STAGE_MAX){
        powerUpButton = [self makePowerUpButton];
        [self addChild: powerUpButton];
    }
    
    [self addChild: [self makePowerUpBar:imageName]];
    
}

- (void)increaseGesturesQuantity {
    if (_maxGestureQtd < 4) {
        _maxGestureQtd++;
    }
}

- (int)generateGesturesQuantity {
    return (arc4random() % _maxGestureQtd);
}

- (void)pauseGame {
    
    SKAction * pauseGame = [SKAction runBlock:^{
        GamePausedScene *myScene = [[GamePausedScene alloc] initWithSize:self.size andGameScene: self];
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:myScene transition: reveal];
        [self pauseBackgroundMusic];
    }];
    
    [pauseButton runAction:pauseGame];
    [self setPaused: YES];
}

- (void)saveNewHighestScoreInPlist {
     
    
    if(dataToSaveInPlist==nil) {
        dataToSaveInPlist = [[NSMutableArray alloc]init];
        
    }else {
        [dataToSaveInPlist removeAllObjects];
    }
    
    
    [dataToSaveInPlist addObject: [NSString stringWithFormat:@"%d", _newHighestScore]];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data.plist"];
    [dataToSaveInPlist writeToFile:path atomically:YES];
}

- (void)readHighestScoreFromPlist {
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data.plist"];
    
    NSMutableArray *result = [[NSMutableArray alloc]initWithContentsOfFile:path];
    
    if(result == nil) {
        _newHighestScore=0;
    }else {
        int cont=0;
        for (NSString *str in result) {
            if(cont==0) {
                _newHighestScore=[str intValue];
                cont++;
            }
        }
    }
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

- (void) pauseBackgroundMusic{
    [musicPlayer pause];
}

- (void)resumeBackgroundMusic{
    [musicPlayer play];
}

@end
