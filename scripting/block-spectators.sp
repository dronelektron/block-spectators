#include <sourcemod>
#include <sdktools>

#include "morecolors"

#include "bs/console-variable"
#include "bs/message"
#include "bs/use-case"

#include "modules/console-command.sp"
#include "modules/console-variable.sp"
#include "modules/message.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Block spectators",
    author = "Dron-elektron",
    description = "Allows you to block the spectators team at the end of the round or earlier",
    version = "1.0.1",
    url = "https://github.com/dronelektron/block-spectators"
};

public void OnPluginStart() {
    Command_Create();
    Variable_Create();
    HookEvent("dod_round_start", Event_RoundStart);
    HookEvent("dod_round_active", Event_RoundActive);
    HookEvent("dod_round_win", Event_RoundWin);
    HookEvent("dod_timer_time_added", Event_TimerTimeAdded);
    LoadTranslations("block-spectators.phrases");
    AutoExecConfig(true, "block-spectators");
}

public void OnMapStart() {
    UseCase_SetRoundTimerExists(ROUND_TIMER_EXISTS_DEFAULT_VALUE);
}

public void OnMapEnd() {
    UseCase_UnblockSpectators();
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
    UseCase_UnblockSpectators();
}

public void Event_RoundActive(Event event, const char[] name, bool dontBroadcast) {
    UseCase_CreateBlockTimer();
}

public void Event_RoundWin(Event event, const char[] name, bool dontBroadcast) {
    UseCase_BlockSpectatorsWithoutTimer();
}

public void Event_TimerTimeAdded(Event event, const char[] name, bool dontBroadcast) {
    int secondsAdded = event.GetInt("seconds_added");

    UseCase_ExtendBlockTimer(secondsAdded);
}
