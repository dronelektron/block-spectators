static ConVar g_pluginEnabled = null;
static ConVar g_notificationsMode = null;
static ConVar g_blockTimeOffset = null;

void Variable_Create() {
    g_pluginEnabled = CreateConVar("sm_blockspectators", "1", "Enable (1) or disable (0) spectators team blocking");
    g_notificationsMode = CreateConVar("sm_blockspectators_notifications_mode", "7", "None (0), Join attempt (1), Round end (2), Timer (4)");
    g_blockTimeOffset = CreateConVar("sm_blockspectators_time_offset", "0", "Time offset (in seconds) until the end of the round");
}

bool Variable_IsPluginEnabled() {
    return g_pluginEnabled.IntValue == 1;
}

bool Variable_IsNotificationFlagEnabled(int flag) {
    return (g_notificationsMode.IntValue & flag) == flag;
}

float Variable_GetBlockTimeOffset() {
    return g_blockTimeOffset.FloatValue;
}
