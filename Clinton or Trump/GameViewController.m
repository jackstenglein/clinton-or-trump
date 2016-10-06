//
//  GameViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

const NSString *shareLink = @"https://itunes.apple.com/us/app/clinton-or-trump/id1159219246?ls=1&mt=8";

@interface GameViewController ()

@end

@implementation GameViewController
{
    //images and answers for regular candidates
    NSMutableArray *imagesArray;
    NSMutableArray *answersArray;
    
    //images, answers, bools for third party candidates
    NSMutableArray *thirdPartyImages;
    NSMutableArray *thirdPartyAnswers;
    BOOL currentThirdParty;
    BOOL upcomingThirdParty;
    
    //game mode related stuff
    NSTimer *gameOverTimer;
    NSTimeInterval timeInterval;
    BOOL isHardMode;
    BOOL gameOver;
    
    int currentIndex;
    int upcomingIndex;
    int score;
    
    AppDelegate *appDelegate;
    NSDictionary *quoteDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"View did load");
   
    //load images
    imagesArray = [[NSMutableArray alloc] init];
    answersArray = [[NSMutableArray alloc] init];
    thirdPartyImages = [[NSMutableArray alloc] init];
    thirdPartyAnswers = [[NSMutableArray alloc] init];
    [self loadClintonImages];
    [self loadTrumpImages];
    [self loadJohnsonImages];
    [self loadSteinImages];
    
    //set up UI
    [self resetUI];
    
    //set up game variables
    score = 0;
    gameOver = NO;
    currentThirdParty = NO;
    upcomingThirdParty = NO;
    
    //set up hard or easy mode
    NSString *mode = [[NSUserDefaults standardUserDefaults] objectForKey:@"Difficulty"];
    if([mode isEqualToString:@"Hard"])
    {
        isHardMode = YES;
        timeInterval = 0.75;
    }
    else
    {
        isHardMode = NO;
        timeInterval = 1.1;
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Quotes" ofType:@"plist"];
    quoteDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //NSLog(@"Quote dictionary: %@",quoteDictionary);
   
    
    //NSLog(@"Answers Array: %@", answersArray);
    
    //display first picture
    currentIndex = arc4random_uniform((int)[imagesArray count]);
    NSLog(@"Index: %d", currentIndex);
    [_imageView setImage:[imagesArray objectAtIndex:currentIndex]];
    
    //get ready for next picture
    [self pickNewPhoto];
    
    /*if([[NSUserDefaults standardUserDefaults] boolForKey:@"Audio"])
        [self loadAudio];*/
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"View did appear");
    
    if(!gameOver) //start the game timer
    {
        /*if(audioArray != nil)
        {
            [cheering setVolume:0.75];
            [cheering setNumberOfLoops:-1];
            [cheering play];
            [self switchAudioFile];
        }*/
        
        gameOverTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(outOfTime) userInfo:nil repeats:NO];
    }
}

/*-(void)loadAudio {
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [NSString stringWithFormat:@"%@/booing.mp3", resourcePath];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    booing = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    path = [NSString stringWithFormat:@"%@/cheering.mp3", resourcePath];
    soundUrl = [NSURL fileURLWithPath:path];
    cheering = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    
    audioArray = [[NSMutableArray alloc] initWithCapacity:30];
    [self loadAudioFile:@"attackingLooks.mp3"];
    [self loadAudioFile:@"attackObama.mp3"];
    [self loadAudioFile:@"china.mp3"];
    [self loadAudioFile:@"crookedHillary.mp3"];
    [self loadAudioFile:@"email1.mp3"];
    [self loadAudioFile:@"email2.mp3"];
    [self loadAudioFile:@"email3.mp3"];
    [self loadAudioFile:@"email4.mp3"];
    [self loadAudioFile:@"gayMarriage1.mp3"];
    [self loadAudioFile:@"gayMarriage2.mp3"];
    [self loadAudioFile:@"getOut.mp3"];
    [self loadAudioFile:@"greatWall1.mp3"];
    [self loadAudioFile:@"greatWall2.mp3"];
    [self loadAudioFile:@"greatWall3.mp3"];
    [self loadAudioFile:@"greatWall4.mp3"];
    [self loadAudioFile:@"greatWall5.mp3"];
    [self loadAudioFile:@"greatWall6.mp3"];
    [self loadAudioFile:@"greatWall7.mp3"];
    [self loadAudioFile:@"huge1.mp3"];
    [self loadAudioFile:@"insultingTrump1.mp3"];
    [self loadAudioFile:@"insultingTrump2.mp3"];
    [self loadAudioFile:@"mistake.mp3"];
    [self loadAudioFile:@"muslims.mp3"];
    [self loadAudioFile:@"reporterInsult.mp3"];
    [self loadAudioFile:@"right.mp3"];
    [self loadAudioFile:@"sitDown.mp3"];
    [self loadAudioFile:@"sniperFire1.mp3"];
    [self loadAudioFile:@"sniperFire2.mp3"];
    [self loadAudioFile:@"sniperFire3.mp3"];
    [self loadAudioFile:@"warHero.mp3"];

}

-(void)loadAudioFile:(NSString *)file{
    // Construct URL to sound file
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", resourcePath, file];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    // Add audio player to audio array
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player setNumberOfLoops:0];
    [player setVolume:1.0];
    [audioArray addObject:player];
}

-(void)switchAudioFile{
    
    int num = 0;
    while( num == currentIndex )
    {
        NSLog(@"Pick random audio: %d", (int)[audioArray count]);
        num = arc4random_uniform((int)[audioArray count]);
    }
    
    currentIndex = num;
    
    AVAudioPlayer *player = [audioArray objectAtIndex:currentIndex];
    if([player play])
        NSLog(@"PLAYING AUDIO");
    
    audioTimer = [NSTimer scheduledTimerWithTimeInterval:[player duration] + 5 target:self selector:@selector(switchAudioFile) userInfo:nil repeats:NO];
}*/

-(void)resetUI{
    NSLog(@"Reset UI");
    
    self.lossView.hidden = YES;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.gameOverViewWidth.constant = width;
    self.quoteViewWidth.constant = width;
    self.scoreViewWidth.constant = width;
    self.gameOverViewLeading.constant = width;
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//LOADING METHODS
-(void)setupNewGame{
    [self loadClintonImages];
    [self loadTrumpImages];
}

-(void)loadClintonImages{
    NSLog(@"Load Clinton Images");
    
    //there are 16 clinton images
    for(int i = 1; i < 17; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"clinton%dsized.jpg",i];
        [imagesArray addObject:[UIImage imageNamed:fileName]];
        [answersArray addObject:@"clinton"];
    }
    
    NSLog(@"Finished loading clinton images");
}

-(void)loadTrumpImages{
     NSLog(@"Load Trump Images");
    
    //there are 16 trump images
    for(int i = 1; i < 17; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"trump%dsized.jpg",i];
        [imagesArray addObject:[UIImage imageNamed:fileName]];
        [answersArray addObject:@"trump"];
    }
    
    NSLog(@"Finished loading trump images");
}

-(void)loadJohnsonImages{
     NSLog(@"Load Johnson Images");
    
    //there are 4 johnson images
    for(int i = 1; i < 5; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"johnson%dsized.jpg",i];
        [thirdPartyImages addObject:[UIImage imageNamed:fileName]];
        [thirdPartyAnswers addObject:@"johnson"];
    }
    
    NSLog(@"Finished loading johnson images");
}

-(void)loadSteinImages{
     NSLog(@"Load Stein Images");
    
    for(int i = 1; i < 5; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"stein%dsized.jpg",i];
        [thirdPartyImages addObject:[UIImage imageNamed:fileName]];
        [thirdPartyAnswers addObject:@"stein"];
    }
    
    NSLog(@"Finished loading stein images");
}



//IN-GAME METHODS
-(void)pickNewPhoto{
    NSLog(@"pick new photo");
    
    //check to see if we are good for third-party candidate tricks
    if(score > 5 && !currentThirdParty)
    {
        
        int num = arc4random_uniform(13); //1 in 13 chance of third-party candidate
        
        if(num == 1)
        {
            NSLog(@"Pick third party candidate");
            
            upcomingThirdParty = YES;
            upcomingIndex = arc4random_uniform((int)[thirdPartyImages count]); //pick one of the third-party candidates
            return;
        }
    }
    
    //regular pick -- trump/clinton
    upcomingIndex = currentIndex;
    while(currentIndex == upcomingIndex)
    {
        upcomingIndex = arc4random_uniform((int)[imagesArray count]);
    }
    
   // NSLog(@"Upcoming Index: %d", upcomingIndex);
    
}

- (IBAction)chooseTrump {
    [self checkAnswer:@"trump"];
}

- (IBAction)chooseClinton {
    [self checkAnswer:@"clinton"];
}

-(void)checkAnswer:(NSString *)answer{
    
    
    if(!gameOver)
    {
        [gameOverTimer invalidate];
        
        if(currentThirdParty)
        {
            NSLog(@"Incorrect--third party");
            [self incorrectAnswer];
            return;
        }
        
        //NSLog(@"Correct answer: %@", [answersArray objectAtIndex:currentIndex]);
        
        if([answer isEqualToString:[answersArray objectAtIndex:currentIndex]]) //CORRECT ANSWER, SHOW NEW PICTURE
        {
            NSLog(@"Correct answer");
            score++;
            
            if(upcomingThirdParty) //set third-party picture
            {
                //need third-party pictures
                NSLog(@"Show Third Party candidate");
                currentThirdParty = YES;
                upcomingThirdParty = NO;
                [_imageView setImage:[thirdPartyImages objectAtIndex:upcomingIndex]];
                //[_imageView setImage: nil];
            }
            else
            {
                [_imageView setImage:[imagesArray objectAtIndex:upcomingIndex]];
            }
            
            [self resetTimer];
            currentIndex = upcomingIndex;
            [self pickNewPhoto];
        }
        else //INCORRECT ANSWER, END GAME
        {
            NSLog(@"Incorrect answer");
            
            //DISABLE BOTH BUTTONS
            gameOver = YES;
            self.clintonButton.enabled = NO;
            self.trumpButton.enabled = NO;
            [self incorrectAnswer];
        }
    }
}

-(void)resetTimer{
    NSLog(@"Reset Timer");
    
    gameOverTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(outOfTime) userInfo:nil repeats:NO];
}

-(void)outOfTime{
    
    NSLog(@"Out of time");
    
    if(currentThirdParty)
    {
        NSLog(@"Currently third party--everything good");
        
        score++;
        currentThirdParty = NO;
        [_imageView setImage:[imagesArray objectAtIndex:upcomingIndex]];
        [self resetTimer];
        currentIndex = upcomingIndex;
        [self pickNewPhoto];
    }
    else
    {
        self.clintonButton.enabled = NO;
        self.trumpButton.enabled = NO;
        gameOver = YES;
        NSLog(@"Not third party--you lose");
        self.lossTitleLabel.text = @"OUT OF TIME";
        [self showLossView];
    }
}

-(void)incorrectAnswer{
    self.clintonButton.enabled = NO;
    self.trumpButton.enabled = NO;
    gameOver = YES;
    self.lossTitleLabel.text = @"WRONG";
    [self showLossView];
}


//GAME OVER METHODS
-(void)showLossView{
    NSLog(@"Show loss view");
    
    //Set up loss view and show it
    if(currentThirdParty)
    {
        if([[thirdPartyAnswers objectAtIndex:currentIndex] isEqualToString:@"johnson"])
        {
            self.lossDescriptionLabel.text = @"It was Gary Johnson, Libertarian nominee";
        }
        else
        {
            self.lossDescriptionLabel.text = @"It was Jill Stein, Green Party nominee";
        }
    }
    else
    {
        if([[answersArray objectAtIndex:currentIndex] isEqualToString:@"trump"])
        {
            self.lossDescriptionLabel.text = @"It was Donald Trump, Republican nominee";
        }
        else
        {
            self.lossDescriptionLabel.text = @"It was Hillary Clinton, Democratic nominee";
        }
    }
    
    self.lossView.hidden = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showGameOverView) userInfo:nil repeats:NO];
    
    [self setUpGameOverView];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self reportScoreToGameCenter];
}

-(void)setUpGameOverView{
    //Set up game over view in preparation for when it shows
    if(isHardMode)
        [self setUpScoreView:@"Hard"];
    else
        [self setUpScoreView:@"Easy"];
    
    [self setUpQuoteView];
}

-(void)setUpScoreView:(NSString *)mode
{
    self.modeLabel.text = [NSString stringWithFormat:@"Mode: %@", mode];
    NSString *highScoreKey = [NSString stringWithFormat:@"%@ High Score", mode];
    int highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:highScoreKey];
    if(score > highScore)
    {
        self.highScoreLabel.text = [NSString stringWithFormat:@"Previous High Score: %d", highScore];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:highScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
        self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d",highScore];
    
    self.currentScoreLabel.text = [NSString stringWithFormat:@"Current Score: %d", score];
}

-(void)setUpQuoteView
{
    NSArray *keys = [quoteDictionary allKeys];

    
    int randomQuote = arc4random_uniform((int)[quoteDictionary count]);
    self.quoteLabel.text = [keys objectAtIndex: randomQuote];
    self.quoteAnswerLabel.text = [quoteDictionary objectForKey:[keys objectAtIndex:randomQuote]];
    self.quoteAnswerLabel.hidden = YES;
    self.viewAnswerButton.hidden = NO;
    self.quoteViewBottom.constant = 10;
    
    self.quoteLabel.numberOfLines = 0;
    CGSize labelSize = [self.quoteLabel.text sizeWithAttributes:@{NSFontAttributeName:self.quoteLabel.font}];
    self.quoteLabel.frame = CGRectMake(
                                       self.quoteLabel.frame.origin.x, self.quoteLabel.frame.origin.y,
                                       self.quoteLabel.frame.size.width, labelSize.height);
}

-(void)showGameOverView{
    
    NSLog(@"Show Game Over View");
    
    [self.view layoutIfNeeded];
    self.gameOverViewLeading.constant = 0;
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (IBAction)showQuoteAnswer:(id)sender {
    NSLog(@"Show Quote Answer");
    
    //hide answer view button
    [UIView transitionWithView:self.viewAnswerButton
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.viewAnswerButton.hidden = YES;
                    }
                    completion:^(BOOL finished) {
                        
                        //move bottom of box up
                        self.quoteViewBottom.constant = -14; //magic number, sorry
                        [UIView animateWithDuration:0.6
                                         animations:^{
                                             [self.view layoutIfNeeded];
                                         }];
                        
                        //show quote answer
                        [UIView transitionWithView:self.quoteAnswerLabel
                                          duration:0.6
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            self.quoteAnswerLabel.hidden = NO;
                                        } completion:nil];
                    }];
}


//RETURN TO HOME SCREEN
- (IBAction)goHome:(id)sender {
    [self.delegate gameDidEnd];
}

//GAME CENTER METHODS
- (IBAction)showLeaderboard:(id)sender {
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
    NSLog(@"Show Leaderboard");
    
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = appDelegate.leaderboardIdentifier;
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reportScoreToGameCenter{
    
    if(appDelegate.gameCenterEnabled)
    {
        NSLog(@"Report Score");
    
        GKScore *scoreToReport = [[GKScore alloc] initWithLeaderboardIdentifier:appDelegate.leaderboardIdentifier];
        scoreToReport.value = score;
    
        [GKScore reportScores:@[scoreToReport] withCompletionHandler:^(NSError *error) {
            if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
    }
}

//PROMOTION METHODS
- (IBAction)share:(id)sender {
    
    NSLog(@"Share");
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:self];
    [sharingItems addObject:[NSString stringWithFormat:@"Just scored a %d on Clinton or Trump! Check out this great app! %@", score, shareLink]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop];
    
    [self presentViewController:activityController animated:YES completion:nil];
}




@end