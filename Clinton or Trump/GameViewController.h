//
//  GameViewController.h
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOverViewController.h"

@protocol GameViewControllerDelegate
-(void)gameDidEnd;
@end


@interface GameViewController : UIViewController <GameOverViewControllerDelegate>
@property (weak, nonatomic) id <GameViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *lossView;
@property (strong, nonatomic) IBOutlet UILabel *lossTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lossDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *gameOverView;
@property (strong, nonatomic) IBOutlet UILabel *modeLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *quoteLabel;
- (IBAction)chooseTrump;
- (IBAction)chooseClinton;
- (IBAction)showQuoteAnswer:(id)sender;

@end