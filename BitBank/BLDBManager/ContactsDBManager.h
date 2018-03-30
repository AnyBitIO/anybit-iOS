//
//  ContactsDBManager.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/10.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

@interface ContactsDBManager : NSObject

+ (BOOL)insertContactsDBWithModel:(ContactModel *)model;

+ (NSMutableArray *)queryAllContactsDB;

+ (BOOL)deleteContactsDBWithModel:(ContactModel *)model;

+ (BOOL)deleteAllContacts;

@end
