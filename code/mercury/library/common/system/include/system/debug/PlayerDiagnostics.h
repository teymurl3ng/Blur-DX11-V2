// [Blur2PC] T275: normal player launches stay clean even with legacy debug settings.
#pragma once

#include <cstdlib>

namespace Debug
{
inline bool PlayerDiagnosticsEnabled()
{
    static const bool enabled = []() {
        const char* value = std::getenv("BLUR2PC_DIAGNOSTICS");
        return value && value[0] == '1' && value[1] == '\0';
    }();
    return enabled;
}
}
