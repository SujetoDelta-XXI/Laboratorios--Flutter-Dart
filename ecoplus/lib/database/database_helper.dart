import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton class that manages SQLite database connection and operations
class DatabaseHelper {
  // Private constructor for singleton pattern
  DatabaseHelper._init();

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Database instance
  static Database? _database;

  /// Gets the database instance, creating it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_tracker.db');

    return await openDatabase(
      path,
      version: 2, // Incremented version for new indexes
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Creates tables when database is first created
  Future<void> _onCreate(Database db, int version) async {
    await createTables(db);
  }

  /// Handles database upgrades when version changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new indexes for version 2
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, date DESC)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_transactions_user_type ON transactions(user_id, type)
      ''');
    }
  }

  /// Creates all database tables with constraints and indexes
  Future<void> createTables(Database db) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create transactions table with CHECK constraints
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('income', 'expense')),
        amount REAL NOT NULL CHECK(amount >= 0),
        description TEXT,
        category_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
      )
    ''');

    // Create indexes for frequently queried fields
    await db.execute('''
      CREATE INDEX idx_transactions_user_id ON transactions(user_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_date ON transactions(date)
    ''');

    // Composite index for optimized queries on user_id and date together
    await db.execute('''
      CREATE INDEX idx_transactions_user_date ON transactions(user_id, date DESC)
    ''');

    // Index for type to optimize balance calculations
    await db.execute('''
      CREATE INDEX idx_transactions_user_type ON transactions(user_id, type)
    ''');

    await db.execute('''
      CREATE INDEX idx_categories_user_id ON categories(user_id)
    ''');
  }

  /// Closes the database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
