//
//  SettingsViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//
static const int DIFFICULTY_ROW = 0;
//static const int HARD_HIGH_SCORE_ROW = 1;
//static const int EASY_HIGH_SCORE_ROW = 2;
static const int TOTAL_MISTAKES_ROW = 3;
static const int REMOVE_ADS_ROW = 4;
static const int CONTACT_US_ROW = 5;

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "AppDelegate.h"

#define kRemoveAdsProductIdentifier @"clintonTrumpRemoveAds"

@interface SettingsViewController ()


@end

@implementation SettingsViewController
{
    NSArray *titleLabels;
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.removeAdsProductIdentifier = @"clintonTrumpRemoveAds";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int image = arc4random_uniform(2);
    
    if(image == 0)
    {
        [self.imageView setImage:[UIImage imageNamed:@"clinton7sized.jpg"]];
    }
    else if(image == 1)
    {
        [self.imageView setImage:[UIImage imageNamed:@"trump14sized.jpg"]];
    }
    
    titleLabels = [[NSArray alloc] initWithObjects:/*@"Audio",*/@"Difficulty",@"Hard High Score",@"Easy High Score",@"Total Mistakes",@"Remove Ads/Restore Purchase",@"Contact Us", nil];
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
        /*case 0: //audio row
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"Audio"])
                cell.valueLabel.text = @"On";
            else
                cell.valueLabel.text = @"Off";
            break;*/
        case DIFFICULTY_ROW: //difficult row
            cell.valueLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[titleLabels objectAtIndex:row]];
            break;
        case REMOVE_ADS_ROW: //remove ads row
            cell.valueLabel.hidden = YES;
            break;
        case CONTACT_US_ROW: //contact row
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
        /*case 0: //audio row
            [self toggleAudio];
            break;*/
        case DIFFICULTY_ROW: //difficulty row
            [self toggleDifficulty];
            break;
        /*case 2:
            //[self deleteStat:@"Hard High Score"];
            break;
        case 3:
            //[self deleteStat:@"Easy High Score"];
            break;*/
        case TOTAL_MISTAKES_ROW:
            [self deleteStat:@"Total Mistakes"];
            break;
        case REMOVE_ADS_ROW:
            [self confirmRemoveAds];
            break;
        case CONTACT_US_ROW:
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
/*-(void)toggleAudio{
    
    BOOL audio = [[NSUserDefaults standardUserDefaults] boolForKey:@"Audio"];
    
    [[NSUserDefaults standardUserDefaults] setBool:!audio forKey:@"Audio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}*/

-(void)toggleDifficulty{
    
    NSString *difficulty = [[NSUserDefaults standardUserDefaults] objectForKey:@"Difficulty"];
    
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


//REMOVE ADS METHODS
-(void)confirmRemoveAds{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"removeAdsPurchased"])
    {
        [self presentErrorAlertWithTitle:@"Already Purchased" message:@"Ads have already been removed on this device."];
    }
    else
    {
        [self removeAds];
    }
    
        
    /*UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:@"Remove Ads?" message:@"Are you sure you want to remove ads for $0.99?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeAds];
    }];
    
    [confirmAlert addAction: cancelAction];
    [confirmAlert addAction:continueAction];
    [self presentViewController:confirmAlert animated:YES completion:nil];*/
    
}


-(void)removeAds{
    NSLog(@"Remove Ads");
    
    
    if([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.removeAdsProductIdentifier]];
        request.delegate = self;
        [request start];
    }
    /*
    if([self canMakePurchases])
    {
        NSLog(@"User can make payments");
        
        SKProductsRequest *removeAdsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:kRemoveAdsProductIdentifier, nil]];
        removeAdsRequest.delegate = self;
        [removeAdsRequest start];
    }
    else
    {
        NSLog(@"User cannot make payment—display alert");
        [self presentErrorAlertWithTitle:@"Cannot Make Payments" message:@"This user is not authorized to make payments on the App Store. Check the restrictions in your device's settings."];
    }*/
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    
    if(products.count > 0)
    {
        NSLog(@"Available Products");
        self.removeAdsProduct = products.firstObject;
        [self buyProduct];
    }
    
}

-(void)buyProduct
{
    NSLog(@"Buy product");
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    SKPayment *payment = [SKPayment paymentWithProduct:self.removeAdsProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    NSLog(@"Update transaction");
    
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Transaction purchased");
                [self unlockPurchase];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction purchasing");
                break;
                
            default:
                break;
        }
    }
    
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"Restore finished. Restored Purchases: %lu", (unsigned long)queue.transactions.count);
    
    [self unlockPurchase];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Restore failed: %@", error);
}

-(void)unlockPurchase
{
    NSLog(@"Unlock purchase");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"removeAdsPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDelegate setRemoveAdsPurchased:YES];
    //[self presentErrorAlertWithTitle:@"Ads removed" message:@"Ads have been removed. You can always restore this purchase for free. Thank you."];
}
//END REMOVE ADS METHODS*/




//CONTACT METHODS
-(void)contactUs{
    
    NSArray *recipients = [NSArray arrayWithObject:@"jackstdevelopment@gmail.com"];
    
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
