//
//  TranslateDetailViewController.m
//  Speedboy
//
//  Created by TaHoangMinh on 2/11/16.
//  Copyright © 2016 TaHoangMinh. All rights reserved.
//

#import "TranslateDetailViewController.h"
#import "AddWordViewController.h"
#import "FMDatabase.h"
@interface TranslateDetailViewController ()

@end

@implementation TranslateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"Translation Detail");
    
    [self refreshWordData];
    
    if ([@"1" isEqualToString:self.word.favorites]) {
        self.btnFavourite.selected = YES;
    } else {
        self.btnFavourite.selected = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshWordData];
}
- (void) refreshWordData
{
    self.lblWord.text = self.word.word;
    self.lblDescription.text = self.word.strDescription;
    self.lblResult.text = self.word.result;
    self.lblEdited.text = self.word.edited;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFavouriteClicked:(UIButton *)sender {
//    if (sender.selected) {
//        self.word.favorites = @"1";
//    }
//    [[DatabaseService shareInstance] update:self.word changeEditTime:NO];
    
//    if (!sender.selected) {
//        [self.view makeToast:LocalizedString(@"Removed from favourite") duration:2.0 position:nil];
//    } else {
//        [self.view makeToast:LocalizedString(@"Added to favourite") duration:2.0 position:nil];
//    }
    sender.selected = !sender.selected;
    if( sender.selected == true ) {
        self.word.favorites = @"1";
    }
    else self.word.favorites = @"-";
    [[DatabaseService shareInstance] update:self.word changeEditTime:NO];
}
- (IBAction)btnShareclicked:(id)sender {
    NSString *str=[NSString stringWithFormat:@"%@\n%@\nTranslate using: http://app_itune_link_here", self.word.word, self.word.result];
    NSArray *postItems=@[str];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)btnEditClicked:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"Edit"), LocalizedString(@"Delete"), nil];
    actionsheet.tag = 1001;
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        // do nothing
    } else if (buttonIndex == 0) {
        NSLog(@"Edit");
        AddWordViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"AddWordEditViewController"];
        vc.word = self.word;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (buttonIndex == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UIAlertViewStyleDefault message:@"Do you want to delete this word ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show ];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
    }
    else if( buttonIndex == 1 ) {
        [[DatabaseService shareInstance] deleteW:self.word ];
    }
}

@end
