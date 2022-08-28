void Command_Create() {
    AddCommandListener(CommandListener_JoinTeam, "jointeam");
}

public Action CommandListener_JoinTeam(int client, const char[] command, int argc) {
    int team = GetCmdArgInt(1);

    return UseCase_OnClientJoinTeam(client, team) ? Plugin_Continue : Plugin_Stop;
}
