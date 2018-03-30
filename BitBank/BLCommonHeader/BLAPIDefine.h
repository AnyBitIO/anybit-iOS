//
//  BLAPIDefine.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/7.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#ifndef BLAPIDefine_h
#define BLAPIDefine_h

/*
 *  BL_HTTPS_SERVER_DEBUG           内网开发环境
 *
 *  BL_HTTPS_SERVER_TEST_RELEASE    外网测试环境
 *
 *  BL_HTTPS_SERVER_RELEASE         外网真实环境
 *
 */

typedef enum ProjectMode{
    
    PROJECT_DEBUG_MODE = 0x11,             //开发调试模式，平时调试使用
    
    PROJECT_TEST_RELEASE_MODEL = 0x110,    //外网测试环境
    
    PROJECT_RELEASE_MODE = 0x1100,         //外网真实环境，发布模式
    
}BL_PROJECT_MODE;

/******************************
 * 默认工程模式，由开发者调试时候设置
 *******************************/

#ifndef PROJECT_MODE

#define PROJECT_MODE 0x1100 //设置此处,平时调试、发布版本时设置此处

#endif


/******************************
 * 下面是各种不同模式下对应开关
 *******************************/

#ifdef PROJECT_MODE
#if PROJECT_MODE == 0x11
#define CONSOLE_LOG_ON                  //控制台日志  开
#define FILE_LOG_ON                     //文件日志    开
#define BL_HTTPS_SERVER_DEBUG
#endif
#endif

#ifdef PROJECT_MODE
#if PROJECT_MODE == 0x110
#define CONSOLE_LOG_ON                  //控制台日志  开
#define FILE_LOG_ON                     //文件日志    开
#define BL_HTTPS_SERVER_TEST_RELEASE
#endif
#endif

#ifdef PROJECT_MODE
#if PROJECT_MODE == 0x1100
#define CONSOLE_LOG_OFF                 //控制台日志  关
#define FILE_LOG_OFF                    //文件日志    关
#define BL_HTTPS_SERVER_RELEASE
#endif
#endif


//////////////////////////////////////////////////////////////////////////

#if defined(BL_HTTPS_SERVER_DEBUG) //内网开发

#define BL_HTTP_SERVER                       @"http://192.168.1.220:8080/lightwallet/server/process"

#elif defined(BL_HTTPS_SERVER_TEST_RELEASE) //外网测试

#define BL_HTTP_SERVER                       @"https://anybit.io/server/process/"

#else //外网真实

#define BL_HTTP_SERVER                       @"https://anybit.io/server/process/"

#endif

#endif /* BLAPIDefine_h */
