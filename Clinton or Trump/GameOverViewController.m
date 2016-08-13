//
//  GameOverViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "GameOverViewController.h"
#import "AppDelegate.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController
{
    int highScore;
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.gameCenterEnabled)
    {
        [self reportScoreToGameCenter];
    }
    
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] == 0)
    {
        highScore = self.currentScore;
    }
    else
    {
        highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
    }
    
    [self.currentScoreLabel setText:[NSString stringWithFormat:@"Score: %d",self.currentScore]];
    [self.highScoreLabel setText:[NSString stringWithFormat:@"High Score: %d", highScore]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)reportScoreToGameCenter{
    
    NSLog(@"Report Score");
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:appDelegate.leaderboardIdentifier];
    score.value = self.currentScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}

- (IBAction)returnToHome:(id)sender {
    
    if(self.currentScore >= highScore)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:self.currentScore forKey:@"highScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.delegate returnToHome];
    //[[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:nil];
   // [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
