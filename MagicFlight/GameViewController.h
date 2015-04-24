//
//  GameViewController.h
//  MagicFlight
//

//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) NSString* leaderboardIdentifier;

-(void)authenticateLocalPlayer;
-(void)reportScore: (int) scoreValue;


@end
