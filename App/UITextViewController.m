//
//  DetailTextViewController.m
//  DrawCheatsApp
//
//  Created by Haohua Huang on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITextViewController.h"

@interface UITextViewController ()

@end

@implementation UITextViewController

@synthesize entry;
@synthesize detailText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.title = [NSString stringWithFormat:@"%@翻译", entry.word];
    [self.detailText setText:[NSString stringWithFormat:@"%@\n%@", self.entry.word, self.entry.desc]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[detailText setText:@"没有详细资料"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
