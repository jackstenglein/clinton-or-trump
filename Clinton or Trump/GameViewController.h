//
//  GameViewController.h
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GameKit;

@protocol GameViewControllerDelegate
-(void)gameDidEnd;
@end


@interface GameViewController : UIViewController <GKGameCenterControllerDelegate>
@property id<GameViewControllerDelegate> delegate;

//Game View
@property (strong, nonatomic) IBOutlet UIButton *clintonButton;
@property (strong, nonatomic) IBOutlet UIButton *trumpButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)chooseTrump;
- (IBAction)chooseClinton;

//Loss View
@property (strong, nonatomic) IBOutlet UIView *lossView;
@property (strong, nonatomic) IBOutlet UILabel *lossTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lossDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

//Game Over View
@property (strong, nonatomic) IBOutlet UIView *gameOverView;
@property (strong, nonatomic) IBOutlet UILabel *modeLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *quoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *quoteAnswerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gameOverViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scoreViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quoteViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gameOverViewLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quoteViewBottom;
@property (strong, nonatomic) IBOutlet UIButton *viewAnswerButton;
- (IBAction)showQuoteAnswer:(id)sender;
- (IBAction)goHome:(id)sender;
- (IBAction)showLeaderboard:(id)sender;
- (IBAction)share:(id)sender;
@end