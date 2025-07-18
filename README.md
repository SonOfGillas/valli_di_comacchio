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
there are 4 collection:
users -> data and user card collection
npcs -> npc data, one for the npc data and the location detail data
event -> event list
walks -> walks and cycling path, all the information are in the walks foulder

the detail of the structure of the collections can be see in the user.dart, npc.dart, walk.dart, event.dart

## WIKI About Birds on the Valli di comacchio
https://www.salinadicomacchio.it/la-salina/fauna/avifauna/
