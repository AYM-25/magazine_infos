import 'package:flutter/material.dart';
import 'package:magazine/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MonApplication());
}

class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  static bool isEmpty = true;

  Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }

  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
}

class DatabaseManager {
  Future<void> initialisation() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'redacteurs.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    final List<Map<String, dynamic>> data = await _db!.query('redacteurs');
    return data.map((e) => Redacteur.fromMap(e)).toList();
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    return await _db!.insert('redacteurs', redacteur.toMap());
  }

  Future<void> deleteRedacteur(int id) async {
    await _db!.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateRedacteur(Redacteur redacteur) async {
    final db = _db;
    await db!.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  Database? _db;
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: RedacteursInterface()),
    );
  }
}

class RedacteursInterface extends StatefulWidget {
  const RedacteursInterface({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RedacteursInterfaceState createState() => _RedacteursInterfaceState();
}

class _RedacteursInterfaceState extends State<RedacteursInterface> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];
  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DatabaseManager().initialisation().then((_) {
      _loadRedacteurs();
    });
  }

  Future<void> _loadRedacteurs() async {
    final data = await DatabaseManager().getAllRedacteurs();
    setState(() {
      _redacteurs = data;
    });
  }

  Future<void> _insertRedacteur() async {
    final redacteur = Redacteur.sansId(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );
    await DatabaseManager().insertRedacteur(redacteur);
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    _loadRedacteurs();
  }

  Future<void> _deleteRedacteur(int id) async {
    await DatabaseManager().deleteRedacteur(id);
    _loadRedacteurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion des rédacteurs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: Colors.pink,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PageAccueil()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _insertRedacteur,
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Ajouter un rédacteur',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  backgroundColor: Colors.pink,
                  shape: StadiumBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Redacteur.isEmpty
                  ? Center(child: Text("Aucun rédacteur enregistré"))
                  : ListView.builder(
                      itemCount: _redacteurs.length,
                      itemBuilder: (context, index) {
                        final redact = _redacteurs[index];
                        return ListTile(
                          title: Text(
                            '${redact.nom} ${redact.prenom}',
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text('$redact.email'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {
                                  _nomController.text = redact.nom;
                                  _prenomController.text = redact.prenom;
                                  _emailController.text = redact.email;

                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Modifier Rédacteur'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _nomController,
                                            decoration: InputDecoration(
                                              labelText: 'Nom',
                                            ),
                                          ),
                                          TextField(
                                            controller: _prenomController,
                                            decoration: InputDecoration(
                                              labelText: 'Prénom',
                                            ),
                                          ),
                                          TextField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Annuler',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await DatabaseManager()
                                                .updateRedacteur(
                                                  Redacteur(
                                                    id: redact.id,
                                                    nom: _nomController.text,
                                                    prenom:
                                                        _prenomController.text,
                                                    email:
                                                        _emailController.text,
                                                  ),
                                                );
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            _loadRedacteurs();
                                          },
                                          child: Text(
                                            'Enregistrer',
                                            style: TextStyle(
                                              color: Colors.white,
                                              backgroundColor: Colors.pink,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteRedacteur(redact.id!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class PageRedacteur extends StatelessWidget {
  const PageRedacteur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Rédacteur',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Recherchez',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Text("Mag_Info", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Accueil"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.radio_rounded),
              title: Text("FM"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.live_tv_rounded),
              title: Text("TV"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.favorite_rounded),
              title: Text("Favoris"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person_2_rounded),
              title: Text("Profil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageRedacteur()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}*/
