//
//  PickerTool.m
//  PatientApp
//
//  Created by Vinay Kumar on 14/03/16.
//  Copyright © 2016 Vinay Kumar. All rights reserved.
//

#import "PickerTool.h"


@implementation PickerTool

+ (id) loadClass
{
	PickerTool* tool = [[[NSBundle mainBundle] loadNibNamed:@"PickerTool" owner:self options:nil] firstObject];
	return tool;
}
- (void) pickerViewMethod:(UITextField*)textField arr:(NSMutableArray*)objArray
{
	_outoutTF = textField;
	_pickerItems=objArray;
	[_pickerView reloadAllComponents];
}

#pragma mark pickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return _pickerItems.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [self stringForRow:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString* str = [self stringForRow:row];
	_outoutTF.text = str;

//	if (self.completionHandler)
//	{
//		self.completionHandler(_pickerItems[row]);
//	}
}

- (IBAction) donePressed:(UIBarButtonItem*)sender
{
	NSString* str = [self stringForRow:0];
	_outoutTF.text = str;
	
//	if (self.completionHandler)
//	{
//		self.completionHandler(_pickerItems[0]);
//	}
}

- (NSString*) stringForRow:(NSInteger)row
{
	id object = [_pickerItems objectAtIndex:row];
	if ([object isKindOfClass:[NSString class]])
	{
		return (NSString*)object;
	}
//	else if ([object isKindOfClass:[PickerModel class]])
//	{
//		PickerModel* obj = (PickerModel*)object;
//		//NSLog (@" %@ ",obj.value);
//		return [obj.name capitalizedString];
//	}
	return @"";
}
@end
