#include <sourcemod>
#include <sdktools>

#include "morecolors"

#pragma semicolon 1
#pragma newdecls required

#define PREFIX_COLORED "{green}[Block spectators] "
#define ENTITY_NOT_FOUND -1
#define TEAM_ARG_MAX_SIZE 2
#define TEAM_SPECTATOR 1
#define ROUND_TIMER_EXISTS_DEFAULT_VALUE true

#define NOTIFICATIONS_JOIN_ATTEMPT (1 << 0)
#define NOTIFICATIONS_ROUND_END (1 << 1)
#define NOTIFICATIONS_EARLY (1 << 2)

public Plugin myinfo = {
    name = "Block spectators",
    author = "Dron-elektron",
    description = "Allows you to block the spectators team at the end of the round or earlier",
    version = "0.2.0",
    url = ""
};

ConVar g_pluginEnabled = null;
ConVar g_notificationsMode = null;
ConVar g_blockTimeOffset = null;

Handle g_blockTimer = null;
float g_blockTimerEndTime = 0.0;
bool g_isSpectatorsBlocked = false;
bool g_isRoundTimerExists = ROUND_TIMER_EXISTS_DEFAULT_VALUE;

public void OnPluginStart() {
    g_pluginEnabled = CreateConVar("sm_blockspectators", "1", "Enable (1) or disable (0) spectators team blocking");
    g_notificationsMode = CreateConVar("sm_blockspectators_notifications_mode", "7", "None (0), Join attempt (1), Round end (2), Early (4)");
    g_blockTimeOffset = CreateConVar("sm_blockspectators_time_offset", "0", "Time offset (in seconds) until the end of the round");

    HookEvent("dod_round_start", Event_RoundStart);
    HookEvent("dod_round_active", Event_RoundActive);
    HookEvent("dod_round_win", Event_RoundWin);
    HookEvent("dod_timer_time_added", Event_TimerTimeAdded);
    AddCommandListener(CommandListener_JoinTeam, "jointeam");
    LoadTranslations("block-spectators.phrases");
    AutoExecConfig(true, "block-spectators");
}

public void OnMapStart() {
    g_isRoundTimerExists = ROUND_TIMER_EXISTS_DEFAULT_VALUE;
}

public void OnMapEnd() {
    UnblockSpectators();
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
    UnblockSpectators();
}

public void Event_RoundActive(Event event, const char[] name, bool dontBroadcast) {
    CreateBlockTimer();
}

public void Event_RoundWin(Event event, const char[] name, bool dontBroadcast) {
    if (!g_isRoundTimerExists) {
        BlockSpectators(NOTIFICATIONS_ROUND_END);
    }
}

public void Event_TimerTimeAdded(Event event, const char[] name, bool dontBroadcast) {
    int secondsAdded = event.GetInt("seconds_added");

    ExtendBlockTimer(secondsAdded);
}

void BlockSpectators(int notificationFlag) {
    g_isSpectatorsBlocked = true;
    NotifySpectatorsWasBlocked(notificationFlag);
}

void UnblockSpectators() {
    delete g_blockTimer;
    g_isSpectatorsBlocked = false;
}

void CreateBlockTimer() {
    if (!IsPluginEnabled()) {
        return;
    }

    int timerEntity = FindEntityByClassname(ENTITY_NOT_FOUND, "dod_round_timer");

    if (timerEntity == ENTITY_NOT_FOUND) {
        g_isRoundTimerExists = false;

        return;
    }

    float timeRemanining = GetEntPropFloat(timerEntity, Prop_Send, "m_flTimeRemaining");
    float timerDelay = timeRemanining - GetBlockTimeOffset() - 1.0;

    if (timerDelay < 0.0) {
        timerDelay = 0.0;
    }

    g_blockTimer = CreateTimer(timerDelay, Timer_BlockSpectators);
    g_blockTimerEndTime = GetGameTime() + timerDelay;
}

void ExtendBlockTimer(int secondsAdded) {
    delete g_blockTimer;

    float timerSecondsLeft = g_blockTimerEndTime - GetGameTime();
    float timerDelay = timerSecondsLeft + secondsAdded;

    g_blockTimer = CreateTimer(timerDelay, Timer_BlockSpectators);
    g_blockTimerEndTime = GetGameTime() + timerDelay;
}

public Action Timer_BlockSpectators(Handle timer) {
    g_blockTimer = null;
    BlockSpectators(NOTIFICATIONS_EARLY);

    return Plugin_Continue;
}

public Action CommandListener_JoinTeam(int client, const char[] command, int argc) {
    char teamStr[TEAM_ARG_MAX_SIZE];

    GetCmdArg(1, teamStr, sizeof(teamStr));

    int team = StringToInt(teamStr);

    if (g_isSpectatorsBlocked && team == TEAM_SPECTATOR) {
        NotifySpectatorsIsBlocked(client);

        return Plugin_Stop;
    }

    return Plugin_Continue;
}

void NotifySpectatorsWasBlocked(int notificationFlag) {
    bool isNotificationEnalbed = IsNotificationFlagEnabled(notificationFlag);

    if (isNotificationEnalbed) {
        CPrintToChatAll("%s%t", PREFIX_COLORED, "Spectators team was blocked");
    }
}

void NotifySpectatorsIsBlocked(int client) {
    bool isNotificationEnalbed = IsNotificationFlagEnabled(NOTIFICATIONS_JOIN_ATTEMPT);

    if (isNotificationEnalbed) {
        CPrintToChat(client, "%s%t", PREFIX_COLORED, "Spectators team is blocked");
    }
}

bool IsPluginEnabled() {
    return g_pluginEnabled.IntValue == 1;
}

bool IsNotificationFlagEnabled(int flag) {
    return (g_notificationsMode.IntValue & flag) == flag;
}

float GetBlockTimeOffset() {
    return g_blockTimeOffset.FloatValue;
}
