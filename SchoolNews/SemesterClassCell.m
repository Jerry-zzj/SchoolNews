//
//  SemesterClassCell.m
//  SchoolNews
//
//  Created by Jerry on 5月13星期一.
//
//

#import "SemesterClassCell.h"
#import "ClassObject.h"
@implementation SemesterClassCell
{
    UILabel* classIndexLabel_;
    UILabel* classNameLabel_;
    UILabel* classRoomLabel_;
    UILabel* weekLabel_;
    UILabel* teacherNameLabel_;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        classIndexLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 80)];
        [classIndexLabel_ setTextAlignment:NSTextAlignmentLeft];
        [classIndexLabel_ setBackgroundColor:[UIColor clearColor]];
        [classIndexLabel_ setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:classIndexLabel_];
        
        classNameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 80, 80)];
        [classNameLabel_ setTextAlignment:NSTextAlignmentCenter];
        [classNameLabel_ setNumberOfLines:0];
        [classNameLabel_ setBackgroundColor:[UIColor clearColor]];
        [classNameLabel_ setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:classNameLabel_];
        
        classRoomLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 60, 80)];
        [classRoomLabel_ setTextAlignment:NSTextAlignmentCenter];
        [classRoomLabel_ setNumberOfLines:2];
        [classRoomLabel_ setBackgroundColor:[UIColor clearColor]];
        [classRoomLabel_ setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:classRoomLabel_];
        
        weekLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 50, 80)];
        [weekLabel_ setTextAlignment:NSTextAlignmentCenter];
        [weekLabel_ setNumberOfLines:2];
        [weekLabel_ setBackgroundColor:[UIColor clearColor]];
        [weekLabel_ setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:weekLabel_];
        
        teacherNameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 45, 80)];
        [teacherNameLabel_ setTextAlignment:NSTextAlignmentRight];
        [teacherNameLabel_ setBackgroundColor:[UIColor clearColor]];
        [teacherNameLabel_ setFont:[UIFont systemFontOfSize:12]];
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
    [classIndexLabel_ setText:classTime];
    
    NSString* className = sender.name;
    [classNameLabel_ setText:className];
    
    NSString* startWeek = sender.startWeek;
    NSString* endWeek = sender.endWeek;
    if (sender.singleDoubleWeek != nil) {
        NSString* classNameString = [NSString stringWithFormat:@"%@-%@,%@",startWeek,endWeek,sender.singleDoubleWeek];
        [weekLabel_ setText:classNameString];
    }
    else
    {
        NSString* classNameString = [NSString stringWithFormat:@"%@-%@",startWeek,endWeek];
        [weekLabel_ setText:classNameString];
    }
    
    NSString* classroomName = sender.classroomName;
    [classRoomLabel_ setText:classroomName];
    
    NSString* teacherName = sender.teacher;
    [teacherNameLabel_ setText:teacherName];
}

@end
