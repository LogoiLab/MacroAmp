//
//  PlayerView.m
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView ()

@end

@implementation PlayerView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"test-art.jpg"]]];
    
    //If is host
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showSongSelectionView)]];
    
    
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
-(void)showSongSelectionView
{
    if (!songSelectionNav)
    {
        
        songSelectionNav = [[AppNavigationController alloc] init];
        ssv = [[SongSelectionView alloc] init];
        [songSelectionNav setViewControllers:@[ssv]];
        ssv.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        songSelectionNav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:songSelectionNav animated:YES completion:nil];
}
@end
