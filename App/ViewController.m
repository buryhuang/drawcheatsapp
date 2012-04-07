//
//  ViewController.m
//  DrawCheatsApp
//
//  Created by Haohua Huang on 3/30/12.
//  Copyright (c) 2012 B&W Studio. All rights reserved.
//

#import "ViewController.h"
#import "DictEntry.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize lookupDict;
@synthesize letters;
@synthesize lengthLabel;
@synthesize length;
@synthesize noResultLabel;
@synthesize contentTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.letters.delegate = self;
    
    self.lengthLabel.text =@"Length:";
    
    self.noResultLabel.hidden = NO;
    
//    self.contentTable.delegate = self;
    
    self.lookupDict = [NSMutableArray array];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];

    [self updateResult];

    return NO;
}

// Segmented Control
-(IBAction) segmentedControlIndexChanged
{
    [self updateResult];
}

- (void)updateResult
{

    integer_t searchLen = self.length.selectedSegmentIndex + 3;
    
    if ( self.letters.text.length >= searchLen ) {
        
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"搜索中....";
        //self.webView.hidden = YES;
 /*       
        NSError *error;
        NSURLResponse *response;
        NSData *dataReply;
    
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dict.youdao.com/drawsth?letters=%@&length=%d", self.letters.text, searchLen]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        id stringReply;
        stringReply = (NSString *)[[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
        // Some debug code, etc.
        // NSLog(@"reply from server: %@", stringReply);

        NSHTTPURLResponse *httpResponse;
        httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = [httpResponse statusCode];  
        NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
        NSLog(@"HTTP Status code: %d", statusCode);
        // End debug.

        //[self.webView loadRequest:request];
        //[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.5;"];
        //self.webView.scalesPageToFit = NO;
        
        NSString * descStr = [NSString stringWithFormat:@"returned code:%d", statusCode];
*/
        // [mContentTable insertEntry:@"aaa" desc:descStr];
        [self insertEntry:@"aaa" desc:@"bbb"];
        
        [self.contentTable reloadData];

/*
        [self.contentTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationRight];
*/
        //[mContentTable reloadData];

    } else {
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"没有搜索结果";
        //self.webView.hidden = YES;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [self.contentTable numberOfSectionsInTableView:tableView];
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"num of row in sec %d: %d", section, [self.lookupDict count]);
    return [self.lookupDict count];//[mContentTable numberOfRowsInSection:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] init];
    }
    
    DictEntry *entry = [self.lookupDict objectAtIndex:indexPath.row];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
    
    cell.textLabel.text = entry.word;        
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", entry.desc];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open a alert with an OK and cancel button
    NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
}

- (void)insertEntry:(NSString*)word desc:(NSString*)desc
{
    NSLog(@"before update, array size = %d", [self.lookupDict count]);
    
    DictEntry *entry = [[DictEntry alloc] init:word desc:desc];
    
    [self.lookupDict insertObject:entry atIndex:0];
    
    NSLog(@"after update, array size = %d", [self.lookupDict count]);
}


@end
