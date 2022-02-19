class Config{
  final String APIURL = 'http://localhost:0601';
  Map<String, String> jsonHeader(String jsonToken) => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    "Authorization": jsonToken
  };
}