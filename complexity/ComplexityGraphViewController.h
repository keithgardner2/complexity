//
//  ComplexityGraphViewController.h
//  complexity
//
//  Created by Patrick Madden on 12/27/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "ComplexityGraph.h"

@interface ComplexityGraphViewController : UIViewController

@property (nonatomic, retain) IBOutlet ComplexityGraph *complexityGraph;
@property (nonatomic, retain) IBOutlet UISlider *cgN;



-(IBAction)slideChange:(id)sender;
@end
