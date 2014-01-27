// gcc ibusctl.c -o ibusctl.so -shared -fPIC `pkg-config --cflags --libs ibus-1.0 glib-2.0`

#include <dlfcn.h>
#include <glib.h>
#include <ibus.h>
#include <string.h>

// Since ibus-1.5.0, switch im engine to enable/disable input mode.
#if IBUS_CHECK_VERSION(1, 5, 0)
# ifndef IM_ENGINE_DISABLE
#  define IM_ENGINE_DISABLE "xkb:jp::jpn"
# endif
# ifndef IM_ENGINE_ENABLE
#  define IM_ENGINE_ENABLE  "anthy"
# endif
#endif

static IBusBus *bus = NULL;
static IBusInputContext *ic = NULL;

int im_init(const char *selfpath)
{
    gchar *path;
    GDBusConnection *conn;
    void *h;

    h = dlopen(selfpath, RTLD_LAZY);
    if (h == NULL)
        return -1;

    ibus_init();

    bus = ibus_bus_new();
    if (bus == NULL)
        return -1;

    path = ibus_bus_current_input_context(bus);
    if (path == NULL)
        return -1;

    conn = ibus_bus_get_connection(bus);
    if (conn == NULL)
        return -1;

    ic = ibus_input_context_get_input_context(path, conn);
    if (ic == NULL)
        return -1;

    g_free(path);

    return 0;
}

int im_is_enabled()
{
    int r;
#if IBUS_CHECK_VERSION(1, 5, 0)
    IBusEngineDesc *d;
    d = ibus_input_context_get_engine(ic);
    r = strcmp(ibus_engine_desc_get_name(d), IM_ENGINE_ENABLE) == 0 ? 1 : 0;
    g_object_unref(d);
#else
    r = ibus_input_context_is_enabled(ic) ? 1 : 0;
#endif
    return r;
}

#include <stdio.h>

int im_enable()
{
#if IBUS_CHECK_VERSION(1, 5, 0)
    ibus_input_context_set_engine(ic, IM_ENGINE_ENABLE);
#else
    ibus_input_context_enable(ic);
#endif
    return 0;
}

int im_disable()
{
#if IBUS_CHECK_VERSION(1, 5, 0)
    ibus_input_context_set_engine(ic, IM_ENGINE_DISABLE);
#else
    ibus_input_context_disable(ic);
#endif
    return 0;
}

