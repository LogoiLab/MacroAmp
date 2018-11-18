//
//  InitialViewController.m
//  SongSync
//
//  Created by Collin Mistr on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"SongSync"];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"green-pattern.jpg"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)startNewSession:(id)sender{
    if(!createSessionNav)
    {
        createSessionNav = [[AppNavigationController alloc] init];
        [createSessionNav setViewControllers:@[[[CreateSessionView alloc] init]]];
    }
    [self presentViewController:createSessionNav animated:YES completion:nil];
}

- (IBAction)joinExistingSession:(id)sender {
    if(!joinSessionNav)
    {
        joinSessionNav = [[AppNavigationController alloc] init];
        [joinSessionNav setViewControllers:@[[[JoinSessionView alloc] init]]];
    }
    [self presentViewController:joinSessionNav animated:YES completion:nil];
}
@end
