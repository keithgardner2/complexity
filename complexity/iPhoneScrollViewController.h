//
//  iPhoneScrollViewController.h
//  complexity
//
//  Created by Keith Gardner on 3/9/14.
//  Copyright (c) 2014 Optimality Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExperimentViewController.h"


@interface iPhoneScrollViewController : UIViewController <UIPickerViewDelegate>

//@property (nonatomic, assign) IBOutlet UILabel *userAlg;
//@property (nonatomic, assign) IBOutlet UILabel *userData;



@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerOptions;
@property (strong, nonatomic)          NSArray *algColumn;
@property (strong, nonatomic)          NSArray *optionsColumn;

@end
