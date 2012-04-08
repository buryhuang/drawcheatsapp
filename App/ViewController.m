//
//  ViewController.m
//  DrawCheatsApp
//
//  Created by Haohua Huang on 3/30/12.
//  Copyright (c) 2012 B&W Studio. All rights reserved.
//

#import "ViewController.h"
#import "DictEntry.h"
#import "UITextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize curSearchLetters;

@synthesize detailTextViewControler;

@synthesize lookupDict;
@synthesize letters;
@synthesize lengthLabel;
@synthesize length;
@synthesize noResultLabel;
@synthesize contentTable;
@synthesize adBanner;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.letters.delegate = self;
    
    self.lengthLabel.text =@"Length:";
    
    self.noResultLabel.hidden = NO;
    
//    self.contentTable.delegate = self;
    
    self.lookupDict = [NSMutableArray array];
    
    self.contentTable.hidden = YES;
    
    self.curSearchLetters = @"";
    self->curSearchLen = 0;
    
    self->detailTextViewControler = [[UITextViewController alloc] initWithNibName:@"UITextViewController" bundle:[NSBundle mainBundle]];

    //(void)[self.adBanner initWithFrame:CGRectZero];
    //self.adBanner.requiredContentSizeIdentifiers = 
    //[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait,nil];
    //self.adBanner.delegate = self;

    
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
    //dont do this now.
    if([self.letters isEditing] == NO) {
        [self updateResult];
    }
}

- (void)updateResult
{
    integer_t searchLen = self.length.selectedSegmentIndex + 3;
    
    if( self->curSearchLen == searchLen && [self.curSearchLetters caseInsensitiveCompare:self.letters.text] == NSOrderedSame ) {
        // Nothing changed, don't update.
        return;
    }
    
    self.curSearchLetters = self.letters.text;
    self->curSearchLen = searchLen;
    
    if ( self.letters.text.length >= searchLen ) {
        [self.lookupDict removeAllObjects];
        [self.contentTable reloadData];
        
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"搜索中....";
        self.contentTable.hidden = YES;
    
        NSError *error;
        NSURLResponse *response;
        NSData *dataReply;
    
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dict.youdao.com/drawsth?letters=%@&length=%d", self.letters.text, searchLen]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        self.contentTable.hidden = NO;

        id stringReply;
        stringReply = (NSString *)[[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
        

        //////////////////////////////////
        // Some debug code, etc.
        // NSLog(@"reply from server: %@", stringReply);

        NSHTTPURLResponse *httpResponse;
        httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = [httpResponse statusCode];  
        NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
        NSLog(@"HTTP Status code: %d", statusCode);
        // End debug.
        /////////////////////////////////
        
        // Parse content
        NSString * wordPrefix = @"class=\"word\">";
        NSString * transPrefix = @"class=\"trans\">";
        NSString * newWord;
        NSString * newTrans;
        
        NSScanner * theScanner = [NSScanner scannerWithString:stringReply];
        while ([theScanner isAtEnd] == NO) {
            BOOL foundWord = NO;
            newWord = @"No word";
            newTrans = @"No trans";

            if([theScanner scanUpToString:wordPrefix intoString:nil] == YES) {
                NSScanner * wordScanner = [NSScanner scannerWithString:[stringReply substringFromIndex:[theScanner scanLocation]]];
                
                if([wordScanner scanUpToString:@"<" intoString:&newWord] == YES) {
                    foundWord = YES;
                }
            }

            if([theScanner scanUpToString:transPrefix intoString:nil] == YES) {
                NSScanner * transScanner = [NSScanner scannerWithString:[stringReply substringFromIndex:[theScanner scanLocation]]];
                
                [transScanner scanUpToString:@"<" intoString:&newTrans];
            }

            if(foundWord) {
                newWord = [newWord substringFromIndex:[wordPrefix length]];
                newTrans = [newTrans substringFromIndex:[transPrefix length]];
                //NSLog(@"Adding pair %@:%@", newWord, newTrans);
                [self insertEntry:newWord desc:newTrans];
                [self.contentTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            }
        
        }

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if( [self.lookupDict count] == 0) {
            self.noResultLabel.text = @"没有搜索结果";
            self.noResultLabel.hidden = NO;
            self.contentTable.hidden = YES;
        }

    } else {
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"没有搜索结果";
        self.contentTable.hidden = YES;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger cellCount = [self.lookupDict count];
    NSLog(@"num of row in sec %d: %d", section, cellCount);

    return cellCount;
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
    
    // TODO use detailText
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", entry.word, entry.desc];        
    cell.detailTextLabel.text = entry.desc;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DictEntry *entry = [self.lookupDict objectAtIndex:indexPath.row];
    self.detailTextViewControler.entry = entry;

    [self.navigationController pushViewController:self.detailTextViewControler animated:YES];
     

}

- (void)insertEntry:(NSString*)word desc:(NSString*)desc
{
    DictEntry *entry = [[DictEntry alloc] init:word desc:desc];
    
    [self.lookupDict insertObject:entry atIndex:0];
    
    //NSLog(@"after update, array size = %d", [self.lookupDict count]);
}


@end
