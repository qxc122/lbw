//
//  MACRO_URL.h
//  base
//
//  Created by 开发者最好的 on 2018/8/21.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#ifndef MACRO_URL_h
#define MACRO_URL_h



#ifdef DEBUG
#define  URLBASIC  @"http://jxjiancai.net:9999/api.v11.php?a="
//#define  URLBASIC  @"http://121.42.42.112:903/api.v10.php?a="
#else
#define  URLBASIC  @"http://jxjiancai.net:9999/api.v11.php?a="
#endif


#define url_getMyMsg  @"getMyMsg"
#define url_buyCard  @"buyCard"
#define url_login  @"login"


///////图片//////////

///////////////


///////存储地址//////////
//#define PATH_HOMEDATA   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"PATH_HOMEDATA"]
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define PATH_UESRINFO   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"PATH_UESRINFo"]
#define PATH_base   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"PATH_base"]
#define PATH_guanggao   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"PATH_guanggao"]


//GlobalParameter *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_APPCOMMONGLOBAL];
//[self openEachWkVcWithId:data.qrCodeInsUrl];  
//
//        [NSKeyedArchiver archiveRootObject:Globaldata toFile:PATH_APPCOMMONGLOBAL];
///////////////

#endif /* MACRO_URL_h */
