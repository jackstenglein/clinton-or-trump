//
//  HomeViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    int gamesPlayed;
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gamesPlayed = 0;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loadInterstitialAds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//AD METHODS
-(void)loadInterstitialAds{
    NSLog(@"Load Interstitial Ads");
    
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-9083199621917832/7672840509"];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
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
    if([[segue identifier] isEqualToString:@"showGameVC"])
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
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if(gamesPlayed >= 3)
    {
        gamesPlayed = 0;
        [self showInterstitial];
    }
    
}

-(void)returnToHome{
    [self dismissViewControllerAnimated:NO completion:nil];
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








