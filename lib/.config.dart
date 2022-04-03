class Config{
  final String API_URL = 'http://localhost:3000';

  Map<String, String> headers(String jwt) => {
    'thepuppyplace': jwt
  };
}