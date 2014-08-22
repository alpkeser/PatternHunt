//
//  Quest.h
//  PatternHunt
//
//  Created by Alp Keser on 8/20/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quest : NSObject
@property (nonatomic,assign)int questId;
@property (nonatomic,assign)BOOL isCompleted;
@property (nonatomic,strong)NSString* questDesctiption;
@property (nonatomic,strong)NSString* type;
@end
