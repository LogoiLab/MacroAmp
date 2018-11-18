//
//  CreateSessionView.m
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "CreateSessionView.h"

@interface CreateSessionView ()

@end

@implementation CreateSessionView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"green-pattern.jpg"]]];
    [self.navigationItem setTitle:@"Create Session"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModal)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dismissModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
     
@end
