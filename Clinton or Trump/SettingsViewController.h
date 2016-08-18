//
//  SettingsViewController.h
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
