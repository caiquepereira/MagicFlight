//
//  GameViewController.m
//  MagicFlight
//
//  Created by Ruyther Parente Da Costa on 4/9/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "GameMenuScene.h"


@implementation GameViewController{
    int timesPlayed;
}

- (void)viewDidLoad
{
    [self authenticateLocalPlayer];
    _leaderboardIdentifier=@"Best_Score_Of_Magic_Flight";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createPost:)
                                                 name:@"createPost"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createShare:)
                                                 name:@"createShare"
                                               object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [[GameMenuScene alloc]initWithSize:skView.bounds.size andSoundEnabled:YES andTimesPlayed:timesPlayed];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                self->_gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        self->_leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                self->_gameCenterEnabled = NO;
            }
        }
    };
}


- (void)reportScore:(int)scoreValue {
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Best_Score_Of_Magic_Flight"];
    score.value = scoreValue;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


- (void)createPost:(NSNotification *)notification {

    UIImage *imageToShare = [self getImage];
    NSArray *objectsToShare = @[imageToShare];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    activityVC.popoverPresentationController.sourceView = self.view;
    activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;

    
    [self presentViewController:activityVC animated:YES completion:nil];

}

- (void)createShare:(NSNotification *)notification {
    
    NSString *textToShare = @"Have you played Magic Flight? Check it out!";
    NSURL *myWebsite = [NSURL URLWithString:@"https://itunes.apple.com/br/app/magic-flight/id993253138?l=en&mt=8"];
    NSArray *objectsToShare = @[textToShare,myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;

    activityVC.popoverPresentationController.sourceView = self.view;
    activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;

    
    [self presentViewController:activityVC animated:YES completion:nil];
    

    
    
}

- (UIImage *) getImage {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}



- (void)removeImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    [[NSFileManager defaultManager]removeItemAtPath:getImagePath error:nil];
    
}

@end
