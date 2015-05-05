//
//  GameViewController.m
//  MagicFlight
//
//  Created by Ruyther Parente Da Costa on 4/9/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "GameMenuScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [self authenticateLocalPlayer];
    _leaderboardIdentifier=@"Best_Score_Of_The_App";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createPost:)
                                                 name:@"CreatePost"
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
        SKScene * scene = [[GameMenuScene alloc]initWithSize:skView.bounds.size
                                       andSoundEnabled: YES];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}


-(void)reportScore: (int)scoreValue {
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Best_Score_Of_The_App"];
    score.value = scoreValue;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)createPost: (NSNotification *)notification {
    NSDictionary *postData = [notification userInfo];
    NSString *postText = (NSString *)[postData objectForKey:@"postText"];
    
    // build your tweet, facebook, etc...
    SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [mySLComposerSheet setInitialText:postText];
    [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    
}

@end
