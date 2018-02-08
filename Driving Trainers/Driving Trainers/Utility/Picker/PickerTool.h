//
//  PickerTool.h
//  PatientApp
//
//  Created by Vinay Kumar on 14/03/16.
//  Copyright © 2016 Vinay Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerTool : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
	__weak IBOutlet UIPickerView* _pickerView;
	NSMutableArray* _pickerItems;
	UITextField* _outoutTF;
	__weak IBOutlet UIBarButtonItem* _doneBTN;
}

//property (nonatomic,copy) void (^completionHandler)(PickerModel* detail);

+ (id) loadClass;

- (void) pickerViewMethod:(UITextField*)textField arr:(NSArray*)objArray;


- (IBAction) donePressed:(UIBarButtonItem*)sender;

@end
