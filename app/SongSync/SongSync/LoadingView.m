//
//  LoadingView.m
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@end

@implementation LoadingView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"green-pattern.jpg"]]];
    
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

@end
