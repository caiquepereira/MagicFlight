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
#import <AVFoundation/AVFoundation.h>

#define HUD_POSITION 15
#define ENEMY_POSITION 10
#define CLOUDS_POSITION 5
#define BACKGROUND_POSITION 0

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
    SKSpriteNode *edge;
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
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        gestureNames = [NSArray arrayWithObjects:@"swipeToRight",
                        @"swipeToLeft",
                        @"swipeUp",
                        @"swipeDown", nil];
        
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
        
        //        edge = [self makeEdge];
        //        [self addChild:edge];
        
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
        SKAction *increaseEnemyQuantity = [SKAction waitForDuration:2];
        SKAction *increaseEnemy = [SKAction runBlock:^{
            [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[waitEnemy, spawnEnemy]]]];
            if (spawnEnemiesQuatity > 0 && increasingEnemySpeed > 0) {
                spawnEnemiesQuatity -= 0.02;
                increasingEnemySpeed -= 0.01;
            }
            
            if (auxiliarIncrementGestureNumberInEnemy%12 == 0)
            {
                [self increaseGesturesQuantity];
            }
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[increaseEnemyQuantity, increaseEnemy]]]];
        
        [self playBackgroundMusic:@"gameMusic" ofType:@"mp3"];
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
        SKAction *pauseGame = [SKAction runBlock:^{
            [self pauseGame];
        }];
        
        [pauseButton runAction:pauseGame];
    }
    
    if ([node.name isEqualToString:@"powerUpButton"]) {
        SKAction *usePowerUp = [SKAction runBlock:^{
            [self attack:@"destroyAll"];
            
        }];
        
        [powerUpButton runAction:usePowerUp];
    }
    
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, startPositionInScene.x, startPositionInScene.y);
    
    lineNode = [SKShapeNode node];
    lineNode.path = pathToDraw;
    lineNode.strokeColor = [SKColor orangeColor];
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
    
    [lineNode removeFromParent];
    CGPathRelease(pathToDraw);
    
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
    
    //    if(edge.position.y < self.size.height - edge.size.height){
    //        edge = [self makeEdge];
    //        [self addChild:edge];
    //    }
    
    [self updateScore];
    [self checkCollision];
}

- (SKLabelNode *)makeScoreLabel {
    
    SKLabelNode *scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"English Towne"];
    
    scoreLabelNode.text = @"";
    scoreLabelNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    scoreLabelNode.zPosition = HUD_POSITION;
    scoreLabelNode.fontColor = [UIColor whiteColor];
    scoreLabelNode.fontSize = 50;
    
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
    mageNode.position = CGPointMake(self.frame.size.width/2, -300);
    [mageNode setScale:0.4];
    
    SKAction *entry = [SKAction moveTo: CGPointMake(self.frame.size.width/2, 70) duration:2];
    [mageNode runAction:entry];
    
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
    
    pauseNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 30);
    pauseNode.zPosition = HUD_POSITION;
    pauseNode.name = @"pauseButton";
    [pauseNode setScale: 0.35];
    
    return pauseNode;
}


- (SKSpriteNode *)makeBackground {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    
    backgroundNode.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    return backgroundNode;
}

- (SKSpriteNode *)makePowerUpButton {
    SKSpriteNode *powerUpNode = [SKSpriteNode spriteNodeWithImageNamed:@"powerUpIcon"];
    
    powerUpNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height/2 + 90);
    powerUpNode.zPosition = HUD_POSITION;
    [powerUpNode setScale:0.6];
    powerUpNode.name = @"powerUpButton";
    
    return powerUpNode;
}

- (SKSpriteNode *)makePowerUpBar: (NSString*) imageName{
    SKSpriteNode *powerUpBarNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    powerUpBarNode.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 400);
    powerUpBarNode.zPosition = HUD_POSITION;
    [powerUpBarNode setScale:0.6];
    return powerUpBarNode;
    
}

- (SKSpriteNode*) makeEdge{
    SKSpriteNode* edgeNode = [SKSpriteNode spriteNodeWithImageNamed:@"edge"];
    edgeNode.position = CGPointMake(30, self.size.height+200);
    
    SKAction *move = [SKAction moveToY: -200 duration:6];
    [edgeNode runAction:move];
    
    return edgeNode;
}

- (void)spawnCloud {
    
    NSString* imageName = [NSString stringWithFormat:@"cloud%d",arc4random_uniform(2)];
    
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    
    [cloud setScale:0.4];
    cloud.zPosition = CLOUDS_POSITION;
    
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
    
    [enemy setScale:0.5];
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

- (SKSpriteNode *)makeGesture: (CGRect)enemySize {
    
    SKSpriteNode* gesture = [self randomGestureNode: [self generateGesturesQuantity]];
    gesture.position = CGPointMake(gesture.position.x, gesture.position.y + enemySize.size.height + 40);
    [gesture setScale:1];
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
                               
                               if (CGRectIntersectsRect(enemy.frame, mage.frame)) {
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
            [enemy removeFromParent];
            _destroyedEnemies++;
            
            if(_destroyedEnemies >= 3 && _powerUpStage < POWERUP_STAGE_MAX){
                _powerUpStage++;
                _destroyedEnemies = 0;
                
                [self updatePowerUpBar];
            }
        }
    }
}

- (void)gameOver {
    SKAction *gameOverAction = [SKAction runBlock:^{
        [self stopBackgroundMusic];
        GameOverScene* gameOver = [[GameOverScene alloc] initWithSize:self.size andHighestScore: _newHighestScore];
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        
        [self.view presentScene:gameOver transition: reveal];
    }];
    
    if(_score > _newHighestScore) {
        [self saveNewHighestScoreInPlist];
    }
    
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
        GamePausedScene * myScene = [[GamePausedScene alloc] initWithSize:self.size andGameScene: self];
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

-(void) pauseBackgroundMusic{
    [musicPlayer pause];
}

- (void)resumeBackgroundMusic{
    [musicPlayer play];
}

@end
