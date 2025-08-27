import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine App',
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/magazineInfo.jpg'),
              width: 500.0,
              height: 200,
              fit: BoxFit.cover,
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.pink,
        child: const Text("Cliquez"),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Acceuil"),
          NavigationDestination(icon: Icon(Icons.radio), label: "FM"),
          NavigationDestination(icon: Icon(Icons.live_tv), label: "TV"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Favoris"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Votre magazine numérique, votre source d'inspiration",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        "Magazine Infos est bien plus qu'un simple magazine d'informations. C'est votre passerelle vers le monde, une source inestimable de connaissances et d'actualiés soigneusement sélectionnées pour vous éclairer sur les enjeux mondiaux, la cultures, la science, IA, et meme le divertissement (le jeux).",
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }
}

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Icon(Icons.phone, color: Colors.pink),
                const SizedBox(height: 5),
                Text(
                  'Tel'.toUpperCase(),
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Icon(Icons.mail, color: Colors.pink),
                const SizedBox(height: 5),
                Text(
                  'Mail'.toUpperCase(),
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
          Container(
            padding: (EdgeInsets.all(20.0)),
            child: Column(
              children: [
                const Icon(Icons.share, color: Colors.pink),
                const SizedBox(height: 5),
                Text(
                  'Partage'.toUpperCase(),
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage('assets/images/design1.jpg'),
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage('assets/images/clip.jpg'),
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
