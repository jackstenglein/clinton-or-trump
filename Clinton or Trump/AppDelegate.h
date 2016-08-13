//
//  AppDelegate.h
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GameKit;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *leaderboardIdentifier;
@property BOOL gameCenterEnabled;
-(void)authenticateLocalPlayer;
@end

