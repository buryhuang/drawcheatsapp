//
//  ViewController.m
//  DrawCheatsApp
//
//  Created by Haohua Huang on 3/30/12.
//  Copyright (c) 2012 B&W Studio. All rights reserved.
//

#import "ViewController.h"
#import "UIDictTableView.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize letters = mLetters;

@synthesize lengthLabel = mLengthLabel;
@synthesize length = mLength;

@synthesize noResultLabel = mNoResultLabel;

@synthesize contentTable = mContentTable;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.letters.delegate = self;
    
    self.lengthLabel.text =@"Length:";
    
    self.noResultLabel.hidden = NO;
    
    mContentTable = [[UIDictTableView alloc] init];
    
    [mContentTable insertEntry:@"aaa" desc:@"aaaDesc"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc
{
    [mLetters release];
    mLetters = nil;
    
    [mLengthLabel release];
    mLengthLabel = nil;
    [mLength release];
    mLength = nil;
    
    [mNoResultLabel release];
    mNoResultLabel = nil;
    
    [mContentTable release];
    mContentTable = nil;

    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];

    [self updateResult];

    return NO;
}

// Segmented Control
-(IBAction) segmentedControlIndexChanged
{
    switch (self.length.selectedSegmentIndex) {
/*
        case 0:
            self.segmentLabel.text =@"1 selected.";
            break;
        case 1:
            self.segmentLabel.text =@"2 selected.";
            break;
 */
        default:
            break;
    }
    [self updateResult];

}

- (void)updateResult
{

    integer_t searchLen = self.length.selectedSegmentIndex + 3;
    
    if ( self.letters.text.length >= searchLen ) {
        
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"搜索中....";
        //self.webView.hidden = YES;
    
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dict.youdao.com/drawsth?letters=%@&length=%d", self.letters.text, searchLen]];
        //NSURLRequest* request = [NSURLRequest requestWithURL:url];
        //[self.webView loadRequest:request];
        //[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.5;"];
        //self.webView.scalesPageToFit = NO;

    } else {
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"没有搜索结果";
        //self.webView.hidden = YES;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mContentTable numberOfSectionsInTableView:tableView];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mContentTable numberOfRowsInSection:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Set up the cell...

    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.text = [NSString  stringWithFormat:@"Cell Row #%d", [indexPath row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open a alert with an OK and cancel button
    NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end
