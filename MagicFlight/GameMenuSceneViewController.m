//
//  GameMenuSceneViewController.m
//  MagicFlight
//
//  Created by Caique de Paula Pereira on 23/04/15.
//
//

#import "GameMenuSceneViewController.h"
#import "GameViewController.h"
#import "GameMenuScene.h"

@interface GameMenuSceneViewController (){
    NSString *leaderboardIdentifier;
    GKGameCenterViewController *gcViewController;
}

@end

@implementation GameMenuSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    leaderboardIdentifier=@"Best_Score_Of_The_App";
    
    
    //[self presentViewController:self animated:YES completion:nil];
    [self showLeaderboardAndAchievements:YES];
    // Do any additional setup after loading the view.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gcViewController dismissViewControllerAnimated:YES completion:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    }



@end
