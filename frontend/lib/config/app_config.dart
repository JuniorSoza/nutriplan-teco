class AppConfig {
  // Configuración del backend
  static const String backendUrl = 'http://localhost:3000';
  static const String apiBaseUrl = '$backendUrl/api';

  // Timeouts
  static const int connectionTimeout = 10000; // 10 segundos
  static const int receiveTimeout = 10000; // 10 segundos

  // Configuración de la aplicación
  static const String appName = 'NutriPlan';
  static const String appVersion = '1.0.0';

  // URLs específicas de la API
  static const String productosUrl = '$apiBaseUrl/productos';
  static const String notificacionesUrl = '$apiBaseUrl/notificaciones';
  static const String facturasUrl = '$apiBaseUrl/facturas';
  static const String reportesUrl = '$apiBaseUrl/reportes';
  static const String biometricosUrl = '$apiBaseUrl/biometricos';

  // URL del servicio de colaboradores externo
  static const String colaboradoresUrl =
      'http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador';
}
