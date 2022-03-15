class Config{
  final String API_URL = 'http://localhost:3000';
  Map<String, String> jsonHeader(String jsonToken) => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": jsonToken
  };
}