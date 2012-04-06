//
//  UIDictTableView.h
//  Draw Cheats
//
//  Created by Haohua Huang on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDictTableView : UITableView
{
    NSMutableArray* mContent;
}

@property (retain) NSMutableArray* content;

- (void)commonInit;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)insertEntry:(NSString*)word desc:(NSString*)desc;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

// Customize the number of rows in the table view.
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
