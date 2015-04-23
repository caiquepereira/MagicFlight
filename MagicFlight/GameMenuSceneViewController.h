//
//  GameMenuSceneViewController.h
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 23/04/15.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>

@interface GameMenuSceneViewController : UIViewController <GKGameCenterControllerDelegate>


-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;

@end
