//
//  SPAppDelegate.h
//  SmartParking
//
//  Created by smart_parking on 1/15/13.
//  Copyright (c) 2013 smart_parking. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>  
#import "AppDelegateProtocol.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class ExampleAppDataObject,KeychainItemWrapper;
@interface SPAppDelegate :NSObject<UIApplicationDelegate,AppDelegateProtocol> {
    UIWindow *window;
//    ExampleAppDataObject* theDataObject;
     ExampleAppDataObject* theAppDataObject;
    KeychainItemWrapper *passwordItem;
    KeychainItemWrapper *accountNumberItem;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    CLLocationManager  *locationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ExampleAppDataObject* theAppDataObject;
@property (nonatomic, strong) KeychainItemWrapper *passwordItem;
@property (nonatomic, strong) KeychainItemWrapper *accountNumberItem;

//数据模型对象
@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//初始化Core Data使用的数据库
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

//managedObjectModel的初始化赋值函数
-(NSManagedObjectModel *)managedObjectModel;

//managedObjectContext的初始化赋值函数
-(NSManagedObjectContext *)managedObjectContext;

@end
