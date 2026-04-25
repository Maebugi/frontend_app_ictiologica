class ErrorMessageParser {
  static String parse(dynamic data, {String fallback = 'Ocurrió un error'}) {
    if (data == null) return fallback;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        final detail = data['detail'];

        if (detail is String) {
          return _beautify(detail);
        }

        if (detail is List) {
          final messages = detail.map((item) {
            if (item is Map<String, dynamic>) {
              final loc = item['loc'];
              final msg = item['msg'];

              final field = _mapField(loc);
              return '$field: ${_beautify(msg?.toString() ?? 'valor inválido')}';
            }
            return null;
          }).whereType<String>().toList();

          if (messages.isNotEmpty) {
            return messages.join('\n');
          }
        }
      }
    }

    return fallback;
  }

  static String _mapField(dynamic loc) {
    if (loc is List && loc.isNotEmpty) {
      final field = loc.last.toString();

      switch (field) {
        case 'correo':
          return 'Correo';
        case 'contrasena':
          return 'Contraseña';
        case 'nombre':
          return 'Nombre';
        case 'institucion':
          return 'Institución';
        default:
          return 'Campo';
      }
    }
    return 'Campo';
  }

  static String _beautify(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('at least 8 characters')) {
      return 'debe tener mínimo 8 caracteres';
    }

    if (msg.contains('valid email address') || msg.contains('@-sign')) {
      return 'debe ser un correo válido';
    }

    if (msg.contains('incorrectos')) {
      return 'correo o contraseña incorrectos';
    }

    if (msg.contains('ya está registrado')) {
      return 'ya se encuentra registrado';
    }

    return message;
  }
}
