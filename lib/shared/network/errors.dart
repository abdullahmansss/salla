class ServerException implements Exception
{
  final dynamic error;

  ServerException(this.error);
}

class CacheException implements Exception {}