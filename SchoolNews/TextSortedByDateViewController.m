//
//  TextSortedByDateViewController.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "TextSortedByDateViewController.h"
#import "TextWithTitleCell.h"

@interface TextSortedByDateViewController ()

@end

@implementation TextSortedByDateViewController
@synthesize selectedDelegate;
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
    return [allKeys_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* array = [self.showDataDictionary objectForKey:key];
    return [array count];
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate* key = [allKeys_ objectAtIndex:section];
    NSString* dateString = [[key description] substringToIndex:19];
    return dateString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TextWithTitleCell *cell = (TextWithTitleCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"TextWithTitleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = (TextWithTitleCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objectForKey = [self.showDataDictionary objectForKey:key];
    NSDictionary* dictionaryInRow = [objectForKey objectAtIndex:row];
    NSString* title = [dictionaryInRow objectForKey:@"标题"];
    NSString* content = [dictionaryInRow objectForKey:@"内容"];
    cell.titleLabel.text = title;
    cell.contentLabel.text = content;
    // Configure the cell...
    
    return cell;
    
}
#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objectForKey = [self.showDataDictionary objectForKey:key];
    NSDictionary* dictionaryInRow = [objectForKey objectAtIndex:row];
    [selectedDelegate choseTheDataDictionary:dictionaryInRow];
}

- (void)sortTheKey
{
    //sorted by date
}

@end
