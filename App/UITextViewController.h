//
//  DetailTextViewController.h
//  DrawCheatsApp
//
//  Created by Haohua Huang on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictEntry.h"

@interface UITextViewController : UIViewController

@property (nonatomic) DictEntry * entry;

@property (nonatomic) IBOutlet UITextView * detailText;

@end
