//
//  ViewController.h
//  SingleViewApp
//
//  Created by Haohua Huang on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIDictTableView;

@interface ViewController : UIViewController
    <UITextFieldDelegate> {
    
    UITextField * mLetters;
    
    UILabel *mLengthLabel;
    UISegmentedControl *mLength;
    
    UILabel *mNoResultLabel;
    
    UIDictTableView * mContentTable;

}

@property (nonatomic,retain) IBOutlet UITextField * letters;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@property (nonatomic,retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic,retain) IBOutlet UISegmentedControl *length;

@property (nonatomic,retain) IBOutlet UILabel *noResultLabel;

@property (nonatomic, retain) IBOutlet UIDictTableView *contentTable;

-(IBAction) segmentedControlIndexChanged;

- (void)updateResult;

@end
