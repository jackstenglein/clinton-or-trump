//
//  AppDelegate.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "AppDelegate.h"
//#import "Firebase.h"//;
@import GoogleMobileAds;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-2103446892914207~1330190376"];
    
    
    if( ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedBefore"] )
    {
        //This is first Launch of app, set all needed values
        NSLog(@"First launch");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedBefore"];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Audio"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Hard" forKey:@"Difficulty"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Hard High Score"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Easy High Score"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Total Mistakes"];
    }
    
    self.removeAdsPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"removeAdsPurchased"];
    if(self.removeAdsPurchased)
        NSLog(@"Remove ads purchased");
    else
        NSLog(@"Remove ads not purchased");
    
    [self authenticateLocalPlayer];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)authenticateLocalPlayer{
    NSLog(@"App Delegate Authenticate");
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            if( ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedBefore"] )
            {
                [self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
            }
            else
            {
                _gameCenterEnabled = NO;
            }
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated)
            {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil)
                    {
                        NSLog(@"Error: %@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            else
            {
                _gameCenterEnabled = NO;
            }
        }
    };
}

@end
