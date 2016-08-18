//
//  SettingsViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
{
    NSArray *titleLabels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int image = arc4random_uniform(2);
    
    if(image == 0)
    {
        [self.imageView setImage:[UIImage imageNamed:@"clinton7sized.jpg"]];
    }
    else if(image == 1)
    {
        [self.imageView setImage:[UIImage imageNamed:@"trump14sized.jpg"]];
    }
    
    titleLabels = [[NSArray alloc] initWithObjects:@"Audio",@"Difficulty",@"Hard High Score",@"Easy High Score",@"Total Mistakes",@"Remove Ads",@"Contact Us", nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentErrorAlertWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [errorAlert addAction: closeAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleLabels count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    
    int row = (int)indexPath.row;
    cell.titleLabel.text = [titleLabels objectAtIndex:row];
    cell.valueLabel.hidden = NO;
    
    switch (row)
    {
        case 0: //audio row
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"Audio"])
                cell.valueLabel.text = @"On";
            else
                cell.valueLabel.text = @"Off";
            break;
        case 1: //difficult row
            cell.valueLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[titleLabels objectAtIndex:row]];
            break;
        case 5: //remove ads row
            cell.valueLabel.hidden = YES;
            break;
        case 6: //contact row
            cell.valueLabel.hidden = YES;
            break;
        default:
            cell.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:[titleLabels objectAtIndex:row]]];
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = (int)indexPath.row;
    switch(row)
    {
        case 0: //audio row
            [self toggleAudio];
            break;
        case 1: //difficulty row
            [self toggleDifficulty];
            break;
        case 2:
            [self deleteStat:@"Hard High Score"];
            break;
        case 3:
            [self deleteStat:@"Easy High Score"];
            break;
        case 4:
            [self deleteStat:@"Total Mistakes"];
            break;
        case 5:
            [self removeAds];
            break;
        case 6:
            [self contactUs];
            break;
        
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)toggleAudio{
    
    BOOL audio = [[NSUserDefaults standardUserDefaults] boolForKey:@"Audio"];
    
    [[NSUserDefaults standardUserDefaults] setBool:!audio forKey:@"Audio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

-(void)toggleDifficulty{
    
    NSString *difficulty = [[NSUserDefaults standardUserDefaults] objectForKey:@"Difficulty"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if( [difficulty isEqualToString:@"Hard"] )
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Easy" forKey:@"Difficulty"];
        [appDelegate setLeaderboardIdentifier:@"easyLeaderboard"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Hard" forKey:@"Difficulty"];
        [appDelegate setLeaderboardIdentifier:@"hardLeaderboard"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

-(void)deleteStat:(NSString *)statKey {
    
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:@"Reset stat?" message:@"Are you sure you want to reset this stat? You will not be able to undo this." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:statKey];
        [self.tableView reloadData];
    }];
    
    [confirmAlert addAction: cancelAction];
    [confirmAlert addAction:continueAction];
    [self presentViewController:confirmAlert animated:YES completion:nil];
}

-(void)removeAds{
    NSLog(@"Remove Ads—To do");
}

-(void)contactUs{
    
    NSArray *recipients = [NSArray arrayWithObject:@"jackstenglein@gmail.com"];
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setToRecipients:recipients];
    [self presentViewController:mailVC animated:YES completion:nil];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    //NSLog(@"mail composer did finish");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:NO];
    
    switch(result)
    {
        case MFMailComposeResultCancelled:
            //[self presentNotificationViewWithTitle:@"Email cancelled"];
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultFailed:
            [self presentErrorAlertWithTitle:@"Email failed to send" message:@"Make sure you are connected to the Internet and try again!"];
            break;
        case MFMailComposeResultSent:
            break;
        default:
            break;
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end