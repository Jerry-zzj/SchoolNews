//
//  ClassCell.m
//  SchoolNews
//
//  Created by Jerry on 5月7星期二.
//
//

#import "ClassCell.h"
#import "ClassObject.h"
#import <QuartzCore/QuartzCore.h>
@implementation ClassCell
{
    UILabel* classNameLabel_;
    UILabel* classroomNameLabel_;
    UILabel* teacherNameLabel_;
    UILabel* classTimeLabel_;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CALayer* layerOne = [[CALayer alloc] init];
        [layerOne setFrame:CGRectMake(38, 0, 2, 44)];
        [layerOne setBackgroundColor:[UIColor grayColor].CGColor];
        
        classTimeLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
        [classTimeLabel_ setBackgroundColor:[UIColor clearColor]];
        [classTimeLabel_ setFont:[UIFont systemFontOfSize:12]];
        //[classTimeLabel_.layer addSublayer:layerOne];
        [self.contentView addSubview:classTimeLabel_];
        
        CALayer* layerTwo = [[CALayer alloc] init];
        [layerTwo setFrame:CGRectMake(98, 0, 2, 44)];
        [layerTwo setBackgroundColor:[UIColor grayColor].CGColor];
        
        classNameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 44)];
        [classNameLabel_ setBackgroundColor:[UIColor clearColor]];
        [classNameLabel_ setFont:[UIFont systemFontOfSize:12]];
        [classNameLabel_ setNumberOfLines:3];
        [classNameLabel_ setTextAlignment:NSTextAlignmentCenter];
        //[classNameLabel_.layer addSublayer:layerTwo];
        [self.contentView addSubview:classNameLabel_];
        
        classroomNameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
        [classroomNameLabel_ setBackgroundColor:[UIColor clearColor]];
        [classroomNameLabel_ setFont:[UIFont systemFontOfSize:12]];
        [classroomNameLabel_ setNumberOfLines:2];
        [classroomNameLabel_ setTextAlignment:NSTextAlignmentCenter];
        //[classroomNameLabel_.layer addSublayer:layerTwo];
        [self.contentView addSubview:classroomNameLabel_];
        
        teacherNameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 50, 44)];
        [teacherNameLabel_ setBackgroundColor:[UIColor clearColor]];
        [teacherNameLabel_ setFont:[UIFont systemFontOfSize:12]];
        [teacherNameLabel_ setTextAlignment:NSTextAlignmentRight];
        //[teacherNameLabel_.layer addSublayer:layerTwo];
        [self.contentView addSubview:teacherNameLabel_];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClass:(ClassObject* )sender
{
    int startClassIndex = [sender.startClassIndex intValue];
    int classLong = sender.classLong;
    
    NSString* classTime = [NSString stringWithFormat:@"%i-%i节",startClassIndex,startClassIndex + classLong - 1];
    [classTimeLabel_ setText:classTime];
    
    NSString* className = sender.name;
    [classNameLabel_ setText:className];
    
    NSString* classroomName = sender.classroomName;
    [classroomNameLabel_ setText:classroomName];
    
    NSString* teacherName = sender.teacher;
    [teacherNameLabel_ setText:teacherName];
}

@end
