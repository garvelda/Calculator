//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

- (NSMutableArray *)programStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

- (NSString *) description {
	return [CalculatorBrain descriptionOfProgram:self.program];
}

+ (BOOL) isTwoParametersOperation:(NSString *) operation {
	NSSet *twoParametersOperations = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
	BOOL itIs = NO;
	
	if (operation && [twoParametersOperations containsObject:operation]) {
		itIs = YES;
	}
	
	return itIs;
}

+ (BOOL) isOneParameterOperation:(NSString *) operation {
	NSSet *oneParameterOperations = [NSSet setWithObjects:@"sin",@"cos",@"sqrt", nil];
	BOOL itIs = NO;
	
	if (operation && [oneParameterOperations containsObject:operation]) {
		itIs = YES;
	}
	
	return itIs;
}

+ (BOOL) isVariable:(NSString *) operation {
	NSSet *variables = [NSSet setWithObjects:@"x",@"y",@"z", nil];
	BOOL itIs = NO;
	
	if (operation && [variables containsObject:operation]) {
		itIs = YES;
	}
	
	return itIs;
}

+ (NSString *)popOperandOffProgramStackForDescription:(NSMutableArray *)stack {
    NSString *description = @"";
	
    id topOfStack = [stack lastObject];
	
    if (topOfStack) {
		[stack removeLastObject];
	}
    
	if ([topOfStack isKindOfClass:[NSNumber class]]) {
        description = [description stringByAppendingString:topOfStack];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
       if ([self isTwoParametersOperation:topOfStack]) {
            description = [description stringByAppendingFormat:@" (%@ %@ %@)", [self popOperandOffProgramStackForDescription:stack], topOfStack, [self popOperandOffProgramStackForDescription:stack]];
        } else if ([self isOneParameterOperation:topOfStack]) {
			description = [description stringByAppendingFormat:@" %@(%@)", topOfStack, [self popOperandOffProgramStackForDescription:stack]];
        } else if ([self isVariable:topOfStack]) {
			description = topOfStack;
		}
    }
	
    return description;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
	NSMutableSet *setOfVariablesInProgram;
	
    if ([program isKindOfClass:[NSArray class]]) {
		for (id operand in program) {
			if ([operand isKindOfClass:[NSString class]] && [self isVariable:operand]) {
				[setOfVariablesInProgram addObject:operand];
			}
		}
    }
	
	return [setOfVariablesInProgram copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
	
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
	
    return [self popOperandOffProgramStackForDescription:stack];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack {
    double result = 0;
	
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
		NSString *operation = topOfStack;
		
		if ([operation isEqualToString:@"+"]) {
			result = [self popOperandOffProgramStack:stack] +
			[self popOperandOffProgramStack:stack];
		} else if ([@"*" isEqualToString:operation]) {
			result = [self popOperandOffProgramStack:stack] *
			[self popOperandOffProgramStack:stack];
		} else if ([operation isEqualToString:@"-"]) {
			double subtrahend = [self popOperandOffProgramStack:stack];
			result = [self popOperandOffProgramStack:stack] - subtrahend;
		} else if ([operation isEqualToString:@"/"]) {
			double divisor = [self popOperandOffProgramStack:stack];
			if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
		} else if ([operation isEqualToString:@"sqrt"]) {
			result = sqrt([self popOperandOffProgramStack:stack]);
		} else if ([operation isEqualToString:@"sin"]) {
			result = sin([self popOperandOffProgramStack:stack]);
		} else if ([operation isEqualToString:@"cos"]) {
			result = cos([self popOperandOffProgramStack:stack]);
		}
    }
	
    return result;
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack usingVariables:(NSDictionary *) variables {
    double result = 0;
	
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
		if ([self isVariable:topOfStack]) {
			result = [[variables objectForKey:topOfStack] doubleValue];
		} else {
			NSString *operation = topOfStack;
			
			if ([operation isEqualToString:@"+"]) {
				result = [self popOperandOffProgramStack:stack usingVariables:variables] +
				[self popOperandOffProgramStack:stack usingVariables:variables];
			} else if ([@"*" isEqualToString:operation]) {
				result = [self popOperandOffProgramStack:stack usingVariables:variables] *
				[self popOperandOffProgramStack:stack usingVariables:variables];
			} else if ([operation isEqualToString:@"-"]) {
				double subtrahend = [self popOperandOffProgramStack:stack usingVariables:variables];
				result = [self popOperandOffProgramStack:stack usingVariables:variables] - subtrahend;
			} else if ([operation isEqualToString:@"/"]) {
				double divisor = [self popOperandOffProgramStack:stack usingVariables:variables];
				if (divisor) result = [self popOperandOffProgramStack:stack usingVariables:variables] / divisor;
			} else if ([operation isEqualToString:@"sqrt"]) {
				result = sqrt([self popOperandOffProgramStack:stack usingVariables:variables]);
			} else if ([operation isEqualToString:@"sin"]) {
				result = sin([self popOperandOffProgramStack:stack usingVariables:variables]);
			} else if ([operation isEqualToString:@"cos"]) {
				result = cos([self popOperandOffProgramStack:stack usingVariables:variables]);
			}
		}
    }
	
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
	
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
	
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *) variables {
    NSMutableArray *stack;
	
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
	
    return [self popOperandOffProgramStack:stack usingVariables:variables];
}

@end
