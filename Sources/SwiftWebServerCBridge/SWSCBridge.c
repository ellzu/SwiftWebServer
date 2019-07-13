//
//  SWSCBridge.c
//  SwiftWebServerLib
//
//  Created by ellzu on 2019/7/12.
//

#include <dlfcn.h>

typedef int(*swsOnHostRequest_C)(void *request, void *response);

int swsForwardRequestToHost(const char *path,void *request, void *response)
{
    void *handler = dlopen(path, RTLD_NOW);
    void *symbol = dlsym(handler, "swsOnHostRequest_C");
    int code = ((swsOnHostRequest_C)symbol)(request, response);
    dlclose(handler);
    return code;
}
