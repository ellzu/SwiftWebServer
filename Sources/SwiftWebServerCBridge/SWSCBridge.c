//
//  SWSCBridge.c
//  SwiftWebServerLib
//
//  Created by ellzu on 2019/7/12.
//

#include <dlfcn.h>

typedef void(*ExampleCallHandler)(void *request, void *response);

void daynmicCall(const char *path,void *request, void *response)
{
    void *handler = dlopen(path, RTLD_NOW);
    void *symbol = dlsym(handler, "WSPExample_requestHandler_C");
    ((ExampleCallHandler)symbol)(request, response);
    dlclose(handler);
}
