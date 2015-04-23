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

#define HORIZ_SWIPE_DRAG_MIN_H  12
#define VERT_SWIPE_DRAG_MAX_H   20
#define HORIZ_SWIPE_DRAG_MIN_V  20
#define VERT_SWIPE_DRAG_MAX_V   15

@implementation GameScene {
    
    CGMutablePathRef pathToDraw;
    SKSpriteNode *mage;
    SKSpriteNode *background;
    SKSpriteNode *powerUp;
    SKShapeNode *lineNode;
    SKLabelNode *scoreLabel;
    NSMutableArray *dataToSaveInPlist;
    GamePausedScene *pauseScene;
    SKSpriteNode *pauseButton;
    NSArray *gestureNames;
    NSArray *gestureColors;
    NSArray* enemies;
    NSTimer *timer;
    CGPoint startPositionInScene;
    int auxiliarIncrement;
    int auxiliarIncrementGestureNumberInEnemy;
    int _score;
    int enemyNumber;
    int _maxGestureQtd;
    int _scoreTemporary;
    int _newHighestScore;
    float spawnEnemiesQuatity;
    float increasingEnemySpeed;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        gestureNames = [NSArray arrayWithObjects:@"swipeToRight",
                                                 @"swipeToLeft",
                                                 @"swipeUp",
                                                 @"swipeDown", nil];
        
        gestureColors = [NSArray arrayWithObjects: [UIColor redColor],
                                                   [UIColor blueColor],
                                                   [UIColor greenColor],
                                                   [UIColor yellowColor], nil];
        
        //colocar o fundo do gameplay aqui (arte)
        self.backgroundColor = [SKColor whiteColor];
        
        _maxGestureQtd = 1;
        _score = 0;
        enemyNumber = 0;
        spawnEnemiesQuatity = 4.5;
        increasingEnemySpeed = 6;
        _score = 0;
        _scoreTemporary = 0;
        auxiliarIncrementGestureNumberInEnemy = 0;
        
        [self readHighestScoreFromPlist];
        
        scoreLabel = [self makeScoreLabel];
        [self addChild:scoreLabel];
        
        mage = [self makeMage];
        [self addChild:mage];
        
        powerUp = [self makePowerUp];
        [self addChild:powerUp];
        
        background = [self makeBackground];
        [self addChild:background];
        
        pauseButton = [self makePauseButton];
        [self addChild:pauseButton];
        
        [self.view setMultipleTouchEnabled:NO];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    startPositionInScene = [touch locationInNode:self];
    
    SKNode* node = [self nodeAtPoint:startPositionInScene];
    
    if ([node.name isEqualToString:@"pauseButton"]) {
        SKAction * pauseGame = [SKAction runBlock:^{
            [self pauseGame];
        }];
        
        [pauseButton runAction:pauseGame];
    }
    
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, startPositionInScene.x, startPositionInScene.y);
    
    lineNode = [SKShapeNode node];
    lineNode.path = pathToDraw;
    lineNode.strokeColor = [SKColor redColor];
    lineNode.lineWidth = 10;
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
    SKNode *node = [self nodeAtPoint:currentTouchPosition];
    
    [lineNode removeFromParent];
    CGPathRelease(pathToDraw);
    
    if ([node.name isEqualToString:@"powerUp"]) {
        SKAction *run = [SKAction runBlock:^{
            NSLog(@"EU");
        }];
        
        [node runAction:run];
    }
    
    if (fabs(startPositionInScene.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN_H &&
        fabs(startPositionInScene.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX_H) {
        
        // If touch appears to be a swipe
        if (startPositionInScene.x < currentTouchPosition.x) {
            [self rightSwipe];
        }
    }
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(startPositionInScene.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN_H &&
        fabs(startPositionInScene.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX_H) {
        
        // If touch appears to be a swipe
        if (startPositionInScene.x > currentTouchPosition.x) {
            [self leftSwipe];
        }
    }
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(startPositionInScene.y - currentTouchPosition.y) >= HORIZ_SWIPE_DRAG_MIN_V &&
        fabs(startPositionInScene.x - currentTouchPosition.x) <= VERT_SWIPE_DRAG_MAX_V) {
        
        if (startPositionInScene.y < currentTouchPosition.y) {
            [self upSwipe];
        }
    }
    
    //  Check if direction of touch is horizontal and long enough
    if (fabs(startPositionInScene.y - currentTouchPosition.y) >= HORIZ_SWIPE_DRAG_MIN_V &&
        fabs(startPositionInScene.x - currentTouchPosition.x) <= VERT_SWIPE_DRAG_MAX_V) {
        // If touch appears to be a swipe
        if (startPositionInScene.y > currentTouchPosition.y) {
            [self downSwipe];
        }
    }
    
    startPositionInScene = CGPointZero;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)update:(NSTimeInterval)currentTime {
    [self updateScore];
    [self checkCollision];
}

- (SKLabelNode *)makeScoreLabel {
    
    SKLabelNode *scoreLabelNode = [SKLabelNode labelNodeWithText: @""];
    
    scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    scoreLabelNode.zPosition = 15;
    scoreLabelNode.fontColor = [UIColor blackColor];
    scoreLabelNode.fontSize = 30;
    
    return scoreLabelNode;
}

- (SKSpriteNode *)makeMage {
    SKSpriteNode *mageNode = [SKSpriteNode spriteNodeWithImageNamed:@"mage"];
    mageNode.zPosition = 15;
    mageNode.name = @"mage";
    
    SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 20) duration:2];
    [mageNode runAction:entry];
    
    return mageNode;
}

- (SKSpriteNode*) makePauseButton{
    SKSpriteNode* pauseNode = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
    
    pauseNode.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 50);
    pauseNode.zPosition = 10;
    pauseNode.name = @"pauseButton";
    [pauseNode setScale: 0.15];
    
    return pauseNode;
}


- (SKSpriteNode *)makeBackground {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    
    backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    [backgroundNode setScale:2.0];
    return backgroundNode;
}

- (SKSpriteNode *)makePowerUp {
    SKSpriteNode *powerUpNode = [SKSpriteNode spriteNodeWithImageNamed:@"powerUpIcon"];
    
    powerUpNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height/2 + 50);
    powerUpNode.zPosition = 17;
    powerUpNode.xScale = 0.2;
    powerUpNode.yScale = 0.2;
    powerUpNode.name = @"powerUp";
    
    return powerUpNode;
}

- (void)spawnCloud {
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    
    [cloud setScale:0.2];
    cloud.zPosition = 0;
    
    CGPoint position = CGPointMake(arc4random_uniform(self.frame.size.width), self.frame.size.height);
    
    cloud.position = position;
    SKAction *move = [SKAction moveToY: -200 duration:6];
    [cloud runAction:move];
    
    [self addChild:cloud];
}

- (void)spawnEnemy {
    
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemyBat"];
    
    [enemy setScale:0.1];
    enemy.zPosition = 5;
    enemy.name = @"bat";
    
    CGPoint position = CGPointMake(arc4random_uniform(self.frame.size.width), self.frame.size.height);
    
    enemy.position = position;
    SKAction *move = [SKAction moveTo: mage.position duration:increasingEnemySpeed];
    [enemy runAction:move];

    for(int cont = 0; cont < _maxGestureQtd; cont++){
        [enemy addChild:[self makeGesture:enemy.frame]];
    }
    
    [self addChild:enemy];
    auxiliarIncrement++;
}

- (SKSpriteNode *)makeGesture: (CGRect)enemySize {
    
    SKSpriteNode* gesture = [self randomGestureNode: [self generateGesturesQuantity]];
    gesture.position = CGPointMake(gesture.position.x, gesture.position.y + 300);
    gesture.zPosition = 5;
    
    return gesture;
}

- (SKSpriteNode *)randomGestureNode: (int)number {
    
    CGRect rect;
    rect.size.height = 200;
    rect.size.width = 200;
    
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:gestureColors[number] size:rect.size];
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
                              
                              if (CGRectIntersectsRect(enemy.frame, mage.frame)) {
                                  [self gameOver];
                              }
                          }];
}

- (void)attack: (NSString *)gestureType {
    
    enemies = [[NSArray alloc]initWithArray:[self objectForKeyedSubscript:@"bat"]];
    
    for (SKSpriteNode* enemy in enemies) {
        [enemy removeChildrenInArray:[enemy objectForKeyedSubscript:gestureType]];
        
        
        for (int i=1; i<=4; i++) {
            if ([[enemy children]count] == i) {
                _scoreTemporary+=10;
            }
        }
            
        if ([[enemy children]count] == 0) {
            _scoreTemporary+=10;
            _score+=_scoreTemporary;
            _scoreTemporary=0;
            [enemy removeFromParent];
        }
    }
}

- (void)gameOver {
    SKAction *gameOverAction = [SKAction runBlock:^{
        GameOverScene* gameOver = [[GameOverScene alloc] initWithSize:self.size WithHighestScore: _newHighestScore];        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        
        [self.view presentScene:gameOver transition: reveal];
    }];
    
    if(_score > _newHighestScore) {
        [self saveNewHighestScoreInPlist];
    }
    
    [self runAction:gameOverAction];
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
    
    CGSize size = CGSizeMake(self.size.width/2, self.size.height/3);
    
    pauseScene = [[GamePausedScene alloc]initWithSize: size];
    
    SKAction * pauseGame = [SKAction runBlock:^{
        GamePausedScene * myScene = [[GamePausedScene alloc] initWithSize:self.size andGameScene: self];
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:myScene transition: reveal];
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
    
    _newHighestScore=_score;
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

@end
