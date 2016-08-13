//
//  GameViewController.m
//  Clinton or Trump
//
//  Created by Jack STENGLEIN on 8/11/16.
//  Copyright © 2016 Jack Stenglein. All rights reserved.
//

#import "GameViewController.h"


@interface GameViewController ()

@end

@implementation GameViewController
{
    NSArray *imagesArray;
    NSMutableArray *answersArray;
    
    NSTimer *gameOverTimer;
    NSTimeInterval timeInterval;
    BOOL isHardMode;
    BOOL gameOver;
    
    int currentIndex;
    int upcomingIndex;
    int score;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"View did load");
    
    // Do any additional setup after loading the view.
    self.lossView.hidden = YES;
    self.backgroundView.hidden = YES;
    score = 0;
    gameOver = NO;
    
    NSString *mode = [[NSUserDefaults standardUserDefaults] objectForKey:@"Difficulty"];
    if([mode isEqualToString:@"Hard"])
    {
        isHardMode = YES;
        timeInterval = 0.75;
    }
    else
    {
        isHardMode = NO;
        timeInterval = 1.5;
    }
    
    
    imagesArray = [[NSArray alloc] initWithObjects:@"clinton1.jpg",@"clinton2.png",@"clinton3.jpeg",@"clinton4.jpg",@"trump1.jpg",@"trump2.jpg",@"trump3.jpg",@"trump4.jpg", nil];
    answersArray = [[NSMutableArray alloc] initWithCapacity:[imagesArray count]];
    
    for(int i = 0; i < [imagesArray count]/2; i++)
    {
        [answersArray addObject:@"clinton"];
    }
    
    for(int i = (int)[imagesArray count]/2; i<[imagesArray count]; i++)
    {
        [answersArray addObject:@"trump"];
    }
    
    NSLog(@"Answers Array: %@", answersArray);
    
    currentIndex = arc4random_uniform((int)[imagesArray count]);
    NSLog(@"Index: %d", currentIndex);
    
    [_imageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:currentIndex]]];
    
    [self pickNewPhoto];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(!gameOver)
    {
        gameOverTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(outOfTime) userInfo:nil repeats:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickNewPhoto{
    
    upcomingIndex = currentIndex;
    
    while(currentIndex == upcomingIndex)
    {
        upcomingIndex = arc4random_uniform((int)[imagesArray count]);
    }
    
    NSLog(@"Upcoming Index: %d", upcomingIndex);
}

-(void)resetTimer{
    gameOverTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(outOfTime) userInfo:nil repeats:NO];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"showGameOverVC"])
    {
        GameOverViewController *gameOverVC = [segue destinationViewController];
        [gameOverVC setCurrentScore:score];
        //[gameOverVC setDelegate:self];
    }
}

-(void)outOfTime {
    NSLog(@"Out of time");
    
    if([[answersArray objectAtIndex:currentIndex] isEqualToString:@"trump"])
    {
        self.lossDescriptionLabel.text = @"It was Donald Trump, Republican nominee";
    }
    else
    {
        self.lossDescriptionLabel.text = @"It was Hillary Clinton, Democratic nominee";
    }
    
    self.lossTitleLabel.text = @"OUT OF TIME";
    self.lossView.hidden = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showGOView) userInfo:nil repeats:NO];
}

-(void)incorrectAnswer
{
    if([[answersArray objectAtIndex:currentIndex] isEqualToString:@"trump"])
    {
        self.lossDescriptionLabel.text = @"It was Donald Trump, Republican nominee";
    }
    else
    {
        self.lossDescriptionLabel.text = @"It was Hillary Clinton, Democratic nominee";
    }
    
    self.lossTitleLabel.text = @"WRONG";
    self.lossView.hidden = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showGOView) userInfo:nil repeats:NO];
}

-(void)showGOView{
    
    //SWITCH TO HIDDEN UIVIEW FOR THIS RATHER THAN WHOLE NEW VIEW CONTROLLER
    
    //self.backgroundView.hidden = NO;
    gameOver = YES;
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    NSLog(@"Storyboard: %@", storyboard);
    
    GameOverViewController *gameOverVC = [storyboard instantiateViewControllerWithIdentifier:@"gameOverVC"];
    gameOverVC.delegate = self;
    //[self dismissViewControllerAnimated:NO completion:nil];
    self.view.hidden = YES;
    [self presentViewController:gameOverVC animated:NO completion:^{
        //self.view.hidden = YES;
    }];
}

-(void)returnToHome{
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

-(void)checkAnswer:(NSString *)answer{
    
    [gameOverTimer invalidate];
    
    //NSLog(@"Correct answer: %@", [answersArray objectAtIndex:currentIndex]);
    
    if([answer isEqualToString:[answersArray objectAtIndex:currentIndex]]) //CORRECT ANSWER, SHOW NEW PICTURE
    {
        NSLog(@"Correct answer");
        score++;
        
        [_imageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:upcomingIndex]]];
        [self resetTimer];
        currentIndex = upcomingIndex;
        [self pickNewPhoto];
    }
    else //INCORRECT ANSWER, END GAME
    {
        //DISABLE BOTH BUTTONS
        [self incorrectAnswer];
    }
}

- (IBAction)chooseTrump {
    [self checkAnswer:@"trump"];
}

- (IBAction)chooseClinton {
    [self checkAnswer:@"clinton"];
}



//GAME OVER METHODS

- (IBAction)showQuoteAnswer:(id)sender {
}
@end
