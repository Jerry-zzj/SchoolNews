//
//  FixedSequenceTableViewController.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "FixedSequenceTableViewController.h"
#import "IntroductionCell.h"
#define CONTENT_LABEL_WIDTH                         200

@interface FixedSequenceTableViewController ()


@end

@implementation FixedSequenceTableViewController
@synthesize fixedSequence;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.showDataDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.fixedSequence count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSDictionary* showData = [self.showDataDictionary objectForKey:key];
    UIFont* font = [UIFont systemFontOfSize:17];
    int row = [indexPath row];
    NSString* name = [self.fixedSequence objectAtIndex:row];
    NSString* content = [showData objectForKey:name];
    float contentWidth = CONTENT_LABEL_WIDTH;
    CGSize contentSize = CGSizeMake(contentWidth, 1000);
    CGSize contentLabelSize= [content sizeWithFont:font constrainedToSize:contentSize lineBreakMode:NSLineBreakByCharWrapping];
    float height = contentLabelSize.height;
    if (height < 44) {
        height = 44;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    IntroductionCell *cell = (IntroductionCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[IntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int section = [indexPath section];
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSDictionary* showContent = [self.showDataDictionary objectForKey:key];
    int row = [indexPath row];
    NSString* name = [self.fixedSequence objectAtIndex:row];
    NSString* content = [showContent objectForKey:name];
    cell.nameLabel.text = name;
    cell.contentLabel.text = content;
    
    return cell;
    
}

- (void)sortTheKey
{
}


@end
