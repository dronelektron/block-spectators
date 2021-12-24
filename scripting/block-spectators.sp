#include <sourcemod>
#include <sdktools>

#include "morecolors"

#pragma semicolon 1
#pragma newdecls required

#define PREFIX_COLORED "{green}[Block spectators] "
#define ENTITY_NOT_FOUND -1
#define TEAM_ARG_MAX_SIZE 2
#define TEAM_SPECTATOR 1

public Plugin myinfo = {
    name = "Block spectators",
    author = "Dron-elektron",
    description = "Allows you to block the spectators team at the end of the round or earlier",
    version = "0.1.0",
    url = ""
};

ConVar g_pluginEnabled = null;
ConVar g_blockTimeOffset = null;

Handle g_blockTimer = null;
bool g_isSpectatorsBlocked = false;

public void OnPluginStart() {
    g_pluginEnabled = CreateConVar("sm_blockspectators", "1", "Enable (1) or disable (0) spectators team blocking");
    g_blockTimeOffset = CreateConVar("sm_blockspectators_time_offset", "0", "Time offset (in seconds) until the end of the round");

    HookEvent("dod_round_start", Event_RoundStart);
    HookEvent("dod_round_active", Event_RoundActive);
    AddCommandListener(CommandListener_JoinTeam, "jointeam");
    LoadTranslations("block-spectators.phrases");
    AutoExecConfig(true, "block-spectators");
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

void UnblockSpectators() {
    DeleteBlockTimer();

    g_isSpectatorsBlocked = false;
}

void CreateBlockTimer() {
    if (!IsPluginEnabled()) {
        return;
    }

    int timerEntity = FindEntityByClassname(ENTITY_NOT_FOUND, "dod_round_timer");

    if (timerEntity == ENTITY_NOT_FOUND) {
        return;
    }

    float timeRemanining = GetEntPropFloat(timerEntity, Prop_Send, "m_flTimeRemaining");
    float timerDelay = timeRemanining - GetBlockTimeOffset();

    g_blockTimer = CreateTimer(timerDelay, Timer_BlockSpectators);
}

void DeleteBlockTimer() {
    delete g_blockTimer;
}

public Action Timer_BlockSpectators(Handle timer) {
    g_blockTimer = null;
    g_isSpectatorsBlocked = true;

    CPrintToChatAll("%s%t", PREFIX_COLORED, "Spectators team was blocked");

    return Plugin_Continue;
}

public Action CommandListener_JoinTeam(int client, const char[] command, int argc) {
    char teamStr[TEAM_ARG_MAX_SIZE];

    GetCmdArg(1, teamStr, sizeof(teamStr));

    int team = StringToInt(teamStr);

    if (g_isSpectatorsBlocked && team == TEAM_SPECTATOR) {
        CPrintToChat(client, "%s%t", PREFIX_COLORED, "Spectators team blocked until round end");

        return Plugin_Stop;
    }

    return Plugin_Continue;
}

bool IsPluginEnabled() {
    return g_pluginEnabled.IntValue == 1;
}

float GetBlockTimeOffset() {
    return g_blockTimeOffset.FloatValue;
}
