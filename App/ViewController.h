//
//  ViewController.h
//  SingleViewApp
//
//  Created by Haohua Huang on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"

@interface ViewController : UIViewController <UITextFieldDelegate> {
    integer_t curSearchLen;
}

@property (nonatomic) NSString * curSearchLetters;

@property (nonatomic) NSMutableArray * lookupDict;

@property (nonatomic) IBOutlet UITextField * letters;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@property (nonatomic) IBOutlet UILabel *lengthLabel;
@property (nonatomic) IBOutlet UISegmentedControl *length;

@property (nonatomic) IBOutlet UILabel *noResultLabel;

@property (nonatomic) IBOutlet UITableView *contentTable;

@property (nonatomic) IBOutlet ADBannerView * adBanner;


-(IBAction) segmentedControlIndexChanged;

- (void)updateResult;

- (void)insertEntry:(NSString*)word desc:(NSString*)desc;

@end
