#include <sourcemod>
#include <sdktools>

#include "block-spectators/console-variable"
#include "block-spectators/message"
#include "block-spectators/use-case"

#include "modules/console-command.sp"
#include "modules/console-variable.sp"
#include "modules/event.sp"
#include "modules/message.sp"
#include "modules/use-case.sp"

#define AUTO_CREATE_YES true

public Plugin myinfo = {
    name = "Block spectators",
    author = "Dron-elektron",
    description = "Allows you to block the spectators team at the end of the round or earlier",
    version = "1.0.3",
    url = "https://github.com/dronelektron/block-spectators"
};

public void OnPluginStart() {
    Command_Create();
    Variable_Create();
    Event_Create();
    LoadTranslations("block-spectators.phrases");
    AutoExecConfig(AUTO_CREATE_YES, "block-spectators");
}

public void OnMapStart() {
    UseCase_SetRoundTimerExists(ROUND_TIMER_EXISTS_DEFAULT_VALUE);
}

public void OnMapEnd() {
    UseCase_UnblockSpectators();
}
