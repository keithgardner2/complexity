//
//  ExperimentViewController.h
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mach/mach_time.h>
#import "InfoViewController.h"
#import "ComplexityGraph.h"

@interface ExperimentViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) BOOL running;
@property (nonatomic) uint64_t startTime, stopTime;
@property (nonatomic, assign) IBOutlet UILabel *elapsed;
@property (nonatomic, retain) NSTimer *timer, *algTimer;
@property (nonatomic) int problemSize;
@property (nonatomic, assign) IBOutlet UISlider *problemSlider;
@property (nonatomic, assign) IBOutlet UILabel *problemLabel;
@property (nonatomic) int algType;
@property (nonatomic, retain) IBOutlet UIView *runShield;

@property (nonatomic, assign) IBOutlet UILabel *userAlg;
@property (nonatomic, assign) IBOutlet UILabel *userData;


-(IBAction)startRun:(id)sender;
-(IBAction)stopRun:(id)sender;

-(void)timerInterrupt:(id)sender;
-(IBAction)runAlgorithm:(id)sender;
-(IBAction)killRun:(id)sender;
-(IBAction)nChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerOptions;
@property (strong, nonatomic)          NSArray *algColumn;
@property (strong, nonatomic)          NSArray *optionsColumn;

@end