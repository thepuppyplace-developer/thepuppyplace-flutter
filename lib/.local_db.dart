class LocalDB{
  final String dbName = 'asdfvxczv';
  final int version = 1;

  final String searchTable = 'Search';
  final String createSearchTable = '''
        CREATE TABLE Search(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        keyword TEXT NOT NULL,
        createdAT DATETIME NOT NULL
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
}