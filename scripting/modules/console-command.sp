public Action CommandListener_JoinTeam(int client, const char[] command, int argc) {
    char teamStr[TEAM_ARG_MAX_SIZE];

    GetCmdArg(1, teamStr, sizeof(teamStr));

    int team = StringToInt(teamStr);

    if (UseCase_IsSpectatorsBlocked() && team == TEAM_SPECTATOR) {
        MessagePrint_SpectatorsIsBlocked(client);

        return Plugin_Stop;
    }

    return Plugin_Continue;
}
