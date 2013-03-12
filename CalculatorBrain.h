//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (double)performOperation:(NSString *)op;

@property (nonatomic, readonly) id program;
@property (nonatomic, readonly) NSString *description;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *) variables;

@end
