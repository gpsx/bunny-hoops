class AppStrings {
  // App General
  static const appName = 'Bunny hoops';

  // Tracker Screen
  static const dailyTotal = 'TOTAL DE HOJE';
  static const lovelyThoughtsToday = 'Pensamentos registrados hoje';
  static const recordThought = 'Registrar pensamento';
  static const lastEntry = 'Último registro';
  static const streak = 'Sequência';
  static const goal = 'Meta:';

  // History Screen
  static const historyTitle = 'Histórico';
  static const tracker = 'Início';
  static const gallery = 'Galeria';
  static const settings = 'Configurações';
  static const errorPrefix = 'Erro';
  static const today = 'Hoje';
  static const yesterday = 'Ontem';

  // Profiles
  static const profileLontra = 'Lontra';
  static const profileCoelho = 'Coelho';
  static const sarky = 'Sarky';
  static const amandinha = 'Amandinha';

  // Thoughts and notifications
  static const customMessageHint = 'Digite uma mensagem (opcional)';
  static const defaultThought = 'Estava pensando em vc meu amor!';
  static const widgetThought =
      'Oi meu amor tava pensando em vc agorinha, te amo mt';
  static const notificationChannelName = 'Bunny Hoops Notifications';
  static const notificationChannelDescription =
      'Notificações de pensamentos do casal';
  static const notificationFallbackTitle = 'Bunny Hoops';
  static const notificationChannelId = 'bunny_hoops_channel_v2';

  static String thoughtNotificationTitle(String senderName, String icon) {
    return '$senderName esta pensando em vc ❤️$icon🤘';
  }
}
