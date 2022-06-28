static Handle g_blockTimer = null;
static float g_blockTimerEndTime = 0.0;
static bool g_isSpectatorsBlocked = false;
static bool g_isRoundTimerExists = ROUND_TIMER_EXISTS_DEFAULT_VALUE;

bool UseCase_IsSpectatorsBlocked() {
    return g_isSpectatorsBlocked;
}

void UseCase_SetRoundTimerExists(bool exists) {
    g_isRoundTimerExists = exists;
}

void UseCase_BlockSpectatorsWithoutTimer() {
    if (!g_isRoundTimerExists) {
        UseCase_BlockSpectators(NOTIFICATIONS_ROUND_END);
    }
}

void UseCase_BlockSpectators(int notificationFlag) {
    g_isSpectatorsBlocked = true;
    MessagePrint_SpectatorsWasBlocked(notificationFlag);
}

void UseCase_UnblockSpectators() {
    delete g_blockTimer;
    g_isSpectatorsBlocked = false;
}

void UseCase_CreateBlockTimer() {
    if (!Variable_IsPluginEnabled()) {
        return;
    }

    int timerEntity = FindEntityByClassname(ENTITY_NOT_FOUND, "dod_round_timer");

    if (timerEntity == ENTITY_NOT_FOUND) {
        g_isRoundTimerExists = false;

        return;
    }

    float timeRemanining = GetEntPropFloat(timerEntity, Prop_Send, "m_flTimeRemaining");
    float timerDelay = timeRemanining - Variable_GetBlockTimeOffset() - 1.0;

    if (timerDelay < 0.0) {
        timerDelay = 0.0;
    }

    g_blockTimer = CreateTimer(timerDelay, Timer_BlockSpectators);
    g_blockTimerEndTime = GetGameTime() + timerDelay;
}

void UseCase_ExtendBlockTimer(int secondsAdded) {
    delete g_blockTimer;

    float timerSecondsLeft = g_blockTimerEndTime - GetGameTime();
    float timerDelay = timerSecondsLeft + secondsAdded;

    g_blockTimer = CreateTimer(timerDelay, Timer_BlockSpectators);
    g_blockTimerEndTime = GetGameTime() + timerDelay;
}

public Action Timer_BlockSpectators(Handle timer) {
    g_blockTimer = null;
    UseCase_BlockSpectators(NOTIFICATIONS_TIMER);

    return Plugin_Continue;
}
