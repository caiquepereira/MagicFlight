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
                                                 name:@"CreatePost"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createTwitter:)
                                                 name:@"CreateTwitter"
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
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        NSDictionary *postData = [notification userInfo];
//        NSString *postText = (NSString *)[postData objectForKey:@"postText"];
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet addImage:[self getImage]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        
//        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result) {
//            if (result == SLComposeViewControllerResultDone) {
//                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"POST" message:@"You post was sent sucessfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                
//                [alertView show];
//            }
//        };
//        
//        mySLComposerSheet.completionHandler = myBlock;
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
    [self removeImage];
}

- (void)createTwitter:(NSNotification *)notification {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        NSDictionary *postData = [notification userInfo];
//        NSString *postTwitter = (NSString *)[postData objectForKey:@"postTwitter"];
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet addImage:[self getImage]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        
//        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result) {
//            if (result == SLComposeViewControllerResultDone) {
//                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"POST" message:@"You post was sent sucessfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                
//                [alertView show];
//            }
//        };
//        
//        mySLComposerSheet.completionHandler = myBlock;
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You can't post right now, make sure your device has an internet connection and you have at least one twitter account setup." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
    [self removeImage];
}

- (UIImage *)getImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    UIImage *highScoreScreenShoot = [UIImage imageWithContentsOfFile:getImagePath];
    
    return highScoreScreenShoot;
}

- (void)removeImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    [[NSFileManager defaultManager]removeItemAtPath:getImagePath error:nil];
    
}

@end
