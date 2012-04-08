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

@synthesize stringToParse;
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
    
    self.title = @"Draw助手";
    
    self.letters.delegate = self;
    
    self.lengthLabel.text =@"Length:";
    
    self.noResultLabel.hidden = NO;
    
//    self.contentTable.delegate = self;
    
    self.lookupDict = [NSMutableArray array];
    
    self.contentTable.hidden = YES;
    
    self.curSearchLetters = @"";
    self->curSearchLen = 0;
    
    self.stringToParse = @"";
    
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse;
    httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode];  
    //NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
    NSLog(@"HTTP Status code: %d", statusCode);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if( [self.lookupDict count] == 0) {
        self.noResultLabel.text = @"网络连接出错，无法获取搜索结果";
        self.noResultLabel.hidden = NO;
        self.contentTable.hidden = YES;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.letters setEnabled:YES];
    [self.length setEnabled:YES];
    self.stringToParse = @"";
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if( [self.lookupDict count] == 0) {
        self.noResultLabel.text = @"没有搜索结果";
        self.noResultLabel.hidden = NO;
        self.contentTable.hidden = YES;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.letters setEnabled:YES];
    [self.length setEnabled:YES];
    self.stringToParse = @"";
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataReply
{
    self.contentTable.hidden = NO;
    self.noResultLabel.hidden = YES;
    
    id stringReply;
    stringReply = (NSString *)[[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
    
    self.stringToParse = [self.stringToParse stringByAppendingFormat:@"%@", stringReply];

    //////////////////////////////////
    // Some debug code, etc.
    //NSLog(@"reply from server: %@", self.stringToParse);
    
    // Parse content
    NSString * wordPrefix = @"class=\"word\">";
    NSString * transPrefix = @"class=\"trans\">";
    NSString * newWord;
    NSString * newTrans;
    
    NSScanner * theScanner = [NSScanner scannerWithString:self.stringToParse];
    while ([theScanner isAtEnd] == NO) {
        BOOL foundWord = NO;
        bool foundTrans = NO;
        newWord = @"No word";
        newTrans = @"No trans";
        integer_t currentScanLoc = [theScanner scanLocation];
        
        if([theScanner scanUpToString:wordPrefix intoString:nil] == YES) {
            NSScanner * wordScanner = [NSScanner scannerWithString:[self.stringToParse substringFromIndex:[theScanner scanLocation]]];
            
            foundWord = [wordScanner scanUpToString:@"<" intoString:&newWord];
        }
        
        if([theScanner scanUpToString:transPrefix intoString:nil] == YES) {
            NSScanner * transScanner = [NSScanner scannerWithString:[self.stringToParse substringFromIndex:[theScanner scanLocation]]];
            
            foundTrans = [transScanner scanUpToString:@"<" intoString:&newTrans];
        }
        
        if(foundWord && foundTrans) {
            newWord = [newWord substringFromIndex:[wordPrefix length]];
            newTrans = [newTrans substringFromIndex:[transPrefix length]];
            //NSLog(@"Adding pair %@:%@", newWord, newTrans);
            [self insertEntry:newWord desc:newTrans];
            [self.contentTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        } else {
            self.stringToParse = [self.stringToParse substringFromIndex:currentScanLoc];
            break;
        }
        
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
    
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dict.youdao.com/drawsth?letters=%@&length=%d", self.letters.text, searchLen]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSURLConnection * aConn = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if(!aConn) {
            self.noResultLabel.hidden = NO;
            self.noResultLabel.text = @"连接服务器失败，请检查网络设置";
            self.contentTable.hidden = YES;
            self.stringToParse = @"";
        } else {
            [self.letters setEnabled:NO];
            [self.length setEnabled:NO];
        }

    } else {
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"没有搜索结果";
        self.contentTable.hidden = YES;
        self.stringToParse = @"";
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
