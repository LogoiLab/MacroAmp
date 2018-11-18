//
//  InitialViewController.h
//  SongSync
//
//  Created by Collin Mistr on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuButton.h"
#import "CreateSessionView.h"
#import "AppNavigationController.h"
#import "JoinSessionView.h"

@interface InitialViewController : UIViewController
{
    AppNavigationController *createSessionNav;
    AppNavigationController *joinSessionNav;
}


@property (strong, nonatomic) IBOutlet UIButton *createSessionButton;
@property (strong, nonatomic) IBOutlet UIButton *joinSessionButton;
- (IBAction)startNewSession:(id)sender;
- (IBAction)joinExistingSession:(id)sender;



@end
