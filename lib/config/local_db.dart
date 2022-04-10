class LocalDB{
  final String dbName = 'test32';
  final int version = 1;

  final String searchTable = 'Search';
  final String createSearchTable = '''
  CREATE TABLE Search(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  keyword TEXT NOT NULL UNIQUE,
  createdAT TEXT NOT NULL
  )
  ''';

  final String boardTable = 'Board';
  final String createBoardTable = '''
  CREATE TABLE IF NOT EXISTS Board(
  id INTEGER PRIMARY KEY NOT NULL,
  user_id INTEGER,
  title TEXT,
  description TEXT,
  location TEXT,
  category TEXT,
  view_count INTEGER,
  User TEXT,
  board_photos TEXT,
  BoardLikes TEXT,
  Comments TEXT,
  createdAt TEXT,
  updatedAt TEXT,
  deletedAt TEXT
  )
  ''';

  final String userTable = 'User';
  final String createUserTable = '''
  CREATE TABLE IF NOT EXISTS User(
  id INTEGER PRIMARY KEY NOT NULL,
  email TEXT,
  password TEXT,
  nickname TEXT,
  name TEXT,
  phone_number TEXT,
  photo_url TEXT,
  gender TEXT,
  fcm_token TEXT,
  is_alarm INTEGER,
  location TEXT,
  createdAt TEXT,
  updatedAt TEXT,
  deletedAt TEXT
  )
  ''';
}