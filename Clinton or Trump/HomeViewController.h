//
//  HomeViewController.h
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
@import GoogleMobileAds;
@import GameKit;

@interface HomeViewController : UIViewController <GADInterstitialDelegate, GameViewControllerDelegate, GKGameCenterControllerDelegate>
@property(nonatomic, strong) GADInterstitial *interstitial;
- (IBAction)showGameCenter:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backgroundWithConstraint;


@end