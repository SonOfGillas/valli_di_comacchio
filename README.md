# valli_di_comacchio

## versions
flutter 3.29.0
flutterfire_cli 1.1.0


## Getting Started

flutter fire:
1) dart pub global activate flutterfire_cli
2) login flutter cli with and account with access to the project "valli-di-comacchio"
3) flutterfire configure --project=valli-di-comacchio --account richy.gardenghi@gmail.com
4) fluttergen


## Genera stringe
flutter pub get 

## BUILD
flutter build apk --debug


## Use of firebase
1) Firebase Authentication with email and password.
  guest user have a random generated account to safely access the database

2) Clode firestore
there are two collection one for the User and one For the Npc
the detail of the structure of the collections can be see in the user.dart and npc.dart

## WIKI About Birds on the Valli di comacchio
https://www.salinadicomacchio.it/la-salina/fauna/avifauna/


// TODO
1) quando si clicca su un percorso navigare sulla mappa con il percorso visualizzato
2) bottone hide npcs
1) aggiungere eventi come catagoria
2) categorizzare i luoghi
2) aggiungere dettaglio ai luogi
3) aggiungee dettaglio escursioni
4) aggiungere dettalgio agli eventi 
5) prendere i dati delle escursioni da app storage


oggetto remoto walks
{
  id:
  image:
  price:
  gpx_file:
}

//location
attrazioni
attivita
monumenti
natura