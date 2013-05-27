//
//  DateAndTextTableViewController.m
//  SchoolNews
//
//  Created by shuangchi on 12月19星期三.
//
//

#import "DateAndTextTableViewController.h"
#import "DateAndTextCell.h"

@interface DateAndTextTableViewController ()

@end

@implementation DateAndTextTableViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objectForKey = [self.showDataDictionary objectForKey:key];
    NSDictionary* dictionaryInRow = [objectForKey objectAtIndex:row];
    NSString* title = [dictionaryInRow objectForKey:@"标题"];
    NSDate* date = [dictionaryInRow objectForKey:@"日期"];
    NSString* dateString = [[date description] substringToIndex:19];
    
    CGSize tempSize = CGSizeMake(320, 1000);
    UIFont* font = [UIFont systemFontOfSize:17];
    CGSize dateSize = [dateString sizeWithFont:font
                             constrainedToSize:tempSize
                                 lineBreakMode:NSLineBreakByCharWrapping];
    CGSize textSize = [title sizeWithFont:font
                        constrainedToSize:tempSize
                            lineBreakMode:NSLineBreakByCharWrapping];
    return dateSize.height + textSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DateAndTextCell *cell = (DateAndTextCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DateAndTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int section = [indexPath section];
    int row = [indexPath row];
    NSString* key = [allKeys_ objectAtIndex:section];
    NSArray* objectForKey = [self.showDataDictionary objectForKey:key];
    NSDictionary* dictionaryInRow = [objectForKey objectAtIndex:row];
    NSString* title = [dictionaryInRow objectForKey:@"标题"];
    NSDate* date = [dictionaryInRow objectForKey:@"日期"];
    
    NSString* dateString = [[date description] substringToIndex:19];
    cell.dateLabel.text = dateString;
    cell.textLabel.text = title;
    // Configure the cell...
    
    return cell;
    
}

@end
