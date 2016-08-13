//
//  GameOverViewController.h
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GameOverViewControllerDelegate
-(void)returnToHome;
@end

@interface GameOverViewController : UIViewController
@property (weak, nonatomic) id<GameOverViewControllerDelegate> delegate;
@property int currentScore;
@property (strong, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
- (IBAction)returnToHome:(id)sender;

@end