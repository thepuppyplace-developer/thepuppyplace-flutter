class LocalDB{
  final String dbName = 'thepuppyplace';
  final int version = 1;

  final String createSearchTable = '''
        CREATE TABLE Search(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        keyword TEXT NOT NULL,
        createdAT DATETIME NOT NULL
        )
        ''';
}