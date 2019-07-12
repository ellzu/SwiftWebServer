//
//  SWSCBridge.c
//  SwiftWebServerLib
//
//  Created by ellzu on 2019/7/12.
//

#include <dlfcn.h>

typedef int(*ExampleCallHandler)(void *request, void *response);

int daynmicCall(const char *path,void *request, void *response)
{
    void *handler = dlopen(path, RTLD_NOW);
    void *symbol = dlsym(handler, "onRequest_C");
    int code = ((ExampleCallHandler)symbol)(request, response);
    dlclose(handler);
    return code;
}
