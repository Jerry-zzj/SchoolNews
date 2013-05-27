//
//  ImageTableViewController.m
//  SchoolNews
//
//  Created by zhenjia zhang on 12-11-29.
//  Copyright (c) 2012年 KiwiIslands. All rights reserved.
//

#import "ImageTableViewController.h"
#import "ImagesCell.h"

@interface ImageTableViewController ()

@end

@implementation ImageTableViewController

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

//------------------------------------------------------------------------------
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [self.showDataDictionary count];
    return 20;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ImagesCell *cell = (ImagesCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"ImagesCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = (ImagesCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:row];
    NSDictionary* imageInformation = [self.showDataDictionary objectForKey:key];
    NSString* title = [imageInformation objectForKey:@"Title"];
    NSString* firstImagePath = [imageInformation objectForKey:@"FirstImagePath"];
    NSString* secondImagePath = [imageInformation objectForKey:@"SecondImagePath"];
    NSString* thirdImagePath = [imageInformation objectForKey:@"ThirdImagePath"];
    NSString* numberOfImage = [imageInformation objectForKey:@"imageNumber"];
    
    cell.titleLabel.text = title;
    [cell.firstImageView setImage:[UIImage imageNamed:firstImagePath]];
    [cell.secondImageView setImage:[UIImage imageNamed:secondImagePath]];
    [cell.thirdImageView setImage:[UIImage imageNamed:thirdImagePath]];
    cell.numberOfImageLabel.text = numberOfImage;
    // Configure the cell...
    [self updateTheFootViewFrame];

    return cell;
    
}


@end
