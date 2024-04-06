void Event_Create() {
    HookEvent("dod_round_start", Event_RoundStart);
    HookEvent("dod_round_active", Event_RoundActive);
    HookEvent("dod_round_win", Event_RoundWin);
    HookEvent("dod_timer_time_added", Event_TimerTimeAdded);
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
