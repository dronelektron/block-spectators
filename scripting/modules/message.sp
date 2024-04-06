void MessagePrint_SpectatorsWasBlocked(int notificationFlag) {
    bool isNotificationEnalbed = Variable_IsNotificationFlagEnabled(notificationFlag);

    if (isNotificationEnalbed) {
        PrintToChatAll(COLOR_DEFAULT ... "%t%t", PREFIX_COLORED, "Spectators team was blocked");
    }
}

void MessagePrint_SpectatorsIsBlocked(int client) {
    bool isNotificationEnalbed = Variable_IsNotificationFlagEnabled(NOTIFICATIONS_JOIN_ATTEMPT);

    if (isNotificationEnalbed) {
        PrintToChat(client, COLOR_DEFAULT ... "%t%t", PREFIX_COLORED, "Spectators team is blocked");
    }
}
