class AuthException implements Exception {
  final String key;
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Este email já está cadastrados.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Múltiplas tentativas, Acesso bloqueado temporariemente, tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não cadastrado.',
    'INVALID_PASSWORD': 'A senha não confere.',
    'USER_DISABLED': 'A conta de usuário está desabilitada.',
  };

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro durante a autenticação.';
  }
}
