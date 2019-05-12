//
//  HomeViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import <sys/sysctl.h>

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    int gamesPlayed;
    AppDelegate *appDelegate;
    BOOL animate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gamesPlayed = 0;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if(!appDelegate.removeAdsPurchased)
        [self loadInterstitialAds];
    
    
    int widthConstraint = [self widthConstraintForDeviceType];
    self.backgroundWithConstraint.constant = widthConstraint;
    
    self.imageView.alpha = 0.0f;
    animate = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view layoutIfNeeded];
    
    if(animate)
    {
        [UIView animateWithDuration:1.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.imageView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             // Do nothing
                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)widthConstraintForDeviceType{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone4,1"])    return 0;
    if ([platform isEqualToString:@"iPhone5,1"])    return 18;
    if ([platform isEqualToString:@"iPhone5,2"])    return 18;
    if ([platform isEqualToString:@"iPhone5,3"])    return 18;
    if ([platform isEqualToString:@"iPhone5,4"])    return 18;
    if ([platform isEqualToString:@"iPhone6,1"])    return 18;
    if ([platform isEqualToString:@"iPhone6,2"])    return 18;
    if ([platform isEqualToString:@"iPhone7,2"])    return 22;
    if ([platform isEqualToString:@"iPhone7,1"])    return 24;
    if ([platform isEqualToString:@"iPhone8,1"])    return 22;
    if ([platform isEqualToString:@"iPhone8,2"])    return 24;
    
    return 0;
}


//AD METHODS
-(void)loadInterstitialAds{
    NSLog(@"Load Interstitial Ads");
    
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2103446892914207/5689351171"];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID, @"e7ec5950c11b81a88c095ef7eb934ace", @"74e0f8f12a18d92e0d89c4c682bd4e7e" ];
    [self.interstitial loadRequest:request];
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    NSLog(@"Interstitial did dismiss screen");
    
    [self loadInterstitialAds];
}
//END AD METHODS


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if( [[segue identifier] isEqualToString:@"showGameVC"] )
    {
        GameViewController *gameVC = [segue destinationViewController];
        [gameVC setDelegate:self];
    }
}


- (void)showInterstitial {
    NSLog(@"Show Interstitial");
    
    if (self.interstitial.isReady)
    {
        [self.interstitial presentFromRootViewController:self];
    }
    else
    {
        NSLog(@"Ad wasn't ready");
    }
}

-(void)gameDidEnd{
    
    gamesPlayed++;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Games played %d", gamesPlayed);
    
    if(gamesPlayed >= 3 && !appDelegate.removeAdsPurchased)
    {
        gamesPlayed = 0;
        [self showInterstitial];
    }
    
    int totalMistakes = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"Total Mistakes"];
    totalMistakes++;
    [[NSUserDefaults standardUserDefaults] setInteger:totalMistakes forKey:@"Total Mistakes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//GAME CENTER METHODS
- (IBAction)showGameCenter:(id)sender {
    
    NSLog(@"Show Game Center");
    
    if(appDelegate.gameCenterEnabled)
    {
        [self showGCLeaderboard];
    }
    else
    {
        [self presentGameCenterAlert];
    }
}

-(void)presentGameCenterAlert
{
    UIAlertController *gameCenterAlert = [UIAlertController alertControllerWithTitle:@"Connection Failed" message:@"Cannot connect to Game Center. Please check that you're signed into Game Center and connected to the Internet." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [gameCenterAlert addAction:confirmAction];
    [self presentViewController:gameCenterAlert animated:YES completion:nil];
}

-(void)showGCLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//END GAME CENTER METHODS
@end








