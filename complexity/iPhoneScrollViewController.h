//
//  iPhoneScrollViewController.h
//  complexity
//
//  Created by Keith Gardner on 3/9/14.
//  Copyright (c) 2014 Optimality Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneScrollViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerOptions;
@property (strong, nonatomic)          NSArray *algColumn;
@property (strong, nonatomic)          NSArray *optionsColumn;

@end
